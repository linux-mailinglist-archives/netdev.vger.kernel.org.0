Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BBF233D0B
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 03:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731155AbgGaB6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 21:58:20 -0400
Received: from mail-am6eur05on2083.outbound.protection.outlook.com ([40.107.22.83]:58208
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730904AbgGaB6T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 21:58:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOYWgdugtEZnQ8OE3769XYsnKsYYiIsXB1QFKmEDywBPAk+XzjGPrUGzw9SXRxTKYDZ020KkFLt3BHOQYVQ3qVjwXemQHiY9Y4phRbZ5mHRtvaNGw/iyiJf28cwu5RMPxUJePne04vgLXC6S4JP5LJpPTIiB82/1kzUnMc/VukbjdobtZR1Q8MoHlZb4GDJXssVrAik1XcODlm2MK4793LnnoTSAKh82m48mZaW1bnOnurQpvCGDN+++QH13ZDYDxq2FjvEOzTVXFPf9Zfxb6j4o4vTy27V7F1rV0ol/Luh+2Fk5aVSBm7fQ4R00fVIaqOrKUOsyo1OJFrrUOLyOPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kw8Cjcf7+68vRP+6EhyqhB08qLEWpXUaIOMaGy2TgOo=;
 b=Lmp0prkWEk9qkaXtlBDfBssDhEJOIMyJZsM0fo2NBd39PmtWpHgaZCFhtftR1pTQMZUpZ6GuTRAJ6Fg1AWir89HORlUX/BRwaCsmowmM8ZZz9dBxd9My9JqHcaIP/20iRTm362F9uptGNFo4rH8ykcwi8aDSlQl3TxxtzHAddWmOsKGJqGjC19yoNAP7R74b9DfejtwuWmpJ+fHqXd4Hb7Yo8RAeGE5+ewmQs4U7IVs1SN0fkSTafDdaQqfY3uPM+JlJwcOJCkV+VBaPyscSAqwGcJTvNj4XnfAItMVKNXgGk8VpbnvHIMRpP9W0AtubbRAHENNndB4QYOQnmOoRHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kw8Cjcf7+68vRP+6EhyqhB08qLEWpXUaIOMaGy2TgOo=;
 b=QVGl8pLxt+ZE/WHXby1DJNn1dZo2L7SiSvcHzkPlfHWdpb6nuCuwQNFZiY7ynBO/dVvUqJbm/qUcGrA09g8iP3E6i7MWRt/A3gH9zu1LTdLC159MMfaoX22m+lLffp2Sq6HJEdxsJAPhjZFORO3Vdk8iqRN352hDmUc4QsG0jSw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB3997.eurprd05.prod.outlook.com (2603:10a6:803:25::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Fri, 31 Jul
 2020 01:58:14 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Fri, 31 Jul 2020
 01:58:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/4] Mellanox, mlx5 fixes 2020-07-30
Date:   Thu, 30 Jul 2020 18:57:48 -0700
Message-Id: <20200731015752.28665-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0075.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::16) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0075.namprd07.prod.outlook.com (2603:10b6:a03:12b::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Fri, 31 Jul 2020 01:58:12 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2525e32a-1720-4abd-8660-08d834f52f63
X-MS-TrafficTypeDiagnostic: VI1PR0502MB3997:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB3997AC112A07F5706A857AC8BE4E0@VI1PR0502MB3997.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ShGjg6RI/TEqn+b0StGKgVcyLq6eACPwaNbwLMZMotCBCte8mfJrgqUjifD2pNyt+DhUI3WwiV7/d91ynJG10K3jSVkligYHl35bzXgZV6NqF5P5er58E2SpDKbeHbWeJaoaF4PsPut8MmT/w4/gVBMOyUnE3v8d2EulEdWyI8edh8lwR65hH8/LJAqiSmiyEBCOCjt+zP2qSdYp0ffUpgZu9hdh9xFaPi9egSxJDKF4+WRjiYN+e87sZp64KBvynP06jBI9bNd+6fjRc4R2yCP78nOWwxTLDQgwnq+q4O8s+Dw+zXmcqUROTJi/2vLFaoJWvJCvWwmiVHOm9ZJYVGU9zj5ft0tWDLnevCwXhxQ/iWWIn71CFLzTzDfaR16F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(346002)(366004)(376002)(396003)(4326008)(5660300002)(1076003)(16526019)(6506007)(6666004)(52116002)(186003)(26005)(478600001)(107886003)(6512007)(316002)(54906003)(6916009)(8936002)(36756003)(66946007)(66476007)(66556008)(2906002)(83380400001)(2616005)(956004)(86362001)(6486002)(8676002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XGk47HcVrkGuTjLEL3WweggRUFljdCqdn3X2T3PhU0Z3uNKfvwJr24BHW9qRjvBsGBvnV6f1vghVoZAPVo0S+qpGpWUrbd9oVJM5Od64mwO2hWIEx3FoI+Uc6h25VlTFlJv8qkLhkYZp8kXKwBYcj74eMVpMto4LsmFolsieSfhgJwuIJlpARtumr1oA+mvRTcA7Qi0lU7GdrHLvrWuJpIuuDNtr/ncNC0DoNXQQ2akmloMcRgi4/pyjyPTfkgT9lTmUFJLUvKmZPoG9sgoQ47s7/noSTNazUd3tqCUaueNFz3ccZ8/6LcTBOF4L46SDscG/5UBJHNINrxhNF01fJRfQOIcnPOxDr7twbj/bbyXUbDP29qSKrQkJ+uDicXuEwEZjcSplymAkV0c318Fj3Ko9agkKCphMjHD9SXTXDU6Z7GPTjeZBmPdzWj8vtn7gIo0L+bl3I0vYX75ySpLF5DcmQiUaCH8OmVjlFgSDO72t3Jr0T+GOYaY5tcVX4O8nBut6FiXrBgrgBBZsjedJNq2hnPnvTLgHUtvh3aBqWkSIkhejaOU3j7tlqi4X92AFiXBtHfY2tmw4+xef4sAuBJnD4zTzKM6JacxpTZXBmlLHc7hme6fBm6/NsdbAsLDfeZjyUTUGiwO5EGj6JB5NDg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2525e32a-1720-4abd-8660-08d834f52f63
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 01:58:14.3142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uAbNBPZWfmQm9eI4rjk8qU1O2+csmGm8bzI6UYW9mWrs8c63FLQ8XE7eZ352aQb0Im2oCiD8kx9xzJKZ/QjdjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB3997
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This small patchset introduces some fixes to mlx5 driver.

Please pull and let me know if there is any problem.

For -stable v4.18:
 ('net/mlx5e: fix bpf_prog reference count leaks in mlx5e_alloc_rq')

For -stable v5.7:
 ('net/mlx5e: E-Switch, Add misc bit when misc fields changed for mirroring')

Thanks,
Saeed.

---
The following changes since commit 85496a29224188051b6135eb38da8afd4c584765:

  net: gemini: Fix missing clk_disable_unprepare() in error path of gemini_ethernet_port_probe() (2020-07-30 17:45:13 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2020-07-30

for you to fetch changes up to e692139e6af339a1495ef401b2d95f7f9d1c7a44:

  net/mlx5e: fix bpf_prog reference count leaks in mlx5e_alloc_rq (2020-07-30 18:53:55 -0700)

----------------------------------------------------------------
mlx5-fixes-2020-07-30

----------------------------------------------------------------
Jianbo Liu (3):
      net/mlx5e: CT: Support restore ipv6 tunnel
      net/mlx5e: E-Switch, Add misc bit when misc fields changed for mirroring
      net/mlx5e: E-Switch, Specify flow_source for rule with no in_port

Xin Xiong (1):
      net/mlx5e: fix bpf_prog reference count leaks in mlx5e_alloc_rq

 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    | 30 +++++++++++++++-------
 .../ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c |  2 ++
 .../ethernet/mellanox/mlx5/core/en/tc_tun_gre.c    |  2 ++
 .../ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c  |  2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  4 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  1 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 19 +++++++++-----
 7 files changed, 42 insertions(+), 18 deletions(-)
