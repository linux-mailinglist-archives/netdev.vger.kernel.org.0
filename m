Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC27E355833
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 17:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345808AbhDFPh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 11:37:57 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:33299 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242528AbhDFPhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 11:37:52 -0400
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 72B042224D;
        Tue,  6 Apr 2021 17:37:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1617723461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qy26WmHeyrVWj0mOxJsJU0yit4VboI/+RdU+hmJ8x3A=;
        b=J3TbzMOYj/OPBKbP3PIoJ0uyZG2Io/6dVLzxNOAdbHAc4rQFDYHLRdCZenSQXotS1dQF28
        qwDueay3oU+AkwyXmgwTFsi+Awz+uPQQUwX0bai4euLv+EOAULhAyoeL5ch83CfrG8KVia
        E1ZJDQPog9wl4ng04Hz3bqt/4J8pc0U=
From:   Michael Walle <michael@walle.cc>
To:     ath9k-devel@qca.qualcomm.com, UNGLinuxDriver@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-amlogic@lists.infradead.org, linux-oxnas@groups.io,
        linux-omap@vger.kernel.org, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org, linux-staging@lists.linux.dev
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Andreas Larsson <andreas@gaisler.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Chris Snook <chris.snook@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        bcm-kernel-feedback-list@broadcom.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Li Yang <leoyang.li@nxp.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Byungho An <bh74.an@samsung.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Wingman Kwok <w-kwok2@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 1/2] of: net: pass the dst buffer to of_get_mac_address()
Date:   Tue,  6 Apr 2021 17:37:24 +0200
Message-Id: <20210406153725.10059-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210406153725.10059-1-michael@walle.cc>
References: <20210406153725.10059-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

of_get_mac_address() returns a "const void*" pointer to a MAC address.
Lately, support to fetch the MAC address by an NVMEM provider was added.
But this will only work with platform devices. It will not work with
PCI devices (e.g. of an integrated root complex) and esp. not with DSA
ports.

There is an of_* variant of the nvmem binding which works without
devices. The returned data of a nvmem_cell_read() has to be freed after
use. On the other hand the return of_get_mac_address() points to some
static data without a lifetime. The trick for now, was to allocate a
device resource managed buffer which is then returned. This will only
work if we have an actual device.

Change it, so that the caller of of_get_mac_address() has to supply a
buffer where the MAC address is written to. Unfortunately, this will
touch all drivers which use the of_get_mac_address().

Usually the code looks like:

  const char *addr;
  addr = of_get_mac_address(np);
  if (!IS_ERR(addr))
    ether_addr_copy(ndev->dev_addr, addr);

This can then be simply rewritten as:

  of_get_mac_address(np, ndev->dev_addr);

Sometimes is_valid_ether_addr() is used to test the MAC address.
of_get_mac_address() already makes sure, it just returns a valid MAC
address. Thus we can just test its return code. But we have to be
careful if there are still other sources for the MAC address before the
of_get_mac_address(). In this case we have to keep the
is_valid_ether_addr() call.

The following coccinelle patch was used to convert common cases to the
new style. Afterwards, I've manually gone over the drivers and fixed the
return code variable: either used a new one or if one was already
available use that. Mansour Moufid, thanks for that coccinelle patch!

<spml>
@a@
identifier x;
expression y, z;
@@
- x = of_get_mac_address(y);
+ x = of_get_mac_address(y, z);
  <...
- ether_addr_copy(z, x);
  ...>

@@
identifier a.x;
@@
- if (<+... x ...+>) {}

@@
identifier a.x;
@@
  if (<+... x ...+>) {
      ...
  }
- else {}

@@
identifier a.x;
expression e;
@@
- if (<+... x ...+>@e)
-     {}
- else
+ if (!(e))
      {...}

@@
expression x, y, z;
@@
- x = of_get_mac_address(y, z);
+ of_get_mac_address(y, z);
  ... when != x
</spml>

All drivers, except drivers/net/ethernet/aeroflex/greth.c, were
compile-time tested.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 arch/arm/mach-mvebu/kirkwood.c                |  3 +-
 arch/powerpc/sysdev/tsi108_dev.c              |  5 +-
 drivers/net/ethernet/aeroflex/greth.c         |  6 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c   | 10 +---
 drivers/net/ethernet/altera/altera_tse_main.c |  7 +--
 drivers/net/ethernet/arc/emac_main.c          |  8 +--
 drivers/net/ethernet/atheros/ag71xx.c         |  7 +--
 drivers/net/ethernet/broadcom/bcm4908_enet.c  |  7 +--
 drivers/net/ethernet/broadcom/bcmsysport.c    |  7 +--
 drivers/net/ethernet/broadcom/bgmac-bcma.c    | 10 ++--
 .../net/ethernet/broadcom/bgmac-platform.c    | 11 ++--
 drivers/net/ethernet/cadence/macb_main.c      | 11 +---
 .../net/ethernet/cavium/octeon/octeon_mgmt.c  |  8 +--
 .../net/ethernet/cavium/thunder/thunder_bgx.c |  5 +-
 drivers/net/ethernet/davicom/dm9000.c         | 10 ++--
 drivers/net/ethernet/ethoc.c                  |  6 +-
 drivers/net/ethernet/ezchip/nps_enet.c        |  7 +--
 drivers/net/ethernet/freescale/fec_main.c     |  7 ++-
 drivers/net/ethernet/freescale/fec_mpc52xx.c  |  7 +--
 drivers/net/ethernet/freescale/fman/mac.c     |  9 +--
 .../ethernet/freescale/fs_enet/fs_enet-main.c |  5 +-
 drivers/net/ethernet/freescale/gianfar.c      |  8 +--
 drivers/net/ethernet/freescale/ucc_geth.c     |  5 +-
 drivers/net/ethernet/hisilicon/hisi_femac.c   |  7 +--
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |  7 +--
 drivers/net/ethernet/lantiq_xrx200.c          |  7 +--
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  5 +-
 drivers/net/ethernet/marvell/mvneta.c         |  6 +-
 .../ethernet/marvell/prestera/prestera_main.c | 11 ++--
 drivers/net/ethernet/marvell/pxa168_eth.c     |  9 +--
 drivers/net/ethernet/marvell/sky2.c           |  8 +--
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   | 11 ++--
 drivers/net/ethernet/micrel/ks8851_common.c   |  7 +--
 drivers/net/ethernet/microchip/lan743x_main.c |  5 +-
 drivers/net/ethernet/nxp/lpc_eth.c            |  4 +-
 drivers/net/ethernet/qualcomm/qca_spi.c       | 10 +---
 drivers/net/ethernet/qualcomm/qca_uart.c      |  9 +--
 drivers/net/ethernet/renesas/ravb_main.c      | 12 ++--
 drivers/net/ethernet/renesas/sh_eth.c         |  5 +-
 .../ethernet/samsung/sxgbe/sxgbe_platform.c   | 13 ++--
 drivers/net/ethernet/socionext/sni_ave.c      | 10 +---
 .../ethernet/stmicro/stmmac/dwmac-anarion.c   |  2 +-
 .../stmicro/stmmac/dwmac-dwc-qos-eth.c        |  2 +-
 .../ethernet/stmicro/stmmac/dwmac-generic.c   |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   |  2 +-
 .../stmicro/stmmac/dwmac-intel-plat.c         |  2 +-
 .../ethernet/stmicro/stmmac/dwmac-ipq806x.c   |  2 +-
 .../ethernet/stmicro/stmmac/dwmac-lpc18xx.c   |  2 +-
 .../ethernet/stmicro/stmmac/dwmac-mediatek.c  |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-meson.c |  2 +-
 .../ethernet/stmicro/stmmac/dwmac-meson8b.c   |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-oxnas.c |  2 +-
 .../stmicro/stmmac/dwmac-qcom-ethqos.c        |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    |  2 +-
 .../ethernet/stmicro/stmmac/dwmac-socfpga.c   |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-sti.c   |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-stm32.c |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-sunxi.c |  2 +-
 .../ethernet/stmicro/stmmac/dwmac-visconti.c  |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  4 +-
 .../ethernet/stmicro/stmmac/stmmac_platform.c | 14 ++---
 .../ethernet/stmicro/stmmac/stmmac_platform.h |  2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      | 19 +++---
 drivers/net/ethernet/ti/cpsw.c                |  7 +--
 drivers/net/ethernet/ti/cpsw_new.c            |  7 +--
 drivers/net/ethernet/ti/davinci_emac.c        |  8 +--
 drivers/net/ethernet/ti/netcp_core.c          |  7 +--
 drivers/net/ethernet/wiznet/w5100-spi.c       |  8 ++-
 drivers/net/ethernet/wiznet/w5100.c           |  2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   |  6 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 11 ++--
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |  8 +--
 drivers/net/wireless/ath/ath9k/init.c         |  5 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c   |  9 +--
 .../net/wireless/ralink/rt2x00/rt2x00dev.c    |  6 +-
 drivers/of/of_net.c                           | 60 +++++++++----------
 drivers/staging/octeon/ethernet.c             | 10 +---
 drivers/staging/wfx/main.c                    |  7 +--
 include/linux/of_net.h                        |  6 +-
 include/net/dsa.h                             |  2 +-
 net/dsa/dsa2.c                                |  2 +-
 net/dsa/slave.c                               |  2 +-
 net/ethernet/eth.c                            | 11 ++--
 85 files changed, 216 insertions(+), 362 deletions(-)

diff --git a/arch/arm/mach-mvebu/kirkwood.c b/arch/arm/mach-mvebu/kirkwood.c
index ceaad6d5927e..06b1706595f4 100644
--- a/arch/arm/mach-mvebu/kirkwood.c
+++ b/arch/arm/mach-mvebu/kirkwood.c
@@ -84,6 +84,7 @@ static void __init kirkwood_dt_eth_fixup(void)
 		struct device_node *pnp = of_get_parent(np);
 		struct clk *clk;
 		struct property *pmac;
+		u8 tmpmac[ETH_ALEN];
 		void __iomem *io;
 		u8 *macaddr;
 		u32 reg;
@@ -93,7 +94,7 @@ static void __init kirkwood_dt_eth_fixup(void)
 
 		/* skip disabled nodes or nodes with valid MAC address*/
 		if (!of_device_is_available(pnp) ||
-		    !IS_ERR(of_get_mac_address(np)))
+		    !of_get_mac_address(np, tmpmac))
 			goto eth_fixup_skip;
 
 		clk = of_clk_get(pnp, 0);
diff --git a/arch/powerpc/sysdev/tsi108_dev.c b/arch/powerpc/sysdev/tsi108_dev.c
index 0baec82510b9..4c4a6efd5e5f 100644
--- a/arch/powerpc/sysdev/tsi108_dev.c
+++ b/arch/powerpc/sysdev/tsi108_dev.c
@@ -73,7 +73,6 @@ static int __init tsi108_eth_of_init(void)
 		struct device_node *phy, *mdio;
 		hw_info tsi_eth_data;
 		const unsigned int *phy_id;
-		const void *mac_addr;
 		const phandle *ph;
 
 		memset(r, 0, sizeof(r));
@@ -101,9 +100,7 @@ static int __init tsi108_eth_of_init(void)
 			goto err;
 		}
 
-		mac_addr = of_get_mac_address(np);
-		if (!IS_ERR(mac_addr))
-			ether_addr_copy(tsi_eth_data.mac_addr, mac_addr);
+		of_get_mac_address(np, tsi_eth_data.mac_addr);
 
 		ph = of_get_property(np, "mdio-handle", NULL);
 		mdio = of_find_node_by_phandle(*ph);
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 9c5891bbfe61..d77fafbc1530 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1449,10 +1449,10 @@ static int greth_of_probe(struct platform_device *ofdev)
 			break;
 	}
 	if (i == 6) {
-		const u8 *addr;
+		u8 addr[ETH_ALEN];
 
-		addr = of_get_mac_address(ofdev->dev.of_node);
-		if (!IS_ERR(addr)) {
+		err = of_get_mac_address(ofdev->dev.of_node, addr);
+		if (!err) {
 			for (i = 0; i < 6; i++)
 				macaddr[i] = (unsigned int) addr[i];
 		} else {
diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 5ed80d9a6b9f..f99ae317c188 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -790,7 +790,6 @@ static int emac_probe(struct platform_device *pdev)
 	struct emac_board_info *db;
 	struct net_device *ndev;
 	int ret = 0;
-	const char *mac_addr;
 
 	ndev = alloc_etherdev(sizeof(struct emac_board_info));
 	if (!ndev) {
@@ -853,12 +852,9 @@ static int emac_probe(struct platform_device *pdev)
 	}
 
 	/* Read MAC-address from DT */
-	mac_addr = of_get_mac_address(np);
-	if (!IS_ERR(mac_addr))
-		ether_addr_copy(ndev->dev_addr, mac_addr);
-
-	/* Check if the MAC address is valid, if not get a random one */
-	if (!is_valid_ether_addr(ndev->dev_addr)) {
+	ret = of_get_mac_address(np, ndev->dev_addr);
+	if (ret) {
+		/* if the MAC address is invalid get a random one */
 		eth_hw_addr_random(ndev);
 		dev_warn(&pdev->dev, "using random MAC address %pM\n",
 			 ndev->dev_addr);
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 907125abef2c..1c00d719e5d7 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1351,7 +1351,6 @@ static int altera_tse_probe(struct platform_device *pdev)
 	struct resource *control_port;
 	struct resource *dma_res;
 	struct altera_tse_private *priv;
-	const unsigned char *macaddr;
 	void __iomem *descmap;
 	const struct of_device_id *of_id = NULL;
 
@@ -1525,10 +1524,8 @@ static int altera_tse_probe(struct platform_device *pdev)
 	priv->rx_dma_buf_sz = ALTERA_RXDMABUFFER_SIZE;
 
 	/* get default MAC address from device tree */
-	macaddr = of_get_mac_address(pdev->dev.of_node);
-	if (!IS_ERR(macaddr))
-		ether_addr_copy(ndev->dev_addr, macaddr);
-	else
+	ret = of_get_mac_address(pdev->dev.of_node, ndev->dev_addr);
+	if (ret)
 		eth_hw_addr_random(ndev);
 
 	/* get phy addr and create mdio */
diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
index b56a9e2aecd9..67b8113a2b53 100644
--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -857,7 +857,6 @@ int arc_emac_probe(struct net_device *ndev, int interface)
 	struct device_node *phy_node;
 	struct phy_device *phydev = NULL;
 	struct arc_emac_priv *priv;
-	const char *mac_addr;
 	unsigned int id, clock_frequency, irq;
 	int err;
 
@@ -942,11 +941,8 @@ int arc_emac_probe(struct net_device *ndev, int interface)
 	}
 
 	/* Get MAC address from device tree */
-	mac_addr = of_get_mac_address(dev->of_node);
-
-	if (!IS_ERR(mac_addr))
-		ether_addr_copy(ndev->dev_addr, mac_addr);
-	else
+	err = of_get_mac_address(dev->of_node, ndev->dev_addr);
+	if (err)
 		eth_hw_addr_random(ndev);
 
 	arc_emac_set_address_internal(ndev);
diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index a60ce9030581..dc716156d87d 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1856,7 +1856,6 @@ static int ag71xx_probe(struct platform_device *pdev)
 	const struct ag71xx_dcfg *dcfg;
 	struct net_device *ndev;
 	struct resource *res;
-	const void *mac_addr;
 	int tx_size, err, i;
 	struct ag71xx *ag;
 
@@ -1957,10 +1956,8 @@ static int ag71xx_probe(struct platform_device *pdev)
 	ag->stop_desc->ctrl = 0;
 	ag->stop_desc->next = (u32)ag->stop_desc_dma;
 
-	mac_addr = of_get_mac_address(np);
-	if (!IS_ERR(mac_addr))
-		memcpy(ndev->dev_addr, mac_addr, ETH_ALEN);
-	if (IS_ERR(mac_addr) || !is_valid_ether_addr(ndev->dev_addr)) {
+	err = of_get_mac_address(np, ndev->dev_addr);
+	if (err) {
 		netif_err(ag, probe, ndev, "invalid MAC address, using random address\n");
 		eth_random_addr(ndev->dev_addr);
 	}
diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index cbfed1d1477b..12945d754ebb 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -685,7 +685,6 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct net_device *netdev;
 	struct bcm4908_enet *enet;
-	const u8 *mac;
 	int err;
 
 	netdev = devm_alloc_etherdev(dev, sizeof(*enet));
@@ -715,10 +714,8 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
 		return err;
 
 	SET_NETDEV_DEV(netdev, &pdev->dev);
-	mac = of_get_mac_address(dev->of_node);
-	if (!IS_ERR(mac))
-		ether_addr_copy(netdev->dev_addr, mac);
-	else
+	err = of_get_mac_address(dev->of_node, netdev->dev_addr);
+	if (err)
 		eth_hw_addr_random(netdev);
 	netdev->netdev_ops = &bcm4908_enet_netdev_ops;
 	netdev->min_mtu = ETH_ZLEN;
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 777bbf6d2586..d9f0f0df8f7b 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2457,7 +2457,6 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	struct bcm_sysport_priv *priv;
 	struct device_node *dn;
 	struct net_device *dev;
-	const void *macaddr;
 	u32 txq, rxq;
 	int ret;
 
@@ -2552,12 +2551,10 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize netdevice members */
-	macaddr = of_get_mac_address(dn);
-	if (IS_ERR(macaddr)) {
+	ret = of_get_mac_address(dn, dev->dev_addr);
+	if (ret) {
 		dev_warn(&pdev->dev, "using random Ethernet MAC\n");
 		eth_hw_addr_random(dev);
-	} else {
-		ether_addr_copy(dev->dev_addr, macaddr);
 	}
 
 	SET_NETDEV_DEV(dev, &pdev->dev);
diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma.c b/drivers/net/ethernet/broadcom/bgmac-bcma.c
index a5fd161ab5ee..85fa0ab7201c 100644
--- a/drivers/net/ethernet/broadcom/bgmac-bcma.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma.c
@@ -115,7 +115,7 @@ static int bgmac_probe(struct bcma_device *core)
 	struct ssb_sprom *sprom = &core->bus->sprom;
 	struct mii_bus *mii_bus;
 	struct bgmac *bgmac;
-	const u8 *mac = NULL;
+	const u8 *mac;
 	int err;
 
 	bgmac = bgmac_alloc(&core->dev);
@@ -128,11 +128,10 @@ static int bgmac_probe(struct bcma_device *core)
 
 	bcma_set_drvdata(core, bgmac);
 
-	if (bgmac->dev->of_node)
-		mac = of_get_mac_address(bgmac->dev->of_node);
+	err = of_get_mac_address(bgmac->dev->of_node, bgmac->net_dev->dev_addr);
 
 	/* If no MAC address assigned via device tree, check SPROM */
-	if (IS_ERR_OR_NULL(mac)) {
+	if (err) {
 		switch (core->core_unit) {
 		case 0:
 			mac = sprom->et0mac;
@@ -149,10 +148,9 @@ static int bgmac_probe(struct bcma_device *core)
 			err = -ENOTSUPP;
 			goto err;
 		}
+		ether_addr_copy(bgmac->net_dev->dev_addr, mac);
 	}
 
-	ether_addr_copy(bgmac->net_dev->dev_addr, mac);
-
 	/* On BCM4706 we need common core to access PHY */
 	if (core->id.id == BCMA_CORE_4706_MAC_GBIT &&
 	    !core->bus->drv_gmac_cmn.core) {
diff --git a/drivers/net/ethernet/broadcom/bgmac-platform.c b/drivers/net/ethernet/broadcom/bgmac-platform.c
index f37f1c58f368..9834b77cf4b6 100644
--- a/drivers/net/ethernet/broadcom/bgmac-platform.c
+++ b/drivers/net/ethernet/broadcom/bgmac-platform.c
@@ -173,7 +173,7 @@ static int bgmac_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct bgmac *bgmac;
 	struct resource *regs;
-	const u8 *mac_addr;
+	int ret;
 
 	bgmac = bgmac_alloc(&pdev->dev);
 	if (!bgmac)
@@ -192,11 +192,10 @@ static int bgmac_probe(struct platform_device *pdev)
 	bgmac->dev = &pdev->dev;
 	bgmac->dma_dev = &pdev->dev;
 
-	mac_addr = of_get_mac_address(np);
-	if (!IS_ERR(mac_addr))
-		ether_addr_copy(bgmac->net_dev->dev_addr, mac_addr);
-	else
-		dev_warn(&pdev->dev, "MAC address not present in device tree\n");
+	ret = of_get_mac_address(np, bgmac->net_dev->dev_addr);
+	if (ret)
+		dev_warn(&pdev->dev,
+			 "MAC address not present in device tree\n");
 
 	bgmac->irq = platform_get_irq(pdev, 0);
 	if (bgmac->irq < 0)
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index f56f3dbbc015..480ea7f5f6fc 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4642,7 +4642,6 @@ static int macb_probe(struct platform_device *pdev)
 	struct net_device *dev;
 	struct resource *regs;
 	void __iomem *mem;
-	const char *mac;
 	struct macb *bp;
 	int err, val;
 
@@ -4757,15 +4756,11 @@ static int macb_probe(struct platform_device *pdev)
 	if (bp->caps & MACB_CAPS_NEEDS_RSTONUBR)
 		bp->rx_intr_mask |= MACB_BIT(RXUBR);
 
-	mac = of_get_mac_address(np);
-	if (PTR_ERR(mac) == -EPROBE_DEFER) {
-		err = -EPROBE_DEFER;
+	err = of_get_mac_address(np, bp->dev->dev_addr);
+	if (err == -EPROBE_DEFER)
 		goto err_out_free_netdev;
-	} else if (!IS_ERR_OR_NULL(mac)) {
-		ether_addr_copy(bp->dev->dev_addr, mac);
-	} else {
+	else if (err)
 		macb_get_hwaddr(bp);
-	}
 
 	err = of_get_phy_mode(np, &interface);
 	if (err)
diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index ecffebd513be..48ff6fb0eed9 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -1385,7 +1385,6 @@ static int octeon_mgmt_probe(struct platform_device *pdev)
 	struct net_device *netdev;
 	struct octeon_mgmt *p;
 	const __be32 *data;
-	const u8 *mac;
 	struct resource *res_mix;
 	struct resource *res_agl;
 	struct resource *res_agl_prt_ctl;
@@ -1502,11 +1501,8 @@ static int octeon_mgmt_probe(struct platform_device *pdev)
 	netdev->min_mtu = 64 - OCTEON_MGMT_RX_HEADROOM;
 	netdev->max_mtu = 16383 - OCTEON_MGMT_RX_HEADROOM - VLAN_HLEN;
 
-	mac = of_get_mac_address(pdev->dev.of_node);
-
-	if (!IS_ERR(mac))
-		ether_addr_copy(netdev->dev_addr, mac);
-	else
+	result = of_get_mac_address(pdev->dev.of_node, netdev->dev_addr);
+	if (result)
 		eth_hw_addr_random(netdev);
 
 	p->phy_np = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
index 8ff28ed04b7f..0c783aadf393 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1474,7 +1474,6 @@ static int bgx_init_of_phy(struct bgx *bgx)
 	device_for_each_child_node(&bgx->pdev->dev, fwn) {
 		struct phy_device *pd;
 		struct device_node *phy_np;
-		const char *mac;
 
 		/* Should always be an OF node.  But if it is not, we
 		 * cannot handle it, so exit the loop.
@@ -1483,9 +1482,7 @@ static int bgx_init_of_phy(struct bgx *bgx)
 		if (!node)
 			break;
 
-		mac = of_get_mac_address(node);
-		if (!IS_ERR(mac))
-			ether_addr_copy(bgx->lmac[lmac].mac, mac);
+		of_get_mac_address(node, bgx->lmac[lmac].mac);
 
 		SET_NETDEV_DEV(&bgx->lmac[lmac].netdev, &bgx->pdev->dev);
 		bgx->lmac[lmac].lmacid = lmac;
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 252adfa5d837..2374c51bf2b2 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1385,7 +1385,7 @@ static struct dm9000_plat_data *dm9000_parse_dt(struct device *dev)
 {
 	struct dm9000_plat_data *pdata;
 	struct device_node *np = dev->of_node;
-	const void *mac_addr;
+	int ret;
 
 	if (!IS_ENABLED(CONFIG_OF) || !np)
 		return ERR_PTR(-ENXIO);
@@ -1399,11 +1399,9 @@ static struct dm9000_plat_data *dm9000_parse_dt(struct device *dev)
 	if (of_find_property(np, "davicom,no-eeprom", NULL))
 		pdata->flags |= DM9000_PLATF_NO_EEPROM;
 
-	mac_addr = of_get_mac_address(np);
-	if (!IS_ERR(mac_addr))
-		ether_addr_copy(pdata->dev_addr, mac_addr);
-	else if (PTR_ERR(mac_addr) == -EPROBE_DEFER)
-		return ERR_CAST(mac_addr);
+	ret = of_get_mac_address(np, pdata->dev_addr);
+	if (ret == -EPROBE_DEFER)
+		return ERR_PTR(ret);
 
 	return pdata;
 }
diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index 3d9b0b161e24..e1b43b07755b 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -1151,11 +1151,7 @@ static int ethoc_probe(struct platform_device *pdev)
 		ether_addr_copy(netdev->dev_addr, pdata->hwaddr);
 		priv->phy_id = pdata->phy_id;
 	} else {
-		const void *mac;
-
-		mac = of_get_mac_address(pdev->dev.of_node);
-		if (!IS_ERR(mac))
-			ether_addr_copy(netdev->dev_addr, mac);
+		of_get_mac_address(pdev->dev.of_node, netdev->dev_addr);
 		priv->phy_id = -1;
 	}
 
diff --git a/drivers/net/ethernet/ezchip/nps_enet.c b/drivers/net/ethernet/ezchip/nps_enet.c
index 815fb62c4b02..e3954d8835e7 100644
--- a/drivers/net/ethernet/ezchip/nps_enet.c
+++ b/drivers/net/ethernet/ezchip/nps_enet.c
@@ -575,7 +575,6 @@ static s32 nps_enet_probe(struct platform_device *pdev)
 	struct net_device *ndev;
 	struct nps_enet_priv *priv;
 	s32 err = 0;
-	const char *mac_addr;
 
 	if (!dev->of_node)
 		return -ENODEV;
@@ -602,10 +601,8 @@ static s32 nps_enet_probe(struct platform_device *pdev)
 	dev_dbg(dev, "Registers base address is 0x%p\n", priv->regs_base);
 
 	/* set kernel MAC address to dev */
-	mac_addr = of_get_mac_address(dev->of_node);
-	if (!IS_ERR(mac_addr))
-		ether_addr_copy(ndev->dev_addr, mac_addr);
-	else
+	err = of_get_mac_address(dev->of_node, ndev->dev_addr);
+	if (err)
 		eth_hw_addr_random(ndev);
 
 	/* Get IRQ number */
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 3db882322b2b..622488241c2e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1665,6 +1665,7 @@ static void fec_get_mac(struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	unsigned char *iap, tmpaddr[ETH_ALEN];
+	int ret;
 
 	/*
 	 * try to get mac address in following order:
@@ -1680,9 +1681,9 @@ static void fec_get_mac(struct net_device *ndev)
 	if (!is_valid_ether_addr(iap)) {
 		struct device_node *np = fep->pdev->dev.of_node;
 		if (np) {
-			const char *mac = of_get_mac_address(np);
-			if (!IS_ERR(mac))
-				iap = (unsigned char *) mac;
+			ret = of_get_mac_address(np, tmpaddr);
+			if (!ret)
+				iap = tmpaddr;
 		}
 	}
 
diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx.c b/drivers/net/ethernet/freescale/fec_mpc52xx.c
index b3bad429e03b..02c47658a215 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx.c
@@ -813,7 +813,6 @@ static int mpc52xx_fec_probe(struct platform_device *op)
 	const u32 *prop;
 	int prop_size;
 	struct device_node *np = op->dev.of_node;
-	const char *mac_addr;
 
 	phys_addr_t rx_fifo;
 	phys_addr_t tx_fifo;
@@ -891,10 +890,8 @@ static int mpc52xx_fec_probe(struct platform_device *op)
 	 *
 	 * First try to read MAC address from DT
 	 */
-	mac_addr = of_get_mac_address(np);
-	if (!IS_ERR(mac_addr)) {
-		ether_addr_copy(ndev->dev_addr, mac_addr);
-	} else {
+	rv = of_get_mac_address(np, ndev->dev_addr);
+	if (rv) {
 		struct mpc52xx_fec __iomem *fec = priv->fec;
 
 		/*
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 901749a7a318..46ecb42f2ef8 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -605,7 +605,6 @@ static int mac_probe(struct platform_device *_of_dev)
 	struct platform_device	*of_dev;
 	struct resource		 res;
 	struct mac_priv_s	*priv;
-	const u8		*mac_addr;
 	u32			 val;
 	u8			fman_id;
 	phy_interface_t          phy_if;
@@ -723,11 +722,9 @@ static int mac_probe(struct platform_device *_of_dev)
 	priv->cell_index = (u8)val;
 
 	/* Get the MAC address */
-	mac_addr = of_get_mac_address(mac_node);
-	if (IS_ERR(mac_addr))
+	err = of_get_mac_address(mac_node, mac_dev->addr);
+	if (err)
 		dev_warn(dev, "of_get_mac_address(%pOF) failed\n", mac_node);
-	else
-		ether_addr_copy(mac_dev->addr, mac_addr);
 
 	/* Get the port handles */
 	nph = of_count_phandle_with_args(mac_node, "fsl,fman-ports", NULL);
@@ -853,7 +850,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (err < 0)
 		dev_err(dev, "fman_set_mac_active_pause() = %d\n", err);
 
-	if (!IS_ERR(mac_addr))
+	if (!is_zero_ether_addr(mac_dev->addr))
 		dev_info(dev, "FMan MAC address: %pM\n", mac_dev->addr);
 
 	priv->eth_dev = dpaa_eth_add_device(fman_id, mac_dev);
diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index 78e008b81374..6ee325ad35c5 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -918,7 +918,6 @@ static int fs_enet_probe(struct platform_device *ofdev)
 	const u32 *data;
 	struct clk *clk;
 	int err;
-	const u8 *mac_addr;
 	const char *phy_connection_type;
 	int privsize, len, ret = -ENODEV;
 
@@ -1006,9 +1005,7 @@ static int fs_enet_probe(struct platform_device *ofdev)
 	spin_lock_init(&fep->lock);
 	spin_lock_init(&fep->tx_lock);
 
-	mac_addr = of_get_mac_address(ofdev->dev.of_node);
-	if (!IS_ERR(mac_addr))
-		ether_addr_copy(ndev->dev_addr, mac_addr);
+	of_get_mac_address(ofdev->dev.of_node, ndev->dev_addr);
 
 	ret = fep->ops->allocate_bd(ndev);
 	if (ret)
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 1cf8ef717453..1c023f12d06e 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -636,7 +636,6 @@ static phy_interface_t gfar_get_interface(struct net_device *dev)
 static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 {
 	const char *model;
-	const void *mac_addr;
 	int err = 0, i;
 	phy_interface_t interface;
 	struct net_device *dev = NULL;
@@ -778,11 +777,8 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 	if (stash_len || stash_idx)
 		priv->device_flags |= FSL_GIANFAR_DEV_HAS_BUF_STASHING;
 
-	mac_addr = of_get_mac_address(np);
-
-	if (!IS_ERR(mac_addr)) {
-		ether_addr_copy(dev->dev_addr, mac_addr);
-	} else {
+	err = of_get_mac_address(np, dev->dev_addr);
+	if (err) {
 		eth_hw_addr_random(dev);
 		dev_info(&ofdev->dev, "Using random MAC address: %pM\n", dev->dev_addr);
 	}
diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index ef4e2febeb5b..e0936510fa34 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3562,7 +3562,6 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 	struct resource res;
 	int err, ucc_num, max_speed = 0;
 	const unsigned int *prop;
-	const void *mac_addr;
 	phy_interface_t phy_interface;
 	static const int enet_to_speed[] = {
 		SPEED_10, SPEED_10, SPEED_10,
@@ -3733,9 +3732,7 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 		goto err_free_netdev;
 	}
 
-	mac_addr = of_get_mac_address(np);
-	if (!IS_ERR(mac_addr))
-		ether_addr_copy(dev->dev_addr, mac_addr);
+	of_get_mac_address(np, dev->dev_addr);
 
 	ugeth->ug_info = ug_info;
 	ugeth->dev = device;
diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index 57c3bc4f7089..3c4db4a6b431 100644
--- a/drivers/net/ethernet/hisilicon/hisi_femac.c
+++ b/drivers/net/ethernet/hisilicon/hisi_femac.c
@@ -772,7 +772,6 @@ static int hisi_femac_drv_probe(struct platform_device *pdev)
 	struct net_device *ndev;
 	struct hisi_femac_priv *priv;
 	struct phy_device *phy;
-	const char *mac_addr;
 	int ret;
 
 	ndev = alloc_etherdev(sizeof(*priv));
@@ -842,10 +841,8 @@ static int hisi_femac_drv_probe(struct platform_device *pdev)
 			   (unsigned long)phy->phy_id,
 			   phy_modes(phy->interface));
 
-	mac_addr = of_get_mac_address(node);
-	if (!IS_ERR(mac_addr))
-		ether_addr_copy(ndev->dev_addr, mac_addr);
-	if (!is_valid_ether_addr(ndev->dev_addr)) {
+	ret = of_get_mac_address(node, ndev->dev_addr);
+	if (ret) {
 		eth_hw_addr_random(ndev);
 		dev_warn(dev, "using random MAC address %pM\n",
 			 ndev->dev_addr);
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index 8b2bf85039f1..c1aae0fca5e9 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -1098,7 +1098,6 @@ static int hix5hd2_dev_probe(struct platform_device *pdev)
 	struct net_device *ndev;
 	struct hix5hd2_priv *priv;
 	struct mii_bus *bus;
-	const char *mac_addr;
 	int ret;
 
 	ndev = alloc_etherdev(sizeof(struct hix5hd2_priv));
@@ -1220,10 +1219,8 @@ static int hix5hd2_dev_probe(struct platform_device *pdev)
 		goto out_phy_node;
 	}
 
-	mac_addr = of_get_mac_address(node);
-	if (!IS_ERR(mac_addr))
-		ether_addr_copy(ndev->dev_addr, mac_addr);
-	if (!is_valid_ether_addr(ndev->dev_addr)) {
+	ret = of_get_mac_address(node, ndev->dev_addr);
+	if (ret) {
 		eth_hw_addr_random(ndev);
 		netdev_warn(ndev, "using random MAC address %pM\n",
 			    ndev->dev_addr);
diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 0f8ef8f1232c..41c2ad210bc9 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -435,7 +435,6 @@ static int xrx200_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct xrx200_priv *priv;
 	struct net_device *net_dev;
-	const u8 *mac;
 	int err;
 
 	/* alloc the network device */
@@ -477,10 +476,8 @@ static int xrx200_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->clk);
 	}
 
-	mac = of_get_mac_address(np);
-	if (!IS_ERR(mac))
-		ether_addr_copy(net_dev->dev_addr, mac);
-	else
+	err = of_get_mac_address(np, net_dev->dev_addr);
+	if (err)
 		eth_hw_addr_random(net_dev);
 
 	/* bring up the dma engine and IP core */
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index ca1681aa951a..d207bfcaf31d 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2702,7 +2702,6 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 	struct platform_device *ppdev;
 	struct mv643xx_eth_platform_data ppd;
 	struct resource res;
-	const char *mac_addr;
 	int ret;
 	int dev_num = 0;
 
@@ -2733,9 +2732,7 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 		return -EINVAL;
 	}
 
-	mac_addr = of_get_mac_address(pnp);
-	if (!IS_ERR(mac_addr))
-		ether_addr_copy(ppd.mac_addr, mac_addr);
+	of_get_mac_address(pnp, ppd.mac_addr);
 
 	mv643xx_eth_property(pnp, "tx-queue-size", ppd.tx_queue_size);
 	mv643xx_eth_property(pnp, "tx-sram-addr", ppd.tx_sram_addr);
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index f20dfd1d7a6b..7d5cd9bc6c99 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5141,7 +5141,6 @@ static int mvneta_probe(struct platform_device *pdev)
 	struct net_device *dev;
 	struct phylink *phylink;
 	struct phy *comphy;
-	const char *dt_mac_addr;
 	char hw_mac_addr[ETH_ALEN];
 	phy_interface_t phy_mode;
 	const char *mac_from;
@@ -5237,10 +5236,9 @@ static int mvneta_probe(struct platform_device *pdev)
 		goto err_free_ports;
 	}
 
-	dt_mac_addr = of_get_mac_address(dn);
-	if (!IS_ERR(dt_mac_addr)) {
+	err = of_get_mac_address(dn, dev->dev_addr);
+	if (!err) {
 		mac_from = "device tree";
-		ether_addr_copy(dev->dev_addr, dt_mac_addr);
 	} else {
 		mvneta_get_mac_addr(pp, hw_mac_addr);
 		if (is_valid_ether_addr(hw_mac_addr)) {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 25dd903a3e92..f08c420a5803 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -456,20 +456,17 @@ static int prestera_switch_set_base_mac_addr(struct prestera_switch *sw)
 {
 	struct device_node *base_mac_np;
 	struct device_node *np;
-	const char *base_mac;
+	int ret;
 
 	np = of_find_compatible_node(NULL, NULL, "marvell,prestera");
 	base_mac_np = of_parse_phandle(np, "base-mac-provider", 0);
 
-	base_mac = of_get_mac_address(base_mac_np);
-	of_node_put(base_mac_np);
-	if (!IS_ERR(base_mac))
-		ether_addr_copy(sw->base_mac, base_mac);
-
-	if (!is_valid_ether_addr(sw->base_mac)) {
+	ret = of_get_mac_address(base_mac_np, sw->base_mac);
+	if (ret) {
 		eth_random_addr(sw->base_mac);
 		dev_info(prestera_dev(sw), "using random base mac address\n");
 	}
+	of_node_put(base_mac_np);
 
 	return prestera_hw_switch_mac_set(sw, sw->base_mac);
 }
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 3712e1786091..e967867828d8 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1392,7 +1392,6 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct clk *clk;
 	struct device_node *np;
-	const unsigned char *mac_addr = NULL;
 	int err;
 
 	printk(KERN_NOTICE "PXA168 10/100 Ethernet Driver\n");
@@ -1435,12 +1434,8 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 
 	INIT_WORK(&pep->tx_timeout_task, pxa168_eth_tx_timeout_task);
 
-	if (pdev->dev.of_node)
-		mac_addr = of_get_mac_address(pdev->dev.of_node);
-
-	if (!IS_ERR_OR_NULL(mac_addr)) {
-		ether_addr_copy(dev->dev_addr, mac_addr);
-	} else {
+	err = of_get_mac_address(pdev->dev.of_node, dev->dev_addr);
+	if (err) {
 		/* try reading the mac address, if set by the bootloader */
 		pxa168_eth_get_mac_address(dev, dev->dev_addr);
 		if (!is_valid_ether_addr(dev->dev_addr)) {
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 68c154d715d6..222c32367b2c 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4728,7 +4728,7 @@ static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
 {
 	struct sky2_port *sky2;
 	struct net_device *dev = alloc_etherdev(sizeof(*sky2));
-	const void *iap;
+	int ret;
 
 	if (!dev)
 		return NULL;
@@ -4798,10 +4798,8 @@ static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
 	 * 1) from device tree data
 	 * 2) from internal registers set by bootloader
 	 */
-	iap = of_get_mac_address(hw->pdev->dev.of_node);
-	if (!IS_ERR(iap))
-		ether_addr_copy(dev->dev_addr, iap);
-	else
+	ret = of_get_mac_address(hw->pdev->dev.of_node, dev->dev_addr);
+	if (ret)
 		memcpy_fromio(dev->dev_addr, hw->regs + B2_MAC_1 + port * 8,
 			      ETH_ALEN);
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 810def064f11..6b00c12c6c43 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2484,14 +2484,11 @@ static int __init mtk_init(struct net_device *dev)
 {
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_eth *eth = mac->hw;
-	const char *mac_addr;
-
-	mac_addr = of_get_mac_address(mac->of_node);
-	if (!IS_ERR(mac_addr))
-		ether_addr_copy(dev->dev_addr, mac_addr);
+	int ret;
 
-	/* If the mac address is invalid, use random mac address  */
-	if (!is_valid_ether_addr(dev->dev_addr)) {
+	ret = of_get_mac_address(mac->of_node, dev->dev_addr);
+	if (ret) {
+		/* If the mac address is invalid, use random mac address */
 		eth_hw_addr_random(dev);
 		dev_err(eth->dev, "generated random MAC address %pM\n",
 			dev->dev_addr);
diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index 2feed6ce19d3..13eef6e9bd2d 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -193,11 +193,10 @@ static void ks8851_read_mac_addr(struct net_device *dev)
 static void ks8851_init_mac(struct ks8851_net *ks, struct device_node *np)
 {
 	struct net_device *dev = ks->netdev;
-	const u8 *mac_addr;
+	int ret;
 
-	mac_addr = of_get_mac_address(np);
-	if (!IS_ERR(mac_addr)) {
-		ether_addr_copy(dev->dev_addr, mac_addr);
+	ret = of_get_mac_address(np, dev->dev_addr);
+	if (!ret) {
 		ks8851_write_mac_addr(dev);
 		return;
 	}
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index e7ab5f3f73fd..a841aba69c5e 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2771,7 +2771,6 @@ static int lan743x_pcidev_probe(struct pci_dev *pdev,
 {
 	struct lan743x_adapter *adapter = NULL;
 	struct net_device *netdev = NULL;
-	const void *mac_addr;
 	int ret = -ENODEV;
 
 	netdev = devm_alloc_etherdev(&pdev->dev,
@@ -2788,9 +2787,7 @@ static int lan743x_pcidev_probe(struct pci_dev *pdev,
 			      NETIF_MSG_IFDOWN | NETIF_MSG_TX_QUEUED;
 	netdev->max_mtu = LAN743X_MAX_FRAME_SIZE;
 
-	mac_addr = of_get_mac_address(pdev->dev.of_node);
-	if (!IS_ERR(mac_addr))
-		ether_addr_copy(adapter->mac_address, mac_addr);
+	of_get_mac_address(pdev->dev.of_node, adapter->mac_address);
 
 	ret = lan743x_pci_init(adapter, pdev);
 	if (ret)
diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index e72fd33a214c..64c6842bd452 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1350,9 +1350,7 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	__lpc_get_mac(pldat, ndev->dev_addr);
 
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
-		const char *macaddr = of_get_mac_address(np);
-		if (!IS_ERR(macaddr))
-			ether_addr_copy(ndev->dev_addr, macaddr);
+		of_get_mac_address(np, ndev->dev_addr);
 	}
 	if (!is_valid_ether_addr(ndev->dev_addr))
 		eth_hw_addr_random(ndev);
diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index 5a3b65a6eb4f..ab9b02574a15 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -885,7 +885,7 @@ qca_spi_probe(struct spi_device *spi)
 	struct net_device *qcaspi_devs = NULL;
 	u8 legacy_mode = 0;
 	u16 signature;
-	const char *mac;
+	int ret;
 
 	if (!spi->dev.of_node) {
 		dev_err(&spi->dev, "Missing device tree\n");
@@ -962,12 +962,8 @@ qca_spi_probe(struct spi_device *spi)
 
 	spi_set_drvdata(spi, qcaspi_devs);
 
-	mac = of_get_mac_address(spi->dev.of_node);
-
-	if (!IS_ERR(mac))
-		ether_addr_copy(qca->net_dev->dev_addr, mac);
-
-	if (!is_valid_ether_addr(qca->net_dev->dev_addr)) {
+	ret = of_get_mac_address(spi->dev.of_node, qca->net_dev->dev_addr);
+	if (ret) {
 		eth_hw_addr_random(qca->net_dev);
 		dev_info(&spi->dev, "Using random MAC address: %pM\n",
 			 qca->net_dev->dev_addr);
diff --git a/drivers/net/ethernet/qualcomm/qca_uart.c b/drivers/net/ethernet/qualcomm/qca_uart.c
index 362b4f5c162c..bcdeca7b3366 100644
--- a/drivers/net/ethernet/qualcomm/qca_uart.c
+++ b/drivers/net/ethernet/qualcomm/qca_uart.c
@@ -323,7 +323,6 @@ static int qca_uart_probe(struct serdev_device *serdev)
 {
 	struct net_device *qcauart_dev = alloc_etherdev(sizeof(struct qcauart));
 	struct qcauart *qca;
-	const char *mac;
 	u32 speed = 115200;
 	int ret;
 
@@ -348,12 +347,8 @@ static int qca_uart_probe(struct serdev_device *serdev)
 
 	of_property_read_u32(serdev->dev.of_node, "current-speed", &speed);
 
-	mac = of_get_mac_address(serdev->dev.of_node);
-
-	if (!IS_ERR(mac))
-		ether_addr_copy(qca->net_dev->dev_addr, mac);
-
-	if (!is_valid_ether_addr(qca->net_dev->dev_addr)) {
+	ret = of_get_mac_address(serdev->dev.of_node, qca->net_dev->dev_addr);
+	if (ret) {
 		eth_hw_addr_random(qca->net_dev);
 		dev_info(&serdev->dev, "Using random MAC address: %pM\n",
 			 qca->net_dev->dev_addr);
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index eb0c03bdb12d..e196ad5816c3 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -109,11 +109,13 @@ static void ravb_set_buffer_align(struct sk_buff *skb)
  * Ethernet AVB device doesn't have ROM for MAC address.
  * This function gets the MAC address that was used by a bootloader.
  */
-static void ravb_read_mac_address(struct net_device *ndev, const u8 *mac)
+static void ravb_read_mac_address(struct device_node *np,
+				  struct net_device *ndev)
 {
-	if (!IS_ERR(mac)) {
-		ether_addr_copy(ndev->dev_addr, mac);
-	} else {
+	int ret;
+
+	ret = of_get_mac_address(np, ndev->dev_addr);
+	if (ret) {
 		u32 mahr = ravb_read(ndev, MAHR);
 		u32 malr = ravb_read(ndev, MALR);
 
@@ -2200,7 +2202,7 @@ static int ravb_probe(struct platform_device *pdev)
 	priv->msg_enable = RAVB_DEF_MSG_ENABLE;
 
 	/* Read and set MAC address */
-	ravb_read_mac_address(ndev, of_get_mac_address(np));
+	ravb_read_mac_address(np, ndev);
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
 		dev_warn(&pdev->dev,
 			 "no valid MAC address supplied, using a random one\n");
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index ebedb1a11132..c5b154868c1f 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -3170,7 +3170,6 @@ static struct sh_eth_plat_data *sh_eth_parse_dt(struct device *dev)
 	struct device_node *np = dev->of_node;
 	struct sh_eth_plat_data *pdata;
 	phy_interface_t interface;
-	const char *mac_addr;
 	int ret;
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
@@ -3182,9 +3181,7 @@ static struct sh_eth_plat_data *sh_eth_parse_dt(struct device *dev)
 		return NULL;
 	pdata->phy_interface = interface;
 
-	mac_addr = of_get_mac_address(np);
-	if (!IS_ERR(mac_addr))
-		ether_addr_copy(pdata->mac_addr, mac_addr);
+	of_get_mac_address(np, pdata->mac_addr);
 
 	pdata->no_ether_link =
 		of_property_read_bool(np, "renesas,no-ether-link");
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
index 33f79402850d..4639ed9438a3 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
@@ -25,8 +25,7 @@
 
 #ifdef CONFIG_OF
 static int sxgbe_probe_config_dt(struct platform_device *pdev,
-				 struct sxgbe_plat_data *plat,
-				 const char **mac)
+				 struct sxgbe_plat_data *plat)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct sxgbe_dma_cfg *dma_cfg;
@@ -35,7 +34,6 @@ static int sxgbe_probe_config_dt(struct platform_device *pdev,
 	if (!np)
 		return -ENODEV;
 
-	*mac = of_get_mac_address(np);
 	err = of_get_phy_mode(np, &plat->interface);
 	if (err && err != -ENODEV)
 		return err;
@@ -63,8 +61,7 @@ static int sxgbe_probe_config_dt(struct platform_device *pdev,
 }
 #else
 static int sxgbe_probe_config_dt(struct platform_device *pdev,
-				 struct sxgbe_plat_data *plat,
-				 const char **mac)
+				 struct sxgbe_plat_data *plat)
 {
 	return -ENOSYS;
 }
@@ -85,7 +82,6 @@ static int sxgbe_platform_probe(struct platform_device *pdev)
 	void __iomem *addr;
 	struct sxgbe_priv_data *priv = NULL;
 	struct sxgbe_plat_data *plat_dat = NULL;
-	const char *mac = NULL;
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct device_node *node = dev->of_node;
 
@@ -101,7 +97,7 @@ static int sxgbe_platform_probe(struct platform_device *pdev)
 		if (!plat_dat)
 			return  -ENOMEM;
 
-		ret = sxgbe_probe_config_dt(pdev, plat_dat, &mac);
+		ret = sxgbe_probe_config_dt(pdev, plat_dat);
 		if (ret) {
 			pr_err("%s: main dt probe failed\n", __func__);
 			return ret;
@@ -122,8 +118,7 @@ static int sxgbe_platform_probe(struct platform_device *pdev)
 	}
 
 	/* Get MAC address if available (DT) */
-	if (!IS_ERR_OR_NULL(mac))
-		ether_addr_copy(priv->dev->dev_addr, mac);
+	of_get_mac_address(node, priv->dev->dev_addr);
 
 	/* Get the TX/RX IRQ numbers */
 	for (i = 0, chan = 1; i < SXGBE_TX_QUEUES; i++) {
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index 501b9c7aba56..fcbb4bb31408 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1559,7 +1559,6 @@ static int ave_probe(struct platform_device *pdev)
 	struct ave_private *priv;
 	struct net_device *ndev;
 	struct device_node *np;
-	const void *mac_addr;
 	void __iomem *base;
 	const char *name;
 	int i, irq, ret;
@@ -1600,12 +1599,9 @@ static int ave_probe(struct platform_device *pdev)
 
 	ndev->max_mtu = AVE_MAX_ETHFRAME - (ETH_HLEN + ETH_FCS_LEN);
 
-	mac_addr = of_get_mac_address(np);
-	if (!IS_ERR(mac_addr))
-		ether_addr_copy(ndev->dev_addr, mac_addr);
-
-	/* if the mac address is invalid, use random mac address */
-	if (!is_valid_ether_addr(ndev->dev_addr)) {
+	ret = of_get_mac_address(np, ndev->dev_addr);
+	if (ret) {
+		/* if the mac address is invalid, use random mac address */
 		eth_hw_addr_random(ndev);
 		dev_warn(dev, "Using random MAC address: %pM\n",
 			 ndev->dev_addr);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c
index 08c76636c164..dfbaea06d108 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c
@@ -115,7 +115,7 @@ static int anarion_dwmac_probe(struct platform_device *pdev)
 	if (IS_ERR(gmac))
 		return PTR_ERR(gmac);
 
-	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index 27254b27d7ed..bc91fd867dcd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -438,7 +438,7 @@ static int dwc_eth_dwmac_probe(struct platform_device *pdev)
 	if (IS_ERR(stmmac_res.addr))
 		return PTR_ERR(stmmac_res.addr);
 
-	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
index fad503820e04..fbfda55b4c52 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
@@ -27,7 +27,7 @@ static int dwmac_generic_probe(struct platform_device *pdev)
 		return ret;
 
 	if (pdev->dev.of_node) {
-		plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+		plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
 		if (IS_ERR(plat_dat)) {
 			dev_err(&pdev->dev, "dt configuration failed\n");
 			return PTR_ERR(plat_dat);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index c1a361305a5a..84651207a1de 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
@@ -231,7 +231,7 @@ static int imx_dwmac_probe(struct platform_device *pdev)
 	if (!dwmac)
 		return -ENOMEM;
 
-	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
index 6c19fcc76c6f..06d287f104be 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
@@ -85,7 +85,7 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat)) {
 		dev_err(&pdev->dev, "dt configuration failed\n");
 		return PTR_ERR(plat_dat);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
index 749585fe6fc9..28dd0ed85a82 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
@@ -255,7 +255,7 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 	if (val)
 		return val;
 
-	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-lpc18xx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-lpc18xx.c
index 3d3f43d91b98..9d77c647badd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-lpc18xx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-lpc18xx.c
@@ -37,7 +37,7 @@ static int lpc18xx_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index 9e4b83832938..58c0feaa8131 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -407,7 +407,7 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c
index bbc16b5a410a..16fb66a0ca72 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c
@@ -52,7 +52,7 @@ static int meson6_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 848e5c37746b..c7a6588d9398 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -398,7 +398,7 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c
index 8551ea878ba5..adfeb8d3293d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c
@@ -118,7 +118,7 @@ static int oxnas_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index a674b7d6b49a..84382fc5cc4d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -461,7 +461,7 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat)) {
 		dev_err(&pdev->dev, "dt configuration failed\n");
 		return PTR_ERR(plat_dat);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index 6ef30252bfe0..8d28a536e1bb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1396,7 +1396,7 @@ static int rk_gmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index 70d41783329d..85208128f135 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -398,7 +398,7 @@ static int socfpga_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
index e1b63df6f96f..710d7435733e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
@@ -325,7 +325,7 @@ static int sti_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
index 5d4df4c5254e..2b38a499a404 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
@@ -371,7 +371,7 @@ static int stm32_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 19e7ec30af4c..4422baeed3d8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1221,7 +1221,7 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return -EINVAL;
 
-	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
index 0e1ca2cba3c7..527077c98ebc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
@@ -108,7 +108,7 @@ static int sun7i_gmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
index d23be45a64e5..d046e33b8a29 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
@@ -208,7 +208,7 @@ static int visconti_eth_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index c49debb62b05..8b4ff9c189a1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -26,7 +26,7 @@
 
 struct stmmac_resources {
 	void __iomem *addr;
-	const char *mac;
+	u8 mac[ETH_ALEN];
 	int wol_irq;
 	int lpi_irq;
 	int irq;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 77285646c5fc..229b842480d1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6016,8 +6016,8 @@ int stmmac_dvr_probe(struct device *device,
 	for (i = 0; i < MTL_MAX_TX_QUEUES; i++)
 		priv->tx_irq[i] = res->tx_irq[i];
 
-	if (!IS_ERR_OR_NULL(res->mac))
-		memcpy(priv->dev->dev_addr, res->mac, ETH_ALEN);
+	if (!is_zero_ether_addr(res->mac))
+		ether_addr_copy(priv->dev->dev_addr, res->mac);
 
 	dev_set_drvdata(device, priv->dev);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 5a1e018884e6..1e17a23d9118 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -394,7 +394,7 @@ static int stmmac_of_get_mac_mode(struct device_node *np)
  * set some private fields that will be used by the main at runtime.
  */
 struct plat_stmmacenet_data *
-stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
+stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct plat_stmmacenet_data *plat;
@@ -406,12 +406,12 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	if (!plat)
 		return ERR_PTR(-ENOMEM);
 
-	*mac = of_get_mac_address(np);
-	if (IS_ERR(*mac)) {
-		if (PTR_ERR(*mac) == -EPROBE_DEFER)
-			return ERR_CAST(*mac);
+	rc = of_get_mac_address(np, mac);
+	if (rc) {
+		if (rc == -EPROBE_DEFER)
+			return ERR_PTR(rc);
 
-		*mac = NULL;
+		eth_zero_addr(mac);
 	}
 
 	plat->phy_interface = device_get_phy_mode(&pdev->dev);
@@ -627,7 +627,7 @@ void stmmac_remove_config_dt(struct platform_device *pdev,
 }
 #else
 struct plat_stmmacenet_data *
-stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
+stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 {
 	return ERR_PTR(-EINVAL);
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
index 3a4663b7b460..3fff3f59d73d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
@@ -12,7 +12,7 @@
 #include "stmmac.h"
 
 struct plat_stmmacenet_data *
-stmmac_probe_config_dt(struct platform_device *pdev, const char **mac);
+stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac);
 void stmmac_remove_config_dt(struct platform_device *pdev,
 			     struct plat_stmmacenet_data *plat);
 
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 638d7b03be4b..6a67b026df0b 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1824,7 +1824,6 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 
 	for_each_child_of_node(node, port_np) {
 		struct am65_cpsw_port *port;
-		const void *mac_addr;
 		u32 port_id;
 
 		/* it is not a slave port node, continue */
@@ -1903,15 +1902,15 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 			return ret;
 		}
 
-		mac_addr = of_get_mac_address(port_np);
-		if (!IS_ERR(mac_addr)) {
-			ether_addr_copy(port->slave.mac_addr, mac_addr);
-		} else if (am65_cpsw_am654_get_efuse_macid(port_np,
-							   port->port_id,
-							   port->slave.mac_addr) ||
-			   !is_valid_ether_addr(port->slave.mac_addr)) {
-			random_ether_addr(port->slave.mac_addr);
-			dev_err(dev, "Use random MAC address\n");
+		ret = of_get_mac_address(port_np, port->slave.mac_addr);
+		if (ret) {
+			am65_cpsw_am654_get_efuse_macid(port_np,
+							port->port_id,
+							port->slave.mac_addr);
+			if (!is_valid_ether_addr(port->slave.mac_addr)) {
+				random_ether_addr(port->slave.mac_addr);
+				dev_err(dev, "Use random MAC address\n");
+			}
 		}
 	}
 	of_node_put(node);
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 074702af3dc6..c0cd7de88316 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1296,7 +1296,6 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
 
 	for_each_available_child_of_node(node, slave_node) {
 		struct cpsw_slave_data *slave_data = data->slave_data + i;
-		const void *mac_addr = NULL;
 		int lenp;
 		const __be32 *parp;
 
@@ -1368,10 +1367,8 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
 		}
 
 no_phy_slave:
-		mac_addr = of_get_mac_address(slave_node);
-		if (!IS_ERR(mac_addr)) {
-			ether_addr_copy(slave_data->mac_addr, mac_addr);
-		} else {
+		ret = of_get_mac_address(slave_node, slave_data->mac_addr);
+		if (ret) {
 			ret = ti_cm_get_macid(&pdev->dev, i,
 					      slave_data->mac_addr);
 			if (ret)
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 0751f77de2c7..69b7a4e0220a 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1257,7 +1257,6 @@ static int cpsw_probe_dt(struct cpsw_common *cpsw)
 
 	for_each_child_of_node(tmp_node, port_np) {
 		struct cpsw_slave_data *slave_data;
-		const void *mac_addr;
 		u32 port_id;
 
 		ret = of_property_read_u32(port_np, "reg", &port_id);
@@ -1316,10 +1315,8 @@ static int cpsw_probe_dt(struct cpsw_common *cpsw)
 			goto err_node_put;
 		}
 
-		mac_addr = of_get_mac_address(port_np);
-		if (!IS_ERR(mac_addr)) {
-			ether_addr_copy(slave_data->mac_addr, mac_addr);
-		} else {
+		ret = of_get_mac_address(port_np, slave_data->mac_addr);
+		if (ret) {
 			ret = ti_cm_get_macid(dev, port_id - 1,
 					      slave_data->mac_addr);
 			if (ret)
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index c7031e1960d4..14e7da7d302f 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1687,7 +1687,6 @@ davinci_emac_of_get_pdata(struct platform_device *pdev, struct emac_priv *priv)
 	const struct of_device_id *match;
 	const struct emac_platform_data *auxdata;
 	struct emac_platform_data *pdata = NULL;
-	const u8 *mac_addr;
 
 	if (!IS_ENABLED(CONFIG_OF) || !pdev->dev.of_node)
 		return dev_get_platdata(&pdev->dev);
@@ -1699,11 +1698,8 @@ davinci_emac_of_get_pdata(struct platform_device *pdev, struct emac_priv *priv)
 	np = pdev->dev.of_node;
 	pdata->version = EMAC_VERSION_2;
 
-	if (!is_valid_ether_addr(pdata->mac_addr)) {
-		mac_addr = of_get_mac_address(np);
-		if (!IS_ERR(mac_addr))
-			ether_addr_copy(pdata->mac_addr, mac_addr);
-	}
+	if (!is_valid_ether_addr(pdata->mac_addr))
+		of_get_mac_address(np, pdata->mac_addr);
 
 	of_property_read_u32(np, "ti,davinci-ctrl-reg-offset",
 			     &pdata->ctrl_reg_offset);
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index d7a144b4a09f..9030e619e543 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1966,7 +1966,6 @@ static int netcp_create_interface(struct netcp_device *netcp_device,
 	struct resource res;
 	void __iomem *efuse = NULL;
 	u32 efuse_mac = 0;
-	const void *mac_addr;
 	u8 efuse_mac_addr[6];
 	u32 temp[2];
 	int ret = 0;
@@ -2036,10 +2035,8 @@ static int netcp_create_interface(struct netcp_device *netcp_device,
 		devm_iounmap(dev, efuse);
 		devm_release_mem_region(dev, res.start, size);
 	} else {
-		mac_addr = of_get_mac_address(node_interface);
-		if (!IS_ERR(mac_addr))
-			ether_addr_copy(ndev->dev_addr, mac_addr);
-		else
+		ret = of_get_mac_address(node_interface, ndev->dev_addr);
+		if (ret)
 			eth_random_addr(ndev->dev_addr);
 	}
 
diff --git a/drivers/net/ethernet/wiznet/w5100-spi.c b/drivers/net/ethernet/wiznet/w5100-spi.c
index 2b4126d2427d..2b84848dc26a 100644
--- a/drivers/net/ethernet/wiznet/w5100-spi.c
+++ b/drivers/net/ethernet/wiznet/w5100-spi.c
@@ -423,8 +423,14 @@ static int w5100_spi_probe(struct spi_device *spi)
 	const struct of_device_id *of_id;
 	const struct w5100_ops *ops;
 	kernel_ulong_t driver_data;
+	const void *mac = NULL;
+	u8 tmpmac[ETH_ALEN];
 	int priv_size;
-	const void *mac = of_get_mac_address(spi->dev.of_node);
+	int ret;
+
+	ret = of_get_mac_address(spi->dev.of_node, tmpmac);
+	if (!ret)
+		mac = tmpmac;
 
 	if (spi->dev.of_node) {
 		of_id = of_match_device(w5100_of_match, &spi->dev);
diff --git a/drivers/net/ethernet/wiznet/w5100.c b/drivers/net/ethernet/wiznet/w5100.c
index c0d181a7f83a..ec5db481c9cd 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -1157,7 +1157,7 @@ int w5100_probe(struct device *dev, const struct w5100_ops *ops,
 	INIT_WORK(&priv->setrx_work, w5100_setrx_work);
 	INIT_WORK(&priv->restart_work, w5100_restart_work);
 
-	if (!IS_ERR_OR_NULL(mac_addr))
+	if (mac_addr)
 		memcpy(ndev->dev_addr, mac_addr, ETH_ALEN);
 	else
 		eth_hw_addr_random(ndev);
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 030185301014..4eb81f467122 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1351,7 +1351,7 @@ static int temac_probe(struct platform_device *pdev)
 	struct device_node *temac_np = dev_of_node(&pdev->dev), *dma_np;
 	struct temac_local *lp;
 	struct net_device *ndev;
-	const void *addr;
+	u8 addr[ETH_ALEN];
 	__be32 *p;
 	bool little_endian;
 	int rc = 0;
@@ -1542,8 +1542,8 @@ static int temac_probe(struct platform_device *pdev)
 
 	if (temac_np) {
 		/* Retrieve the MAC address */
-		addr = of_get_mac_address(temac_np);
-		if (IS_ERR(addr)) {
+		rc = of_get_mac_address(temac_np, addr);
+		if (rc) {
 			dev_err(&pdev->dev, "could not find MAC address\n");
 			return -ENODEV;
 		}
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 92cf9051d557..5e1e923d7e7e 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1835,8 +1835,8 @@ static int axienet_probe(struct platform_device *pdev)
 	struct device_node *np;
 	struct axienet_local *lp;
 	struct net_device *ndev;
-	const void *mac_addr;
 	struct resource *ethres;
+	u8 mac_addr[ETH_ALEN];
 	int addr_width = 32;
 	u32 value;
 
@@ -2062,13 +2062,14 @@ static int axienet_probe(struct platform_device *pdev)
 		dev_info(&pdev->dev, "Ethernet core IRQ not defined\n");
 
 	/* Retrieve the MAC address */
-	mac_addr = of_get_mac_address(pdev->dev.of_node);
-	if (IS_ERR(mac_addr)) {
+	ret = of_get_mac_address(pdev->dev.of_node, mac_addr);
+	if (!ret) {
+		axienet_set_mac_address(ndev, mac_addr);
+	} else {
 		dev_warn(&pdev->dev, "could not find MAC address property: %ld\n",
 			 PTR_ERR(mac_addr));
-		mac_addr = NULL;
+		axienet_set_mac_address(ndev, NULL);
 	}
-	axienet_set_mac_address(ndev, mac_addr);
 
 	lp->coalesce_count_rx = XAXIDMA_DFT_RX_THRESHOLD;
 	lp->coalesce_count_tx = XAXIDMA_DFT_TX_THRESHOLD;
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 007840d4a807..d9d58a7dabee 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1115,7 +1115,6 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 	struct net_device *ndev = NULL;
 	struct net_local *lp = NULL;
 	struct device *dev = &ofdev->dev;
-	const void *mac_address;
 
 	int rc = 0;
 
@@ -1157,12 +1156,9 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 	lp->next_rx_buf_to_use = 0x0;
 	lp->tx_ping_pong = get_bool(ofdev, "xlnx,tx-ping-pong");
 	lp->rx_ping_pong = get_bool(ofdev, "xlnx,rx-ping-pong");
-	mac_address = of_get_mac_address(ofdev->dev.of_node);
 
-	if (!IS_ERR(mac_address)) {
-		/* Set the MAC address. */
-		ether_addr_copy(ndev->dev_addr, mac_address);
-	} else {
+	rc = of_get_mac_address(ofdev->dev.of_node, ndev->dev_addr);
+	if (rc) {
 		dev_warn(dev, "No MAC address found, using random\n");
 		eth_hw_addr_random(ndev);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 01f9c26f9bf3..e9a36dd7144f 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -617,7 +617,6 @@ static int ath9k_of_init(struct ath_softc *sc)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	enum ath_bus_type bus_type = common->bus_ops->ath_bus_type;
-	const char *mac;
 	char eeprom_name[100];
 	int ret;
 
@@ -640,9 +639,7 @@ static int ath9k_of_init(struct ath_softc *sc)
 		ah->ah_flags |= AH_NO_EEP_SWAP;
 	}
 
-	mac = of_get_mac_address(np);
-	if (!IS_ERR(mac))
-		ether_addr_copy(common->macaddr, mac);
+	of_get_mac_address(np, common->macaddr);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/eeprom.c b/drivers/net/wireless/mediatek/mt76/eeprom.c
index 665b54c5c8ae..6d895738222a 100644
--- a/drivers/net/wireless/mediatek/mt76/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -91,16 +91,9 @@ void
 mt76_eeprom_override(struct mt76_phy *phy)
 {
 	struct mt76_dev *dev = phy->dev;
-
-#ifdef CONFIG_OF
 	struct device_node *np = dev->dev->of_node;
-	const u8 *mac = NULL;
 
-	if (np)
-		mac = of_get_mac_address(np);
-	if (!IS_ERR_OR_NULL(mac))
-		ether_addr_copy(phy->macaddr, mac);
-#endif
+	of_get_mac_address(np, phy->macaddr);
 
 	if (!is_valid_ether_addr(phy->macaddr)) {
 		eth_random_addr(phy->macaddr);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 61a4f1ad31e2..e95c101c2711 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -989,11 +989,7 @@ static void rt2x00lib_rate(struct ieee80211_rate *entry,
 
 void rt2x00lib_set_mac_address(struct rt2x00_dev *rt2x00dev, u8 *eeprom_mac_addr)
 {
-	const char *mac_addr;
-
-	mac_addr = of_get_mac_address(rt2x00dev->dev->of_node);
-	if (!IS_ERR(mac_addr))
-		ether_addr_copy(eeprom_mac_addr, mac_addr);
+	of_get_mac_address(rt2x00dev->dev->of_node, eeprom_mac_addr);
 
 	if (!is_valid_ether_addr(eeprom_mac_addr)) {
 		eth_random_addr(eeprom_mac_addr);
diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
index bc0a27de69d4..2344ad7fff5e 100644
--- a/drivers/of/of_net.c
+++ b/drivers/of/of_net.c
@@ -45,42 +45,35 @@ int of_get_phy_mode(struct device_node *np, phy_interface_t *interface)
 }
 EXPORT_SYMBOL_GPL(of_get_phy_mode);
 
-static const void *of_get_mac_addr(struct device_node *np, const char *name)
+static int of_get_mac_addr(struct device_node *np, const char *name, u8 *addr)
 {
 	struct property *pp = of_find_property(np, name, NULL);
 
-	if (pp && pp->length == ETH_ALEN && is_valid_ether_addr(pp->value))
-		return pp->value;
-	return NULL;
+	if (pp && pp->length == ETH_ALEN && is_valid_ether_addr(pp->value)) {
+		ether_addr_copy(addr, pp->value);
+		return 0;
+	}
+	return -ENODEV;
 }
 
-static const void *of_get_mac_addr_nvmem(struct device_node *np)
+static int of_get_mac_addr_nvmem(struct device_node *np, u8 addr)
 {
-	int ret;
-	const void *mac;
-	u8 nvmem_mac[ETH_ALEN];
 	struct platform_device *pdev = of_find_device_by_node(np);
+	int ret;
 
 	if (!pdev)
-		return ERR_PTR(-ENODEV);
+		return -ENODEV;
 
-	ret = nvmem_get_mac_address(&pdev->dev, &nvmem_mac);
-	if (ret) {
-		put_device(&pdev->dev);
-		return ERR_PTR(ret);
-	}
-
-	mac = devm_kmemdup(&pdev->dev, nvmem_mac, ETH_ALEN, GFP_KERNEL);
+	ret = nvmem_get_mac_address(&pdev->dev, addr);
 	put_device(&pdev->dev);
-	if (!mac)
-		return ERR_PTR(-ENOMEM);
 
-	return mac;
+	return ret;
 }
 
 /**
  * of_get_mac_address()
  * @np:		Caller's Device Node
+ * @addr:	Pointer to a six-byte array for the result
  *
  * Search the device tree for the best MAC address to use.  'mac-address' is
  * checked first, because that is supposed to contain to "most recent" MAC
@@ -101,24 +94,27 @@ static const void *of_get_mac_addr_nvmem(struct device_node *np)
  * this case, the real MAC is in 'local-mac-address', and 'mac-address' exists
  * but is all zeros.
  *
- * Return: Will be a valid pointer on success and ERR_PTR in case of error.
+ * Return: 0 on success and errno in case of error.
 */
-const void *of_get_mac_address(struct device_node *np)
+int of_get_mac_address(struct device_node *np, u8 *addr)
 {
-	const void *addr;
+	int ret;
+
+	if (!np)
+		return -ENODEV;
 
-	addr = of_get_mac_addr(np, "mac-address");
-	if (addr)
-		return addr;
+	ret = of_get_mac_addr(np, "mac-address", addr);
+	if (!ret)
+		return 0;
 
-	addr = of_get_mac_addr(np, "local-mac-address");
-	if (addr)
-		return addr;
+	ret = of_get_mac_addr(np, "local-mac-address", addr);
+	if (!ret)
+		return 0;
 
-	addr = of_get_mac_addr(np, "address");
-	if (addr)
-		return addr;
+	ret = of_get_mac_addr(np, "address", addr);
+	if (!ret)
+		return 0;
 
-	return of_get_mac_addr_nvmem(np);
+	return of_get_mac_addr_nvmem(np, addr);
 }
 EXPORT_SYMBOL(of_get_mac_address);
diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index 5dea6e96ec90..da7c2cd8ebb8 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -407,14 +407,10 @@ static int cvm_oct_common_set_mac_address(struct net_device *dev, void *addr)
 int cvm_oct_common_init(struct net_device *dev)
 {
 	struct octeon_ethernet *priv = netdev_priv(dev);
-	const u8 *mac = NULL;
+	int ret;
 
-	if (priv->of_node)
-		mac = of_get_mac_address(priv->of_node);
-
-	if (!IS_ERR_OR_NULL(mac))
-		ether_addr_copy(dev->dev_addr, mac);
-	else
+	ret = of_get_mac_address(priv->of_node, dev->dev_addr);
+	if (ret)
 		eth_hw_addr_random(dev);
 
 	/*
diff --git a/drivers/staging/wfx/main.c b/drivers/staging/wfx/main.c
index e7bc1988124a..4b9fdf99981b 100644
--- a/drivers/staging/wfx/main.c
+++ b/drivers/staging/wfx/main.c
@@ -334,7 +334,6 @@ int wfx_probe(struct wfx_dev *wdev)
 {
 	int i;
 	int err;
-	const void *macaddr;
 	struct gpio_desc *gpio_saved;
 
 	// During first part of boot, gpio_wakeup cannot yet been used. So
@@ -423,9 +422,9 @@ int wfx_probe(struct wfx_dev *wdev)
 
 	for (i = 0; i < ARRAY_SIZE(wdev->addresses); i++) {
 		eth_zero_addr(wdev->addresses[i].addr);
-		macaddr = of_get_mac_address(wdev->dev->of_node);
-		if (!IS_ERR_OR_NULL(macaddr)) {
-			ether_addr_copy(wdev->addresses[i].addr, macaddr);
+		err = of_get_mac_address(wdev->dev->of_node,
+					 wdev->addresses[i].addr);
+		if (!err) {
 			wdev->addresses[i].addr[ETH_ALEN - 1] += i;
 		} else {
 			ether_addr_copy(wdev->addresses[i].addr,
diff --git a/include/linux/of_net.h b/include/linux/of_net.h
index 71bbfcf3adcd..daef3b0d9270 100644
--- a/include/linux/of_net.h
+++ b/include/linux/of_net.h
@@ -13,7 +13,7 @@
 
 struct net_device;
 extern int of_get_phy_mode(struct device_node *np, phy_interface_t *interface);
-extern const void *of_get_mac_address(struct device_node *np);
+extern int of_get_mac_address(struct device_node *np, u8 *mac);
 extern struct net_device *of_find_net_device_by_node(struct device_node *np);
 #else
 static inline int of_get_phy_mode(struct device_node *np,
@@ -22,9 +22,9 @@ static inline int of_get_phy_mode(struct device_node *np,
 	return -ENODEV;
 }
 
-static inline const void *of_get_mac_address(struct device_node *np)
+static inline int of_get_mac_address(struct device_node *np, u8 *mac)
 {
-	return ERR_PTR(-ENODEV);
+	return -ENODEV;
 }
 
 static inline struct net_device *of_find_net_device_by_node(struct device_node *np)
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 57b2c49f72f4..1259b0f40684 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -260,7 +260,7 @@ struct dsa_port {
 	unsigned int		index;
 	const char		*name;
 	struct dsa_port		*cpu_dp;
-	const char		*mac;
+	u8			mac[ETH_ALEN];
 	struct device_node	*dn;
 	unsigned int		ageing_time;
 	bool			vlan_filtering;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index d142eb2b288b..805118941dae 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -392,7 +392,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 
 		break;
 	case DSA_PORT_TYPE_USER:
-		dp->mac = of_get_mac_address(dp->dn);
+		of_get_mac_address(dp->dn, dp->mac);
 		err = dsa_slave_create(dp);
 		if (err)
 			break;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 995e0e16f295..9300cb66e500 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1896,7 +1896,7 @@ int dsa_slave_create(struct dsa_port *port)
 	slave_dev->hw_features |= NETIF_F_HW_TC;
 	slave_dev->features |= NETIF_F_LLTX;
 	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
-	if (!IS_ERR_OR_NULL(port->mac))
+	if (!is_zero_ether_addr(port->mac))
 		ether_addr_copy(slave_dev->dev_addr, port->mac);
 	else
 		eth_hw_addr_inherit(slave_dev, master);
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 933b427122be..9cce612e8976 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -511,13 +511,14 @@ unsigned char * __weak arch_get_platform_mac_address(void)
 
 int eth_platform_get_mac_address(struct device *dev, u8 *mac_addr)
 {
-	const unsigned char *addr = NULL;
+	unsigned char *addr;
+	int ret;
 
-	if (dev->of_node)
-		addr = of_get_mac_address(dev->of_node);
-	if (IS_ERR_OR_NULL(addr))
-		addr = arch_get_platform_mac_address();
+	ret = of_get_mac_address(dev->of_node, mac_addr);
+	if (!ret)
+		return 0;
 
+	addr = arch_get_platform_mac_address();
 	if (!addr)
 		return -ENODEV;
 
-- 
2.20.1

