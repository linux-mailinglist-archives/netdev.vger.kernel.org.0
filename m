Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302E133D0C2
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 10:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbhCPJ1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 05:27:52 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16338 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233155AbhCPJ1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 05:27:34 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G9QRwe020155;
        Tue, 16 Mar 2021 02:27:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=KvfXCDX7XiyIyyAZXt1r3F7riXVwVyiaOzjegUt6zt8=;
 b=NkrWShuGAwW9JKY99jvdR2Vxk/eNSSVJ7FSdB3873VQgHBADIHm5uN/GKqVmMvNl916X
 B+6egDYmZPKv5g57mg6F21+YDe6X56pO+WRVrAUyN+4vomoEnfYdb6rmiyF6QAWAJVHT
 nYDgiJnSgghMdnM9c6bv7m8x6PnbhBNyNZoJETh+PmJl11s6iUpxqEvUv3lmGbfy4b+q
 XePZp7Gpl9B5Va2e3Uu3ThMbT8M3cgR2bhSziw8as/D3sHqAWk+yvJnbZUDNQcitgurA
 3zSIyObFiUoCy0Kcu/1a89Hw27vBVK7rwhFokPOvgU7xeBRJZYUJCJMiAZUsh4fkddNN vQ== 
Received: from dc6wp-exch01.marvell.com ([4.21.29.232])
        by mx0a-0016f401.pphosted.com with ESMTP id 378umtfrbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 02:27:33 -0700
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 16 Mar 2021 05:27:31 -0400
Received: from maili.marvell.com (10.76.176.51) by DC6WP-EXCH01.marvell.com
 (10.76.176.21) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Mar 2021 05:27:31 -0400
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id 68AEC3F703F;
        Tue, 16 Mar 2021 02:27:28 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH 4/9] octeontx2-af: Remove TOS field from MKEX TX
Date:   Tue, 16 Mar 2021 14:57:08 +0530
Message-ID: <1615886833-71688-5-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1615886833-71688-1-git-send-email-hkelam@marvell.com>
References: <1615886833-71688-1-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_03:2021-03-15,2021-03-16 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

TOS overlaps with DMAC field in mcam search key and hence installing
rules for TX side are failing. Hence remove TOS field from TX profile.

Fixes: 42006910("octeontx2-af: cleanup KPU config data")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index b192692..5c372d2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -13499,8 +13499,6 @@ static struct npc_mcam_kex npc_mkex_default = {
 			[NPC_LT_LC_IP] = {
 				/* SIP+DIP: 8 bytes, KW2[63:0] */
 				KEX_LD_CFG(0x07, 0xc, 0x1, 0x0, 0x10),
-				/* TOS: 1 byte, KW1[63:56] */
-				KEX_LD_CFG(0x0, 0x1, 0x1, 0x0, 0xf),
 			},
 			/* Layer C: IPv6 */
 			[NPC_LT_LC_IP6] = {
-- 
2.7.4

