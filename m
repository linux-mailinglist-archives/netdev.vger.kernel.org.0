Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5C2CE810
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 17:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfJGPnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 11:43:20 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:4546 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727745AbfJGPnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 11:43:20 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x97FQnAJ023875;
        Mon, 7 Oct 2019 17:43:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=STMicroelectronics;
 bh=UTHD69iAxHI4Q+BO79OUIRdFG9H6XecRAFidEkGXZRg=;
 b=RPW4WwWq7gR3ZFkXAf216UPqDWG1PZ/yCNDOvW0Y6K1dEnNlz42dbw6HpT+pW8Mwc08d
 5wVr+5IzVa9MN5vW1khBKZd+Li/pO0eyGnhnF2T1L+8O9i4YamU+sNxPlvLlsU2bd+CJ
 z7DOXCp3KRUiys0CJKb//CS9VEohKQhouvT/ZTyIQIVWkAY63zsbDwIFzKMzZWLvMSav
 NenOhoS1LLhVT/OslXvPRc+eY/TKtqga5jO7CJHuTWG1Q/nPbiaYbvauPBiiq+mZvngu
 LmWdegyys2KP6eX6GXJrY8xQxEKH1TV9dJwqmYfJFdcZaBn9568B9p85lsb4PgSVgMlV bw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2vegaguhpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Oct 2019 17:43:17 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 4156C10002A;
        Mon,  7 Oct 2019 17:43:17 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag5node3.st.com [10.75.127.15])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 3A9832B1E43;
        Mon,  7 Oct 2019 17:43:17 +0200 (CEST)
Received: from localhost (10.75.127.47) by SFHDAG5NODE3.st.com (10.75.127.15)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Oct 2019 17:43:16
 +0200
From:   Antonio Borneo <antonio.borneo@st.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>
CC:     Antonio Borneo <antonio.borneo@st.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ptp: fix typo of "mechanism" in Kconfig help text
Date:   Mon, 7 Oct 2019 17:43:02 +0200
Message-ID: <20191007154306.95827-1-antonio.borneo@st.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.75.127.47]
X-ClientProxiedBy: SFHDAG1NODE3.st.com (10.75.127.3) To SFHDAG5NODE3.st.com
 (10.75.127.15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-07_03:2019-10-07,2019-10-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix typo s/mechansim/mechanism/

Signed-off-by: Antonio Borneo <antonio.borneo@st.com>
---
 drivers/ptp/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 960961fb0d7c..0517272a268e 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -97,8 +97,8 @@ config PTP_1588_CLOCK_PCH
 	help
 	  This driver adds support for using the PCH EG20T as a PTP
 	  clock. The hardware supports time stamping of PTP packets
-	  when using the end-to-end delay (E2E) mechansim. The peer
-	  delay mechansim (P2P) is not supported.
+	  when using the end-to-end delay (E2E) mechanism. The peer
+	  delay mechanism (P2P) is not supported.
 
 	  This clock is only useful if your PTP programs are getting
 	  hardware time stamps on the PTP Ethernet packets using the
-- 
2.23.0

