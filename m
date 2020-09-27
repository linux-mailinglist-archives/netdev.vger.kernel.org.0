Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EE4279F85
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 10:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730499AbgI0IKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 04:10:30 -0400
Received: from inva021.nxp.com ([92.121.34.21]:51194 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727263AbgI0IK3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 04:10:29 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id EA8EA20147F;
        Sun, 27 Sep 2020 10:10:27 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 29B0B200049;
        Sun, 27 Sep 2020 10:10:24 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 340DE402E6;
        Sun, 27 Sep 2020 10:10:19 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] ptp: add stub function for ptp_get_msgtype()
Date:   Sun, 27 Sep 2020 16:01:50 +0800
Message-Id: <20200927080150.8479-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added the missing stub function for ptp_get_msgtype().

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: 036c508ba95e ("ptp: Add generic ptp message type function")
Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 include/linux/ptp_classify.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index 8437307..c6487b7 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -134,5 +134,13 @@ static inline struct ptp_header *ptp_parse_header(struct sk_buff *skb,
 {
 	return NULL;
 }
+static inline u8 ptp_get_msgtype(const struct ptp_header *hdr,
+				 unsigned int type)
+{
+	/* The return is meaningless. The stub function would not be
+	 * executed since no available header from ptp_parse_header.
+	 */
+	return 0;
+}
 #endif
 #endif /* _PTP_CLASSIFY_H_ */
-- 
2.7.4

