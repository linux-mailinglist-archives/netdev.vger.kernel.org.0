Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D23A430831
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 07:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbfEaF4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 01:56:38 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40806 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbfEaF4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 01:56:35 -0400
Received: by mail-pf1-f193.google.com with SMTP id u17so5489662pfn.7;
        Thu, 30 May 2019 22:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Gqoy5TZzBBGMENH1KBlvfihB+rmyEhkB3t2QMsDk7ug=;
        b=Ky4xio3xjCsa4X5gslc45UaciB3CJg6XUhpO3fdF8A7wIihWWa9NQ1VvcULMCzAtJ7
         RAm4uYr3FlBv40gGPN6ct2oskP//orzda/9CZ1c2VtHZAS2AcMY+hB9qkjjL+U759eEO
         8iSV8RaUqmb4x69s6mFNP6dszztfAVJyn7sqn+s16bay7TA7eGIs/LxShu+MbfNFVhm/
         W2mOLGcJEryYEVrdOQiRbaTvmqSCdgTQt4ufui7MgK7PY7yzMtwzsjzhIHQ03oroc3fF
         88vSRLGzOSFpp2TPK8se+Fd9Ro/OV2EqYnOc+d1R3gPKPc3QkwT6JbpRJ/ME6itB9yRn
         tJDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Gqoy5TZzBBGMENH1KBlvfihB+rmyEhkB3t2QMsDk7ug=;
        b=QPHnm3SrFfYs1QcP9Q5izj9wH+A67rFi+x5GgsjxMhO7l+c7+8iun7mCrt0q3NA/me
         VpuCoAPm6C7VhVbcxnPsDx2MU1m+QKxQdb3vlgrAQSVjdj+4fYJcuwsFu092flMTOISv
         CS/ukBGl9TcEsMX6PaNFZfmfUFHJjSMptAM3VwTrk0Z4DlHrH4Gy8zGrF9E1E6MLc2GN
         wqFo6GFHQRwfwwDzwWzhZ/eMscVM3qsdnOqrjLtSsyKj5h2rOtnOucq1DGlvcAQVW5K3
         Xsy2Ah8anYHCsuslwl3HEnAAZV5ari4mcYFc+QeQUzbNp6b+aBFrOHr9+3o3EzYYRzol
         Jlow==
X-Gm-Message-State: APjAAAWhhQk57olvOgU+QtMd9Kgtbs1xoXzt/8fu/yMzIjnpor4M2e9Y
        0r0y+BcNXbTLd/M2xS3lW8HdiOxt
X-Google-Smtp-Source: APXvYqyhh/SED85FZgPWzlkX8TUUDSrgztkMYNenV6UWG+2JzuNLk/QcgJTucoVXe0moVBEvJvwuaA==
X-Received: by 2002:a62:ea0a:: with SMTP id t10mr7645178pfh.236.1559282194401;
        Thu, 30 May 2019 22:56:34 -0700 (PDT)
Received: from localhost.localdomain (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id u2sm4554184pjv.30.2019.05.30.22.56.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 22:56:33 -0700 (PDT)
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
Subject: [PATCH V5 net-next 4/6] dt-bindings: ptp: Introduce MII time stamping devices.
Date:   Thu, 30 May 2019 22:56:24 -0700
Message-Id: <d786656435c64160d50014beb3d3d9d1aaf6f22d.1559281985.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <cover.1559281985.git.richardcochran@gmail.com>
References: <cover.1559281985.git.richardcochran@gmail.com>
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

