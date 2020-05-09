Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952A51CBE26
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 08:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728937AbgEIGrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 02:47:43 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54606 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725940AbgEIGrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 02:47:43 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0496lgtW029194;
        Fri, 8 May 2020 23:47:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=qU3g098MnYcEEmAh7VK4Q6+uZprmKzAzkPY8f+Oolx4=;
 b=Tbs6nk8T4fO3sfKL4UKpRQZxYWmoP+6IBEWiOyqFwD+khWr+FTjlb3y7u2YpmgvP9NT8
 bxQoRa1LRjez0Pp2VTvxBVCH1sYFSRjU0Olelb++OvHQzfktNRAN85JkwGnWGgX1tz2R
 3AGugsoNrSgZSRVFGoUaj0m8cKsjhbpjrnUhWmhdnF7tEgvrtAj/GUgsu3HtJGwSO4yY
 6je05NzJIfu3PvjIQKZxAk1fA7G931iYTdrfR3VwC6HkHHiqShXocMGgOfShFx2XmIRl
 jjvT90yH8ptjig4Xoc/moEPrbXPxrEgZYVbgrb6/YcNWk+jlQ+nFtsXGpZTG6ESQId/x lA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 30vtdkp390-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 23:47:42 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 8 May
 2020 23:47:40 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 8 May
 2020 23:47:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 May 2020 23:47:39 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 519FD3F7040;
        Fri,  8 May 2020 23:47:31 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 2/7] net: atlantic: minor MACSec code cleanup
Date:   Sat, 9 May 2020 09:46:55 +0300
Message-ID: <20200509064700.202-3-irusskikh@marvell.com>
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

This patch fixes a couple of minor merge issues found in macsec_api.c
after corresponding patch series has been applied.

These are not real bugs, so pushing to net-next.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
index fbe9d88b13c7..36c7cf05630a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
+++ b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
@@ -846,8 +846,7 @@ static int get_ingress_sakey_record(struct aq_hw_s *hw,
 	rec->key[7] = packed_record[14];
 	rec->key[7] |= packed_record[15] << 16;
 
-	rec->key_len = (rec->key_len & 0xFFFFFFFC) |
-		       (packed_record[16] & 0x3);
+	rec->key_len = packed_record[16] & 0x3;
 
 	return 0;
 }
@@ -1158,6 +1157,7 @@ static int set_egress_ctlf_record(struct aq_hw_s *hw,
 
 	packed_record[0] = rec->sa_da[0] & 0xFFFF;
 	packed_record[1] = (rec->sa_da[0] >> 16) & 0xFFFF;
+
 	packed_record[2] = rec->sa_da[1] & 0xFFFF;
 
 	packed_record[3] = rec->eth_type & 0xFFFF;
@@ -1552,7 +1552,7 @@ static int set_egress_sc_record(struct aq_hw_s *hw,
 
 	packed_record[5] |= (rec->sak_len & 0x3) << 4;
 
-	packed_record[7] |= (rec->valid & 0x1) << 15;
+	packed_record[7] = (rec->valid & 0x1) << 15;
 
 	return set_raw_egress_record(hw, packed_record, 8, 2,
 				     ROWOFFSET_EGRESSSCRECORD + table_index);
-- 
2.20.1

