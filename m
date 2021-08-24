Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0493F6A06
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 21:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbhHXToB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 15:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbhHXTn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 15:43:59 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6373BC061757;
        Tue, 24 Aug 2021 12:43:15 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id r21so17789830qtw.11;
        Tue, 24 Aug 2021 12:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to;
        bh=zBd/UKu6RYkJwzOer0cfQtBzoFIUvC8rt1cVcFn20Xg=;
        b=Dl8ZxC4LAIEgBRNJSu744ISXyrVlatyqWjAkxSfoWrYqiisRTlOO9RQCzIH4uT+/xX
         RHIgWqjJzgqW6mgZgOHi2B07V85tFQVjyct8UPHAINGJ+D0qvlOU4jJ5SYA9pf107aPa
         tT0JextLP01u9vc1cPR1Ewd+XygVgfwP7/p3B4kDRI70sz708YND9XEGjMcF28CweGJt
         uAc9Bc1lwWlzPkYXy1DRHyWUdc+zFI7CsHqJEZUrIBB2A/UKxmMR9lLR1ohvzfvwdHSc
         tIac71KtYPrDw/+2C8yVMiSJf/6vd7gyyYfFzF/uaBWcm/vEe3BCoW+svbYQsZzzOdbo
         0uTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to;
        bh=zBd/UKu6RYkJwzOer0cfQtBzoFIUvC8rt1cVcFn20Xg=;
        b=JKuu5T8PEIPntwhtWwEcgAa7A2TqM8voE67ocOysRnIMdEVPcACbO20QQr612AAV9/
         19J1uV7kyBH/Y2OEPxriLxvTCCxpzFynYMY+ducdY4rvcezeaDRhmFPsDygPhjK/fjPU
         zUSYp9TuW5DAfS2Wb0RLixekYA/3/RfTP7mesBKo5hKs9tg+Qf3Vste6dRsaAQwo3bF+
         B3Cbx5LORL4WWMHu7Y+ypzgTHENGam1a3rwH7UjryP0ZaealEOhiyOsyf8lbcNBIHK59
         lFg7h+NrKYL9XSNEnkP5wIv2jidLMmrWu4dXkYGir5PeY30rdvfLZwe5RSwQyHaUEe4U
         xwcw==
X-Gm-Message-State: AOAM532AYLAG17SjU40ZFFckDieKqm2l9aqhKPRVy/5bvbbXUMXvbeVt
        LlCTeMRxQmrmtI/Mk8Fp+HruDzzv1FM7lw==
X-Google-Smtp-Source: ABdhPJwMLav+kJbe+w7ATTnlefg5quv9HCg7M3d8HJ+OD/5ZQN4sDnAFTj8dIq/QsaL+G2UKEkVsmA==
X-Received: by 2002:a05:622a:1910:: with SMTP id w16mr35574353qtc.227.1629834194490;
        Tue, 24 Aug 2021 12:43:14 -0700 (PDT)
Received: from errol.ini.cmu.edu (pool-71-112-192-175.pitbpa.fios.verizon.net. [71.112.192.175])
        by smtp.gmail.com with ESMTPSA id b1sm1228513qtj.76.2021.08.24.12.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 12:43:13 -0700 (PDT)
Date:   Tue, 24 Aug 2021 15:43:11 -0400
From:   "Gabriel L. Somlo" <gsomlo@gmail.com>
To:     Joel Stanley <joel@jms.id.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Shah <dave@ds0.me>,
        Stafford Horne <shorne@gmail.com>
Subject: Re: [PATCH v2 2/2] net: Add driver for LiteX's LiteEth network
 interface
Message-ID: <YSVLz0Se+hTVr0DA@errol.ini.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820074726.2860425-3-joel@jms.id.au>
X-Clacks-Overhead: GNU Terry Pratchett
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joel,

Couple of comments below:

On Fri, Aug 20, 2021 at 05:17:26PM +0930, Joel Stanley wrote:
> LiteX is a soft system-on-chip that targets FPGAs. LiteEth is a basic
> network device that is commonly used in LiteX designs.
> 
> The driver was first written in 2017 and has been maintained by the
> LiteX community in various trees. Thank you to all who have contributed.
> 
> Co-developed-by: Gabriel Somlo <gsomlo@gmail.com>
> Co-developed-by: David Shah <dave@ds0.me>
> Co-developed-by: Stafford Horne <shorne@gmail.com>
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> ---
> v2:
>  - check for bad len in liteeth_rx before getting skb
>  - use netdev_alloc_skb_ip_align
>  - remove unused duplex/speed and mii_bus variables
>  - set carrier off when stopping device
>  - increment packet count in the same place as bytes
>  - fix error return code when irq could not be found
>  - remove request of mdio base address until it is used
>  - fix of_property_read line wrapping/alignment
>  - only check that reader isn't busy, and then send off next packet
>  - drop phy reset, it was incorrect (wrong address)
>  - Add an description to the kconfig text
>  - stop tx queue when busy and re-start after tx complete irq fires
>  - use litex accessors to support big endian socs
>  - clean up unused includes
>  - use standard fifo-depth properties, which are in bytes
> 
>  drivers/net/ethernet/Kconfig               |   1 +
>  drivers/net/ethernet/Makefile              |   1 +
>  drivers/net/ethernet/litex/Kconfig         |  27 ++
>  drivers/net/ethernet/litex/Makefile        |   5 +
>  drivers/net/ethernet/litex/litex_liteeth.c | 327 +++++++++++++++++++++
>  5 files changed, 361 insertions(+)
>  create mode 100644 drivers/net/ethernet/litex/Kconfig
>  create mode 100644 drivers/net/ethernet/litex/Makefile
>  create mode 100644 drivers/net/ethernet/litex/litex_liteeth.c
> 
> diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
> index 1cdff1dca790..d796684ec9ca 100644
> --- a/drivers/net/ethernet/Kconfig
> +++ b/drivers/net/ethernet/Kconfig
> @@ -118,6 +118,7 @@ config LANTIQ_XRX200
>  	  Support for the PMAC of the Gigabit switch (GSWIP) inside the
>  	  Lantiq / Intel VRX200 VDSL SoC
>  
> +source "drivers/net/ethernet/litex/Kconfig"
>  source "drivers/net/ethernet/marvell/Kconfig"
>  source "drivers/net/ethernet/mediatek/Kconfig"
>  source "drivers/net/ethernet/mellanox/Kconfig"
> diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
> index cb3f9084a21b..aaa5078cd7d1 100644
> --- a/drivers/net/ethernet/Makefile
> +++ b/drivers/net/ethernet/Makefile
> @@ -51,6 +51,7 @@ obj-$(CONFIG_JME) += jme.o
>  obj-$(CONFIG_KORINA) += korina.o
>  obj-$(CONFIG_LANTIQ_ETOP) += lantiq_etop.o
>  obj-$(CONFIG_LANTIQ_XRX200) += lantiq_xrx200.o
> +obj-$(CONFIG_NET_VENDOR_LITEX) += litex/
>  obj-$(CONFIG_NET_VENDOR_MARVELL) += marvell/
>  obj-$(CONFIG_NET_VENDOR_MEDIATEK) += mediatek/
>  obj-$(CONFIG_NET_VENDOR_MELLANOX) += mellanox/
> diff --git a/drivers/net/ethernet/litex/Kconfig b/drivers/net/ethernet/litex/Kconfig
> new file mode 100644
> index 000000000000..265dba414b41
> --- /dev/null
> +++ b/drivers/net/ethernet/litex/Kconfig
> @@ -0,0 +1,27 @@
> +#
> +# LiteX device configuration
> +#
> +
> +config NET_VENDOR_LITEX
> +	bool "LiteX devices"
> +	default y
> +	help
> +	  If you have a network (Ethernet) card belonging to this class, say Y.
> +
> +	  Note that the answer to this question doesn't directly affect the
> +	  kernel: saying N will just cause the configurator to skip all
> +	  the questions about LiteX devices. If you say Y, you will be asked
> +	  for your specific card in the following questions.
> +
> +if NET_VENDOR_LITEX
> +
> +config LITEX_LITEETH
> +	tristate "LiteX Ethernet support"

Mostly cosmetic, but should there be a "depends on LITEX" statement in here?
Maybe also "select MII" and "select PHYLIB"?

> +	help
> +	  If you wish to compile a kernel for hardware with a LiteX LiteEth
> +	  device then you should answer Y to this.
> +
> +	  LiteX is a soft system-on-chip that targets FPGAs. LiteETH is a basic
> +	  network device that is commonly used in LiteX designs.
> +
> +endif # NET_VENDOR_LITEX
> diff --git a/drivers/net/ethernet/litex/Makefile b/drivers/net/ethernet/litex/Makefile
> new file mode 100644
> index 000000000000..9343b73b8e49
> --- /dev/null
> +++ b/drivers/net/ethernet/litex/Makefile
> @@ -0,0 +1,5 @@
> +#
> +# Makefile for the LiteX network device drivers.
> +#
> +
> +obj-$(CONFIG_LITEX_LITEETH) += litex_liteeth.o
> diff --git a/drivers/net/ethernet/litex/litex_liteeth.c b/drivers/net/ethernet/litex/litex_liteeth.c
> new file mode 100644
> index 000000000000..e9c5d817e1f9
> --- /dev/null
> +++ b/drivers/net/ethernet/litex/litex_liteeth.c
> @@ -0,0 +1,327 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * LiteX Liteeth Ethernet
> + *
> + * Copyright 2017 Joel Stanley <joel@jms.id.au>
> + *
> + */
> +
> +#include <linux/etherdevice.h>
> +#include <linux/interrupt.h>
> +#include <linux/litex.h>
> +#include <linux/module.h>
> +#include <linux/of_net.h>
> +#include <linux/platform_device.h>
> +
> +#define LITEETH_WRITER_SLOT       0x00
> +#define LITEETH_WRITER_LENGTH     0x04
> +#define LITEETH_WRITER_ERRORS     0x08
> +#define LITEETH_WRITER_EV_STATUS  0x0C
> +#define LITEETH_WRITER_EV_PENDING 0x10
> +#define LITEETH_WRITER_EV_ENABLE  0x14
> +#define LITEETH_READER_START      0x18
> +#define LITEETH_READER_READY      0x1C
> +#define LITEETH_READER_LEVEL      0x20
> +#define LITEETH_READER_SLOT       0x24
> +#define LITEETH_READER_LENGTH     0x28
> +#define LITEETH_READER_EV_STATUS  0x2C
> +#define LITEETH_READER_EV_PENDING 0x30
> +#define LITEETH_READER_EV_ENABLE  0x34
> +#define LITEETH_PREAMBLE_CRC      0x38
> +#define LITEETH_PREAMBLE_ERRORS   0x3C
> +#define LITEETH_CRC_ERRORS        0x40
> +
> +#define LITEETH_PHY_CRG_RESET     0x00
> +#define LITEETH_MDIO_W            0x04
> +#define LITEETH_MDIO_R            0x0C
> +
> +#define DRV_NAME	"liteeth"
> +
> +#define LITEETH_BUFFER_SIZE		0x800
> +#define MAX_PKT_SIZE			LITEETH_BUFFER_SIZE
> +
> +struct liteeth {
> +	void __iomem *base;
> +	struct net_device *netdev;
> +	struct device *dev;
> +
> +	/* Tx */
> +	int tx_slot;
> +	int num_tx_slots;
> +	void __iomem *tx_base;
> +
> +	/* Rx */
> +	int rx_slot;
> +	int num_rx_slots;
> +	void __iomem *rx_base;
> +};
> +
> +static int liteeth_rx(struct net_device *netdev)
> +{
> +	struct liteeth *priv = netdev_priv(netdev);
> +	struct sk_buff *skb;
> +	unsigned char *data;
> +	u8 rx_slot;
> +	int len;
> +
> +	rx_slot = litex_read8(priv->base + LITEETH_WRITER_SLOT);
> +	len = litex_read32(priv->base + LITEETH_WRITER_LENGTH);
> +
> +	if (len == 0 || len > 2048)
> +		goto rx_drop;
> +
> +	skb = netdev_alloc_skb_ip_align(netdev, len);
> +	if (!skb) {
> +		netdev_err(netdev, "couldn't get memory\n");
> +		goto rx_drop;
> +	}
> +
> +	data = skb_put(skb, len);
> +	memcpy_fromio(data, priv->rx_base + rx_slot * LITEETH_BUFFER_SIZE, len);
> +	skb->protocol = eth_type_trans(skb, netdev);
> +
> +	netdev->stats.rx_packets++;
> +	netdev->stats.rx_bytes += len;
> +
> +	return netif_rx(skb);
> +
> +rx_drop:
> +	netdev->stats.rx_dropped++;
> +	netdev->stats.rx_errors++;
> +
> +	return NET_RX_DROP;
> +}
> +
> +static irqreturn_t liteeth_interrupt(int irq, void *dev_id)
> +{
> +	struct net_device *netdev = dev_id;
> +	struct liteeth *priv = netdev_priv(netdev);
> +	u8 reg;
> +
> +	reg = litex_read8(priv->base + LITEETH_READER_EV_PENDING);
> +	if (reg) {
> +		if (netif_queue_stopped(netdev))
> +			netif_wake_queue(netdev);
> +		litex_write8(priv->base + LITEETH_READER_EV_PENDING, reg);
> +	}
> +
> +	reg = litex_read8(priv->base + LITEETH_WRITER_EV_PENDING);
> +	if (reg) {
> +		liteeth_rx(netdev);
> +		litex_write8(priv->base + LITEETH_WRITER_EV_PENDING, reg);
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int liteeth_open(struct net_device *netdev)
> +{
> +	struct liteeth *priv = netdev_priv(netdev);
> +	int err;
> +
> +	/* Clear pending events */
> +	litex_write8(priv->base + LITEETH_WRITER_EV_PENDING, 1);
> +	litex_write8(priv->base + LITEETH_READER_EV_PENDING, 1);
> +
> +	err = request_irq(netdev->irq, liteeth_interrupt, 0, netdev->name, netdev);
> +	if (err) {
> +		netdev_err(netdev, "failed to request irq %d\n", netdev->irq);
> +		return err;
> +	}
> +
> +	/* Enable IRQs */
> +	litex_write8(priv->base + LITEETH_WRITER_EV_ENABLE, 1);
> +	litex_write8(priv->base + LITEETH_READER_EV_ENABLE, 1);
> +
> +	netif_carrier_on(netdev);
> +	netif_start_queue(netdev);
> +
> +	return 0;
> +}
> +
> +static int liteeth_stop(struct net_device *netdev)
> +{
> +	struct liteeth *priv = netdev_priv(netdev);
> +
> +	netif_stop_queue(netdev);
> +	netif_carrier_off(netdev);
> +
> +	litex_write8(priv->base + LITEETH_WRITER_EV_ENABLE, 0);
> +	litex_write8(priv->base + LITEETH_READER_EV_ENABLE, 0);
> +
> +	free_irq(netdev->irq, netdev);
> +
> +	return 0;
> +}
> +
> +static int liteeth_start_xmit(struct sk_buff *skb, struct net_device *netdev)
> +{
> +	struct liteeth *priv = netdev_priv(netdev);
> +	void __iomem *txbuffer;
> +
> +	if (!litex_read8(priv->base + LITEETH_READER_READY)) {
> +		if (net_ratelimit())
> +			netdev_err(netdev, "LITEETH_READER_READY not ready\n");
> +
> +		netif_stop_queue(netdev);
> +
> +		return NETDEV_TX_BUSY;
> +	}
> +
> +	/* Reject oversize packets */
> +	if (unlikely(skb->len > MAX_PKT_SIZE)) {
> +		if (net_ratelimit())
> +			netdev_err(netdev, "tx packet too big\n");
> +
> +		dev_kfree_skb_any(skb);
> +		netdev->stats.tx_dropped++;
> +		netdev->stats.tx_errors++;
> +
> +		return NETDEV_TX_OK;
> +	}
> +
> +	txbuffer = priv->tx_base + priv->tx_slot * LITEETH_BUFFER_SIZE;
> +	memcpy_toio(txbuffer, skb->data, skb->len);
> +	litex_write8(priv->base + LITEETH_READER_SLOT, priv->tx_slot);
> +	litex_write16(priv->base + LITEETH_READER_LENGTH, skb->len);
> +	litex_write8(priv->base + LITEETH_READER_START, 1);
> +
> +	netdev->stats.tx_bytes += skb->len;
> +	netdev->stats.tx_packets++;
> +
> +	priv->tx_slot = (priv->tx_slot + 1) % priv->num_tx_slots;
> +	dev_kfree_skb_any(skb);
> +
> +	return NETDEV_TX_OK;
> +}
> +
> +static const struct net_device_ops liteeth_netdev_ops = {
> +	.ndo_open		= liteeth_open,
> +	.ndo_stop		= liteeth_stop,
> +	.ndo_start_xmit         = liteeth_start_xmit,
> +};
> +
> +int liteeth_setup_slots(struct liteeth *priv)
> +{
> +	struct device_node *np = priv->dev->of_node;
> +	int err, depth;
> +
> +	err = of_property_read_u32(np, "rx-fifo-depth", &depth);
> +	if (err) {
> +		dev_err(priv->dev, "unable to get rx-fifo-depth\n");
> +		return err;
> +	}
> +	if (depth < LITEETH_BUFFER_SIZE) {

If I set depth to be *equal* to LITEETH_BUFFER_SIZE (2048) in DTS,
no traffic makes it out of my network interface (linux-on-litex-rocket
on an ecpix5 board, see github.com/litex-hub/linux-on-litex-rocket).

May I suggest rejecting if (depth / LITEETH_BUFFER_SIZE < 2) instead?
When that's enforced, the interface actually works fine for me.

> +		dev_err(priv->dev, "invalid tx-fifo-depth: %d\n", depth);

This should read "rx-fifo-depth".

> +		return -EINVAL;
> +	}
> +	priv->num_rx_slots = depth / LITEETH_BUFFER_SIZE;
> +
> +	err = of_property_read_u32(np, "tx-fifo-depth", &depth);
> +	if (err) {
> +		dev_err(priv->dev, "unable to get tx-fifo-depth\n");
> +		return err;
> +	}
> +	if (depth < LITEETH_BUFFER_SIZE) {

Ditto reject if (depth / LITEETH_BUFFER_SIZE < 2) instead.

> +		dev_err(priv->dev, "invalid rx-fifo-depth: %d\n", depth);

This should read "tx-fifo-depth".

> +		return -EINVAL;
> +	}
> +	priv->num_tx_slots = depth / LITEETH_BUFFER_SIZE;
> +
> +	return 0;
> +}
> +
> +static int liteeth_probe(struct platform_device *pdev)
> +{
> +	struct net_device *netdev;
> +	void __iomem *buf_base;
> +	struct resource *res;
> +	struct liteeth *priv;
> +	int irq, err;
> +
> +	netdev = devm_alloc_etherdev(&pdev->dev, sizeof(*priv));
> +	if (!netdev)
> +		return -ENOMEM;
> +
> +	SET_NETDEV_DEV(netdev, &pdev->dev);
> +	platform_set_drvdata(pdev, netdev);
> +
> +	priv = netdev_priv(netdev);
> +	priv->netdev = netdev;
> +	priv->dev = &pdev->dev;
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "Failed to get IRQ %d\n", irq);
> +		return irq;

At this point, netdev has been dynamically allocated, and should
probably be free'd before liteeth_probe() is allowed to fail,
to avoid any potential leaks...

Something like "err = irq; goto err_free;" maybe?

> +	}
> +	netdev->irq = irq;
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mac");
> +	priv->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(priv->base))
> +		return PTR_ERR(priv->base);

goto err_free instead?

> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "buffer");
> +	buf_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(buf_base))
> +		return PTR_ERR(buf_base);

goto err_free, again?

Same for everywhere we return with an error, from here to the end of the
probe function...

> +
> +	err = liteeth_setup_slots(priv);
> +	if (err)
> +		return err;
> +
> +	/* Rx slots */
> +	priv->rx_base = buf_base;
> +	priv->rx_slot = 0;
> +
> +	/* Tx slots come after Rx slots */
> +	priv->tx_base = buf_base + priv->num_rx_slots * LITEETH_BUFFER_SIZE;
> +	priv->tx_slot = 0;
> +
> +	err = of_get_mac_address(pdev->dev.of_node, netdev->dev_addr);
> +	if (err)
> +		eth_hw_addr_random(netdev);
> +
> +	netdev->netdev_ops = &liteeth_netdev_ops;
> +
> +	err = register_netdev(netdev);
> +	if (err) {
> +		dev_err(&pdev->dev, "Failed to register netdev %d\n", err);
> +		return err;
> +	}
> +
> +	netdev_info(netdev, "irq %d tx slots %d rx slots %d",
> +		    netdev->irq, priv->num_tx_slots, priv->num_rx_slots);
> +
> +	return 0;

err_free:
	free_netdev(netdev);
	return err;

Thanks,
--Gabriel

> +}
> +
> +static int liteeth_remove(struct platform_device *pdev)
> +{
> +	struct net_device *netdev = platform_get_drvdata(pdev);
> +
> +	unregister_netdev(netdev);
> +	free_netdev(netdev);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id liteeth_of_match[] = {
> +	{ .compatible = "litex,liteeth" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, liteeth_of_match);
> +
> +static struct platform_driver liteeth_driver = {
> +	.probe = liteeth_probe,
> +	.remove = liteeth_remove,
> +	.driver = {
> +		.name = DRV_NAME,
> +		.of_match_table = liteeth_of_match,
> +	},
> +};
> +module_platform_driver(liteeth_driver);
> +
> +MODULE_AUTHOR("Joel Stanley <joel@jms.id.au>");
> +MODULE_LICENSE("GPL");
> -- 
> 2.32.0
> 
