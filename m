Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C53E1E34FA
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgE0BuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:50:01 -0400
Received: from mail-vi1eur05on2068.outbound.protection.outlook.com ([40.107.21.68]:61537
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727041AbgE0BuA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:50:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c2uvfPLpDd58tfbQa1cHUIoP3xxmEXYAruGZxrFffRCQVj33kHd44g/cjqRvUJ2cVOtRXUZGmxtX0bLeUMAHLQNqXOVfbb0gHxRGAVa2vK3nb0StFiYnco4JZrBp7KYly1o6tsVyr6tZTjp5q89nfFzKdLj+LbDPSrfhDTJfp9ouwjFVC6oM9QaFIql61bHKnOOXSR8vUiCVC6wajbtxkyWpgK7slfrjWUiwNgEapLTVwzVGYOh8e9lm6gbZd7Ys+CWAVP21v6ACM95rdIaJGtKuz2zJ88Pb8FazL6aT4RmI3p5Z6JQlwNxTQoECYxE4TzaXgNWQo3kEUHOLLRt3oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uLWkKiDFsNsAztdtfhXWLSsyf1oTKDTXAdMsWYfdXlQ=;
 b=eoBtAXFFVM0KSljrhSofiUwWw7SnbMuv9zWUdqBtlrtfGwOcYmxSHCY4x9EVT+05mCWkFib5MJWTmCktqqMOjwwYoNzCuyDHLq6ERNNe1SY+1UjqhBDiZfH0GioJbjamEj6Jdh/4MeFdFl2SO2zHYF4NV9kl8uMogP8pSvLUOWMhDUagjloJKbyjuaHl3h4pLqtjzqHUPJWOZDaiKbx7RSPwLILHqz4HmUqqsPKuXvcifbHxaWfP9isvgLj6Kqr0m6fliN54sIgmSGO6vtaqYRrQmxWF4qI/MPy562HqLJQ6vEKhPlQa+e2ha/DZc09T0IEXJ3ROGneJFLOQLG59RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uLWkKiDFsNsAztdtfhXWLSsyf1oTKDTXAdMsWYfdXlQ=;
 b=eKiOrvK4wpf3HBXf5vq0ol4q2x5edc2tNYd2BsD53EzEHHFn2gSn7rF3jQiSVW4oq0bX7tN1BrGOtPFAJGmBN1GT9roZf80IGxAGLS8GYXGjlBzucgiKzn9xq2dYfpK7S8/ZQLoJt4YuUmcqmF9OTe7Iv2Wu58ss9OrC0tu2NuM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6637.eurprd05.prod.outlook.com (2603:10a6:800:142::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.26; Wed, 27 May
 2020 01:49:53 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 01:49:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/16] mlx5 updates 2020-05-26
Date:   Tue, 26 May 2020 18:49:08 -0700
Message-Id: <20200527014924.278327-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0061.namprd11.prod.outlook.com
 (2603:10b6:a03:80::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0061.namprd11.prod.outlook.com (2603:10b6:a03:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Wed, 27 May 2020 01:49:51 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4f35d190-9fb2-4099-4ccd-08d801e03fbe
X-MS-TrafficTypeDiagnostic: VI1PR05MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB66372C0849F327FE1FAED877BEB10@VI1PR05MB6637.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2bDXSIRG75yobG1Pu2AEQryZZnw8rmXcr52aPyTHeb+g9+Zpk63zOWj+bNknhTdGIBQnXwLgzit3N4P+Rb+RKsX7p86LPNLD83Bzb9QcdxP0SSCnWOlcFf6h60kl0sDLwHLxQ8ddE3c4nlbL3kE6oak1rPWEJ0KQDuRhHQesWPTshTr14+yB6uo0OMHP49nDLj9KQH42h8oT7auFjoQ9HggRFhshD8b/NLssy1pTFdVoAqQuw5CDGCoyH06utu3qHJPXUOCkPawBKjfRNDrcAftgCajKorrxXRRplHMgLlWFAwl15XVlArwCwQhN8VfBfSOj0VbgExlPtUz+YyhOIZzTGxAULAAXaVpT+V0B8F2q/G5xx8ibnJUaoBMrsdIZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39850400004)(26005)(6506007)(6486002)(6512007)(8676002)(478600001)(16526019)(86362001)(2906002)(186003)(6666004)(5660300002)(1076003)(66476007)(36756003)(2616005)(956004)(66946007)(107886003)(8936002)(15650500001)(316002)(52116002)(66556008)(4326008)(83380400001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UBDyEfYI77xNYbVLwoPlFzYLwGPT5XBQMExtJNQCsg2eHrO/CCe3aMb7MPX4PKx5IUGLNtOawEQDOmiU2xYFA3M4cIMuPDH0lNUW0xkpN2p0Z9NTMRTuX0PteJSpjZkeGNDxavGH5v/kPLyQ1g0Y8F2Op4mEhMxNgbGKK8Z0iiUpObtM6MNP7qjbdawgEWHaN8oi0790q/N++oF4VWdvlKLWW4L9iZZm3+5b7dLfGY37LcbOV8lttBaSu2vld40RgSMzvHufJtkRru1gNT7c6m5seoNphfYiVVz6qp4Kd3VaHjisfmhstsO1rJCcOUbPrJWQi14WuXj4u1BHK1MPUI8OEPv5ffl2+uPdsXTqdA+BdQraMcwWOowjJAWeLx0yWbGf1SsFpitum+ouNX3W/DBlgBNTFQaIh4fAHTn2uZEyrwurvFjWLYfZicRcEyryi5Q7/gmlIzUz/d49gkc8MjxTUS27rOa4s4UV9x8h4aM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f35d190-9fb2-4099-4ccd-08d801e03fbe
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 01:49:53.1210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cUdzH+Pryi4NPOA1TGLrRfyzN6YqEsRdDlzfvlCzBjk33z7ODYKy88OW8808ZIaqY2VAsGXRi0JDzclcoPDciA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6637
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave/Jakub.

This series adds support for mlx5 switchdev VM failover using FW bonded
representor vport and probed VF interface via eswitch vport ACLs.
Plus some extra misc updates.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit fb8ddaa915395c97f234340f465a4c424a7be090:

  Merge tag 'batadv-next-for-davem-20200526' of git://git.open-mesh.org/linux-merge (2020-05-26 15:19:29 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-05-26

for you to fetch changes up to e95af813ca7ba71840d0407c87f573b540d70c1b:

  net/mlx5: DR, Split RX and TX lock for parallel insertion (2020-05-26 18:37:18 -0700)

----------------------------------------------------------------
mlx5-updates-2020-05-26

Updates highlights:

1) From Vu Pham (8): Support VM traffics failover with bonded VF
representors and e-switch egress/ingress ACLs

This series introduce the support for Virtual Machine running I/O
traffic over direct/fast VF path and failing over to slower
paravirtualized path using the following features:

     __________________________________
    |  VM      _________________        |
    |          |FAILOVER device |       |
    |          |________________|       |
    |                  |                |
    |              ____|_____           |
    |              |         |          |
    |       ______ |___  ____|_______   |
    |       |  VF PT  |  |VIRTIO-NET |  |
    |       | device  |  | device    |  |
    |       |_________|  |___________|  |
    |___________|______________|________|
                |              |
                | HYPERVISOR   |
                |          ____|______
                |         |  macvtap  |
                |         |virtio BE  |
                |         |___________|
                |               |
                |           ____|_____
                |           |host VF  |
                |           |_________|
                |               |
           _____|______    _____|_____
           |  PT VF    |  |  host VF  |
           |representor|  |representor|
           |___________|  |___________|
                \               /
                 \             /
                  \           /
                   \         /                     _________________
                    \_______/                     |                |
                 _______|________                 |    V-SWITCH    |
                |VF representors |________________|      (OVS)     |
                |      bond      |                |________________|
                |________________|                        |
                                                  ________|________
                                                 |    Uplink       |
                                                 |  representor    |
                                                 |_________________|

Summary:
--------
Problem statement:
------------------
Currently in above topology, when netfailover device is configured using
VFs and eswitch VF representors, and when traffic fails over to stand-by
VF which is exposed using macvtap device to guest VM, eswitch fails to
switch the traffic to the stand-by VF representor. This occurs because
there is no knowledge at eswitch level of the stand-by representor
device.

Solution:
---------
Using standard bonding driver, a bond netdevice is created over VF
representor device which is used for offloading tc rules.
Two VF representors are bonded together, one for the passthrough VF
device and another one for the stand-by VF device.
With this solution, mlx5 driver listens to the failover events
occuring at the bond device level to failover traffic to either of
the active VF representor of the bond.

a. VM with netfailover device of VF pass-thru (PT) device and virtio-net
   paravirtualized device with same MAC-address to handle failover
   traffics at VM level.

b. Host bond is active-standby mode, with the lower devices being the VM
   VF PT representor, and the representor of the 2nd VF to handle
   failover traffics at Hypervisor/V-Switch OVS level.
   - During the steady state (fast datapath): set the bond active
     device to be the VM PT VF representor.
   - During failover: apply bond failover to the second VF representor
     device which connects to the VM non-accelerated path.

c. E-Switch ingress/egress ACL tables to support failover traffics at
   E-Switch level
   I. E-Switch egress ACL with forward-to-vport rule:
     - By default, eswitch vport egress acl forward packets to its
       counterpart NIC vport.
     - During port failover, the egress acl forward-to-vport rule will
       be added to e-switch vport of passive/in-active slave VF
representor
       to forward packets to other e-switch vport ie. the active slave
       representor's e-switch vport to handle egress "failover"
traffics.
     - Using lower change netdev event to detect a representor is a
       lower
       dev (slave) of bond and becomes active, adding egress acl
       forward-to-vport rule of all other slave netdevs to forward to
this
       representor's vport.
     - Using upper change netdev event to detect a representor unslaving
       from bond device to delete its vport's egress acl forward-to-vport
       rule.

   II. E-Switch ingress ACL metadata reg_c for match
     - Bonded representors' vorts sharing tc block have the same
       root ingress acl table and a unique metadata for match.
     - Traffics from both representors's vports will be tagged with same
       unique metadata reg_c.
     - Using upper change netdev event to detect a representor
       enslaving/unslaving from bond device to setup shared root ingress
       acl and unique metadata.

2) From Alex Vesker (2): Slpit RX and TX lock for parallel rule insertion in
software steering

3) Eli Britstein (2): Optimize performance for IPv4/IPv6 ethertype use the HW
ip_version register rather than parsing eth frames for ethertype.

4) Mark Bloch (1): Add basic suspend/resume support

----------------------------------------------------------------
Alex Vesker (2):
      net/mlx5: DR, Add a spinlock to protect the send ring
      net/mlx5: DR, Split RX and TX lock for parallel insertion

Eli Britstein (2):
      net/mlx5e: Helper function to set ethertype
      net/mlx5e: Optimize performance for IPv4/IPv6 ethertype

Mark Bloch (1):
      net/mlx5: Add basic suspend/resume support

Or Gerlitz (2):
      net/mlx5e: Use netdev events to set/del egress acl forward-to-vport rule
      net/mlx5e: Offload flow rules to active lower representor

Parav Pandit (1):
      net/mlx5: Add missing mutex destroy

Vu Pham (8):
      net/mlx5: E-Switch, Refactor eswitch egress acl codes
      net/mlx5: E-Switch, Refactor eswitch ingress acl codes
      net/mlx5: E-Switch, Introduce APIs to enable egress acl forward-to-vport rule
      net/mlx5e: Support tc block sharing for representors
      net/mlx5e: Add bond_metadata and its slave entries
      net/mlx5: E-Switch, Alloc and free unique metadata for match
      net/mlx5e: Slave representors sharing unique metadata for match
      net/mlx5e: Use change upper event to setup representors' bond_metadata

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   7 +-
 .../mellanox/mlx5/core/diag/fs_tracepoint.c        |  85 ++--
 .../net/ethernet/mellanox/mlx5/core/en/rep/bond.c  | 350 +++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  10 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  21 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  30 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |  13 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  96 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   4 +
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c       | 170 +++++++
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c       | 235 +++++++++
 .../ethernet/mellanox/mlx5/core/esw/acl/helper.c   | 160 ++++++
 .../ethernet/mellanox/mlx5/core/esw/acl/helper.h   |  26 +
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      | 279 ++++++++++
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c      | 322 ++++++++++++
 .../net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h |  17 +
 .../net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h |  29 ++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 559 +--------------------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  41 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 401 +++------------
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  34 +-
 .../mellanox/mlx5/core/steering/dr_domain.c        |  14 +-
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  10 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  31 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |  13 +-
 .../mellanox/mlx5/core/steering/dr_table.c         |  12 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |  25 +-
 27 files changed, 1983 insertions(+), 1011 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
