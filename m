Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C99931D533
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 07:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbhBQGCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 01:02:10 -0500
Received: from pbmsgap01.intersil.com ([192.157.179.201]:32790 "EHLO
        pbmsgap01.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhBQGCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 01:02:07 -0500
X-Greylist: delayed 1123 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Feb 2021 01:02:06 EST
Received: from pps.filterd (pbmsgap01.intersil.com [127.0.0.1])
        by pbmsgap01.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 11H5gMDl009524;
        Wed, 17 Feb 2021 00:42:40 -0500
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap01.intersil.com with ESMTP id 36pb661ge0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 00:42:40 -0500
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Wed, 17 Feb 2021 00:42:39 -0500
Received: from localhost (132.158.202.108) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 17 Feb 2021 00:42:38 -0500
From:   <vincent.cheng.xh@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH v3 net-next 7/7] ptp: ptp_clockmatrix: clean-up - parenthesis around a == b are unnecessary
Date:   Wed, 17 Feb 2021 00:42:18 -0500
Message-ID: <1613540538-23792-8-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1613540538-23792-1-git-send-email-vincent.cheng.xh@renesas.com>
References: <1613540538-23792-1-git-send-email-vincent.cheng.xh@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-17_02:2021-02-16,2021-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170042
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

Code clean-up.

Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index dc42c36..75463c2 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -444,7 +444,7 @@ static int _sync_pll_output(struct idtcm *idtcm,
 	u16 sync_ctrl1;
 	u8 temp;
 
-	if ((qn == 0) && (qn_plus_1 == 0))
+	if (qn == 0 && qn_plus_1 == 0)
 		return 0;
 
 	switch (pll) {
@@ -509,7 +509,7 @@ static int _sync_pll_output(struct idtcm *idtcm,
 		return err;
 
 	/* PLL5 can have OUT8 as second additional output. */
-	if ((pll == 5) && (qn_plus_1 != 0)) {
+	if (pll == 5 && qn_plus_1 != 0) {
 		err = idtcm_read(idtcm, 0, HW_Q8_CTRL_SPARE,
 				 &temp, sizeof(temp));
 		if (err)
@@ -531,7 +531,7 @@ static int _sync_pll_output(struct idtcm *idtcm,
 	}
 
 	/* PLL6 can have OUT11 as second additional output. */
-	if ((pll == 6) && (qn_plus_1 != 0)) {
+	if (pll == 6 && qn_plus_1 != 0) {
 		err = idtcm_read(idtcm, 0, HW_Q11_CTRL_SPARE,
 				 &temp, sizeof(temp));
 		if (err)
@@ -654,7 +654,7 @@ static int idtcm_sync_pps_output(struct idtcm_channel *channel)
 			}
 		}
 
-		if ((qn != 0) || (qn_plus_1 != 0))
+		if (qn != 0 || qn_plus_1 != 0)
 			err = _sync_pll_output(idtcm, pll, sync_src, qn,
 					       qn_plus_1);
 
@@ -1263,13 +1263,11 @@ static int idtcm_load_firmware(struct idtcm *idtcm,
 			err = 0;
 
 			/* Top (status registers) and bottom are read-only */
-			if ((regaddr < GPIO_USER_CONTROL)
-			    || (regaddr >= SCRATCH))
+			if (regaddr < GPIO_USER_CONTROL || regaddr >= SCRATCH)
 				continue;
 
 			/* Page size 128, last 4 bytes of page skipped */
-			if (((loaddr > 0x7b) && (loaddr <= 0x7f))
-			     || loaddr > 0xfb)
+			if ((loaddr > 0x7b && loaddr <= 0x7f) || loaddr > 0xfb)
 				continue;
 
 			err = idtcm_write(idtcm, regaddr, 0, &val, sizeof(val));
@@ -1688,7 +1686,7 @@ static int _enable_pll_tod_sync(struct idtcm *idtcm,
 	u16 dpll;
 	u16 out0 = 0, out1 = 0;
 
-	if ((qn == 0) && (qn_plus_1 == 0))
+	if (qn == 0 && qn_plus_1 == 0)
 		return 0;
 
 	switch (pll) {
@@ -1883,7 +1881,7 @@ static int idtcm_enable_tod_sync(struct idtcm_channel *channel)
 			}
 		}
 
-		if ((qn != 0) || (qn_plus_1 != 0))
+		if (qn != 0 || qn_plus_1 != 0)
 			err = _enable_pll_tod_sync(idtcm, pll, sync_src, qn,
 					       qn_plus_1);
 		if (err)
-- 
2.7.4

