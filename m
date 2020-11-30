Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF8B2C7FE8
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 09:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgK3IaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 03:30:17 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:56970 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727662AbgK3IaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 03:30:15 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AU8SYRm008667;
        Mon, 30 Nov 2020 02:28:34 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1606724914;
        bh=h5CVmDm6zhA5LBmaGMR5Ram6bII69s04PXZ9eWvYC2Q=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=gE3dME+F5v5BSQ9TJFDpYn35iHZ5hcagwWJr7Yo3TUBKx5HLUKnOFOwiHG5r+MiBQ
         +zDN7ijNLpdjxpCbhUvomS6vWiPWPupvJZgZj4ZaXAxm1CEwr1ZLvh/BHFuSAYv+34
         e7cvyZyzlz5OL2Wyp7aKrn8ZGN30vRuOfIIQutS8=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AU8SYSU039653
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 02:28:34 -0600
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 30
 Nov 2020 02:28:34 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 30 Nov 2020 02:28:34 -0600
Received: from ula0132425.ent.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AU8S9Du057144;
        Mon, 30 Nov 2020 02:28:30 -0600
From:   Vignesh Raghavendra <vigneshr@ti.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
CC:     Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <netdev@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 4/4] docs: networking: ti: Add driver doc for AM65 NUSS switch driver
Date:   Mon, 30 Nov 2020 13:50:46 +0530
Message-ID: <20201130082046.16292-5-vigneshr@ti.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130082046.16292-1-vigneshr@ti.com>
References: <20201130082046.16292-1-vigneshr@ti.com>
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
2.29.2

