Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD42A188A26
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 17:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgCQQZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 12:25:05 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:55980 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbgCQQZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 12:25:05 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02HGOnQN073884;
        Tue, 17 Mar 2020 11:24:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584462289;
        bh=FMEfVF/Y6JC0PmkJEu3lBXtB/Eyjcxja+1xNFplvEe8=;
        h=From:To:CC:Subject:Date;
        b=hsRpF3SMUwPAnHVRLPldS3DwA4UAevCJY/DWuq6M+FnadUTjcz4u0mOlUdHaGIxFm
         dHZVIeUJbYHsKqyLWXF6Ao5Qhdt4dxC5m2UJC83zJ4glVT5Bq3VmS9GpQDMpegp7UC
         uAN8gYA4IG66Yuds/yjn8wY7bSxecK8fHdfxgro8=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02HGOnMR091951
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Mar 2020 11:24:49 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 17
 Mar 2020 11:24:48 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 17 Mar 2020 11:24:48 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02HGOm1H100261;
        Tue, 17 Mar 2020 11:24:48 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <linux-doc@vger.kernel.org>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-can@vger.kernel.org>, <robh+dt@kernel.org>,
        <davem@davemloft.net>, <mkl@pengutronix.de>, <wg@grandegger.com>,
        <corbet@lwn.net>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH] docs: dt: Fix m_can.txt reference in tcan4x5x.txt
Date:   Tue, 17 Mar 2020 11:19:00 -0500
Message-ID: <20200317161900.14380-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the m_can.txt reference to point to the bosch,m_can.yaml.

Fixes: 824674b59f72 ("dt-bindings: net: can: Convert M_CAN to json-schema")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 Documentation/devicetree/bindings/net/can/tcan4x5x.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
index 6bdcc3f84bd3..3613c2c8f75d 100644
--- a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
+++ b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
@@ -14,7 +14,7 @@ Required properties:
                     the interrupt.
 	- interrupts: interrupt specification for data-ready.
 
-See Documentation/devicetree/bindings/net/can/m_can.txt for additional
+See Documentation/devicetree/bindings/net/can/bosch,m_can.yaml for additional
 required property details.
 
 Optional properties:
-- 
2.25.1

