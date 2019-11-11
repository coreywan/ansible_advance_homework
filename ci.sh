#! /bin/sh

failcount=0
echo
echo "Running ansible-lint on all playbooks..."
# Reuse the list of playbooks
if [ ! -z "$playbookfiles" ]; then
  ansible-lint ${playbookfiles}
  failcount=$(( failcount + $?)) 2>/dev/null
fi


echo
echo "Finding and linting all yaml files..."
yamlfiles=$(find . -type f -name "*.yaml" -o -name "*.yml")
if [ ! -z "$yamlfiles" ]; then
  # This honors the .yamllint in the current directory, so projects can tweak the configuration
  yamllint ${yamlfiles}
  failcount=$(( failcount + $?)) 2>/dev/null
fi
