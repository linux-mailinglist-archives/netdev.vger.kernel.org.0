Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8E5718941A
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 03:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgCRCsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 22:48:03 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:20090
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726607AbgCRCsD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 22:48:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XRxPB6PLDMeQRy/3i7C4RclA/zLXsBfnoJ8cUWYinKhY6ZA9AQdI0sFMYMAWRi1tnRYL2I2iKR8fCAT6mBIg/+W30spYqz5Ho+Pv26uEyqG68/SeaUpEfonWCk8Z+127SpiFlv3O1nABN8vJoomX44dSmvqv/sRXawDLGqRRwFGcVSJhQv6gVl9k1ZxGFK3VxLeqaUYR783SGA8S6dAo2mduW7eLUjlJuaZ1sRfnpnUQRdCxjpTSZDuZUYcJzQWS0jqwZ+TcKupki40k/lCSK/r426zOtqIQOlKc/CMQ1XemujXO8+5zOB9T5cw0zE+6xrV9QuA+oSlQ8eCjLagP5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tkbq9uQUsypkwN7hcy/3K1B4+ncY2WNbR+dLROezdVE=;
 b=R6Dne3lEZ6I+UpK90KerPVXyVwJf39pPtb+vpKWSxn1fKnG00ILlH/cvuxKITrDH2U26fq0eCiYl+q23NxiM6faI0FWzKvTtNSjHMYSotq18i3LpmwQwuXSH3/c5x1Ek+i3yPO+9DTdW+s9BGKl6G2fOA8BZkB5UGKjW/dW52aPlERococBJyf/k0244u43BsQK320HIBRQ7tX27vkRrj/wxNvQ99R6GazoMp/YmM07YceRN/pAjE0n6MwfDyXbZ/YQyQM1IQoS0NweKTFIAemP7ESfCDGeqBcUDGQXKtlsLq1CQUd8dTSyPbOwF1pFPvfcbapgJkKEgrLOaez0R6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tkbq9uQUsypkwN7hcy/3K1B4+ncY2WNbR+dLROezdVE=;
 b=Q9516C7W/TxtTjPyHufLq3JaLU8Bx0NzuDu56P4mIKnHKRJEWMuxmosWk8SI6yVL6zxS0J/O7awp0P+U6QV5va8dSuM86CzdS4dd5MdgTkKM8aqKXfGsp6HWSxnY9ghNAEClsUmVpoOQREAU3yv5ok8SR6bPA1mmwLGxW1Eoc5U=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4109.eurprd05.prod.outlook.com (10.171.182.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Wed, 18 Mar 2020 02:47:56 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 02:47:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/14] Mellanox, mlx5 updates 2020-03-17
Date:   Tue, 17 Mar 2020 19:47:08 -0700
Message-Id: <20200318024722.26580-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:180::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR13CA0027.namprd13.prod.outlook.com (2603:10b6:a03:180::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.12 via Frontend Transport; Wed, 18 Mar 2020 02:47:54 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 73389cdb-a18b-4618-de98-08d7cae6c325
X-MS-TrafficTypeDiagnostic: VI1PR05MB4109:|VI1PR05MB4109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB41095B358C6C0EB5A778782ABEF70@VI1PR05MB4109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(199004)(956004)(478600001)(2616005)(6486002)(2906002)(5660300002)(52116002)(86362001)(81156014)(6506007)(81166006)(4326008)(107886003)(8676002)(8936002)(26005)(66946007)(15650500001)(186003)(16526019)(1076003)(6512007)(66556008)(6666004)(66476007)(36756003)(316002)(6916009)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4109;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mtE7GRfVySHahcYTM37A8iBAUlW33WJnfD1MHGrrCzWfYYyW2SwZj5TYxKtDDGlE9MePrRcPUcX+ORC5SlZcZwB01LbaNl/fbuQYR6F2wiUvTFFP2rpLv0ARS2/OlAByToopd/0U4W+pQewykwMaYgI2UXR5ilaFESRHi4fFEGFfg3U417K7Oupt6pZC2/yk4xG9ntHn8UFXiDfPO5bGEyysIEjTuxTyK0ujxW9AOoj/yXQe5jYomYAmJw9QVt8EtzKuqhgvz7/LALofQt8A/jhttLRM5AcNv0Vkz/QBp/nraUbDDFu8KiG3IOFHCv3CFHrGeOLTn5BQBS8BrFQpclHZ7T1aQPvG6KONnbDuyEoVZPrMnqIgsy8vE6ZRM0TvwdVtajoup1IHPVxKUSFOcorRssrIR19tRkrvbCEoolGAoc8VQH2T+aIvF0d3m2TCenBPrS9wt1Aq3Ns+KNPAmgc/GRLGFVEcS3Sl58GpUpawjusuoGEcR9t+3Gm5JCkdq63x3dQiQcS6/jb+Yjbd2Z9nmxuc0msm50GVCM0ktWY=
X-MS-Exchange-AntiSpam-MessageData: f7VlL9noE8EitdGueBL7Rjr1MvK+Wjz+endN/gD7PdRZfvm5e8BvMk3yAp8Z5h2ZnYP6dXa3npES5vPvYp8frv0ZGA/J3G0njg0k2iNpDNtD4tuCVBjOm1Kg3esDosmwKbQXvdTyRqWX35jgKKQe4A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73389cdb-a18b-4618-de98-08d7cae6c325
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 02:47:56.4620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y+D4ye3D2w9cFEid3YYtyzNvZRdpv/QCray/soR8xdL7YpHpeW1O52qP9kL6pqchhDHKjcZRsRXlBJt2d+wMqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series provides some fixes and cleanups for issues introduced lately
in mlx5 Connection tracking offloads series. In the last 5 patches, Eli 
adds the support for forwarding traffic between uplink representors
(Hairpin for Switchdev mode).

For more information please see the tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 86e85bf6981c0c265c427d6bfe9e2a0111797444:

  sfc: fix XDP-redirect in this driver (2020-03-16 18:22:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-03-17

for you to fetch changes up to 87b51810f4ad99a833883f6f00795ee550f3a622:

  net/mlx5: Avoid forwarding to other eswitch uplink (2020-03-17 19:41:41 -0700)

----------------------------------------------------------------
mlx5-updates-2020-03-17

1) Compiler warnings and cleanup for the connection tracking series
2) Bug fixes for the connection tracking series
3) Fix devlink port register sequence
4) Last five patches in the series, By Eli cohen
   Add the support for forwarding traffic between two eswitch uplink
   representors (Hairpin for eswitch), using mlx5 termination tables
   to change the direction of a packet in hw from RX to TX pipeline.

----------------------------------------------------------------
Eli Cohen (5):
      net/mlx5: Avoid configuring eswitch QoS if not supported
      net/mlx5: Don't use termination tables in slow path
      net/mlx5e: Add support for offloading traffic from uplink to uplink
      net/mlx5: Eswitch, enable forwarding back to uplink port
      net/mlx5: Avoid forwarding to other eswitch uplink

Nathan Chancellor (1):
      net/mlx5: Add missing inline to stub esw_add_restore_rule

Paul Blakey (4):
      net/mlx5: E-Switch: Fix using fwd and modify when firmware doesn't support it
      net/mlx5: E-Switch, Skip restore modify header between prios of same chain
      net/mlx5e: CT: Fix insert rules when TC_CT config isn't enabled
      net/mlx5e: en_tc: Rely just on register loopback for tunnel restoration

Roi Dayan (1):
      net/mlx5e: Fix rejecting all egress rules not on vlan

Saeed Mahameed (1):
      net/mlx5e: CT: Fix stack usage compiler warning

Vladyslav Tarasiuk (1):
      net/mlx5e: Fix devlink port register sequence

YueHaibing (1):
      net/mlx5e: CT: remove set but not used variable 'unnew'

 .../net/ethernet/mellanox/mlx5/core/en/devlink.c   | 26 +++---
 .../net/ethernet/mellanox/mlx5/core/en/devlink.h   |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 34 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |  9 ++
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 16 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 86 +++++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  9 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 20 +++--
 .../mellanox/mlx5/core/eswitch_offloads_chains.c   | 15 +++-
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  | 99 ++++++++++++++++------
 include/linux/mlx5/mlx5_ifc.h                      |  3 +-
 12 files changed, 218 insertions(+), 105 deletions(-)
