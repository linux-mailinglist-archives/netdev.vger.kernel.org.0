Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFE51C8493
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 10:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgEGIPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 04:15:38 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6312 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725819AbgEGIPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 04:15:33 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0478ExMD011624;
        Thu, 7 May 2020 01:15:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Bm2wma5lMqC9SPzzJroHzmwS6NWzjnMBO/BlJStmOfg=;
 b=v0AbnFdWrPdrOKHfDlnNPaQEO6wYTsPHZLz1t/BhtiMW+dhC8vqtqHERaIX9YnLQrNDx
 bMOqstii2wgzdeNvQNVMwAASuqkGpnmTwWhKi5J491k5zhjk/LwatrYLlFIfVkurieKM
 1D7gU9eT9hBUX7q2H9cHFM8H5lueaQzZKh06CJwrWyy/viKOzoGQpc2IbRxG6ceNBIWs
 wXkzn6dYw3UKBoXuxcOPcG3tnerbTxTw+AsXy9+W+L9ZjJNjq9vxw5WuSP+gm7AlkKLi
 kH3utB8neukphgGK0l3BewRjHiil7rg5lP3B7rzZctzh8/TfFjdN+Ao9/AJGn7aik2XE WA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 30urytwcv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 May 2020 01:15:29 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 May
 2020 01:15:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 7 May 2020 01:15:27 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 7ED753F703F;
        Thu,  7 May 2020 01:15:25 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 1/7] net: atlantic: use __packed instead of the full expansion.
Date:   Thu, 7 May 2020 11:15:04 +0300
Message-ID: <20200507081510.2120-2-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200507081510.2120-1-irusskikh@marvell.com>
References: <20200507081510.2120-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_04:2020-05-05,2020-05-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patches fixes the review comment made by Jakub Kicinski
in the "net: atlantic: A2 support" patch series.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h    | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h
index 2317dd8459d0..b66fa346581c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h
@@ -103,7 +103,7 @@ struct sleep_proxy_s {
 		u32 crc32;
 	} wake_up_pattern[8];
 
-	struct __attribute__ ((__packed__)) {
+	struct __packed {
 		u8 arp_responder:1;
 		u8 echo_responder:1;
 		u8 igmp_client:1;
@@ -119,7 +119,7 @@ struct sleep_proxy_s {
 	u32 ipv4_offload_addr[8];
 	u32 reserved[8];
 
-	struct __attribute__ ((__packed__)) {
+	struct __packed {
 		u8 ns_responder:1;
 		u8 echo_responder:1;
 		u8 mld_client:1;
-- 
2.20.1

