Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0175E1C03C0
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgD3RU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:20:59 -0400
Received: from mail-eopbgr150078.outbound.protection.outlook.com ([40.107.15.78]:28495
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726355AbgD3RU6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:20:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NjIp2kO9pgnP5Q0Houz46lUm8vPHWmkCgi4dn3y0ZK8F5Ua158Y4tEbCAQZrtCEV53LRUOO+IlAmnxs8XgppTXHIIqr3+R+/svDU2EFRnBBAF3rVkE3wEClmD/1/PSCw19s1ORt70MvJIEQtkWGoDKI1X66bE1QoNtKK/31qK7QPiaMI0N0fdpxKiaZnWnIQxNftZQSFwJ4w7ywW2ute4C2iSOzbybgBVCHGPU5uEvIYMD5nNKW6NrBRN505D0addT1O6+W2fmH1YXJHg/8SX9CP7Vso2YiYFFx4dbGWRYI6LdAgcDEEzoPxpAM2VDxWCiOWEA7tqvg0YyhL6HqnKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ABE+gZkKEQTE/VSoIm8ySbJMcbNvnRc2rt9XmCYPVwg=;
 b=XnUCPLutqkLVGawuya+adYvuliPgCQwr6Deeink1QgX62Vn4ZdhMxno33c0bO5ZtZx7/ymW8Rj/JTqhvE+S68cHixOv5+KJBoXJWc6YtLvg5t695rZYsSqgCLcc81kqX5eYcrj6jkT9wiUdZ3PhBDSreF9aj4BBdpi6CrFTcJ1KFZGhAvNpnXl2fGpPyPjYJbNhpsssczbbkrqyt5ImFeCTlXGh+mX4w40E+elsd2R5DHY7U9bJ2Yve6miw8CT4o96QroeSUtiCqCvZNC77R+sRyrYDOT8r56EfA6B6OEZIobjVIxbwNFGhsnM2v68Bh1WQBsR0dwBLqhSmmP8rsvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ABE+gZkKEQTE/VSoIm8ySbJMcbNvnRc2rt9XmCYPVwg=;
 b=kHWkYeal5mAb/0anV2tQYShKqJxnZmbeCVicN7zkcbCWFTRfLzpCpkKAXAyZny51qCLGkT/aje9QJ42f/eRoXg03o9kUyFKg2Gt4iLX2ROfUYU8yhp0UVXdXNweSdtAWN0zsFSp/1A9draKpl0+bgHnueTJyM47RrDt4wsjroDQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6222.eurprd05.prod.outlook.com (2603:10a6:803:d1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Thu, 30 Apr
 2020 17:20:53 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 17:20:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/15] Mellanox, mlx5 updates 2020-04-30
Date:   Thu, 30 Apr 2020 10:18:20 -0700
Message-Id: <20200430171835.20812-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR17CA0030.namprd17.prod.outlook.com (2603:10b6:a03:1b8::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 17:20:51 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f40691c4-d3c1-4551-aba7-08d7ed2ad60e
X-MS-TrafficTypeDiagnostic: VI1PR05MB6222:|VI1PR05MB6222:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6222F4A79DBAD906053D1184BEAA0@VI1PR05MB6222.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(66556008)(8936002)(2906002)(8676002)(956004)(2616005)(66476007)(316002)(66946007)(6666004)(26005)(6512007)(86362001)(5660300002)(6506007)(1076003)(478600001)(6486002)(107886003)(15650500001)(4326008)(186003)(36756003)(16526019)(52116002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ePFwCSnqrIxWADKcSdjGQXLWfTMMzjyVf4uFlYZZPPuC76MFC0sZXx4fFhd3nxtcGrSzOIZZfpObDxM2KFScFeMP4WMkFBUCuxPJcKuC4DTTpk4hhosPqIHfBNHPtIiaoybCFIF9mPjVFiZLDdwf+wtMePULcTuwMSbSaaDhQsZkME3AOzcgyLI1OaFM3FfDuAcGJA6vXzMi2oCbnlv7QawbiWL7aJhVt9JH5mUE7ghtqswgY3sAaPVwRPSQkDTgAY0sE0fQ2BNaBz/QVWjtvzZEBvMg9v3yBtce1M9PiXXUuVlhom39MyXoSutED5403dKA9cz5O7x0QakuqviiB6mrmWOqnrGEuxo0z4k7uFKoM6fiNQbtwjhgm3F5TXGqJPFkcSeuY9Q0D0Nhwe2jrEAye+ubfVU7mlJI8T3hz7JGogc9NvBe7S3+/gCrRXxtL2gfEHujEWi6V5QFSnk2Dq0gh8Vuvm8sXZp1QXoCSoqdJ0GB1FgwPd8lvcJGJG4v
X-MS-Exchange-AntiSpam-MessageData: ngFSGXQ4xh8AxH24AkS/krLRqKmq8Ben4m0NaOl2Q1NrsQbI36+3dM9j2bKIBMM1XpvZWUpNy29Szw8whqw0vtgrRx8dTiSsw1yMEtQXIwHx2XpapUbFPmb15VXh+KBWeVeYsX9v+gsjL6wRNESfAvw04IcENzHRPwf6y5LiL/2JEHovlTonJqizS9TdpUqLJoVegsT3TnlvexJS4uvCqkqcxsgAJF6wTj5dWdwfJIWiGbdwxYsnHkm8IFMSlNlH5f4qbKmsftt2qmAptz3i3oBaKE8BIGQ6/8FB1W8rFzrskPlq5qaOqqfeOBKhUc5XcqxNM4Fm7FjLH+to1tEUnk7lv0IV/31bdFPFP5nHV8C79OUFzpyaM6RzEsM+HxDXlRsUCH6SIABiLvqKpOCWVwc5YSDKkWgIyOF4H6OW5TdWNtOxss7/1GZ1p0nSw5YxWFb7JQbXUsvKv0KMdVgwAVKussiTuojyiMMLSrx93JbunN4NOxok2Gc+Drd1zUBvYW6rsXicO3rIwWve1ubOojZXs9ioHnf+MLNzqQ/x4ddIewhf+otfzOyZwk3eqhMnDweAFlZe14QZ4mB4GWt0bhYgEIGYfZgKoGFZWQ+Ctf8R08HU8cP4Ak1lPzetsGzGOXnPz/Y0GxDDze0Lf8KFZUf3g8TvAI+WwbwMgB7qCRSoYIoe5ZW5uVMwqWiWuXfj7zwW30tnOL4dLz79R6daeIlxeBKdp4dqthyR6U/S/58j6JhRFVlvD5JSzAZ/5lpusRIrPC5yfDJ19J/8iOteg0mzPwu9pUlS2vaUkDbX7bg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f40691c4-d3c1-4551-aba7-08d7ed2ad60e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 17:20:53.4917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uw2bi3VQhIWdM2yQWInkgKEGeUEI/EAhFVEkNF0eQ096YSiAT8Ua2p4kpllBtV2yyKoAgu8kTne0JObSS6y7YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6222
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series adds misc updates to mlx5 driver.

For more info please see tag log below.

Please pull and let me know if there is any problem.

Please note that this series starts with a merge commit of mlx5-next
branch.

Merge conflict note:
Once merged with latest mlx5 fixes submission to net:
git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2020-04-29

A merge conflict will appear: 
This can be fixed by simply deleting dr_cq_event() function and the
one reference to it.

Thanks,
Saeed.

---
The following changes since commit a6b1b936057e874db52d3e5f0caeb42f11449acf:

  Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux (2020-04-30 09:49:53 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-04-30

for you to fetch changes up to ec9cdca0663a543ede2072ff091beec1787e3374:

  net/mlx5e: Unify reserving space for WQEs (2020-04-30 10:10:46 -0700)

----------------------------------------------------------------
mlx5-updates-2020-04-30

1) Add release all pages support, From Eran.
   to release all FW pages at once on driver unload, when supported by FW.

2) From Maxim and Tariq, Trivial Data path cleanup and code improvements
   in preparation for their next features, TLS offload and TX performance
    improvements

3) Multiple cleanups.

----------------------------------------------------------------
Eran Ben Elisha (3):
      net/mlx5: Add helper function to release fw page
      net/mlx5: Rate limit page not found error messages
      net/mlx5: Add support for release all pages event

Maxim Mikityanskiy (3):
      net/mlx5e: Fetch WQE: reuse code and enforce typing
      net/mlx5e: Rename ICOSQ WQE info struct and field
      net/mlx5e: Unify reserving space for WQEs

Parav Pandit (1):
      net/mlx5e: Use helper API to get devlink port index for all port flavours

Paul Blakey (1):
      net/mlx5: CT: Remove unused variables

Raed Salem (1):
      net/mlx5: IPsec, Fix coverity issue

Roi Dayan (1):
      net/mlx5e: CT: Avoid false warning about rule may be used uninitialized

Tariq Toukan (4):
      net/mlx5: Remove unused field in EQ
      net/mlx5e: Use proper name field for the UMR key
      net/mlx5e: TX, Generalise code and usage of error CQE dump
      net/mlx5e: XDP, Print the offending TX descriptor on error completion

Zheng Bin (1):
      net/mlx5e: Remove unneeded semicolon

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  | 84 ++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   | 55 ++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   | 30 --------
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |  8 +++
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 31 ++++----
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 12 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 12 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 38 +++-------
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    | 37 +++-------
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |  4 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.c   |  4 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h  | 11 +--
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h   |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  3 +
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    | 71 +++++++++++++-----
 18 files changed, 235 insertions(+), 180 deletions(-)
