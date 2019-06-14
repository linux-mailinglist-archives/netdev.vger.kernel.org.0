Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37B2A45A95
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 12:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfFNKjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 06:39:20 -0400
Received: from inva020.nxp.com ([92.121.34.13]:55840 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727387AbfFNKjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 06:39:19 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 24EC01A0631;
        Fri, 14 Jun 2019 12:39:18 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 999711A062F;
        Fri, 14 Jun 2019 12:39:13 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 81D1E4031C;
        Fri, 14 Jun 2019 18:39:07 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>
Subject: [v2, 6/6] MAINTAINERS: maintain DPAA2 PTP driver in QorIQ PTP entry
Date:   Fri, 14 Jun 2019 18:40:55 +0800
Message-Id: <20190614104055.43998-7-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190614104055.43998-1-yangbo.lu@nxp.com>
References: <20190614104055.43998-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maintain DPAA2 PTP driver in QorIQ PTP entry.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- None.
---
 MAINTAINERS | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b70d5d5..b1f2207 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4922,13 +4922,6 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/staging/fsl-dpaa2/ethsw
 
-DPAA2 PTP CLOCK DRIVER
-M:	Yangbo Lu <yangbo.lu@nxp.com>
-L:	netdev@vger.kernel.org
-S:	Maintained
-F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp*
-F:	drivers/net/ethernet/freescale/dpaa2/dprtc*
-
 DPT_I2O SCSI RAID DRIVER
 M:	Adaptec OEM Raid Solutions <aacraid@microsemi.com>
 L:	linux-scsi@vger.kernel.org
@@ -6371,6 +6364,8 @@ FREESCALE QORIQ PTP CLOCK DRIVER
 M:	Yangbo Lu <yangbo.lu@nxp.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp*
+F:	drivers/net/ethernet/freescale/dpaa2/dprtc*
 F:	drivers/net/ethernet/freescale/enetc/enetc_ptp.c
 F:	drivers/ptp/ptp_qoriq.c
 F:	drivers/ptp/ptp_qoriq_debugfs.c
-- 
2.7.4

