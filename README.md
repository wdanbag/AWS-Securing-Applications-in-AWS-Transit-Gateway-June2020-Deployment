# AWS-Securing-Applications-in-AWS-Transit-Gateway-June2020-Deployment
The following terraform templates implement the Reference Architecture for Palo Alto Networks VM-Series Transit Gateway VPC Model for June 2020 release found at https://www.paloaltonetworks.com/resources/reference-architectures/aws.

# Transit Gateway Topology
In the topology below everything but the Panorama Management VPC is create or the VPN back to a corporate datacenter.  
![image Transitgateway Topology](https://user-images.githubusercontent.com/55389530/89569910-633a2080-d7f3-11ea-964a-14982fb2bc67.png)


# Instructions
Instructions for creating the VM-Series Transit Gateway Model can be found under the docs folder in Readme.pdf.

# Support Policy
The guide in this directory and accompanied files are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself. Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.


# License
Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
