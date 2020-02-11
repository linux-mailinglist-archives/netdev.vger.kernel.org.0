Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31A11158946
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 05:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgBKExV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 23:53:21 -0500
Received: from inva020.nxp.com ([92.121.34.13]:51948 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727121AbgBKExV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 23:53:21 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E608E1C2FBB;
        Tue, 11 Feb 2020 05:53:19 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id CDB9A1BDDB3;
        Tue, 11 Feb 2020 05:53:17 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id C28E0402E0;
        Tue, 11 Feb 2020 12:53:14 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH] ptp_qoriq: add initialization message
Date:   Tue, 11 Feb 2020 12:50:53 +0800
Message-Id: <20200211045053.8088-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is necessary to print the initialization result.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/ptp/ptp_qoriq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index b27c46e..66e7d57 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -541,6 +541,8 @@ int ptp_qoriq_init(struct ptp_qoriq *ptp_qoriq, void __iomem *base,
 
 	ptp_qoriq->phc_index = ptp_clock_index(ptp_qoriq->clock);
 	ptp_qoriq_create_debugfs(ptp_qoriq);
+
+	pr_info("new PTP clock ptp%d\n", ptp_qoriq->phc_index);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ptp_qoriq_init);
-- 
2.7.4

