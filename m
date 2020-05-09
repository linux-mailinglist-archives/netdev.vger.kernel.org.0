Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739F41CBE25
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 08:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbgEIGre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 02:47:34 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47124 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725940AbgEIGre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 02:47:34 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0496jZUD032341;
        Fri, 8 May 2020 23:47:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Bm2wma5lMqC9SPzzJroHzmwS6NWzjnMBO/BlJStmOfg=;
 b=lSr7XCNaJ3qYwt7ccWtTGa89sJLLBUSg8H8X95L+rRFeDEGHqbPYHwGIPOmrgywYW9xv
 qUHyZOI22JmxXFqB5SxWbsBZl01t9d0rfepkyEXkV+G9NfyIfUywJcLJ500f3s7AmCRV
 /j/Jw77qQ5S+Mvws7yHewghVVomqQ6ENrblwhN5x6/3sBn/QmyqH9xwCt7ICTXJWuTHB
 63Pz88YZOTkHSgqi7eKh0tcq6ena44GoXQhCVJDYmZAg3qGsKociX7T17taSutuajL+8
 ETSbAJVlM0SNqalIap/6dNRoKjX1wKRH2+zuCH/A9jGCvI0HSSWCG19XtYjSbP4PJh7e +Q== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 30wjj7gvb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 23:47:31 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 8 May
 2020 23:47:29 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 May 2020 23:47:29 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id F1C623F703F;
        Fri,  8 May 2020 23:47:19 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 1/7] net: atlantic: use __packed instead of the full expansion.
Date:   Sat, 9 May 2020 09:46:54 +0300
Message-ID: <20200509064700.202-2-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200509064700.202-1-irusskikh@marvell.com>
References: <20200509064700.202-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_02:2020-05-08,2020-05-09 signatures=0
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

