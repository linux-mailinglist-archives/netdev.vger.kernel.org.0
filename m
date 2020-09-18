Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F3C270300
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgIRROs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:14:48 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:56980 "EHLO
        zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726118AbgIRROr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 13:14:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6Ud7AkCAdBtXJLdzdExeSRZGMEp2+p6ATGo0aHX6quQ=; b=RTwZ/2vHa2B8mkL5Ev4ozL3b0O
        yCIRBOyV2q+BBx7dQWwFPikrKLL8oIwhJoNs+gYPuDhJgIoOPS0p6Dnu404KNsW8nhkRX6zjMOKip
        lDWlw2T7o/g6tVjSx8oQ1Szgi3eylRr3IsyZhLQX1gIp7WX1AqFyRVeqH/KeGdGVtP0k=;
Received: from 78-83-68-78.spectrumnet.bg ([78.83.68.78] helo=p310)
        by zztop.nucleusys.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <petkan@nucleusys.com>)
        id 1kJJy3-0002GK-Cw; Fri, 18 Sep 2020 20:14:40 +0300
Date:   Fri, 18 Sep 2020 20:14:40 +0300
From:   Petko Manolov <petkan@nucleusys.com>
To:     David Bilsby <d.bilsby@virgin.net>
Cc:     Thor Thayer <thor.thayer@linux.intel.com>, netdev@vger.kernel.org
Subject: Re: Altera TSE driver not working in 100mbps mode
Message-ID: <20200918171440.GA1538@p310>
References: <20191127135419.7r53qw6vtp747x62@p310>
 <20191203092918.52x3dfuvnryr5kpx@carbon>
 <c8e4fc3a-0f40-45b6-d9c8-f292c3fdec9d@virgin.net>
 <20200917064239.GA40050@p310>
 <9f312748-1069-4a30-ba3f-d1de6d84e920@virgin.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <9f312748-1069-4a30-ba3f-d1de6d84e920@virgin.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Score: -1.0 (-)
X-Spam-Report: Spam detection software, running on the system "zztop.nucleusys.com",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On 20-09-17 21:29:41, David Bilsby wrote: > On 17/09/2020
   07:42, Petko Manolov wrote: > > On 20-09-16 22:32:03, David Bilsby wrote:
   > > > Hi > > > > > > Would you consider making the PhyLink modificat [...]
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
  0.0 TVD_RCVD_IP            Message was received from an IP address
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 20-09-17 21:29:41, David Bilsby wrote:
> On 17/09/2020 07:42, Petko Manolov wrote:
> > On 20-09-16 22:32:03, David Bilsby wrote:
> > > Hi
> > > 
> > > Would you consider making the PhyLink modifications to the Altera TSE 
> > > driver public as this would be very useful for a board we have which uses 
> > > an SFP PHY connected to the TSE core via I2C. Currently we are using a 
> > > fibre SFP and fixing the speed to 1G but would really like to be able to 
> > > use a copper SFP which needs to do negotiation.
> > Well, definitely yes.
> > 
> > The driver isn't 100% finished, but it mostly works.  One significant 
> > downside is the kernel version i had to port it to: 4.19.  IIRC there is API 
> > change so my current patches can't be applied to 5.x kernels.  Also, i could 
> > not finish the upstreaming as the customer device i worked on had to be 
> > returned.
>
> Interesting about kernel versions as we have just moved to the latest 5.4.44 
> lts kernel as suggested on Rocketboard for Arria 10s. We had been having 
> issues with 4.19 kernel which seem to have been resolved in the 5.4.44.

Always use mainline (and new) kernels.  If possible... ;)

> > However, given access to Altera TSE capable device (which i don't have atm), 
> > running a recent kernel, i'll gladly finish the upstreaming.
>
> I would be happy to take what you have at the moment, pre-upstreaming, and see 
> if I can get it going on the latter kernel, and hopefully provide some testing 
> feedback. Obviously pass any changes back for you to review and include as 
> part of your original work.

There you go.


		Petko

--BOKacYhQ+x31HxR3
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-convert-the-Altera-TSE-driver-to-phylink.patch"

From c59957adebf39153a9a98af278d6036086654150 Mon Sep 17 00:00:00 2001
From: Petko Manolov <petko.manolov@konsulko.com>
Date: Fri, 25 Oct 2019 12:12:33 +0300
Subject: [PATCH 1/2] convert the Altera TSE driver to phylink

Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>
---
 drivers/net/ethernet/altera/altera_tse.h      |  47 ++
 .../net/ethernet/altera/altera_tse_ethtool.c  |  20 +-
 drivers/net/ethernet/altera/altera_tse_main.c | 547 ++++++++----------
 3 files changed, 311 insertions(+), 303 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_tse.h b/drivers/net/ethernet/altera/altera_tse.h
index e2feee87180a..781ea1b71289 100644
--- a/drivers/net/ethernet/altera/altera_tse.h
+++ b/drivers/net/ethernet/altera/altera_tse.h
@@ -38,6 +38,7 @@
 #include <linux/list.h>
 #include <linux/netdevice.h>
 #include <linux/phy.h>
+#include <linux/phylink.h>
 
 #define ALTERA_TSE_SW_RESET_WATCHDOG_CNTR	10000
 #define ALTERA_TSE_MAC_FIFO_WIDTH		4	/* TX/RX FIFO width in
@@ -120,13 +121,51 @@
 #define MAC_CMDCFG_DISABLE_READ_TIMEOUT_GET(v)	GET_BIT_VALUE(v, 27)
 #define MAC_CMDCFG_CNT_RESET_GET(v)		GET_BIT_VALUE(v, 31)
 
+#define PCS_CTRL_REG				0x0
+#define	  PCS_CTRL_RESTART_AN			BIT(9)
+#define	  PCS_CTRL_AN_ENABLE			BIT(12)
+#define	  PCS_CTRL_RESET			BIT(15)
+#define PCS_STATUS_REG				0x1
+#define	  PCS_STATUS_LINK			BIT(2)
+#define	  PCS_STATUS_AN_COMPLETE		BIT(5)
+#define PCS_DEV_ABILITY_REG			0x4
+#define PCS_PARTNER_ABILITY_REG			0x5
+#define PCS_ABILITY_1000BASEX_FD		BIT(5)
+#define PCS_ABILITY_1000BASEX_HD		BIT(6)
+#define PCS_ABILITY_1000BASEX_PAUSE_MASK	GENMASK(8, 7)
+#define PCS_ABILITY_1000BASEX_NO_PAUSE		(0 << 7)
+#define PCS_ABILITY_1000BASEX_PAUSE_ASYM	(1 << 7)
+#define PCS_ABILITY_1000BASEX_PAUSE_SYM		(2 << 7)
+#define PCS_ABILITY_1000BASEX_PAUSE_TXRX	(3 << 7)
+#define PCS_ABILITY_1000BASEX_RFAULT_MASK	GENMASK(13, 12)
+#define PCS_ABILITY_1000BASEX_NO_RFAULT		(0 << 12)
+#define PCS_ABILITY_1000BASEX_OFFLINE		(1 << 12)
+#define PCS_ABILITY_1000BASEX_FAILURE		(2 << 12)
+#define PCS_ABILITY_1000BASEX_AN_ERROR		(3 << 12)
+#define PCS_ABILITY_SGMII_COPPER_SPEED_MASK	GENMASK(11, 10)
+#define PCS_ABILITY_SGMI_SPEED_10		(0 << 10)
+#define PCS_ABILITY_SGMI_SPEED_100		(1 << 10)
+#define PCS_ABILITY_SGMI_SPEED_1000		(2 << 10)
+#define PCS_ABILITY_SGMII_COPPER_FD		BIT(12)
+#define PCS_ABILITY_SGMII_ACK			BIT(14)
+#define PCS_ABILITY_SGMII_COPPER_LINK_STATUS	BIT(15)
+
 /* SGMII PCS register addresses
  */
 #define SGMII_PCS_SCRATCH	0x10
 #define SGMII_PCS_REV		0x11
 #define SGMII_PCS_LINK_TIMER_0	0x12
+#define   SGMII_PCS_LINK_TIMER_REG(x)		(0x12 + (x))
 #define SGMII_PCS_LINK_TIMER_1	0x13
 #define SGMII_PCS_IF_MODE	0x14
+#define   PCS_IF_MODE_SGMII_ENA		BIT(0)
+#define   PCS_IF_MODE_USE_SGMII_AN	BIT(1)
+#define   PCS_IF_MODE_SGMI_SPEED_MASK	GENMASK(3, 2)
+#define   PCS_IF_MODE_SGMI_SPEED_10	(0 << 2)
+#define   PCS_IF_MODE_SGMI_SPEED_100	(1 << 2)
+#define   PCS_IF_MODE_SGMI_SPEED_1000	(2 << 2)
+#define   PCS_IF_MODE_SGMI_HALF_DUPLEX	BIT(4)
+#define   PCS_IF_MODE_SGMI_PHY_AN	BIT(5)
 #define SGMII_PCS_DIS_READ_TO	0x15
 #define SGMII_PCS_READ_TO	0x16
 #define SGMII_PCS_SW_RESET_TIMEOUT 100 /* usecs */
@@ -491,6 +530,14 @@ struct altera_tse_private {
 	u32 msg_enable;
 
 	struct altera_dmaops *dmaops;
+
+	/* phylink stuff */
+	struct phylink *phylink;
+
+	/* PCS address */
+	struct {
+		void __iomem *iomem;
+	} pcs;
 };
 
 /* Function prototypes
diff --git a/drivers/net/ethernet/altera/altera_tse_ethtool.c b/drivers/net/ethernet/altera/altera_tse_ethtool.c
index 7c367713c3e6..e1f69f00f4c2 100644
--- a/drivers/net/ethernet/altera/altera_tse_ethtool.c
+++ b/drivers/net/ethernet/altera/altera_tse_ethtool.c
@@ -233,6 +233,22 @@ static void tse_get_regs(struct net_device *dev, struct ethtool_regs *regs,
 		buf[i] = csrrd32(priv->mac_dev, i * 4);
 }
 
+static int tse_ethtool_set_link_ksettings(struct net_device *dev,
+					  const struct ethtool_link_ksettings *cmd)
+{
+	struct altera_tse_private *priv = netdev_priv(dev);
+
+	return phylink_ethtool_ksettings_set(priv->phylink, cmd);
+}
+
+static int tse_ethtool_get_link_ksettings(struct net_device *dev,
+					  struct ethtool_link_ksettings *cmd)
+{
+	struct altera_tse_private *priv = netdev_priv(dev);
+
+	return phylink_ethtool_ksettings_get(priv->phylink, cmd);
+}
+
 static const struct ethtool_ops tse_ethtool_ops = {
 	.get_drvinfo = tse_get_drvinfo,
 	.get_regs_len = tse_reglen,
@@ -243,8 +259,8 @@ static const struct ethtool_ops tse_ethtool_ops = {
 	.get_ethtool_stats = tse_fill_stats,
 	.get_msglevel = tse_get_msglevel,
 	.set_msglevel = tse_set_msglevel,
-	.get_link_ksettings = phy_ethtool_get_link_ksettings,
-	.set_link_ksettings = phy_ethtool_set_link_ksettings,
+	.get_link_ksettings = tse_ethtool_get_link_ksettings,
+	.set_link_ksettings = tse_ethtool_set_link_ksettings,
 };
 
 void altera_tse_set_ethtool_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index c3c1195021a2..b19b8c166433 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -97,25 +97,32 @@ static inline u32 tse_tx_avail(struct altera_tse_private *priv)
 	return priv->tx_cons + priv->tx_ring_size - priv->tx_prod - 1;
 }
 
-/* PCS Register read/write functions
+/* PCS Register sgmii_pcs_read read/write functions
  */
 static u16 sgmii_pcs_read(struct altera_tse_private *priv, int regnum)
 {
-	return csrrd32(priv->mac_dev,
-		       tse_csroffs(mdio_phy0) + regnum * 4) & 0xffff;
+	u16 ret;
+
+	ret = ioread32(priv->pcs.iomem + (regnum * sizeof(u16)));
+
+	return ret;
 }
 
 static void sgmii_pcs_write(struct altera_tse_private *priv, int regnum,
 				u16 value)
 {
-	csrwr32(value, priv->mac_dev, tse_csroffs(mdio_phy0) + regnum * 4);
+	iowrite32(value, priv->pcs.iomem + (regnum * sizeof(u16)));
 }
 
-/* Check PCS scratch memory */
-static int sgmii_pcs_scratch_test(struct altera_tse_private *priv, u16 value)
+static void sgmii_pcs_reset(struct altera_tse_private *priv)
 {
-	sgmii_pcs_write(priv, SGMII_PCS_SCRATCH, value);
-	return (sgmii_pcs_read(priv, SGMII_PCS_SCRATCH) == value);
+	u16 tmp;
+
+	tmp = sgmii_pcs_read(priv, PCS_CTRL_REG);
+	tmp |= PCS_CTRL_RESET;
+	sgmii_pcs_write(priv, PCS_CTRL_REG, tmp);
+	/* wait until the reset bit is clear */
+	while (sgmii_pcs_read(priv, PCS_CTRL_REG) & PCS_CTRL_RESET);
 }
 
 /* MDIO specific functions
@@ -126,12 +133,11 @@ static int altera_tse_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 	struct altera_tse_private *priv = netdev_priv(ndev);
 
 	/* set MDIO address */
-	csrwr32((mii_id & 0x1f), priv->mac_dev,
-		tse_csroffs(mdio_phy1_addr));
+	csrwr32((mii_id & 0x1f), priv->mac_dev,	tse_csroffs(mdio_phy0_addr));
 
 	/* get the data */
 	return csrrd32(priv->mac_dev,
-		       tse_csroffs(mdio_phy1) + regnum * 4) & 0xffff;
+		       tse_csroffs(mdio_phy0) + regnum * 4) & 0xffff;
 }
 
 static int altera_tse_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
@@ -141,11 +147,10 @@ static int altera_tse_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	struct altera_tse_private *priv = netdev_priv(ndev);
 
 	/* set MDIO address */
-	csrwr32((mii_id & 0x1f), priv->mac_dev,
-		tse_csroffs(mdio_phy1_addr));
-
+	csrwr32((mii_id & 0x1f), priv->mac_dev,	tse_csroffs(mdio_phy0_addr));
 	/* write the data */
-	csrwr32(value, priv->mac_dev, tse_csroffs(mdio_phy1) + regnum * 4);
+	csrwr32(value, priv->mac_dev, tse_csroffs(mdio_phy0) + regnum * 4);
+
 	return 0;
 }
 
@@ -626,117 +631,6 @@ static int tse_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return ret;
 }
 
-/* Called every time the controller might need to be made
- * aware of new link state.  The PHY code conveys this
- * information through variables in the phydev structure, and this
- * function converts those variables into the appropriate
- * register values, and can bring down the device if needed.
- */
-static void altera_tse_adjust_link(struct net_device *dev)
-{
-	struct altera_tse_private *priv = netdev_priv(dev);
-	struct phy_device *phydev = dev->phydev;
-	int new_state = 0;
-
-	/* only change config if there is a link */
-	spin_lock(&priv->mac_cfg_lock);
-	if (phydev->link) {
-		/* Read old config */
-		u32 cfg_reg = ioread32(&priv->mac_dev->command_config);
-
-		/* Check duplex */
-		if (phydev->duplex != priv->oldduplex) {
-			new_state = 1;
-			if (!(phydev->duplex))
-				cfg_reg |= MAC_CMDCFG_HD_ENA;
-			else
-				cfg_reg &= ~MAC_CMDCFG_HD_ENA;
-
-			netdev_dbg(priv->dev, "%s: Link duplex = 0x%x\n",
-				   dev->name, phydev->duplex);
-
-			priv->oldduplex = phydev->duplex;
-		}
-
-		/* Check speed */
-		if (phydev->speed != priv->oldspeed) {
-			new_state = 1;
-			switch (phydev->speed) {
-			case 1000:
-				cfg_reg |= MAC_CMDCFG_ETH_SPEED;
-				cfg_reg &= ~MAC_CMDCFG_ENA_10;
-				break;
-			case 100:
-				cfg_reg &= ~MAC_CMDCFG_ETH_SPEED;
-				cfg_reg &= ~MAC_CMDCFG_ENA_10;
-				break;
-			case 10:
-				cfg_reg &= ~MAC_CMDCFG_ETH_SPEED;
-				cfg_reg |= MAC_CMDCFG_ENA_10;
-				break;
-			default:
-				if (netif_msg_link(priv))
-					netdev_warn(dev, "Speed (%d) is not 10/100/1000!\n",
-						    phydev->speed);
-				break;
-			}
-			priv->oldspeed = phydev->speed;
-		}
-		iowrite32(cfg_reg, &priv->mac_dev->command_config);
-
-		if (!priv->oldlink) {
-			new_state = 1;
-			priv->oldlink = 1;
-		}
-	} else if (priv->oldlink) {
-		new_state = 1;
-		priv->oldlink = 0;
-		priv->oldspeed = 0;
-		priv->oldduplex = -1;
-	}
-
-	if (new_state && netif_msg_link(priv))
-		phy_print_status(phydev);
-
-	spin_unlock(&priv->mac_cfg_lock);
-}
-static struct phy_device *connect_local_phy(struct net_device *dev)
-{
-	struct altera_tse_private *priv = netdev_priv(dev);
-	struct phy_device *phydev = NULL;
-	char phy_id_fmt[MII_BUS_ID_SIZE + 3];
-
-	if (priv->phy_addr != POLL_PHY) {
-		snprintf(phy_id_fmt, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
-			 priv->mdio->id, priv->phy_addr);
-
-		netdev_dbg(dev, "trying to attach to %s\n", phy_id_fmt);
-
-		phydev = phy_connect(dev, phy_id_fmt, &altera_tse_adjust_link,
-				     priv->phy_iface);
-		if (IS_ERR(phydev)) {
-			netdev_err(dev, "Could not attach to PHY\n");
-			phydev = NULL;
-		}
-
-	} else {
-		int ret;
-		phydev = phy_find_first(priv->mdio);
-		if (phydev == NULL) {
-			netdev_err(dev, "No PHY found\n");
-			return phydev;
-		}
-
-		ret = phy_connect_direct(dev, phydev, &altera_tse_adjust_link,
-				priv->phy_iface);
-		if (ret != 0) {
-			netdev_err(dev, "Could not attach to PHY\n");
-			phydev = NULL;
-		}
-	}
-	return phydev;
-}
-
 static int altera_tse_phy_get_addr_mdio_create(struct net_device *dev)
 {
 	struct altera_tse_private *priv = netdev_priv(dev);
@@ -746,8 +640,10 @@ static int altera_tse_phy_get_addr_mdio_create(struct net_device *dev)
 	priv->phy_iface = of_get_phy_mode(np);
 
 	/* Avoid get phy addr and create mdio if no phy is present */
-	if (!priv->phy_iface)
+	if (!priv->phy_iface) {
+		netdev_info(dev, "no PHY specified\n");
 		return 0;
+	}
 
 	/* try to get PHY address from device tree, use PHY autodetection if
 	 * no valid address is given
@@ -766,8 +662,7 @@ static int altera_tse_phy_get_addr_mdio_create(struct net_device *dev)
 	}
 
 	/* Create/attach to MDIO bus */
-	ret = altera_tse_mdio_create(dev,
-					 atomic_add_return(1, &instance_count));
+	ret = altera_tse_mdio_create(dev, atomic_add_return(1, &instance_count));
 
 	if (ret)
 		return -ENODEV;
@@ -775,94 +670,6 @@ static int altera_tse_phy_get_addr_mdio_create(struct net_device *dev)
 	return 0;
 }
 
-/* Initialize driver's PHY state, and attach to the PHY
- */
-static int init_phy(struct net_device *dev)
-{
-	struct altera_tse_private *priv = netdev_priv(dev);
-	struct phy_device *phydev;
-	struct device_node *phynode;
-	bool fixed_link = false;
-	int rc = 0;
-
-	/* Avoid init phy in case of no phy present */
-	if (!priv->phy_iface)
-		return 0;
-
-	priv->oldlink = 0;
-	priv->oldspeed = 0;
-	priv->oldduplex = -1;
-
-	phynode = of_parse_phandle(priv->device->of_node, "phy-handle", 0);
-
-	if (!phynode) {
-		/* check if a fixed-link is defined in device-tree */
-		if (of_phy_is_fixed_link(priv->device->of_node)) {
-			rc = of_phy_register_fixed_link(priv->device->of_node);
-			if (rc < 0) {
-				netdev_err(dev, "cannot register fixed PHY\n");
-				return rc;
-			}
-
-			/* In the case of a fixed PHY, the DT node associated
-			 * to the PHY is the Ethernet MAC DT node.
-			 */
-			phynode = of_node_get(priv->device->of_node);
-			fixed_link = true;
-
-			netdev_dbg(dev, "fixed-link detected\n");
-			phydev = of_phy_connect(dev, phynode,
-						&altera_tse_adjust_link,
-						0, priv->phy_iface);
-		} else {
-			netdev_dbg(dev, "no phy-handle found\n");
-			if (!priv->mdio) {
-				netdev_err(dev, "No phy-handle nor local mdio specified\n");
-				return -ENODEV;
-			}
-			phydev = connect_local_phy(dev);
-		}
-	} else {
-		netdev_dbg(dev, "phy-handle found\n");
-		phydev = of_phy_connect(dev, phynode,
-			&altera_tse_adjust_link, 0, priv->phy_iface);
-	}
-	of_node_put(phynode);
-
-	if (!phydev) {
-		netdev_err(dev, "Could not find the PHY\n");
-		if (fixed_link)
-			of_phy_deregister_fixed_link(priv->device->of_node);
-		return -ENODEV;
-	}
-
-	/* Stop Advertising 1000BASE Capability if interface is not GMII
-	 * Note: Checkpatch throws CHECKs for the camel case defines below,
-	 * it's ok to ignore.
-	 */
-	if ((priv->phy_iface == PHY_INTERFACE_MODE_MII) ||
-	    (priv->phy_iface == PHY_INTERFACE_MODE_RMII))
-		phydev->advertising &= ~(SUPPORTED_1000baseT_Half |
-					 SUPPORTED_1000baseT_Full);
-
-	/* Broken HW is sometimes missing the pull-up resistor on the
-	 * MDIO line, which results in reads to non-existent devices returning
-	 * 0 rather than 0xffff. Catch this here and treat 0 as a non-existent
-	 * device as well. If a fixed-link is used the phy_id is always 0.
-	 * Note: phydev->phy_id is the result of reading the UID PHY registers.
-	 */
-	if ((phydev->phy_id == 0) && !fixed_link) {
-		netdev_err(dev, "Bad PHY UID 0x%08x\n", phydev->phy_id);
-		phy_disconnect(phydev);
-		return -ENODEV;
-	}
-
-	netdev_dbg(dev, "attached to PHY %d UID 0x%08x Link = %d\n",
-		   phydev->mdio.addr, phydev->phy_id, phydev->link);
-
-	return 0;
-}
-
 static void tse_update_mac_addr(struct altera_tse_private *priv, u8 *addr)
 {
 	u32 msb;
@@ -1097,66 +904,6 @@ static void tse_set_rx_mode(struct net_device *dev)
 	spin_unlock(&priv->mac_cfg_lock);
 }
 
-/* Initialise (if necessary) the SGMII PCS component
- */
-static int init_sgmii_pcs(struct net_device *dev)
-{
-	struct altera_tse_private *priv = netdev_priv(dev);
-	int n;
-	unsigned int tmp_reg = 0;
-
-	if (priv->phy_iface != PHY_INTERFACE_MODE_SGMII)
-		return 0; /* Nothing to do, not in SGMII mode */
-
-	/* The TSE SGMII PCS block looks a little like a PHY, it is
-	 * mapped into the zeroth MDIO space of the MAC and it has
-	 * ID registers like a PHY would.  Sadly this is often
-	 * configured to zeroes, so don't be surprised if it does
-	 * show 0x00000000.
-	 */
-
-	if (sgmii_pcs_scratch_test(priv, 0x0000) &&
-		sgmii_pcs_scratch_test(priv, 0xffff) &&
-		sgmii_pcs_scratch_test(priv, 0xa5a5) &&
-		sgmii_pcs_scratch_test(priv, 0x5a5a)) {
-		netdev_info(dev, "PCS PHY ID: 0x%04x%04x\n",
-				sgmii_pcs_read(priv, MII_PHYSID1),
-				sgmii_pcs_read(priv, MII_PHYSID2));
-	} else {
-		netdev_err(dev, "SGMII PCS Scratch memory test failed.\n");
-		return -ENOMEM;
-	}
-
-	/* Starting on page 5-29 of the MegaCore Function User Guide
-	 * Set SGMII Link timer to 1.6ms
-	 */
-	sgmii_pcs_write(priv, SGMII_PCS_LINK_TIMER_0, 0x0D40);
-	sgmii_pcs_write(priv, SGMII_PCS_LINK_TIMER_1, 0x03);
-
-	/* Enable SGMII Interface and Enable SGMII Auto Negotiation */
-	sgmii_pcs_write(priv, SGMII_PCS_IF_MODE, 0x3);
-
-	/* Enable Autonegotiation */
-	tmp_reg = sgmii_pcs_read(priv, MII_BMCR);
-	tmp_reg |= (BMCR_SPEED1000 | BMCR_FULLDPLX | BMCR_ANENABLE);
-	sgmii_pcs_write(priv, MII_BMCR, tmp_reg);
-
-	/* Reset PCS block */
-	tmp_reg |= BMCR_RESET;
-	sgmii_pcs_write(priv, MII_BMCR, tmp_reg);
-	for (n = 0; n < SGMII_PCS_SW_RESET_TIMEOUT; n++) {
-		if (!(sgmii_pcs_read(priv, MII_BMCR) & BMCR_RESET)) {
-			netdev_info(dev, "SGMII PCS block initialised OK\n");
-			return 0;
-		}
-		udelay(1);
-	}
-
-	/* We failed to reset the block, return a timeout */
-	netdev_err(dev, "SGMII PCS block reset failed.\n");
-	return -ETIMEDOUT;
-}
-
 /* Open and initialize the interface
  */
 static int tse_open(struct net_device *dev)
@@ -1181,14 +928,6 @@ static int tse_open(struct net_device *dev)
 		netdev_warn(dev, "TSE revision %x\n", priv->revision);
 
 	spin_lock(&priv->mac_cfg_lock);
-	/* no-op if MAC not operating in SGMII mode*/
-	ret = init_sgmii_pcs(dev);
-	if (ret) {
-		netdev_err(dev,
-			   "Cannot init the SGMII PCS (error: %d)\n", ret);
-		spin_unlock(&priv->mac_cfg_lock);
-		goto phy_error;
-	}
 
 	ret = reset_mac(priv);
 	/* Note that reset_mac will fail if the clocks are gated by the PHY
@@ -1246,8 +985,12 @@ static int tse_open(struct net_device *dev)
 
 	spin_unlock_irqrestore(&priv->rxdma_irq_lock, flags);
 
-	if (dev->phydev)
-		phy_start(dev->phydev);
+	ret = phylink_of_phy_connect(priv->phylink, priv->device->of_node, 0);
+	if (ret) {
+		netdev_err(dev, "could not connect phylink (%d)\n", ret);
+		goto tx_request_irq_error;
+	}
+	phylink_start(priv->phylink);
 
 	napi_enable(&priv->napi);
 	netif_start_queue(dev);
@@ -1278,10 +1021,7 @@ static int tse_shutdown(struct net_device *dev)
 	int ret;
 	unsigned long int flags;
 
-	/* Stop the PHY */
-	if (dev->phydev)
-		phy_stop(dev->phydev);
-
+	phylink_stop(priv->phylink);
 	netif_stop_queue(dev);
 	napi_disable(&priv->napi);
 
@@ -1327,6 +1067,209 @@ static struct net_device_ops altera_tse_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
+static void alt_tse_validate(struct net_device *ndev, unsigned long *supported,
+			    struct phylink_link_state *state)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	/* We only support SGMII, 802.3z and RGMII modes */
+	if (state->interface != PHY_INTERFACE_MODE_NA &&
+	    state->interface != PHY_INTERFACE_MODE_SGMII &&
+	    !phy_interface_mode_is_8023z(state->interface) &&
+	    !phy_interface_mode_is_rgmii(state->interface)) {
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		return;
+	}
+
+	/* Allow all the expected bits */
+	phylink_set(mask, Autoneg);
+	phylink_set_port_modes(mask);
+
+	/* Asymmetric pause is unsupported */
+	phylink_set(mask, Pause);
+	/* Half-duplex at speeds higher than 100Mbit is unsupported */
+	phylink_set(mask, 1000baseT_Full);
+	phylink_set(mask, 1000baseX_Full);
+
+	if (!phy_interface_mode_is_8023z(state->interface)) {
+		/* 10M and 100M are only supported in non-802.3z mode */
+		phylink_set(mask, 10baseT_Half);
+		phylink_set(mask, 10baseT_Full);
+		phylink_set(mask, 100baseT_Half);
+		phylink_set(mask, 100baseT_Full);
+	}
+
+	bitmap_and(supported, supported, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static int alt_tse_mac_link_state(struct net_device *ndev,
+				 struct phylink_link_state *state)
+{
+	struct altera_tse_private *priv = netdev_priv(ndev);
+	u32 pa, stat, if_mode;
+
+	stat = sgmii_pcs_read(priv, PCS_STATUS_REG);
+	if_mode = sgmii_pcs_read(priv, SGMII_PCS_IF_MODE);
+	pa = sgmii_pcs_read(priv, PCS_PARTNER_ABILITY_REG);
+
+	state->an_complete = !!(stat & PCS_STATUS_AN_COMPLETE);
+	state->link = !!(stat & PCS_STATUS_LINK);
+	state->pause = MLO_PAUSE_NONE;
+
+	if (if_mode & PCS_IF_MODE_SGMII_ENA) {	// SGMII mode
+		if (pa & PCS_ABILITY_SGMII_COPPER_FD)
+			state->duplex = DUPLEX_FULL;
+		else
+			state->duplex = DUPLEX_HALF;
+		state->link = !!(pa & PCS_ABILITY_SGMII_COPPER_LINK_STATUS);
+
+		switch (pa & PCS_ABILITY_SGMII_COPPER_SPEED_MASK) {
+		case PCS_ABILITY_SGMI_SPEED_10:
+			state->speed = SPEED_10;
+			break;
+		case PCS_ABILITY_SGMI_SPEED_100:
+			state->speed = SPEED_100;
+			break;
+		case PCS_ABILITY_SGMI_SPEED_1000:
+			state->speed = SPEED_1000;
+			break;
+		default:
+			netdev_warn(ndev, "bad copper mode\n");
+		}
+	} else {	// 1000BASE-X mode
+		if (pa & PCS_ABILITY_1000BASEX_FD)
+			state->duplex = DUPLEX_FULL;
+		else
+			state->duplex = DUPLEX_HALF;
+
+		switch (pa & PCS_ABILITY_1000BASEX_PAUSE_MASK) {
+		case PCS_ABILITY_1000BASEX_PAUSE_SYM:
+			state->pause = MLO_PAUSE_SYM;
+			break;
+		case PCS_ABILITY_1000BASEX_PAUSE_ASYM:
+			state->pause = MLO_PAUSE_ASYM | MLO_PAUSE_TX;
+			break;
+		case PCS_ABILITY_1000BASEX_PAUSE_TXRX:
+			state->pause = MLO_PAUSE_TXRX_MASK;
+			break;
+		}
+
+		state->speed = SPEED_1000;
+	}
+
+	return 0;
+}
+
+static void alt_tse_mac_an_restart(struct net_device *ndev)
+{
+	struct altera_tse_private *priv = netdev_priv(ndev);
+	u32 ctrl;
+
+	ctrl = sgmii_pcs_read(priv, PCS_CTRL_REG);
+	ctrl |= (1 << 12) | (1 << 9);		// enable AN and restart it
+	sgmii_pcs_write(priv, PCS_CTRL_REG, ctrl);
+
+	sgmii_pcs_reset(priv);
+}
+
+static void alt_tse_pcs_config(struct net_device *ndev,
+			       const struct phylink_link_state *state)
+{
+	struct altera_tse_private *priv = netdev_priv(ndev);
+	u32 ctrl, if_mode;
+
+	ctrl = sgmii_pcs_read(priv, PCS_CTRL_REG);
+	if_mode = sgmii_pcs_read(priv, SGMII_PCS_IF_MODE);
+
+	sgmii_pcs_write(priv, SGMII_PCS_LINK_TIMER_0, 0x0D40);
+	sgmii_pcs_write(priv, SGMII_PCS_LINK_TIMER_1, 0x03);
+
+	if (state->interface == PHY_INTERFACE_MODE_SGMII) {
+		if_mode = PCS_IF_MODE_USE_SGMII_AN | PCS_IF_MODE_SGMII_ENA;
+		ctrl |= (BMCR_SPEED1000 | BMCR_FULLDPLX | BMCR_ANENABLE);
+	} else if (state->interface == PHY_INTERFACE_MODE_1000BASEX ) {
+		ctrl |= (BMCR_SPEED1000 | BMCR_FULLDPLX | BMCR_ANENABLE);
+		if_mode &= ~(PCS_IF_MODE_USE_SGMII_AN | PCS_IF_MODE_SGMII_ENA);
+		if_mode |= PCS_IF_MODE_SGMI_SPEED_1000;
+	}
+
+	sgmii_pcs_write(priv, PCS_CTRL_REG, ctrl);
+	sgmii_pcs_write(priv, SGMII_PCS_IF_MODE, if_mode);
+
+	sgmii_pcs_reset(priv);
+}
+
+static void alt_tse_mac_config(struct net_device *ndev, unsigned int mode,
+			       const struct phylink_link_state *state)
+{
+	struct altera_tse_private *priv = netdev_priv(ndev);
+	u32 ctrl;
+
+
+	ctrl = csrrd32(priv->mac_dev, tse_csroffs(command_config));
+	ctrl &= ~(MAC_CMDCFG_ENA_10 | MAC_CMDCFG_ETH_SPEED | MAC_CMDCFG_HD_ENA);
+
+	if (state->duplex == DUPLEX_HALF)
+		ctrl |= MAC_CMDCFG_HD_ENA;
+
+	if (state->interface == PHY_INTERFACE_MODE_SGMII) {
+		switch (state->speed) {
+		case SPEED_1000:
+			ctrl |= MAC_CMDCFG_ETH_SPEED;
+			break;
+		case SPEED_100:
+			break;
+		case SPEED_10:
+			ctrl |= MAC_CMDCFG_ENA_10;
+			break;
+		case SPEED_UNKNOWN:
+		case 0:
+			break;
+		default:
+			netdev_warn(ndev, "wrong speed");
+			return;
+		}
+	} else if (state->interface == PHY_INTERFACE_MODE_1000BASEX ) {
+		ctrl |= MAC_CMDCFG_ETH_SPEED;
+	} else {
+		netdev_warn(ndev, "wrong mode");
+		return;
+	}
+
+	alt_tse_pcs_config(ndev, state);
+
+	spin_lock(&priv->mac_cfg_lock);
+	csrwr32(ctrl, priv->mac_dev, tse_csroffs(command_config));
+	reset_mac(priv);
+	tse_set_mac(priv, true);
+	spin_unlock(&priv->mac_cfg_lock);
+}
+
+static void alt_tse_mac_link_down(struct net_device *ndev, unsigned int mode,
+				 phy_interface_t interface)
+{
+	netdev_info(ndev, "%s\n", __func__);
+}
+
+static void alt_tse_mac_link_up(struct net_device *ndev, unsigned int mode,
+			       phy_interface_t interface,
+			       struct phy_device *phy)
+{
+	netdev_info(ndev, "%s\n", __func__);
+}
+
+static const struct phylink_mac_ops alt_tse_phylink_ops = {
+	.validate = alt_tse_validate,
+	.mac_link_state = alt_tse_mac_link_state,
+	.mac_an_restart = alt_tse_mac_an_restart,
+	.mac_config = alt_tse_mac_config,
+	.mac_link_down = alt_tse_mac_link_down,
+	.mac_link_up = alt_tse_mac_link_up,
+};
+
 static int request_and_map(struct platform_device *pdev, const char *name,
 			   struct resource **res, void __iomem **ptr)
 {
@@ -1364,6 +1307,7 @@ static int altera_tse_probe(struct platform_device *pdev)
 	int ret = -ENODEV;
 	struct resource *control_port;
 	struct resource *dma_res;
+	struct resource *pcs;
 	struct altera_tse_private *priv;
 	const unsigned char *macaddr;
 	void __iomem *descmap;
@@ -1475,6 +1419,11 @@ static int altera_tse_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_free_netdev;
 
+	/* PCS address space */
+	ret = request_and_map(pdev, "pcs", &pcs, &priv->pcs.iomem);
+	if (ret)
+		goto err_free_netdev;
+
 
 	/* Rx IRQ */
 	priv->rx_irq = platform_get_irq_byname(pdev, "rx_irq");
@@ -1600,11 +1549,13 @@ static int altera_tse_probe(struct platform_device *pdev)
 			 (unsigned long) control_port->start, priv->rx_irq,
 			 priv->tx_irq);
 
-	ret = init_phy(ndev);
-	if (ret != 0) {
-		netdev_err(ndev, "Cannot attach to PHY (error: %d)\n", ret);
+	priv->phylink = phylink_create(ndev, of_fwnode_handle(priv->device->of_node),
+				       priv->phy_iface, &alt_tse_phylink_ops);
+	if (IS_ERR(priv->phylink)) {
+		dev_err(&pdev->dev, "failed to create phylink\n");
 		goto err_init_phy;
 	}
+
 	return 0;
 
 err_init_phy:
@@ -1624,16 +1575,10 @@ static int altera_tse_remove(struct platform_device *pdev)
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct altera_tse_private *priv = netdev_priv(ndev);
 
-	if (ndev->phydev) {
-		phy_disconnect(ndev->phydev);
-
-		if (of_phy_is_fixed_link(priv->device->of_node))
-			of_phy_deregister_fixed_link(priv->device->of_node);
-	}
-
 	platform_set_drvdata(pdev, NULL);
 	altera_tse_mdio_destroy(ndev);
 	unregister_netdev(ndev);
+	phylink_destroy(priv->phylink);
 	free_netdev(ndev);
 
 	return 0;
-- 
2.28.0


--BOKacYhQ+x31HxR3
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-add-PHYLINK-dependency.patch"

From c7449fac3bbdf2f76c4aa5a24986e84f02a487db Mon Sep 17 00:00:00 2001
From: Petko Manolov <petko.manolov@konsulko.com>
Date: Fri, 25 Oct 2019 12:34:21 +0300
Subject: [PATCH 2/2] add PHYLINK dependency

Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>
---
 drivers/net/ethernet/altera/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/altera/Kconfig b/drivers/net/ethernet/altera/Kconfig
index fdddba51473e..6c75b0de8998 100644
--- a/drivers/net/ethernet/altera/Kconfig
+++ b/drivers/net/ethernet/altera/Kconfig
@@ -2,6 +2,7 @@ config ALTERA_TSE
 	tristate "Altera Triple-Speed Ethernet MAC support"
 	depends on HAS_DMA
 	select PHYLIB
+	select PHYLINK
 	---help---
 	  This driver supports the Altera Triple-Speed (TSE) Ethernet MAC.
 
-- 
2.28.0


--BOKacYhQ+x31HxR3--
