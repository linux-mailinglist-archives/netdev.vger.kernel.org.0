Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316CD1B9590
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 05:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgD0Dna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 23:43:30 -0400
Received: from inva021.nxp.com ([92.121.34.21]:33430 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbgD0Dna (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 23:43:30 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C9C58200F2D;
        Mon, 27 Apr 2020 05:43:28 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 75CE720067B;
        Mon, 27 Apr 2020 05:43:26 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id DE5C7402DA;
        Mon, 27 Apr 2020 11:43:20 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Li Yang <leoyang.li@nxp.com>
Subject: [PATCH] ptp_qoriq: output PPS signal on FIPER2 in default
Date:   Mon, 27 Apr 2020 11:39:03 +0800
Message-Id: <20200427033903.9724-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Output PPS signal on FIPER2 (Fixed Period Interval Pulse) in default
which is more desired by user.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 include/linux/fsl/ptp_qoriq.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fsl/ptp_qoriq.h b/include/linux/fsl/ptp_qoriq.h
index 7588456..884b8f8 100644
--- a/include/linux/fsl/ptp_qoriq.h
+++ b/include/linux/fsl/ptp_qoriq.h
@@ -135,7 +135,7 @@ struct ptp_qoriq_registers {
 #define DEFAULT_CKSEL		1
 #define DEFAULT_TMR_PRSC	2
 #define DEFAULT_FIPER1_PERIOD	1000000000
-#define DEFAULT_FIPER2_PERIOD	100000
+#define DEFAULT_FIPER2_PERIOD	1000000000
 
 struct ptp_qoriq {
 	void __iomem *base;
-- 
2.7.4

