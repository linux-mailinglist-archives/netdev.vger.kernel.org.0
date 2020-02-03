Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA65415090C
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 16:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgBCPEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 10:04:16 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:27986 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727619AbgBCPEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 10:04:16 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013Es2DN019579;
        Mon, 3 Feb 2020 16:04:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=GXqILcfjKu1HZOddsc0sEBRj0lXkax7Z1NWFwRyw1pc=;
 b=0IB8Ygh7r7dbQwEI5T5WzvtYWJg+YD04cXhVBxfHxQFiYtCZ3ojUg8xfDiPgqVDCfzqg
 ESU7I5EXWsG9LhGa1fg+XLXAC1VZCNfNyHd87As0ekzH0ie6NlCyo6lvhBbGTpP2zZBi
 4u4T6VOD2ydZG6GcoTbneejfmIFT0q0vI66xSv9a+G6/qUnnSVLRXcGLJ1me4nOt9oGG
 hKZBpenEYR4LtpioNkHFNmvBKmD0vOwJCAXe6WyAMY9b12ZJcoZqNINoGPUy/HFn9ZJx
 HY8Pr67mk+CrnYvIR51BO1Sr8EGBvXpTbYUcz+JBipBzvFyREnSt4sj8CWzayLL3N46k Gg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2xvybdsxtd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 16:04:00 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 5BBD1100034;
        Mon,  3 Feb 2020 16:04:00 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag3node3.st.com [10.75.127.9])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 4E31A2B26E8;
        Mon,  3 Feb 2020 16:04:00 +0100 (CET)
Received: from localhost (10.75.127.49) by SFHDAG3NODE3.st.com (10.75.127.9)
 with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon, 3 Feb 2020 16:03:59
 +0100
From:   Benjamin Gaignard <benjamin.gaignard@st.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <sriram.dash@samsung.com>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@st.com>
Subject: [PATCH v2 1/2] dt-bindinsg: net: can: Convert can-transceiver to json-schema
Date:   Mon, 3 Feb 2020 16:03:52 +0100
Message-ID: <20200203150353.23903-2-benjamin.gaignard@st.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <20200203150353.23903-1-benjamin.gaignard@st.com>
References: <20200203150353.23903-1-benjamin.gaignard@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.49]
X-ClientProxiedBy: SFHDAG4NODE3.st.com (10.75.127.12) To SFHDAG3NODE3.st.com
 (10.75.127.9)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_04:2020-02-02,2020-02-03 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert can-transceiver property to json-schema

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
---
 .../bindings/net/can/can-transceiver.txt           | 24 ----------------------
 .../bindings/net/can/can-transceiver.yaml          | 23 +++++++++++++++++++++
 2 files changed, 23 insertions(+), 24 deletions(-)
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
index 000000000000..73bb084a45a8
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/can-transceiver.yaml
@@ -0,0 +1,23 @@
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
+  can-transceiver:
+    type: object
+
+    properties:
+      max-bitrate:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        description: a positive non 0 value that determines the max speed that
+                     CAN/CAN-FD can run.
+        minimum: 1
-- 
2.15.0

