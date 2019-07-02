#!/usr/bin/env bash
if [ -z "$ALERTMANAGER_SLACK_WEBHOOK" ]; then
    echo "Error: ALERTMANAGER_SLACK_WEBHOOK environment variable must be set" >&2
    exit 1
fi

cat <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: alertmanager-config
  labels:
    app: prometheus
    component: alertmanager
    env: prod
data:
  alertmanager.yml: |
    global: {}
    templates: 
    - '/etc/alertmanager/template/*.tmpl'

    # The root route on which each incoming alert enters.
    route:
      # The labels by which incoming alerts are grouped together. For example,
      # multiple alerts coming in for cluster=A and alertname=LatencyHigh would
      # be batched into a single group.
      #
      # To aggregate by all possible labels use '...' as the sole label name.
      # This effectively disables aggregation entirely, passing through all
      # alerts as-is. This is unlikely to be what you want, unless you have
      # a very low alert volume or your upstream notification system performs
      # its own grouping. Example: group_by: [...]
      group_by: ['alertname', 'service']

      # When a new group of alerts is created by an incoming alert, wait at
      # least 'group_wait' to send the initial notification.
      # This way ensures that you get multiple alerts for the same group that start
      # firing shortly after another are batched together on the first 
      # notification.
      group_wait: 30s

      # When the first notification was sent, wait 'group_interval' to send a batch
      # of new alerts that started firing for that group.
      group_interval: 5m

      # If an alert has successfully been sent, wait 'repeat_interval' to
      # resend them.
      repeat_interval: 3h 

      # A default receiver
      receiver: kscout-slack

      # All the above attributes are inherited by all child routes and can 
      # overwritten on each.

      # The child route trees.
      routes: []
      # This routes performs a regular expression match on alert labels to
      # catch alerts that are related to a list of services.
    #  - match_re:
    #      service: ^(foo1|foo2|baz)$
    #    receiver: team-X-mails
    #    # The service has a sub-route for critical alerts, any alerts
    #    # that do not match, i.e. severity != critical, fall-back to the
    #    # parent node and are sent to 'team-X-mails'
    #    routes:
    #    - match:
    #        severity: critical
    #      receiver: team-X-pager
    #  - match:
    #      service: files
    #    receiver: team-Y-mails
    #
    #    routes:
    #    - match:
    #        severity: critical
    #      receiver: team-Y-pager

      # This route handles all alerts coming from a database service. If there's
      # no team to handle it, it defaults to the DB team.
    #  - match:
    #      service: database
    #    receiver: team-DB-pager
    #    # Also group alerts by affected database.
    #    group_by: [alertname, cluster, database]
    #    routes:
    #    - match:
    #        owner: team-X
    #      receiver: team-X-pager
    #      continue: true
    #    - match:
    #        owner: team-Y
    #      receiver: team-Y-pager


    # Inhibition rules allow to mute a set of alerts given that another alert is
    # firing.
    # We use this to mute any warning-level notifications if the same alert is 
    # already critical.
    inhibit_rules:
    - source_match:
        severity: 'critical'
      target_match:
        severity: 'warning'
      # Apply inhibition if the alertname is the same.
      equal: ['alertname', 'service']


    receivers:
    - name: kscout-slack
      slack_configs:
      - channel: '#kscout'
        api_url: '$ALERTMANAGER_SLACK_WEBHOOK'
        text: |
          {{ range .Alerts }}
          *Alert*: {{ .Annotations.summary }}
          *Description*: {{ .Annotations.description }}
          *Maintainers*: {{ .Labels.maintainers }}
          *Severity*: {{ .Labels.severity }}
          {{ end }}
        send_resolved: true
        link_names: true
EOF