Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFF4144CC5
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 09:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgAVICS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 03:02:18 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:33134 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729085AbgAVICL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 03:02:11 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00M81nxc100955;
        Wed, 22 Jan 2020 02:01:49 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1579680109;
        bh=QEfHc54Sq3cSMEDsHEl0ZkK03ez70ajlWEziFOuth0s=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=EfO9tSj7GDP5hTZLOndOZttkXugBuJEfedDzVvAjwzrES7ihJTzt5lRUOMljZm2+M
         sVHnYei65s+/1YJfdH7U7Ah0wBLjrljQMFFrdnOvPSd5V8qq0oMnB25jiFOvkNvVIJ
         lsh5Zvvs5EqbF95d5rGbfWpVgGYcD2kCtj5AJGyc=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00M81ng8079140
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 Jan 2020 02:01:49 -0600
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 22
 Jan 2020 02:01:49 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 22 Jan 2020 02:01:49 -0600
Received: from a0230074-OptiPlex-7010.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00M81ctn007984;
        Wed, 22 Jan 2020 02:01:44 -0600
From:   Faiz Abbas <faiz_abbas@ti.com>
To:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>
CC:     <catalin.marinas@arm.com>, <mark.rutland@arm.com>,
        <robh+dt@kernel.org>, <davem@davemloft.net>, <mkl@pengutronix.de>,
        <wg@grandegger.com>, <sriram.dash@samsung.com>, <dmurphy@ti.com>,
        <faiz_abbas@ti.com>, <nm@ti.com>, <t-kristo@ti.com>
Subject: [PATCH 1/3] dt-bindings: net: can: m_can: Add Documentation for stb-gpios
Date:   Wed, 22 Jan 2020 13:33:08 +0530
Message-ID: <20200122080310.24653-2-faiz_abbas@ti.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200122080310.24653-1-faiz_abbas@ti.com>
References: <20200122080310.24653-1-faiz_abbas@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CAN transceiver on some boards has an STB pin which is
used to control its standby mode. Add an optional property
stb-gpios to toggle the same.

Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
---
 Documentation/devicetree/bindings/net/can/m_can.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/m_can.txt b/Documentation/devicetree/bindings/net/can/m_can.txt
index ed614383af9c..cc8ba3f7a2aa 100644
--- a/Documentation/devicetree/bindings/net/can/m_can.txt
+++ b/Documentation/devicetree/bindings/net/can/m_can.txt
@@ -48,6 +48,8 @@ Optional Subnode:
 			  that can be used for CAN/CAN-FD modes. See
 			  Documentation/devicetree/bindings/net/can/can-transceiver.txt
 			  for details.
+stb-gpios		: gpio node to toggle the STB (standby) signal on the transceiver
+
 Example:
 SoC dtsi:
 m_can1: can@20e8000 {
-- 
2.19.2

