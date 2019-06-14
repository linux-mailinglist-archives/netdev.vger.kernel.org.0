Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15E0045A8F
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 12:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfFNKjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 06:39:16 -0400
Received: from inva020.nxp.com ([92.121.34.13]:55722 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727251AbfFNKjQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 06:39:16 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 163F21A0631;
        Fri, 14 Jun 2019 12:39:14 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8A8521A061A;
        Fri, 14 Jun 2019 12:39:09 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id C82DE40310;
        Fri, 14 Jun 2019 18:39:03 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>
Subject: [v2, 3/6] dt-binding: ptp_qoriq: support DPAA2 PTP compatible
Date:   Fri, 14 Jun 2019 18:40:52 +0800
Message-Id: <20190614104055.43998-4-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190614104055.43998-1-yangbo.lu@nxp.com>
References: <20190614104055.43998-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new compatible for DPAA2 PTP.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- None.
---
 Documentation/devicetree/bindings/ptp/ptp-qoriq.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/ptp/ptp-qoriq.txt b/Documentation/devicetree/bindings/ptp/ptp-qoriq.txt
index 6ec0534..d48f9eb 100644
--- a/Documentation/devicetree/bindings/ptp/ptp-qoriq.txt
+++ b/Documentation/devicetree/bindings/ptp/ptp-qoriq.txt
@@ -4,7 +4,8 @@ General Properties:
 
   - compatible   Should be "fsl,etsec-ptp" for eTSEC
                  Should be "fsl,fman-ptp-timer" for DPAA FMan
-		 Should be "fsl,enetc-ptp" for ENETC
+                 Should be "fsl,dpaa2-ptp" for DPAA2
+                 Should be "fsl,enetc-ptp" for ENETC
   - reg          Offset and length of the register set for the device
   - interrupts   There should be at least two interrupts. Some devices
                  have as many as four PTP related interrupts.
-- 
2.7.4

