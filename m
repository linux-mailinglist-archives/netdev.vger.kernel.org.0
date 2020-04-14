Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874A51A798E
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 13:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439251AbgDNLbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 07:31:49 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:18260 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438988AbgDNL1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 07:27:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1586863637; x=1618399637;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=bgal25Q2GLlB11cf7TVsL0b4pEAKBlQgQ2+f0ocKzAw=;
  b=2AwyDrd7zSLDlCq/kpl2L+PU4PdOgAw9MwikaDSOyMyOtl/+EOiyP9qg
   7WdHs2WA+NcEOse26b0qe27IWDXEjRq+Sat5UcTRPcB6yFuzQ/URBV+z/
   pafcnLHsgbCKe8BRUcW/RRFILbMVJnuyRxdzJyS6YI8N0idBAKUGfbYJr
   wvKyu6+LhD4rqajLD7tTIhxULsyGHnjdhshydYwrLA8AFPcGLZbq5sERS
   CnoTP93wV2vKicR4/Elfq5HeKuPkgNiyzDgQz6qRGilWSoC11unrZ/mE6
   +FQjkcDKfHn6q5xb1mE6JVD/gK+e9DootCTuxmX+i/tMYP8QB6UMmZnSk
   A==;
IronPort-SDR: FyX6K0vNEkVdhwRsCL9eiSdv7aItkODXd3Lk3HnNjfVx3Ql4HoDErhwnrIzoJgVV1nvzILIPgW
 lctKj78CbMqvGjgZ7laVmI2I7CJMlp9K5RCRs+JG3GaHAhgPhkO6EHYGBLj5Ae5kDYYPYaZI8E
 JiZgZsh35IhX4FoiXCPmXs60xvosDQtlKDmsApiJIEgV2zFPoNrEMPrxriL264luDHtMuqHzP2
 5tBkAcj36BSXuwYUASUXAYRV3WOpKFVmkDGwVvwP/Qg8c6B3FhX1fLX/AxiH94EDel/ldcgAL8
 vyc=
X-IronPort-AV: E=Sophos;i="5.72,382,1580799600"; 
   d="scan'208";a="75809061"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Apr 2020 04:27:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 14 Apr 2020 04:27:03 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Tue, 14 Apr 2020 04:27:14 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next v5 2/9] bridge: mrp: Update Kconfig and Makefile
Date:   Tue, 14 Apr 2020 13:26:11 +0200
Message-ID: <20200414112618.3644-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200414112618.3644-1-horatiu.vultur@microchip.com>
References: <20200414112618.3644-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the option BRIDGE_MRP to allow to build in or not MRP support.
The default value is N.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/Kconfig  | 12 ++++++++++++
 net/bridge/Makefile |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/net/bridge/Kconfig b/net/bridge/Kconfig
index e4fb050e2078..51a6414145d2 100644
--- a/net/bridge/Kconfig
+++ b/net/bridge/Kconfig
@@ -61,3 +61,15 @@ config BRIDGE_VLAN_FILTERING
 	  Say N to exclude this support and reduce the binary size.
 
 	  If unsure, say Y.
+
+config BRIDGE_MRP
+	bool "MRP protocol"
+	depends on BRIDGE
+	default n
+	help
+	  If you say Y here, then the Ethernet bridge will be able to run MRP
+	  protocol to detect loops
+
+	  Say N to exclude this support and reduce the binary size.
+
+	  If unsure, say N.
diff --git a/net/bridge/Makefile b/net/bridge/Makefile
index 49da7ae6f077..9bf3e1be3328 100644
--- a/net/bridge/Makefile
+++ b/net/bridge/Makefile
@@ -25,3 +25,5 @@ bridge-$(CONFIG_BRIDGE_VLAN_FILTERING) += br_vlan.o br_vlan_tunnel.o br_vlan_opt
 bridge-$(CONFIG_NET_SWITCHDEV) += br_switchdev.o
 
 obj-$(CONFIG_NETFILTER) += netfilter/
+
+bridge-$(CONFIG_BRIDGE_MRP)	+= br_mrp.o br_mrp_netlink.o br_mrp_switchdev.o
-- 
2.17.1

