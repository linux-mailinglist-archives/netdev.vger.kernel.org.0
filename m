Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9578C3AD89
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 05:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387584AbfFJDTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 23:19:36 -0400
Received: from inva020.nxp.com ([92.121.34.13]:43312 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387400AbfFJDTf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Jun 2019 23:19:35 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8AA981A073B;
        Mon, 10 Jun 2019 05:19:33 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6BC9E1A072D;
        Mon, 10 Jun 2019 05:19:29 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 06B8340310;
        Mon, 10 Jun 2019 11:19:23 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH 3/6] dt-binding: ptp_qoriq: support DPAA2 PTP compatible
Date:   Mon, 10 Jun 2019 11:21:05 +0800
Message-Id: <20190610032108.5791-4-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190610032108.5791-1-yangbo.lu@nxp.com>
References: <20190610032108.5791-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new compatible for DPAA2 PTP.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
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

