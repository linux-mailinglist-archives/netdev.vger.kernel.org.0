Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3056B1C5623
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 15:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgEENB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 09:01:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55312 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728834AbgEENBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 09:01:55 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045CYtND088265;
        Tue, 5 May 2020 09:01:54 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s510tnhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 09:01:50 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 045D0duU011466;
        Tue, 5 May 2020 13:01:43 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 30s0g5aunx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 13:01:42 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 045D1e2951183786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 May 2020 13:01:40 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A792AE057;
        Tue,  5 May 2020 13:01:40 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5BC3AE059;
        Tue,  5 May 2020 13:01:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 May 2020 13:01:39 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 2/2] net/smc: remove unused inline function smc_curs_read
Date:   Tue,  5 May 2020 15:01:21 +0200
Message-Id: <20200505130121.103272-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505130121.103272-1-kgraul@linux.ibm.com>
References: <20200505130121.103272-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_08:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 clxscore=1015 suspectscore=1 mlxlogscore=588 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit bac6de7b6370 ("net/smc: eliminate cursor read and write calls")
left behind this.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_cdc.h | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
index 9cfabc9af120..2ddcc5fb5ceb 100644
--- a/net/smc/smc_cdc.h
+++ b/net/smc/smc_cdc.h
@@ -97,23 +97,6 @@ static inline void smc_curs_add(int size, union smc_host_cursor *curs,
 	}
 }
 
-/* SMC cursors are 8 bytes long and require atomic reading and writing */
-static inline u64 smc_curs_read(union smc_host_cursor *curs,
-				struct smc_connection *conn)
-{
-#ifndef KERNEL_HAS_ATOMIC64
-	unsigned long flags;
-	u64 ret;
-
-	spin_lock_irqsave(&conn->acurs_lock, flags);
-	ret = curs->acurs;
-	spin_unlock_irqrestore(&conn->acurs_lock, flags);
-	return ret;
-#else
-	return atomic64_read(&curs->acurs);
-#endif
-}
-
 /* Copy cursor src into tgt */
 static inline void smc_curs_copy(union smc_host_cursor *tgt,
 				 union smc_host_cursor *src,
-- 
2.17.1

