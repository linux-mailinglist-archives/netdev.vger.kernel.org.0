Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66ADB155534
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 11:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgBGKDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 05:03:24 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:51753 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726587AbgBGKDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 05:03:24 -0500
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0179w2wJ027031;
        Fri, 7 Feb 2020 11:03:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=CohntQm5nv98R/c5r9z9/0MAzldldRyWYCtFjXGF2w8=;
 b=vhYEHnEWP99sDPDGSapOiMXSMcxPJ8ia2TPbpozpFVFXQ3Q3Ea2twKrNFoiUFNr6C5LF
 35PihXMu7MKheFtP1AWu3v2Oun7QK0syahZ9suo+lMCsRwye2lkmkbuwbQw+Dknfcwh6
 Aiqx/2ItDf8wJ1CNs8ZMcduMsEkodz+zRE8IbO9fxn5M/T3YpbvwzhVb1pZgng6JJTId
 k/5qPmYxHWho/UHiu8w3N7qDaZna3jXu7gd1CsvZBa9LR6m7R2d58DR+D3W5e0Rkk+9l
 DbVwyBQHwboYIS8Lw0MAYAInvx127wZxW6/nz51SazvXgvdSpJIQFd8036Em/UYm1wqj Ow== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2xyhk8sxms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 11:03:09 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 7CDBE100034;
        Fri,  7 Feb 2020 11:03:08 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag3node3.st.com [10.75.127.9])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 6AB122A96FF;
        Fri,  7 Feb 2020 11:03:08 +0100 (CET)
Received: from localhost (10.75.127.49) by SFHDAG3NODE3.st.com (10.75.127.9)
 with Microsoft SMTP Server (TLS) id 15.0.1347.2; Fri, 7 Feb 2020 11:03:08
 +0100
From:   Benjamin Gaignard <benjamin.gaignard@st.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <sriram.dash@samsung.com>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@st.com>
Subject: [PATCH v4 1/2] dt-bindinsg: net: can: Convert can-transceiver to json-schema
Date:   Fri, 7 Feb 2020 11:03:05 +0100
Message-ID: <20200207100306.20997-2-benjamin.gaignard@st.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <20200207100306.20997-1-benjamin.gaignard@st.com>
References: <20200207100306.20997-1-benjamin.gaignard@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.49]
X-ClientProxiedBy: SFHDAG5NODE2.st.com (10.75.127.14) To SFHDAG3NODE3.st.com
 (10.75.127.9)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-07_01:2020-02-07,2020-02-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert can-transceiver property to json-schema

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
---
version 4:
- no change

version 3:
- only declare max-bitrate property in can-transceiver.yaml

 .../bindings/net/can/can-transceiver.txt           | 24 ----------------------
 .../bindings/net/can/can-transceiver.yaml          | 18 ++++++++++++++++
 2 files changed, 18 insertions(+), 24 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/can/can-transceiver.txt
 create mode 100644 Documentation/devicetree/bindings/net/can/can-transceiver.yaml

diff --git a/Documentation/devicetree/bindings/net/can/can-transceiver.txt b/Documentation/devicetree/bindings/net/can/can-transceiver.txt
deleted file mode 100644
index 0011f53ff159..000000000000
--- a/Documentation/devicetree/bindings/net/can/can-transceiver.txt
+++ /dev/null
@@ -1,24 +0,0 @@
-Generic CAN transceiver Device Tree binding
-------------------------------
-
-CAN transceiver typically limits the max speed in standard CAN and CAN FD
-modes. Typically these limitations are static and the transceivers themselves
-provide no way to detect this limitation at runtime. For this situation,
-the "can-transceiver" node can be used.
-
-Required Properties:
- max-bitrate:	a positive non 0 value that determines the max
-		speed that CAN/CAN-FD can run. Any other value
-		will be ignored.
-
-Examples:
-
-Based on Texas Instrument's TCAN1042HGV CAN Transceiver
-
-m_can0 {
-	....
-	can-transceiver {
-		max-bitrate = <5000000>;
-	};
-	...
-};
diff --git a/Documentation/devicetree/bindings/net/can/can-transceiver.yaml b/Documentation/devicetree/bindings/net/can/can-transceiver.yaml
new file mode 100644
index 000000000000..6396977d29e5
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/can-transceiver.yaml
@@ -0,0 +1,18 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/can/can-transceiver.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: CAN transceiver Bindings
+
+description: CAN transceiver generic properties bindings
+
+maintainers:
+  - Rob Herring <robh@kernel.org>
+
+properties:
+  max-bitrate:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: a positive non 0 value that determines the max speed that CAN/CAN-FD can run.
+    minimum: 1
-- 
2.15.0

