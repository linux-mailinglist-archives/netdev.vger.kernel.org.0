Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF0116149F
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgBQO1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:27:38 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:41510 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728845AbgBQO1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:27:22 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01HEQxeF041813;
        Mon, 17 Feb 2020 08:26:59 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1581949619;
        bh=d45ru5d3fIe+VZkm3lVD10Gnrxhb5tb33AdK63CL63Y=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=uDgHPfvP/R4R2E79YryAUHEf0ID5wky+B81iDKsc+JjLDA44TofwAf3JlqLvd75m6
         e2BaTFfKsdsSpuKc0yYOU0JEgobsPspkycxImlJi3JOyijDIT81UL2sBgu55oYboAZ
         9ylzoBULVAwaUHkT9pUwKK0a/WYI/QHLzhvezsLs=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01HEQxD3064624;
        Mon, 17 Feb 2020 08:26:59 -0600
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 17
 Feb 2020 08:26:59 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 17 Feb 2020 08:26:59 -0600
Received: from a0230074-OptiPlex-7010.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01HEQoJM033875;
        Mon, 17 Feb 2020 08:26:55 -0600
From:   Faiz Abbas <faiz_abbas@ti.com>
To:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>
CC:     <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <catalin.marinas@arm.com>, <mark.rutland@arm.com>,
        <robh+dt@kernel.org>, <mkl@pengutronix.de>, <wg@grandegger.com>,
        <sriram.dash@samsung.com>, <dmurphy@ti.com>, <faiz_abbas@ti.com>
Subject: [PATCH v2 1/3] dt-bindings: m_can: Add Documentation for transceiver regulator
Date:   Mon, 17 Feb 2020 19:58:34 +0530
Message-ID: <20200217142836.23702-2-faiz_abbas@ti.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200217142836.23702-1-faiz_abbas@ti.com>
References: <20200217142836.23702-1-faiz_abbas@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some CAN transceivers have a standby line that needs to be asserted
before they can be used. Model this GPIO lines as an optional
fixed-regulator node. Document bindings for the same.

Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
---
 Documentation/devicetree/bindings/net/can/m_can.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/m_can.txt b/Documentation/devicetree/bindings/net/can/m_can.txt
index ed614383af9c..f17e2a5207dc 100644
--- a/Documentation/devicetree/bindings/net/can/m_can.txt
+++ b/Documentation/devicetree/bindings/net/can/m_can.txt
@@ -48,6 +48,9 @@ Optional Subnode:
 			  that can be used for CAN/CAN-FD modes. See
 			  Documentation/devicetree/bindings/net/can/can-transceiver.txt
 			  for details.
+
+- xceiver-supply: Regulator that powers the CAN transceiver.
+
 Example:
 SoC dtsi:
 m_can1: can@20e8000 {
-- 
2.19.2

