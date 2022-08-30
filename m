Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5243C5A5FEB
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiH3J4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiH3J4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:56:12 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E465A1D78;
        Tue, 30 Aug 2022 02:55:59 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 613DB1BF208;
        Tue, 30 Aug 2022 09:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661853357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=inPHOWh5jcwFBikJcWTipiErJLZs64xvq0nFt+bXVfI=;
        b=Y6nX7NoQ7wCE2Fy8wUAztbRf9QImR6J0Swhh98ZCeWuQXLeQudaYdwyHCFcgBApZO6Zq/v
        5o+/0N43khwIAktmqAnz/c0xCKPvPM5VDNYhns8g043hum8S4M6C/PX7LD7uHVfNLMq8qD
        p7sHcix8w4s3UJQVd74/iaPGdRP69W/Ea6JI5JWrfA+/a7Swb02ipuuo/yxgyxgZ+WwxGa
        vX0QWejjUDZtFjNyzNNanLrRdh/LZHmWZ6+0CZ48rsNPqXAEVAP+Pri93PxC2sMc+5NfkV
        bUpaj3iZRr+hVT1+5GPf/Fv0lcmSvrBvSChaih4tSaSOrDOG7/5UkwV00XplDQ==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH net-next v2 2/5] net: altera: tse: cosmetic change to use reverse xmas tree ordering
Date:   Tue, 30 Aug 2022 11:55:46 +0200
Message-Id: <20220830095549.120625-3-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220830095549.120625-1-maxime.chevallier@bootlin.com>
References: <20220830095549.120625-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit is a strictly cosmetic change, to use the reverse xmas tree
variable declaration ordering, and introduces no functional changes.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V1->V2 : No changes

 .../net/ethernet/altera/altera_tse_ethtool.c  |  2 +-
 drivers/net/ethernet/altera/altera_tse_main.c | 43 ++++++++++---------
 2 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_tse_ethtool.c b/drivers/net/ethernet/altera/altera_tse_ethtool.c
index 3081e5874ac5..f0b11a278644 100644
--- a/drivers/net/ethernet/altera/altera_tse_ethtool.c
+++ b/drivers/net/ethernet/altera/altera_tse_ethtool.c
@@ -199,9 +199,9 @@ static int tse_reglen(struct net_device *dev)
 static void tse_get_regs(struct net_device *dev, struct ethtool_regs *regs,
 			 void *regbuf)
 {
-	int i;
 	struct altera_tse_private *priv = netdev_priv(dev);
 	u32 *buf = regbuf;
+	int i;
 
 	/* Set version to a known value, so ethtool knows
 	 * how to do any special formatting of this data.
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 8c5828582c21..930afc9ec833 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -141,10 +141,10 @@ static int altera_tse_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 static int altera_tse_mdio_create(struct net_device *dev, unsigned int id)
 {
 	struct altera_tse_private *priv = netdev_priv(dev);
-	int ret;
 	struct device_node *mdio_node = NULL;
-	struct mii_bus *mdio = NULL;
 	struct device_node *child_node = NULL;
+	struct mii_bus *mdio = NULL;
+	int ret;
 
 	for_each_child_of_node(priv->device->of_node, child_node) {
 		if (of_device_is_compatible(child_node, "altr,tse-mdio")) {
@@ -236,8 +236,8 @@ static int tse_init_rx_buffer(struct altera_tse_private *priv,
 static void tse_free_rx_buffer(struct altera_tse_private *priv,
 			       struct tse_buffer *rxbuffer)
 {
-	struct sk_buff *skb = rxbuffer->skb;
 	dma_addr_t dma_addr = rxbuffer->dma_addr;
+	struct sk_buff *skb = rxbuffer->skb;
 
 	if (skb != NULL) {
 		if (dma_addr)
@@ -358,6 +358,7 @@ static inline void tse_rx_vlan(struct net_device *dev, struct sk_buff *skb)
 {
 	struct ethhdr *eth_hdr;
 	u16 vid;
+
 	if ((dev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
 	    !__vlan_get_tag(skb, &vid)) {
 		eth_hdr = (struct ethhdr *)skb->data;
@@ -371,10 +372,10 @@ static inline void tse_rx_vlan(struct net_device *dev, struct sk_buff *skb)
  */
 static int tse_rx(struct altera_tse_private *priv, int limit)
 {
-	unsigned int count = 0;
+	unsigned int entry = priv->rx_cons % priv->rx_ring_size;
 	unsigned int next_entry;
+	unsigned int count = 0;
 	struct sk_buff *skb;
-	unsigned int entry = priv->rx_cons % priv->rx_ring_size;
 	u32 rxstatus;
 	u16 pktlength;
 	u16 pktstatus;
@@ -448,10 +449,10 @@ static int tse_rx(struct altera_tse_private *priv, int limit)
 static int tse_tx_complete(struct altera_tse_private *priv)
 {
 	unsigned int txsize = priv->tx_ring_size;
-	u32 ready;
-	unsigned int entry;
 	struct tse_buffer *tx_buff;
+	unsigned int entry;
 	int txcomplete = 0;
+	u32 ready;
 
 	spin_lock(&priv->tx_lock);
 
@@ -497,8 +498,8 @@ static int tse_poll(struct napi_struct *napi, int budget)
 {
 	struct altera_tse_private *priv =
 			container_of(napi, struct altera_tse_private, napi);
-	int rxcomplete = 0;
 	unsigned long int flags;
+	int rxcomplete = 0;
 
 	tse_tx_complete(priv);
 
@@ -561,13 +562,13 @@ static irqreturn_t altera_isr(int irq, void *dev_id)
 static netdev_tx_t tse_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct altera_tse_private *priv = netdev_priv(dev);
+	unsigned int nopaged_len = skb_headlen(skb);
 	unsigned int txsize = priv->tx_ring_size;
-	unsigned int entry;
-	struct tse_buffer *buffer = NULL;
 	int nfrags = skb_shinfo(skb)->nr_frags;
-	unsigned int nopaged_len = skb_headlen(skb);
+	struct tse_buffer *buffer = NULL;
 	netdev_tx_t ret = NETDEV_TX_OK;
 	dma_addr_t dma_addr;
+	unsigned int entry;
 
 	spin_lock_bh(&priv->tx_lock);
 
@@ -696,8 +697,8 @@ static void altera_tse_adjust_link(struct net_device *dev)
 static struct phy_device *connect_local_phy(struct net_device *dev)
 {
 	struct altera_tse_private *priv = netdev_priv(dev);
-	struct phy_device *phydev = NULL;
 	char phy_id_fmt[MII_BUS_ID_SIZE + 3];
+	struct phy_device *phydev = NULL;
 
 	if (priv->phy_addr != POLL_PHY) {
 		snprintf(phy_id_fmt, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
@@ -773,8 +774,8 @@ static int altera_tse_phy_get_addr_mdio_create(struct net_device *dev)
 static int init_phy(struct net_device *dev)
 {
 	struct altera_tse_private *priv = netdev_priv(dev);
-	struct phy_device *phydev;
 	struct device_node *phynode;
+	struct phy_device *phydev;
 	bool fixed_link = false;
 	int rc = 0;
 
@@ -1012,8 +1013,8 @@ static int tse_change_mtu(struct net_device *dev, int new_mtu)
 static void altera_tse_set_mcfilter(struct net_device *dev)
 {
 	struct altera_tse_private *priv = netdev_priv(dev);
-	int i;
 	struct netdev_hw_addr *ha;
+	int i;
 
 	/* clear the hash filter */
 	for (i = 0; i < 64; i++)
@@ -1152,9 +1153,9 @@ static int init_sgmii_pcs(struct net_device *dev)
 static int tse_open(struct net_device *dev)
 {
 	struct altera_tse_private *priv = netdev_priv(dev);
+	unsigned long flags;
 	int ret = 0;
 	int i;
-	unsigned long int flags;
 
 	/* Reset and configure TSE MAC and probe associated PHY */
 	ret = priv->dmaops->init_dma(priv);
@@ -1265,8 +1266,8 @@ static int tse_open(struct net_device *dev)
 static int tse_shutdown(struct net_device *dev)
 {
 	struct altera_tse_private *priv = netdev_priv(dev);
-	int ret;
 	unsigned long int flags;
+	int ret;
 
 	/* Stop the PHY */
 	if (dev->phydev)
@@ -1320,8 +1321,8 @@ static struct net_device_ops altera_tse_netdev_ops = {
 static int request_and_map(struct platform_device *pdev, const char *name,
 			   struct resource **res, void __iomem **ptr)
 {
-	struct resource *region;
 	struct device *device = &pdev->dev;
+	struct resource *region;
 
 	*res = platform_get_resource_byname(pdev, IORESOURCE_MEM, name);
 	if (*res == NULL) {
@@ -1350,13 +1351,13 @@ static int request_and_map(struct platform_device *pdev, const char *name,
  */
 static int altera_tse_probe(struct platform_device *pdev)
 {
-	struct net_device *ndev;
-	int ret = -ENODEV;
+	const struct of_device_id *of_id = NULL;
+	struct altera_tse_private *priv;
 	struct resource *control_port;
 	struct resource *dma_res;
-	struct altera_tse_private *priv;
+	struct net_device *ndev;
 	void __iomem *descmap;
-	const struct of_device_id *of_id = NULL;
+	int ret = -ENODEV;
 
 	ndev = alloc_etherdev(sizeof(struct altera_tse_private));
 	if (!ndev) {
-- 
2.37.2

