Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB21C31890B
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhBKLGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:06:08 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:58258 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbhBKLAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 06:00:11 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 11BAvmp3066595;
        Thu, 11 Feb 2021 04:57:48 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1613041068;
        bh=W8JvbtKs6xELp4t59mJ78/Bnm5C7ehNUvAZNav+7AMM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=fslAIAtmx2QDT9qVF4P84zkPikpEb+BAwWJbwb4FZKSWfCmCuCtA4MFjq//e09gph
         ZgZpLWuhmoDhh0PqRr45LnYBfOPWtItyuqj0AQFXKXEG6yl/3JYwpqZMTJHtjnF4gA
         EYpu3RHk4vzpaYDbkIptDVbQCWBy+SUG597aSj5s=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 11BAvmhh029451
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 11 Feb 2021 04:57:48 -0600
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 11
 Feb 2021 04:57:47 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 11 Feb 2021 04:57:48 -0600
Received: from ula0132425.ent.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 11BAvS0d045148;
        Thu, 11 Feb 2021 04:57:44 -0600
From:   Vignesh Raghavendra <vigneshr@ti.com>
To:     David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>
CC:     Vignesh Raghavendra <vigneshr@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 4/4] docs: networking: ti: Add driver doc for AM65 NUSS switch driver
Date:   Thu, 11 Feb 2021 16:26:44 +0530
Message-ID: <20210211105644.15521-5-vigneshr@ti.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210211105644.15521-1-vigneshr@ti.com>
References: <20210211105644.15521-1-vigneshr@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

J721e, J7200 and AM64 have multi port switches which can work in multi
mac mode and in switch mode. Add documentation explaining how to use
different modes.

Borrowed from:
Documentation/networking/device_drivers/ethernet/ti/cpsw_switchdev.rst

Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
---
 .../device_drivers/ethernet/index.rst         |   1 +
 .../ethernet/ti/am65_nuss_cpsw_switchdev.rst  | 143 ++++++++++++++++++
 2 files changed, 144 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/ti/am65_nuss_cpsw_switchdev.rst

diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
index cbb75a1818c0..6b5dc203da2b 100644
--- a/Documentation/networking/device_drivers/ethernet/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/index.rst
@@ -49,6 +49,7 @@ Contents:
    stmicro/stmmac
    ti/cpsw
    ti/cpsw_switchdev
+   ti/am65_nuss_cpsw_switchdev
    ti/tlan
    toshiba/spider_net
 
diff --git a/Documentation/networking/device_drivers/ethernet/ti/am65_nuss_cpsw_switchdev.rst b/Documentation/networking/device_drivers/ethernet/ti/am65_nuss_cpsw_switchdev.rst
new file mode 100644
index 000000000000..f24adfab6a1b
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/ti/am65_nuss_cpsw_switchdev.rst
@@ -0,0 +1,143 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================================================================
+Texas Instruments K3 AM65 CPSW NUSS switchdev based ethernet driver
+===================================================================
+
+:Version: 1.0
+
+Port renaming
+=============
+
+In order to rename via udev::
+
+    ip -d link show dev sw0p1 | grep switchid
+
+    SUBSYSTEM=="net", ACTION=="add", ATTR{phys_switch_id}==<switchid>, \
+	    ATTR{phys_port_name}!="", NAME="sw0$attr{phys_port_name}"
+
+
+Multi mac mode
+==============
+
+- The driver is operating in multi-mac mode by default, thus
+  working as N individual network interfaces.
+
+Devlink configuration parameters
+================================
+
+See Documentation/networking/devlink/am65-nuss-cpsw-switch.rst
+
+Enabling "switch"
+=================
+
+The Switch mode can be enabled by configuring devlink driver parameter
+"switch_mode" to 1/true::
+
+        devlink dev param set platform/c000000.ethernet \
+        name switch_mode value true cmode runtime
+
+This can be done regardless of the state of Port's netdev devices - UP/DOWN, but
+Port's netdev devices have to be in UP before joining to the bridge to avoid
+overwriting of bridge configuration as CPSW switch driver completely reloads its
+configuration when first port changes its state to UP.
+
+When the both interfaces joined the bridge - CPSW switch driver will enable
+marking packets with offload_fwd_mark flag.
+
+All configuration is implemented via switchdev API.
+
+Bridge setup
+============
+
+::
+
+        devlink dev param set platform/c000000.ethernet \
+        name switch_mode value true cmode runtime
+
+	ip link add name br0 type bridge
+	ip link set dev br0 type bridge ageing_time 1000
+	ip link set dev sw0p1 up
+	ip link set dev sw0p2 up
+	ip link set dev sw0p1 master br0
+	ip link set dev sw0p2 master br0
+
+	[*] bridge vlan add dev br0 vid 1 pvid untagged self
+
+	[*] if vlan_filtering=1. where default_pvid=1
+
+	Note. Steps [*] are mandatory.
+
+
+On/off STP
+==========
+
+::
+
+	ip link set dev BRDEV type bridge stp_state 1/0
+
+VLAN configuration
+==================
+
+::
+
+  bridge vlan add dev br0 vid 1 pvid untagged self <---- add cpu port to VLAN 1
+
+Note. This step is mandatory for bridge/default_pvid.
+
+Add extra VLANs
+===============
+
+ 1. untagged::
+
+	bridge vlan add dev sw0p1 vid 100 pvid untagged master
+	bridge vlan add dev sw0p2 vid 100 pvid untagged master
+	bridge vlan add dev br0 vid 100 pvid untagged self <---- Add cpu port to VLAN100
+
+ 2. tagged::
+
+	bridge vlan add dev sw0p1 vid 100 master
+	bridge vlan add dev sw0p2 vid 100 master
+	bridge vlan add dev br0 vid 100 pvid tagged self <---- Add cpu port to VLAN100
+
+FDBs
+----
+
+FDBs are automatically added on the appropriate switch port upon detection
+
+Manually adding FDBs::
+
+    bridge fdb add aa:bb:cc:dd:ee:ff dev sw0p1 master vlan 100
+    bridge fdb add aa:bb:cc:dd:ee:fe dev sw0p2 master <---- Add on all VLANs
+
+MDBs
+----
+
+MDBs are automatically added on the appropriate switch port upon detection
+
+Manually adding MDBs::
+
+  bridge mdb add dev br0 port sw0p1 grp 239.1.1.1 permanent vid 100
+  bridge mdb add dev br0 port sw0p1 grp 239.1.1.1 permanent <---- Add on all VLANs
+
+Multicast flooding
+==================
+CPU port mcast_flooding is always on
+
+Turning flooding on/off on swithch ports:
+bridge link set dev sw0p1 mcast_flood on/off
+
+Access and Trunk port
+=====================
+
+::
+
+ bridge vlan add dev sw0p1 vid 100 pvid untagged master
+ bridge vlan add dev sw0p2 vid 100 master
+
+
+ bridge vlan add dev br0 vid 100 self
+ ip link add link br0 name br0.100 type vlan id 100
+
+Note. Setting PVID on Bridge device itself works only for
+default VLAN (default_pvid).
-- 
2.30.0

