- [Problem to Be Solved](task_github.md#problem-to-be-solved)
  * [Explanation of the Solution](task_github.md#explanation-of-the-solution)
  * [PRE-REQUISITES](task_github.md#pre-requisites)
- [Creating GitHub resources](task_github.md#creating-github-resources)
  * [TASK 1 - Create GitHub Organization settings](task_github.md#task-1-create-github-organization-settings)
  * [TASK 2 - Create an organization secret](task_github.md#task-2-create-an-organization-secret)
  * [TASK 3 - Create teams and memberships](task_github.md#task-3-create-teams-and-memberships)
  * [TASK 4 - Create a security manager](task_github.md#task-4-create-a-security-manager)
  * [TASK 5 - Create a Private Repository](task_github.md#task-5-create-a-private-repository)
  * [TASK 6 - Form TF Output](task_github.md#task-6-form-tf-output)
  * [TASK 7 - Configure a remote data source](task_github.md#task-7-configure-a-remote-data-source)
  * [TASK 8 - Create a Secure Public Repository](task_github.md#task-8-create-a-secure-public-repository)
- [Working with Terraform state](task_github.md#working-with-terraform-state)
  * [TASK 9 - Move state to Postgres database](task_github.md#task-9-move-state-to-postgres-database)
  * [TASK 10 - Move resources](task_github.md#task-10-move-resources)
  * [TASK 11 - Import resources](task_github.md#task-11-import-resources)
  * [TASK 12 - Use data discovery](task_github.md#task-12-use-data-discovery)
- [Advanced tasks](task_github.md#advanced-tasks)
  * [TASK 13 - Create dynamically manageable resources](task_github.md#task-13-create-dynamically-manageable-resources)
  * [TASK 14 - Modules](task_github.md#task-14-modules)
  


# Problem to Be Solved in This Lab
This lab shows you how to use Terraform to configure an organization, members, teams, and repositories in GitHub. This task is binding to real production needs – for instance, the DevOps team centrally manages the state of the GitHub repositories within their organization.

 
### Explanation of the Solution 
You will use Terraform with the GitHub provider to create 2 separate Terraform configurations:
 1) Base configuration
 2) Repos configuration
After you’ve created the configuration, we will work on its optimization like using a data-driven approach and creating modules.


## PRE-REQUISITES
1. Fork current repository. A fork is a copy of a project and this allows you to make changes without affecting the original project.
2. Create a GitHub organization [refer to this document](https://docs.github.com/ru/organizations/collaborating-with-groups-in-organizations/creating-a-new-organization-from-scratch). Choose a name you find appealing.
3. Create a personal access token with full access [refer to this document](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).
4. All actions should be done under your fork and Terraform gets it context from your local clone working directory: 
    - Change current directory to `/tf-epam-lab/non_cloud_task/github/base` folder and create files `root.tf` and `variables.tf`.
    - In the `variables.tf` create variable `gh_token` without default value. To prevent providing GitHub token on each configuration run and staying secure set binding environment variable:
        ```bash
        export TF_VAR_gh_token={CREATED_PERSONAL_GITHUB_TOKEN}
        ```
    <b><mark>**NOTE**: NEVER store the value of the GitHub token in the repository code.</b></mark>
    - Add a `terraform {}`empty block to this file. Create an GitHub provider block inside `root.tf` file with the following attributes: 
        - `owner = "{organization_name}"`
        - `token = "var.gh_token"`.

    Run `terraform init` to initialize your configuration. 
    Run `terraform validate` and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
    Run `terraform plan` to ensure that there are no changes.

    Please use **underscore** Terraform resources naming, e.g. `my_resource` instead of `my-resource`.

5. Create directory `/tf-epam-lab/non_cloud_task/github/repos`, change current directory  to `/tf-epam-lab/non_cloud_task/github/repos` and repeat the steps in [2].
6. Install docker on your laptop.

You are ready for the lab!

# Creating GitHub resources

## TASK 1 - Create GitHub Organization settings
Change current directory  to `/tf-epam-lab/non_cloud_task/github/base`

Create an organization settings resource with attributes:

-	`billing_email`: `{Student github account email}`
-	`company`: `{Organization Name}`
-	`description`: `{StudentName} {StudentSurname} organization for EPAM Terraform Lab`
-	`default_repository_permission`: `"read"`
-	`members_can_create_repositories`: `false`
-	`members_can_create_public_repositories`: `false`
-	`members_can_create_private_repositories`: `false`
-	`members_can_create_internal_repositories`: `false`
-	`members_can_create_pages`: `false`
-	`members_can_create_public_pages`: `false`
-	`members_can_create_private_pages`: `false`
-	`members_can_fork_private_repositories`: `false`
-	`web_commit_signoff_required`: `true`
-	`dependabot_alerts_enabled_for_new_repositories`: `true`
-	`dependabot_security_updates_enabled_for_new_repositories`: `true`
-	`dependency_graph_enabled_for_new_repositories`: `true`

**Hint**: A local value assigns a name to an expression, so you can use it multiple times within a module without repeating it. 

Store all resources from this task in the `settings.tf` file.
Store all locals in `locals.tf`.

Run `terraform validate`  and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when you're ready.

### Definition of DONE:

- Terraform created resources with no errors
- GitHub organization is configured as expected (check GitHub WebUI)
- Push *.tf configuration files to git

## TASK 2 - Create an organization secret

Ensure that the current directory is `/tf-epam-lab/non_cloud_task/github/base`

- Generate a read only personal GitHub token [refer to this document](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token). 
- Create empty variable `read_only_gh_token` but with the following description `Provides read only GitHub token`. <br><b><mark>Never store you secrets inside the code!</b></mark>
- Create a `secrets.tf` file with `github_actions_organization_secret` resource (`visibility="selected"`). Use `read_only_gh_token` variable as a secret value source.
- Run `terraform plan` and provide required public key. Observe the output and run `terraform plan` again.
- To prevent providing read only token on each configuration run and staying secure set binding environment variable - `export TF_VAR_read_only_gh_token="{YOUR_READ_ONLY_GITHUB_TOKEN}"`
- Run `terraform plan` and observe the output.

Run `terraform validate` and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.

Apply your changes when ready.

### Definition of DONE:

- Terraform created resources with no errors
- GitHub organization secret is configured as expected (check GitHub WebUI)
- Push *.tf configuration files to git

## TASK 3 - Create teams and memberships

Ensure that the current directory is  `/tf-epam-lab/non_cloud_task/github/base`

Create an S3 bucket as the storage for your infrastructure:

-	Create `members.tf`.
-   Create an organization team (`name="devops-team"`, `privacy="secret"`)
-	Create at least 1-2 members (`role="member"`) and add them to the team.

**Hint**: Use your coalligues' GitHub account usernames as members in terms of this lab.

Run `terraform validate` and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when ready.

### Definition of DONE:

- Terraform created resources with no errors
- GitHub team and members resources created as expected (check GitHub WebUI)
- Push *.tf configuration files to git

## TASK 4 - Create a security manager
Ensure that the current directory is  `/tf-epam-lab/non_cloud_task/github/base`

Create a GitHub organization project resource with attributes:
-   Create add a new team resource (`name="security-team"`).
-   Create add a new security manager for the organization and assign to the created team.

Store all resources from this task in the `security.tf` file.

Run `terraform validate`  and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when ready.

### Definition of DONE:

- Terraform created resources with no errors
- GitHub team and security manager assignment are created as expected (check GitHub WebUI)
- Push *.tf configuration files to git

## TASK 5 - Create a Private Repository
Ensure that the current directory is  `/tf-epam-lab/non_cloud_task/github/base`

Create the following repository with attributes:
- `name`: `"tf-lab-devops"`
- `description`: `"{StudentName} {StudentSurname}, TF EPAM lab repository for DevOps team"`
- `vulnerability_alerts`: `true`
- `visibility`: `"private"`

Store all resources from this task in the `base_repository.tf` file.

Run `terraform validate`  and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying  your changes.
Run `terraform plan` to see your changes.

Apply your changes when ready.

### Definition of DONE:

- Terraform created resources with no errors
- GitHub repository is created as expected (check GitHub WebUI)
- Push *.tf configuration files to git

## TASK 6 - Form TF Output
Ensure that current directory is  `/tf-epam-lab/non_cloud_task/github/base`

Create outputs for your configuration:

- Create `outputs.tf` file.
- Following outputs are required: `organization_id`, `teams_names`[set of strings], `security_manager_team_slug`, `secrets_names`[set of strings], `base_repository_name`.

Store all resources from this task in the `outputs.tf` file.

Run `terraform validate`  and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when ready. You can update outputs without using `terraform apply` - just use the `terraform refresh` command.

### Definition of DONE:

- Push *.tf configuration files to git

## TASK 7 - Configure a remote data source

Learn about [terraform remote state data source](https://www.terraform.io/docs/language/state/remote-state-data.html).

! Change the current directory to  `/tf-epam-lab/non_cloud_task/github/repos`
! Copy `root.tf` from `/tf-epam-lab/non_cloud_task/github/base` to `/tf-epam-lab/non_cloud_task/github/repos`

Add remote state resources to your configuration to be able to import output resources:

-	Create a data resource for base remote state. (backend="local")

Store all resources from this task in the `data.tf` file.

Run `terraform validate`  and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when ready.

### Definition of DONE:

- Push *.tf configuration files to git

## TASK 8 - Create a Secure Public Repository

Ensure that the current directory is  ``/tf-epam-lab/non_cloud_task/github/repos`

- Create a repository resource with attributes:
    - `name=tf-lab-frontend`
    - `description="TF EPAM lab repository for frontend app"`,
    - `vulnerability_alerts=true`,
    - `visibility="public"`,
    - `has_issues=true`,
    - `has_projects=true`,
    - `has_wiki=true`,
    - `allow_squash_merge=true`,
    - `allow_merge_commit=true`,
    - `allow_rebase_merge=true`,
    - `delete_branch_on_merge=true`,
    - `auto_init=true`.
- Assign `push` permissions to the repository for `devops-team` and `security-team`.
- Provide access to the created organization secret for the repository.
- Create `.github/CODEOWNERS` files with the content:
    ```
    *      @{ORGANIZATION_NAME}/{SECURITY_TEAM_SLUG}
    ```

Store all resources from this task in the `repositories.tf` file.

Run `terraform validate` and `terraform fmt` to check if your configuration valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when you're ready.

As a result a GitHub repository should be created with appropriate teams' permissions, a project and `CODEOWNERS` file should be created in the repository. 

### Definition of DONE:

- Terraform created resources with no errors
- GitHub repository is created as expected (check GitHub WebUI)
- `CODEOWNERS` file exists in the repository.
- Push *.tf configuration files to git

    
# Working with Terraform state

**Mandatory**: Please do not proceed to TASKs 9-14 until your have finished previous tasks.

## TASK 9 - Move state to Postgres database

Hint: Create a docker container with Postgres databases as a pre-requirement for this task. 
```bash
docker run -d --name pg-state -e POSTGRES_USER=tfstate -e POSTGRES_PASSWORD={YOUR_PASSWORD} -e POSTGRES_MULTIPLE_DATABASES=repos,base -p 5432:5432 gradescope/postgresql-multiple-databases:14.4
```

Learn about [terraform backend in Postgres](https://developer.hashicorp.com/terraform/language/settings/backends/pg)

Refine your configurations:

- Refine `base` configuration by moving local state to a postgres database.
- Refine `repos` configuration by moving local state to a postgres database.

Hint: configuration for `base` state:
```tf
  backend "pg" {
    conn_str = "postgres://tfstate:{YOUR_PASSWORD}@localhost/base?sslmode=disable"
  }
```

Do not forget to change the path to the remote state for `compute` configuration.

Run `terraform validate` and `terraform fmt` to check if your modules valid and fits to a canonical format and style.
Run `terraform plan` to see your changes and re-apply your changes if needed.

## TASK 10 - Move resources

Learn about [terraform state mv](https://www.terraform.io/docs/cli/commands/state/mv.html) command

You are going to move previously created resource(DevOps repository) from `base` to `compute` state.
Hint: Keep in mind that there are 3 instances: GitHub resource, Terraform state file which store some state of that resource, and Terraform configuration which describe resource. "Move resource" is moving it between states. Moreover to make it work you should delete said resource from source configuration and add it to the destination configuration (this action is not automated).

- Move The created GitHub repository `tf-lab-devops` resource from the `base` state to the `compute` using `terraform state mv` command.
- Update both configurations according to this move.
- Run `terraform plan` on both configurations and observe the changes. Hint: there should not be any changes detected (no resource creation or deletion in case of correct resource move).

Run `terraform validate` and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style.

### Definition of DONE:

- Terraform moved resources with no errors
- GitHub repository is created as expected (check GitHub WebUI)

## TASK 11 - Import resources

Learn about the [terraform import](https://www.terraform.io/docs/cli/import/index.html) command.

You are going to import a new resource (repository `tf-lab-backend`) to your state.
Hint: Keep in mind that there are 3 instances: GitHub resource, Terraform state file which store some state of that resource, and Terraform configuration which describe resource. "Importing a resource" is importing its attributes into a Terraform state. Then you have to add said resource to the destination configuration (this action is not automated).

- Create a GitHub repository in the created GitHub organization via GitHub WebUI (`name="tf-lab-backend"`).
- Add a new resource `github_repository` `tf_epam_lab_backend_repository` to the `compute` configuration.
- Run `terraform plan` to see your changes but do not apply changes.
- Import `tf_epam_lab_backend_repository` repository to the `compute` state.
- Run `terraform plan` again to ensure that import was successful.

Run `terraform validate` and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style.

- Terraform imported resources with no errors
- GitHub resources are NOT changed (check GitHub WebUI)

## TASK 12 - Use data discovery
Learn about [terraform data sources](https://www.terraform.io/docs/language/data-sources/index.html) and [querying terraform data sources](https://learn.hashicorp.com/tutorials/terraform/data-sources?in=terraform/configuration-language&utm_source=WEBSITE&utm_medium=WEB_BLOG&utm_offer=ARTICLE_PAGE).

In this task we are going to use a data driven approach instead to use remote state data source.

#### compute configuration
Change the current directory to `/tf-epam-lab/non_cloud_task/github/repos`

Refine your configuration:

- Use a data source to request the following resources: `organization_id`, `organization_members`, `organization_teams`, `github_actions_organization_secrets`.

Hint: These data sources should replace remote state outputs, therefore you can delete `data "terraform_remote_state" "base"` resource from your current state and the `outputs.tf` file from the `base` configuration. **Don't forget to replace references with a new data sources.**
Hint: run `terraform refresh` command under `base` configuration to reflect changes.

Store all resources from this task in the `data.tf` file.

Run `terraform validate` and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes. Also you can use `terraform refresh`.
If applicable all resources should be defined with the provider alias.

Apply your changes when ready.


# Advanced tasks

## TASK 13 - Create dynamically manageable resources

Ensure that the current directory is  `/tf-epam-lab/non_cloud_task/github/base`

Make the organization teams memberships management more manageable. In order to do this, for each team create a variable. For instance, for the team `security-team` create a variable:
```tf
variable "security_team_membership" {
  type = list(strings)
}
```
Create a file `github-team-membership.auto.tfvars`.
To this file add values for the variable `security_team_membership`:
```
security_team_membership = [
  "username1",
  "username2"
]
```

Configure resources in the file `members.tf` to use created variables in order to create resources dynamically.

**Hint:** Use this [documentation](https://developer.hashicorp.com/terraform/language/meta-arguments/count).

Run `terraform validate` and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when ready.

### Definition of DONE:

- Terraform imported resources with no errors
- GitHub resources are NOT changed (check GitHub WebUI)

## TASK 14 - Modules

Learn about [terraform modules](https://www.terraform.io/docs/language/modules/develop/index.html)

Refine your configurations:

- Refine `repos` configuration by creating a repository module.


Store your modules in `/tf-epam-lab/non_cloud_task/github/modules` subfolders.

Run `terraform validate` and `terraform fmt` to check if your modules are valid and fit to a canonical format and style.
Run `terraform plan` to see your changes and re-apply your changes if needed.
