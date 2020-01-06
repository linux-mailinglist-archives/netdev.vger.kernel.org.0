Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFE8131163
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 12:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgAFLXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 06:23:07 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43960 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726569AbgAFLXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 06:23:03 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 006BFnCe024813;
        Mon, 6 Jan 2020 03:23:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=GRRKV54DkRowHLNKs2VPf2lkovJivQmbDPzEI8OEklY=;
 b=hX8VEGYCedKvO2Cb4VVe6jverd7ZBO75rIn5IejVRWc0jpq0J7t44R6TrNGPWEZIyyBu
 WoPUM7AnPk+hWsfP3q2lGSCCr5Q410q8kIq7xINNtfG+2L/Hc0bhRCDdebS2lACo1VSC
 QfGUjM64W61HQuRGv3p/3NDMVfkEs72kzdMMovLiXUlh+/WexY3Q8nlP1r0n8qpJwefK
 tK2rnbn3CeNm3/OlOwcrTv/tk1Vgt0YQzitwIeTp5w40GefPEhY3BPovtLwYfVQQZcAf
 hihu7t5rSW3FTkVEeLIgKx/qMNzADrOmw+Q4wdBwfIv8n/XpDNcjfiARLfS2o9sjqIML qw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2xarxv5k2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 06 Jan 2020 03:23:02 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jan
 2020 03:23:01 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jan 2020 03:23:01 -0800
Received: from NN-LT0019.marvell.com (unknown [10.9.16.57])
        by maili.marvell.com (Postfix) with ESMTP id 2EBC03F7045;
        Mon,  6 Jan 2020 03:22:59 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net 3/3] net: atlantic: remove duplicate entries
Date:   Mon, 6 Jan 2020 14:22:30 +0300
Message-ID: <2ed3e0a64e7d0055e95b0baa92f69bd48f7ac085.1578059294.git.irusskikh@marvell.com>
X-Mailer: git-send-email 2.24.1.windows.2
In-Reply-To: <cover.1578059294.git.irusskikh@marvell.com>
References: <cover.1578059294.git.irusskikh@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2020-01-06_04:2020-01-06,2020-01-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function entries were duplicated accidentally, removing the dups.

Fixes: ea4b4d7fc106 ("net: atlantic: loopback tests via private flags")
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 58e891af6e09..ec041f78d063 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -1525,9 +1525,6 @@ const struct aq_hw_ops hw_atl_ops_b0 = {
 	.rx_extract_ts           = hw_atl_b0_rx_extract_ts,
 	.extract_hwts            = hw_atl_b0_extract_hwts,
 	.hw_set_offload          = hw_atl_b0_hw_offload_set,
-	.hw_get_hw_stats         = hw_atl_utils_get_hw_stats,
-	.hw_get_fw_version       = hw_atl_utils_get_fw_version,
-	.hw_set_offload          = hw_atl_b0_hw_offload_set,
 	.hw_set_loopback         = hw_atl_b0_set_loopback,
 	.hw_set_fc               = hw_atl_b0_set_fc,
 };
-- 
2.20.1

