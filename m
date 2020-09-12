Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796A626778A
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 05:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgILDic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 23:38:32 -0400
Received: from inva021.nxp.com ([92.121.34.21]:36302 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgILDiU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 23:38:20 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 50C12200D6C;
        Sat, 12 Sep 2020 05:38:16 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 42851200DA0;
        Sat, 12 Sep 2020 05:38:13 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 9AD36402F2;
        Sat, 12 Sep 2020 05:38:07 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>, devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 1/2] dt-binding: ptp_qoriq: support fsl,tmr-fiper3 property
Date:   Sat, 12 Sep 2020 11:30:05 +0800
Message-Id: <20200912033006.20771-2-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200912033006.20771-1-yangbo.lu@nxp.com>
References: <20200912033006.20771-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add fsl,tmr-fiper3 property definition which is supported only
on DPAA2 and ENETC network controller hardware.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
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

