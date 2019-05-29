Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3297B2D546
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 07:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfE2F6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 01:58:21 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44501 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbfE2F6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 01:58:16 -0400
Received: by mail-pg1-f193.google.com with SMTP id n2so663185pgp.11;
        Tue, 28 May 2019 22:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Gqoy5TZzBBGMENH1KBlvfihB+rmyEhkB3t2QMsDk7ug=;
        b=mmVNzVd/e69pfS7hr/r0uUOvBRfjOKdCHl1LcAPeSzAToVRcEyFrGbfBtjlnQ/gbfN
         Ink2CZ6nbKJmHpaUHBBr7Guzg9hzE8YBMcLPR+jEO6eEB3kx+GJQ1VumXe51eaKWViPO
         bYUwejqxxfUIjEtzLoK+JYTypcsPXubwAxbdzM8J10AGdHzJHIQWxr2NcTsk8uLhnPEz
         q83sAC5nv7Df3Oy7nSPb/6iNUI4/Fl4uBkaa5tFiWXL99sWRS3BeLtHBiH5mR3HO7gNt
         XJXL/acz7ZrAPTPnBoOvUlpsvoUIhvoff2+MQifFgnw9hQoO5KuTzgMkFetnCmzWaOUB
         qU7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Gqoy5TZzBBGMENH1KBlvfihB+rmyEhkB3t2QMsDk7ug=;
        b=o2xRJ6Lx6eHX0PJvDcQHMwF6/ZynJSrO6W+gh+2/J1LxvuI0VSnzyuGDM840kQKOpM
         HyWyyux7zS9ba/VFgRUPthe4E3bzY5WoU6gP6XNkvyBQYw7pEjXLEbIFaW86X2C8jSCg
         J2l1bcg5H4PEv3+WeW/eFvBZDoRdjhKTD2ofqYOtMvAiLmhKaH3oLmeqPXnG1QbOhrT7
         CMxtY9HImtUW+UesJzWqrNlvyPNcvDgVJkiwq1OyeS8Dsdwc4wopGETmYmb2evqy/Un9
         atX9vYcnS9dutaUAlWo1tR/SggcYqY9utBJR0VJljOZPPtgua4ClLTLz7iHNg+F90WA1
         6ULA==
X-Gm-Message-State: APjAAAWKrVBV4kZ0E4d5UrJxrIxY9j7/sbDJILJv70dt8i+i526Ahs8g
        B/yxzM/BUflZmUVVJzyupjMfpLq9
X-Google-Smtp-Source: APXvYqw9jDRCASPCquwBEb9ZxjUvn80iPFLkuIjACygTfzEofP0F7SeKI5NAGhF9ei/fpzkRmk73yg==
X-Received: by 2002:a17:90a:8982:: with SMTP id v2mr9796733pjn.138.1559109495384;
        Tue, 28 May 2019 22:58:15 -0700 (PDT)
Received: from localhost.localdomain (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id w1sm19093127pfg.51.2019.05.28.22.58.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 22:58:14 -0700 (PDT)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH V4 net-next 4/6] dt-bindings: ptp: Introduce MII time stamping devices.
Date:   Tue, 28 May 2019 22:58:05 -0700
Message-Id: <1dfbeb30abee8e28d066f90f2a98f8d364355df1.1559109077.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <cover.1559109076.git.richardcochran@gmail.com>
References: <cover.1559109076.git.richardcochran@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add a new binding that allows non-PHY MII time stamping
devices to find their buses.  The new documentation covers both the
generic binding and one upcoming user.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 Documentation/devicetree/bindings/ptp/ptp-ines.txt | 35 ++++++++++++++++++
 .../devicetree/bindings/ptp/timestamper.txt        | 41 ++++++++++++++++++++++
 2 files changed, 76 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ptp/ptp-ines.txt
 create mode 100644 Documentation/devicetree/bindings/ptp/timestamper.txt

diff --git a/Documentation/devicetree/bindings/ptp/ptp-ines.txt b/Documentation/devicetree/bindings/ptp/ptp-ines.txt
new file mode 100644
index 000000000000..4dee9eb89455
--- /dev/null
+++ b/Documentation/devicetree/bindings/ptp/ptp-ines.txt
@@ -0,0 +1,35 @@
+ZHAW InES PTP time stamping IP core
+
+The IP core needs two different kinds of nodes.  The control node
+lives somewhere in the memory map and specifies the address of the
+control registers.  There can be up to three port handles placed as
+attributes of PHY nodes.  These associate a particular MII bus with a
+port index within the IP core.
+
+Required properties of the control node:
+
+- compatible:		"ines,ptp-ctrl"
+- reg:			physical address and size of the register bank
+
+Required format of the port handle within the PHY node:
+
+- timestamper:		provides control node reference and
+			the port channel within the IP core
+
+Example:
+
+	tstamper: timestamper@60000000 {
+		compatible = "ines,ptp-ctrl";
+		reg = <0x60000000 0x80>;
+	};
+
+	ethernet@80000000 {
+		...
+		mdio {
+			...
+			phy@3 {
+				...
+				timestamper = <&tstamper 0>;
+			};
+		};
+	};
diff --git a/Documentation/devicetree/bindings/ptp/timestamper.txt b/Documentation/devicetree/bindings/ptp/timestamper.txt
new file mode 100644
index 000000000000..88ea0bc7d662
--- /dev/null
+++ b/Documentation/devicetree/bindings/ptp/timestamper.txt
@@ -0,0 +1,41 @@
+Time stamps from MII bus snooping devices
+
+This binding supports non-PHY devices that snoop the MII bus and
+provide time stamps.  In contrast to PHY time stamping drivers (which
+can simply attach their interface directly to the PHY instance), stand
+alone MII time stamping drivers use this binding to specify the
+connection between the snooping device and a given network interface.
+
+Non-PHY MII time stamping drivers typically talk to the control
+interface over another bus like I2C, SPI, UART, or via a memory mapped
+peripheral.  This controller device is associated with one or more
+time stamping channels, each of which snoops on a MII bus.
+
+The "timestamper" property lives in a phy node and links a time
+stamping channel from the controller device to that phy's MII bus.
+
+Example:
+
+	tstamper: timestamper@10000000 {
+		compatible = "bigcorp,ts-ctrl";
+	};
+
+	ethernet@20000000 {
+		mdio {
+			phy@1 {
+				timestamper = <&tstamper 0>;
+			};
+		};
+	};
+
+	ethernet@30000000 {
+		mdio {
+			phy@2 {
+				timestamper = <&tstamper 1>;
+			};
+		};
+	};
+
+In this example, time stamps from the MII bus attached to phy@1 will
+appear on time stamp channel 0 (zero), and those from phy@2 appear on
+channel 1.
-- 
2.11.0

