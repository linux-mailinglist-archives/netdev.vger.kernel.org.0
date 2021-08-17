Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3963EE5CB
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 06:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237897AbhHQEqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 00:46:06 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27136 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237376AbhHQEpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 00:45:53 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17H2lc5r006745;
        Mon, 16 Aug 2021 21:45:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=h9BHfU7xF1A0NvmrSjVguWiVKjxApuQnXVlPI44VG+o=;
 b=cf32KsXEs8YY4HfpCp4QLBWH4KtvuaZRiy6+EcDoIPcH/ZkJZ0RRfPVTLTW3u8tm3pFK
 LJdeWSAlm4ZD7vQHXWaKOuUeF+5eLVPcA41dj5BLVEHD6iUt/GNvTC1FbaAdkWx65Ktz
 Qb3D5856NyRsfEHJceb+k4cDjr5ZNldhqhDCAuH2TgRdAhvWVdGDk3fhctFaTkTRnQ8a
 ppund23EW9Mm+uODHyBwM7NNosgLRgcCgzPvS8EYr/P6k2Rgd3ZpDoUy8R6fvcArL+nG
 GlPH9ItzIi0bjb93ith8kC0dmVXcFUcwx01Mqb2fQanOqzuianCN94BTDDLrhXw07Rfa Tw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ag4n0ra56-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 21:45:20 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 21:45:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 21:45:12 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 7CA113F70AB;
        Mon, 16 Aug 2021 21:45:08 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 04/11] octeontx2-pf: Enable NETIF_F_RXALL support for VF driver
Date:   Tue, 17 Aug 2021 10:14:46 +0530
Message-ID: <1629175493-4895-5-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
References: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: hSPqKQeY19xGV3Fdjq25V7WdiYdWcsqd
X-Proofpoint-ORIG-GUID: hSPqKQeY19xGV3Fdjq25V7WdiYdWcsqd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Enabled NETIF_F_RXALL support for VF driver.
Also removed MTU range comments which are no longer valid.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 5 ++---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 3 ++-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 22b7af0..e0968ca 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2569,8 +2569,6 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			       NETIF_F_GSO_UDP_L4);
 	netdev->features |= netdev->hw_features;
 
-	netdev->hw_features |= NETIF_F_LOOPBACK | NETIF_F_RXALL;
-
 	err = otx2_mcam_flow_init(pf);
 	if (err)
 		goto err_ptp_destroy;
@@ -2594,12 +2592,13 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (pf->flags & OTX2_FLAG_TC_FLOWER_SUPPORT)
 		netdev->hw_features |= NETIF_F_HW_TC;
 
+	netdev->hw_features |= NETIF_F_LOOPBACK | NETIF_F_RXALL;
+
 	netdev->gso_max_segs = OTX2_MAX_GSO_SEGS;
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
 
 	netdev->netdev_ops = &otx2_netdev_ops;
 
-	/* MTU range: 64 - 9190 */
 	netdev->min_mtu = OTX2_MIN_MTU;
 	netdev->max_mtu = otx2_get_max_mtu(pf);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index a8bee5a..722c601 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -627,12 +627,13 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 				NETIF_F_HW_VLAN_STAG_TX;
 	netdev->features |= netdev->hw_features;
 
+	netdev->hw_features |= NETIF_F_RXALL;
+
 	netdev->gso_max_segs = OTX2_MAX_GSO_SEGS;
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
 
 	netdev->netdev_ops = &otx2vf_netdev_ops;
 
-	/* MTU range: 68 - 9190 */
 	netdev->min_mtu = OTX2_MIN_MTU;
 	netdev->max_mtu = otx2_get_max_mtu(vf);
 
-- 
2.7.4

