Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737F920ED8E
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 07:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgF3F3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 01:29:35 -0400
Received: from mail-am6eur05on2051.outbound.protection.outlook.com ([40.107.22.51]:33760
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726015AbgF3F3e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 01:29:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KTLinKdEiGgkVsS63GLcVh2hqT8xOz2QMq+Kn2wezbI9PWD/qQCIO4u8Uj7mCFYXW3S6MG77HzU29LomW+ho5AI9dX0UJzdT2/2wl08e583UGckunb3NxYWnKoyI9cXCmm8QcrlXtBzt+mtKrC95imW2ajn5LlNGYYTHGaogK+phOuAIm1jpvPxiJ1XHmVr/dnxU6q5DdFwdTEBEjaJrwjW9IlVxlyCgbLRo8FWLBpEyQMZyDdD3Dt+vwJ/2IBbO/p7wNzSo76TIbUQ2AkDl37Yf+9SR3dZ0luZ1ngxK+yl39mvaLfWHplHUlnmPfns61egWCkHPIR7XaEn1CmXz9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkfAXKN5JjPK4sTiq5IDzvAHHP9ZVZCtEmUH6llBs1k=;
 b=Ot/8htQsByg+QK1KGvZG6EY+HqLvLwV2npWDBYV2Oh/HyjdsEm+uvu3jutgGh53XWpldeaztzaAweOwDYnIl0OysT0gF8eV0SRNvqs6ltfs/2b6aA+dw8vgN151+xr45GQeNw5ipiHL/6qloiFqZCTL9W5faE3C3wamZ6HQsQnBR2/MzWpemOHWD1imN83LXpjROwsAMbIPy9bazcuUKLCaXwJZ3gVTfSmgPntLhMJ6dAy0R7E8pNncAs9M1hTALpoQl5xLwrgnFvaqMPSS89tByr6HkWinJYSuGGAApu1EWJGvD2wUmGeVnc5BJJ8+IcUR7P/ipVOZMInY0V9ZN6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkfAXKN5JjPK4sTiq5IDzvAHHP9ZVZCtEmUH6llBs1k=;
 b=kb9ksdiF0P+hQi10w2/g8EyAzk5ctOuRPVkrotzuOJNzuc1uiMPMZvESIevcllzeJgfryvltP3ZaBv35LeBZ6T+kmd+O1HVl3cXvf7Qw3px5ICrupEVH2ANi73yVySS3Lzw8bqt3hqU9ibs5jUQQWaeYqPRMJ/XCofUDnUfyJ3I=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4786.eurprd05.prod.outlook.com (2603:10a6:208:b3::15)
 by AM0PR05MB5713.eurprd05.prod.outlook.com (2603:10a6:208:116::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Tue, 30 Jun
 2020 05:29:30 +0000
Received: from AM0PR05MB4786.eurprd05.prod.outlook.com
 ([fe80::e00a:324b:e95c:750f]) by AM0PR05MB4786.eurprd05.prod.outlook.com
 ([fe80::e00a:324b:e95c:750f%7]) with mapi id 15.20.3131.026; Tue, 30 Jun 2020
 05:29:30 +0000
Date:   Tue, 30 Jun 2020 08:29:25 +0300
From:   Eli Cohen <eli@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH] vhost: Fix documentation
Message-ID: <20200630052925.GA157062@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: AM4PR0501CA0064.eurprd05.prod.outlook.com
 (2603:10a6:200:68::32) To AM0PR05MB4786.eurprd05.prod.outlook.com
 (2603:10a6:208:b3::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mtl-vdi-166.wap.labs.mlnx (94.188.199.18) by AM4PR0501CA0064.eurprd05.prod.outlook.com (2603:10a6:200:68::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Tue, 30 Jun 2020 05:29:29 +0000
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b458bb68-9c7b-417a-74ab-08d81cb69039
X-MS-TrafficTypeDiagnostic: AM0PR05MB5713:
X-Microsoft-Antispam-PRVS: <AM0PR05MB5713FEF47932E4389FA89C0AC56F0@AM0PR05MB5713.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F0Uymda0rvnlbBNeqceFBTIpwW/M6GFsz6a+sV+ELrNecxAuBav69s+/47xhrlTerDuv/H5ClMigLW/T2DMPV5EbJhZHhJ33R44zGDAN04vzOJgUWBW9QQl7XlUfw++/dGzbY5MZJ2uF6tm5XWCqkGIoGZWNs4gwvYrrNYrlN/htPnd6Rl0z1+hECBHBGWhAAl2IiRCHvLatnsPWokRq9xqy9zUXhGntL2dxucLgJu++AyEAZYGcfQT1YdZrwtrII1NuOIz1Hb5v5Qo65ly/h2jiEOCTmlupfv2W8Ppzq/iWWZdYqe/3RcuYJK+Mj9lKUdd9KDTG1N9N3SV9POxAsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4786.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(26005)(9686003)(16526019)(86362001)(316002)(83380400001)(110136005)(478600001)(8936002)(7696005)(52116002)(33656002)(8676002)(55016002)(1076003)(66946007)(66556008)(66476007)(956004)(5660300002)(6666004)(6506007)(186003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /bi+24F3yaGO2BD50flDcRA2QbWpYW6/CDt0Jz2HgOSwa/KttgmaTKoV18umhsEFc6QHJ1AEvL0u8/vM423cp8BozPPoJ8DjxPwOQ040f+fbB2Ec7DplcVY0H/VjGTIuP8xvljFNuHNg8rb7x8vAbAg1cSSsFMqVLF/HrROhWyt9EBeSFPMPmcm0njGDqxkm3KPaT4aCDihj24wh72pYyK18UBlU/VStLLyFOrcwGTk7uWTeepquOttGaJLCMpaERZMifApOFEkF1aNJoQlX8g65mXK0uZSbYpS84XelhzkZoHDBSvPhBayyapY4n24ObS9txeEvcoRRfRaB9Gx3jQYAFXgBp8Hi3T3WPEKQmIpx1fP9KjR4/DizWQeeDUizZ1bItQSO6tw84gU1oo/U5t3BpiDasGEqMXTwbAWDdigdMQCsbL2aPDeV+0IMdGi+K6Y1fscIMm3FoAJL5WRMHXUKpZyJKb17EfAxVgm1OBc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b458bb68-9c7b-417a-74ab-08d81cb69039
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4786.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 05:29:30.3754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ITwxnQcs0xorv5LsBZVHa3QnFCNTfu9NsBA2eBTDByupteTo037IYeAsu3xp6M7opH6ph23OdWbpXkvj2Huh7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5713
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix documentation to match actual function prototypes

"end" used instead of "last". Fix that.

Signed-off-by: Eli Cohen <eli@mellanox.com>
---
 drivers/vhost/iotlb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
index 1f0ca6e44410..0d4213a54a88 100644
--- a/drivers/vhost/iotlb.c
+++ b/drivers/vhost/iotlb.c
@@ -149,7 +149,7 @@ EXPORT_SYMBOL_GPL(vhost_iotlb_free);
  * vhost_iotlb_itree_first - return the first overlapped range
  * @iotlb: the IOTLB
  * @start: start of IOVA range
- * @end: end of IOVA range
+ * @last: last byte in IOVA range
  */
 struct vhost_iotlb_map *
 vhost_iotlb_itree_first(struct vhost_iotlb *iotlb, u64 start, u64 last)
@@ -162,7 +162,7 @@ EXPORT_SYMBOL_GPL(vhost_iotlb_itree_first);
  * vhost_iotlb_itree_first - return the next overlapped range
  * @iotlb: the IOTLB
  * @start: start of IOVA range
- * @end: end of IOVA range
+ * @last: last byte IOVA range
  */
 struct vhost_iotlb_map *
 vhost_iotlb_itree_next(struct vhost_iotlb_map *map, u64 start, u64 last)
-- 
2.26.0

