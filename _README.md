## Setup Lab Environment

1. Update the following files:
  * _GUID_HW with the Homework Lab GUID
  * _GUID_OSP with the OSP Lab GUID
  * _OPENTLC_USER the opentlc user you are using
2. Run the `_SETUP.yml` playbook from your local laptop.
    ```sh
    ansible-playbook _SETUP.yml
    ```
3. Run the Site Setup playbook that comes from upstream on the Tower Bastion Host
    ```sh
    sudo su -
    cd /root/ansible_advance_homework
    ansible-playbook site-setup-workstation.yml -e OSP_GUID=${OSP_GUID} --private-key=/root/.ssh/mykey_id_rsa -u ${OPENTLC_LOGIN}
    ansible-playbook site-config-tower.yml -e tower_GUID=${TOWER_GUID} -e osp_GUID=${OSP_GUID} -e opentlc_login=${OPENTLC_LOGIN} -e path_to_opentlc_key=/root/.ssh/mykey_id_rsa -e param_repo_base=${JQ_REPO_BASE} -e opentlc_password=${OPENTLC_PASSWORD} -e REGION_NAME=${REGION} -e EMAIL=${RH_MAIL_ID} -e github_repo=${GITHUB_REPO}
    ```

## Quick Hits

* SSH Into Tower Host
    ```sh
    ssh $(cat _OPENTLC_USER)@bastion.$(cat _GUID_TOWER).example.opentlc.com
    ```
* SSH Into OSP Workstation
    ```sh
    ssh $(cat _OPENTLC_USER)@workstation-$(cat _GUID_OSP).rhpds.opentlc.com
    ```
* SSH Into 3-Tier Bastion Host
    ```sh
    ssh $(cat _OPENTLC_USER)@bastion.$(cat _GUID_3TIER).example.opentlc.com
    ```

## Overall changes

* I updated the tower role to include more options and be more idempotent. Where possible I removed the tower-cli shell commands for the native ansible modules.
* To be a little more secure, I opted not to utlize my existing private/public key in the environment. Instead I generated a new key that is only used in this environment.
* To help accelerate the setup of the different parts of the environment, I created a `_SETUP.yml` playbook. It generates the ssh keys and copies them around.   See the `Setup Lab Environment` above for more information.
* I had a problem where the Openstack VM's would power off after a while. I wrote a quick playbook to start the osp servers. (`site-ops-startup.yml`)