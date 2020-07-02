Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D63B212797
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 17:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbgGBPSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 11:18:20 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:50964 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbgGBPST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 11:18:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593703099; x=1625239099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RT9huaVB12colQyq/kqbHAxSkjiisimneAH/k9IHSxc=;
  b=2MmTpwzhiCBYag8J1LSyJjhqSi6b/bH7uawmOnDuEaOwKIb8lsxnP3VL
   YSwpkzO88H0cSJkVTGb93AvJ4ZqqsmqHoNQHrC7eUi2FPxJR4yjE0x7s/
   Z9kx8aOCCWYXvP01gHtAMSQZ7ZjA1ad+K6NXFq9IIinkzCbqwGcpnY6pu
   HRZo8o4o1QFM39bZAmOivK6CR8scm1O9S+xWSVJC1XTacyJ3cMFPmJBZx
   VuLtZhu9237PC/1MsIGuRh2+pORCHQlBeiZW7CUR2OueTZJnFfDcrTgXh
   Obgr3uxVsOAsAGdp/EVUsWhRpN7ZF1fjLkWiuDdwLdq9LnoLcr1jrBITD
   g==;
IronPort-SDR: E33SwwIZhBiTaXk0LBEoizoL5cYX0fD1B0oWVhdQj3vNWfNLvSLUH/IkBeEZ12ArhjohoHqYyv
 pVG4Xc+fGybFIB0as4nJ9gW5Ms5qcAdy/Hv4MEpmQduSUflu5sI5JAmUVc6x/AYQD6heK0boKg
 E1KnCEnhdCL21F2HWackRoGz8SV1vBVcDNBMBcZNnS7GrkJKgq7WAeuGsIJSIe1RZ9NUbJtm6X
 olJmDi9WyWaMWT94mScaY6VEsrZctSlzSHfZ3jXiYHxDswmTK27HsFEdo+snbtMZpZcsvwVvce
 0+M=
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="82417413"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2020 08:18:18 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 2 Jul 2020 08:18:17 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 2 Jul 2020 08:17:45 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next v2 2/2] net: dsa: microchip: remove unused private members
Date:   Thu, 2 Jul 2020 18:17:24 +0300
Message-ID: <20200702151724.1483891-2-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702151724.1483891-1-codrin.ciubotariu@microchip.com>
References: <20200702151724.1483891-1-codrin.ciubotariu@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Private structure members live_ports, on_ports, rx_ports, tx_ports are
initialized but not used anywhere. Let's remove them.

Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
---

Changes in v2:
 - new patch, there was no v1

 drivers/net/dsa/microchip/ksz8795.c    | 18 --------------
 drivers/net/dsa/microchip/ksz9477.c    | 23 ++----------------
 drivers/net/dsa/microchip/ksz_common.c | 33 --------------------------
 drivers/net/dsa/microchip/ksz_common.h |  8 -------
 4 files changed, 2 insertions(+), 80 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 862306a9db2c..4202411627f1 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -731,15 +731,6 @@ static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
 
 	ksz_pwrite8(dev, port, P_STP_CTRL, data);
 	p->stp_state = state;
-	if (data & PORT_RX_ENABLE)
-		dev->rx_ports |= BIT(port);
-	else
-		dev->rx_ports &= ~BIT(port);
-	if (data & PORT_TX_ENABLE)
-		dev->tx_ports |= BIT(port);
-	else
-		dev->tx_ports &= ~BIT(port);
-
 	/* Port membership may share register with STP state. */
 	if (member >= 0 && member != p->member)
 		ksz8795_cfg_port_member(dev, port, (u8)member);
@@ -976,15 +967,8 @@ static void ksz8795_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 		p->phydev.duplex = 1;
 
 		member = dev->port_mask;
-		dev->on_ports = dev->host_mask;
-		dev->live_ports = dev->host_mask;
 	} else {
 		member = dev->host_mask | p->vid_member;
-		dev->on_ports |= BIT(port);
-
-		/* Link was detected before port is enabled. */
-		if (p->phydev.link)
-			dev->live_ports |= BIT(port);
 	}
 	ksz8795_cfg_port_member(dev, port, member);
 }
@@ -1112,9 +1096,7 @@ static const struct dsa_switch_ops ksz8795_switch_ops = {
 	.phy_read		= ksz_phy_read16,
 	.phy_write		= ksz_phy_write16,
 	.phylink_mac_link_down	= ksz_mac_link_down,
-	.phylink_mac_link_up	= ksz_mac_link_up,
 	.port_enable		= ksz_enable_port,
-	.port_disable		= ksz_disable_port,
 	.get_strings		= ksz8795_get_strings,
 	.get_ethtool_stats	= ksz_get_ethtool_stats,
 	.get_sset_count		= ksz_sset_count,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 9e4bdd950194..b939e0b82aa0 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -452,15 +452,6 @@ static void ksz9477_port_stp_state_set(struct dsa_switch *ds, int port,
 	ksz_pwrite8(dev, port, P_STP_CTRL, data);
 	p->stp_state = state;
 	mutex_lock(&dev->dev_mutex);
-	if (data & PORT_RX_ENABLE)
-		dev->rx_ports |= (1 << port);
-	else
-		dev->rx_ports &= ~(1 << port);
-	if (data & PORT_TX_ENABLE)
-		dev->tx_ports |= (1 << port);
-	else
-		dev->tx_ports &= ~(1 << port);
-
 	/* Port membership may share register with STP state. */
 	if (member >= 0 && member != p->member)
 		ksz9477_cfg_port_member(dev, port, (u8)member);
@@ -1268,18 +1259,10 @@ static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 		p->phydev.duplex = 1;
 	}
 	mutex_lock(&dev->dev_mutex);
-	if (cpu_port) {
+	if (cpu_port)
 		member = dev->port_mask;
-		dev->on_ports = dev->host_mask;
-		dev->live_ports = dev->host_mask;
-	} else {
+	else
 		member = dev->host_mask | p->vid_member;
-		dev->on_ports |= (1 << port);
-
-		/* Link was detected before port is enabled. */
-		if (p->phydev.link)
-			dev->live_ports |= (1 << port);
-	}
 	mutex_unlock(&dev->dev_mutex);
 	ksz9477_cfg_port_member(dev, port, member);
 
@@ -1400,9 +1383,7 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.phy_read		= ksz9477_phy_read16,
 	.phy_write		= ksz9477_phy_write16,
 	.phylink_mac_link_down	= ksz_mac_link_down,
-	.phylink_mac_link_up	= ksz_mac_link_up,
 	.port_enable		= ksz_enable_port,
-	.port_disable		= ksz_disable_port,
 	.get_strings		= ksz9477_get_strings,
 	.get_ethtool_stats	= ksz_get_ethtool_stats,
 	.get_sset_count		= ksz_sset_count,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 55ceaf00ece1..74f2216989ee 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -144,26 +144,9 @@ void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
 	/* Read all MIB counters when the link is going down. */
 	p->read = true;
 	schedule_delayed_work(&dev->mib_read, 0);
-
-	mutex_lock(&dev->dev_mutex);
-	dev->live_ports &= ~(1 << port);
-	mutex_unlock(&dev->dev_mutex);
 }
 EXPORT_SYMBOL_GPL(ksz_mac_link_down);
 
-void ksz_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
-		     phy_interface_t interface, struct phy_device *phydev,
-		     int speed, int duplex, bool tx_pause, bool rx_pause)
-{
-	struct ksz_device *dev = ds->priv;
-
-	/* Remember which port is connected and active. */
-	mutex_lock(&dev->dev_mutex);
-	dev->live_ports |= (1 << port) & dev->on_ports;
-	mutex_unlock(&dev->dev_mutex);
-}
-EXPORT_SYMBOL_GPL(ksz_mac_link_up);
-
 int ksz_sset_count(struct dsa_switch *ds, int port, int sset)
 {
 	struct ksz_device *dev = ds->priv;
@@ -377,22 +360,6 @@ int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 }
 EXPORT_SYMBOL_GPL(ksz_enable_port);
 
-void ksz_disable_port(struct dsa_switch *ds, int port)
-{
-	struct ksz_device *dev = ds->priv;
-
-	if (!dsa_is_user_port(ds, port))
-		return;
-
-	dev->on_ports &= ~(1 << port);
-	dev->live_ports &= ~(1 << port);
-
-	/* port_stp_state_set() will be called after to disable the port so
-	 * there is no need to do anything.
-	 */
-}
-EXPORT_SYMBOL_GPL(ksz_disable_port);
-
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
 {
 	struct dsa_switch *ds;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index c0224dd0cf8a..f7d92c1656b8 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -84,10 +84,6 @@ struct ksz_device {
 	unsigned long mib_read_interval;
 	u16 br_member;
 	u16 member;
-	u16 live_ports;
-	u16 on_ports;			/* ports enabled by DSA */
-	u16 rx_ports;
-	u16 tx_ports;
 	u16 mirror_rx;
 	u16 mirror_tx;
 	u32 features;			/* chip specific features */
@@ -161,9 +157,6 @@ int ksz_phy_read16(struct dsa_switch *ds, int addr, int reg);
 int ksz_phy_write16(struct dsa_switch *ds, int addr, int reg, u16 val);
 void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
 		       phy_interface_t interface);
-void ksz_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
-		     phy_interface_t interface, struct phy_device *phydev,
-		     int speed, int duplex, bool tx_pause, bool rx_pause);
 int ksz_sset_count(struct dsa_switch *ds, int port, int sset);
 void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf);
 int ksz_port_bridge_join(struct dsa_switch *ds, int port,
@@ -182,7 +175,6 @@ void ksz_port_mdb_add(struct dsa_switch *ds, int port,
 int ksz_port_mdb_del(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_mdb *mdb);
 int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy);
-void ksz_disable_port(struct dsa_switch *ds, int port);
 
 /* Common register access functions */
 
-- 
2.25.1

