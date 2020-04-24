Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0AD51B7F3A
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 21:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgDXTpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 15:45:47 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:44128
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726908AbgDXTpr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 15:45:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5+Pyx6YYEsaF/jTRhytSI5vRKXavObEhlHOWXAiIHb13RWFJWZKSedO3zdYsMug2r1UPxk4ynEeTFSxme0zYmCV0cVYFCQYxF6LB1aFNSeqdwmnZ5S8nkyYPlIHMDglnqP+oLEQOPxK6FfHTrHrxYA3QO2sje5lJySVTnezCLB8haPS1mFnwnlvd+Q7kGnmJrx4w5K8bsXrMhou3XBNCZLOlwJlmSichWdIWKO+LEZ9kRt7+7VvmRApiiDSfsQrQg+CzkqzVhvItmfRsNBCNVuZcq+mbKIoznc6V0yrb+Va/FtlBXTEhtGQ9tw5KXNQR0RYCD20AETT2eTsfZWg6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yePYpO97945zQIsJzH4azEee8B65mnqYOqpdGZ8O2es=;
 b=KAXlZMZlGB8wpLfaVN/nOAt6UGT33ziL72z3+x2tROi1C333Qg+/Y8TdqqtAcp+Lh/3h3iFoBrUxc6GqTPE2KIfcIulUH0Ydnjj2dky/fyAGb5pp73ARCapuyfgkDXRPtykmHjYWYDhnF/1jqN67omhODopS3F82N8/r7UrIpvcrAVMzOv4vXyUmBPjjGh4L1r9FuOSg9jihPRtlKZ0fyyHMRqbTA2OGVXCm4rdZ0OAAC/9d6+kuGisj7Ry7HDEA72Lq3XBO7Ivw+R2DHvYMyUw3ebek23EFnOwc6gxVFT4AkiUjdNB9b5z4Wu7nBcur8FOg9MIcHwxuyIMw1ZkLBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yePYpO97945zQIsJzH4azEee8B65mnqYOqpdGZ8O2es=;
 b=suEPXysAvK7+/DCRiP4vhtUjEgKK3W6vluB34k3YlrQXAcJeiG5GZTSwljLOUOFsFryu3T5xlq1r5lHcRcwOUS6AMCrj5+8/81z9TuoREKiPU6jm5de97RCV6cOHUnp7ge8EES22WwSxUlpAlL1w7yAOT6JgQwgneuIReLMjEVg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5072.eurprd05.prod.outlook.com (2603:10a6:803:61::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Fri, 24 Apr
 2020 19:45:32 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.020; Fri, 24 Apr 2020
 19:45:32 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH mlx5-next 0/9] Mellanox, mlx5-next updates 2020-04-24
Date:   Fri, 24 Apr 2020 12:45:01 -0700
Message-Id: <20200424194510.11221-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0016.namprd06.prod.outlook.com (2603:10b6:a03:d4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 19:45:30 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5f059c91-2673-4ea6-2341-08d7e8880c78
X-MS-TrafficTypeDiagnostic: VI1PR05MB5072:|VI1PR05MB5072:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB50729958C7F898E3102E3AA9BED00@VI1PR05MB5072.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(6506007)(26005)(2616005)(8936002)(8676002)(316002)(6636002)(36756003)(6666004)(15650500001)(66946007)(66556008)(52116002)(81156014)(478600001)(66476007)(6512007)(956004)(5660300002)(110136005)(4326008)(1076003)(16526019)(186003)(2906002)(6486002)(86362001)(450100002)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mGJ0XPvo3L71N1dKc3PSyCk2omUVWGcxIR02G7d1s7OMGSDmeVnm1ljc0qFVSyLqdETv7RkYplOdcfr7r2y8AeCsWf2fKlsyegxzDKCD9pUnfyBEXtm7bdvV09vjYTGGoaJaRR/Chi0l7ZF9SqVukUhONTqRbf5dpF5IfCvKoKVLgh1B0xiZcFbWsGC2FK59MXX9IAFlMj7Y7cD1p0vZu2gDHO8eGZjlr+lnDvPCKbEFqPJTLG4SEpjwjkiPOx1HC8OZUMabZHSI3HOBhskMSANhrrtvSTWMVXIlGeoSxA0sq4tplH34wVXIIScguvlu8nFkltSxUczMcy2JYvG1Nz0oDmR8e1cZl2KiRCDCAoFd1PPwtODbxXh1uNq1lqGjQ2eSz3FT+vAfAcfyCjpbJdpuxFqDqhazJ5LmD7vb4cfTXa2MLA59TJy077P7AujrkVVjNCb7pd/Dms9IGyLtjzAcVWcBidWog+btICfrBGlbij7L0L3AnwO4+d9YjDHG
X-MS-Exchange-AntiSpam-MessageData: XJARCXta1QN+nLMsahyXb/GZuwncsZzwCE/sddRd+TXpZOz53v9O/LrZcF0KnkiGFgWzdbhqN4QWFPHEKUYpdTH5vj3msRjdakK9CKnvEarq9CQU5Ik3P0Xg2u+YiKRXdlxCHdF1iqb0PWKVOkuPtQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f059c91-2673-4ea6-2341-08d7e8880c78
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 19:45:32.1828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: POAi38lNe6bNsJXSnNmPW+IjW1jwLbqK5/HpQYD+O+fkPUf9FcG6WSl1zfi8uresxu4N8QRr831BC2ml9kSlKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, 

This series provides misc mlx5 updates, mostly HW bits and definitions:

1) release all pages FW capability but
2) Aligned ICM memory allocation
3) COPY steering action
4) bits and definitions for FW update feature
5) IPSec and TLS related HW bits

In case of no objection this series will be applied to mlx5-next branch
and sent later as pull request to both rdma-next and net-next branches.

Thanks,
Saeed.

---

Eran Ben Elisha (1):
  net/mlx5: Add release all pages capability bit

Erez Shitrit (1):
  net/mlx5: Use aligned variable while allocating ICM memory

Huy Nguyen (1):
  net/mlx5: Add support for COPY steering action

Moshe Shemesh (2):
  net/mlx5: Add structure layout and defines for MFRL register
  net/mlx5: Add structure and defines for pci sync for fw update event

Raed Salem (3):
  net/mlx5: Introduce IPsec Connect-X offload hardware bits and
    structures
  net/mlx5: Refactor imm_inval_pkey field in cqe struct
  net/mlx5: TX WQE Add trailer insertion field

Tariq Toukan (1):
  net/mlx5: Introduce TLS RX offload hardware bits

 drivers/infiniband/hw/mlx5/cq.c               |   8 +-
 drivers/infiniband/hw/mlx5/flow.c             |   4 +-
 drivers/infiniband/hw/mlx5/main.c             |   2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   8 +-
 .../ethernet/mellanox/mlx5/core/esw/chains.c  |   2 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |   4 +-
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/dm.c  |  15 ++-
 .../mellanox/mlx5/core/steering/dr_icm_pool.c |  53 ++++----
 .../mellanox/mlx5/core/steering/fs_dr.c       |   2 +-
 include/linux/mlx5/device.h                   |  44 ++++++-
 include/linux/mlx5/driver.h                   |   4 +-
 include/linux/mlx5/mlx5_ifc.h                 | 123 ++++++++++++++++--
 include/linux/mlx5/qp.h                       |   6 +
 15 files changed, 214 insertions(+), 65 deletions(-)

-- 
2.25.3

