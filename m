Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA07B26F9B5
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 11:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgIRJ4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 05:56:19 -0400
Received: from inva021.nxp.com ([92.121.34.21]:42002 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbgIRJ4R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 05:56:17 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 38EBA20179A;
        Fri, 18 Sep 2020 11:56:16 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 29208200073;
        Fri, 18 Sep 2020 11:56:13 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id EE157402AE;
        Fri, 18 Sep 2020 11:56:08 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [v2, 1/2] dt-binding: ptp_qoriq: support fsl,tmr-fiper3 property
Date:   Fri, 18 Sep 2020 17:48:00 +0800
Message-Id: <20200918094801.37514-2-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200918094801.37514-1-yangbo.lu@nxp.com>
References: <20200918094801.37514-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add fsl,tmr-fiper3 property definition which is supported only
on DPAA2 and ENETC network controller hardware.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- None.
---
 Documentation/devicetree/bindings/ptp/ptp-qoriq.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/ptp/ptp-qoriq.txt b/Documentation/devicetree/bindings/ptp/ptp-qoriq.txt
index d48f9eb..743eda7 100644
--- a/Documentation/devicetree/bindings/ptp/ptp-qoriq.txt
+++ b/Documentation/devicetree/bindings/ptp/ptp-qoriq.txt
@@ -18,6 +18,8 @@ Clock Properties:
   - fsl,tmr-add      Frequency compensation value.
   - fsl,tmr-fiper1   Fixed interval period pulse generator.
   - fsl,tmr-fiper2   Fixed interval period pulse generator.
+  - fsl,tmr-fiper3   Fixed interval period pulse generator.
+                     Supported only on DPAA2 and ENETC hardware.
   - fsl,max-adj      Maximum frequency adjustment in parts per billion.
   - fsl,extts-fifo   The presence of this property indicates hardware
 		     support for the external trigger stamp FIFO.
-- 
2.7.4

