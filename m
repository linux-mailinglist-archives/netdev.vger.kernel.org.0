Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBC456607
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 11:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfFZJ6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 05:58:48 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36731 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbfFZJ6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 05:58:48 -0400
Received: by mail-lj1-f196.google.com with SMTP id i21so1549024ljj.3
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 02:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PBNpa0fe2lxiY3oi4Yz97EGdJS/d5sgIDQQHO7FmfTA=;
        b=mpA7e48X0kGmTm3SqWODh2AldqmI9ON5GZZDMgX88qKXh7+Zh6JmvYSO52wYCEMRk8
         A2QSiiA+GeS+mND14bUi+upQs5qbkjKdZccB7AOiQ6tgFbqDf+6mdVGOD2VJuXY7gYeN
         /zz6InGlg2xdTIpcd7xrMjq3mllZLXrHUdiyttPKu53akQ+iozXgFMeTzjMIOtRUD4mO
         BdqO7FRCjjh+6elVPjSfn41Zj4+A9CFfCuGOpELQwy7e+5uhzrNu8jAzP0vl5wzCsron
         /PSzq2KW4X3MhH9z6BO/v5u5rjqu+IOaXrba8KigQgO4+Z1L1qJK/AdA2XMJXTEWEolF
         MJLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=PBNpa0fe2lxiY3oi4Yz97EGdJS/d5sgIDQQHO7FmfTA=;
        b=lRkD4JhyGi/+WbtuZF1vyrCZ6KYUAlEXlUY75bq1CaygUjQgAo/CnmuMNCmO5EIiOt
         QGk7D9xWkoftokiE2WvJ7GpEDbScxHshYTHG5ZxiIjxGAuJxrLzH50+eZho1k6TbDxbR
         Muz7KWtVeg+rXNXikwiiAQ4NKwr+9widvWG9QNRwJFanEmC/SJ8ipONAERfVBMh2pQ59
         hP/rDKQZMmK0R/XSCx3pLKs2q1CZEzFDSEnvGRK1j5RIUkbEXhKgWALqfPewhVyPdwTK
         1SB1XMiYw0KatE8Xqd5UU/mZgAN9bhtuLSoKIs4vUpHb2VQgsBq84kSSsFCt6vBo9apR
         2O1w==
X-Gm-Message-State: APjAAAUGM66USRnRVJjV6nnOpLJvigF2rGcIVpKDXmKEA3voavR1yEii
        J/yHvWfATUrzJ4jBchYJTxXnOA==
X-Google-Smtp-Source: APXvYqzNFxfVX9de86L2UgFlGfdLdsNudfKlSAPxlO8JRkFe2MYug9gl6HUyXx7EFq3ektf6gSJ+0w==
X-Received: by 2002:a2e:5c88:: with SMTP id q130mr2398685ljb.176.1561543125048;
        Wed, 26 Jun 2019 02:58:45 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id z83sm2732080ljb.73.2019.06.26.02.58.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Jun 2019 02:58:44 -0700 (PDT)
Date:   Wed, 26 Jun 2019 12:58:42 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [RFC PATCH v4 net-next 06/11] net: ethernet: ti: introduce cpsw
 switchdev based driver part 1 - dual-emac
Message-ID: <20190626095839.GE6485@khorivan>
Mail-Followup-To: Grygorii Strashko <grygorii.strashko@ti.com>,
        netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org
References: <20190621181314.20778-1-grygorii.strashko@ti.com>
 <20190621181314.20778-7-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190621181314.20778-7-grygorii.strashko@ti.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Grygorii

Too much code, but I've tried pass thru.
Probably expectation the devlink to be reviewed, but several
common replies that should be reflected in non RFC v.

On Fri, Jun 21, 2019 at 09:13:09PM +0300, Grygorii Strashko wrote:
>From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
>
>Part 1:
> Introduce basic CPSW dual_mac driver (cpsw_new.c) which is operating in
>dual-emac mode by default, thus working as 2 individual network interfaces.
>Main differences from legacy CPSW driver are:
>
> - optimized promiscuous mode: The P0_UNI_FLOOD (both ports) is enabled in
>addition to ALLMULTI (current port) instead of ALE_BYPASS. So, Ports in
>promiscuous mode will keep possibility of mcast and vlan filtering, which
>is provides significant benefits when ports are joined to the same bridge,
>but without enabling "switch" mode, or to different bridges.
> - learning disabled on ports as it make not too much sense for
>   segregated ports - no forwarding in HW.
> - enabled basic support for devlink.
>
>	devlink dev show
>		platform/48484000.ethernet_switch
>
>	devlink dev param show
>	 platform/48484000.ethernet_switch:
>	name ale_bypass type driver-specific
>	 values:
>		cmode runtime value false
>
> - "ale_bypass" devlink driver parameter allows to enable
>ALE_CONTROL(4).BYPASS mode for debug purposes.
> - updated DT bindings.
>
>Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
>Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>---
> drivers/net/ethernet/ti/Kconfig     |   19 +-
> drivers/net/ethernet/ti/Makefile    |    2 +
> drivers/net/ethernet/ti/cpsw_new.c  | 1555 +++++++++++++++++++++++++++
> drivers/net/ethernet/ti/cpsw_priv.c |    8 +-
> drivers/net/ethernet/ti/cpsw_priv.h |   12 +-
> 5 files changed, 1591 insertions(+), 5 deletions(-)
> create mode 100644 drivers/net/ethernet/ti/cpsw_new.c
>

[...]

>+
>+static void cpsw_rx_handler(void *token, int len, int status)
>+{
>+	struct sk_buff *skb = token;
>+	struct cpsw_common *cpsw;
>+	struct net_device *ndev;
>+	struct sk_buff *new_skb;
>+	struct cpsw_priv *priv;
>+	struct cpdma_chan *ch;
>+	int ret = 0, port;
>+
>+	ndev = skb->dev;
>+	cpsw = ndev_to_cpsw(ndev);
>+
>+	port = CPDMA_RX_SOURCE_PORT(status);
>+	if (port) {
>+		ndev = cpsw->slaves[--port].ndev;
>+		skb->dev = ndev;
>+	}
>+
>+	if (unlikely(status < 0) || unlikely(!netif_running(ndev))) {
>+		/* In dual emac mode check for all interfaces */
>+		if (cpsw->usage_count && status >= 0) {
>+			/* The packet received is for the interface which
>+			 * is already down and the other interface is up
>+			 * and running, instead of freeing which results
>+			 * in reducing of the number of rx descriptor in
>+			 * DMA engine, requeue skb back to cpdma.
>+			 */
>+			new_skb = skb;
>+			goto requeue;
>+		}
>+
>+		/* the interface is going down, skbs are purged */
>+		dev_kfree_skb_any(skb);
>+		return;
>+	}
>+
>+	priv = netdev_priv(ndev);
>+
>+	new_skb = netdev_alloc_skb_ip_align(ndev, cpsw->rx_packet_max);
>+	if (new_skb) {
>+		skb_copy_queue_mapping(new_skb, skb);
>+		skb_put(skb, len);
>+		if (status & CPDMA_RX_VLAN_ENCAP)
>+			cpsw_rx_vlan_encap(skb);
>+		if (priv->rx_ts_enabled)
>+			cpts_rx_timestamp(cpsw->cpts, skb);
>+		skb->protocol = eth_type_trans(skb, ndev);
>+		netif_receive_skb(skb);
>+		ndev->stats.rx_bytes += len;
>+		ndev->stats.rx_packets++;
>+		/* CPDMA stores skb in internal CPPI RAM (SRAM) which belongs
>+		 * to DEV MMIO space. Kmemleak does not scan IO memory and so
>+		 * reports memory leaks.
>+		 * see commit 254a49d5139a ('drivers: net: cpsw: fix kmemleak
>+		 * false-positive reports for sk buffers') for details.
>+		 */
>+		kmemleak_not_leak(new_skb);
>+	} else {
>+		ndev->stats.rx_dropped++;
>+		new_skb = skb;
>+	}
>+
>+requeue:

----
>+	if (netif_dormant(ndev)) {
>+		dev_kfree_skb_any(new_skb);
>+		return;
>+	}
---

drop above, no need any more

>+
>+	ch = cpsw->rxv[skb_get_queue_mapping(new_skb)].ch;
>+	ret = cpdma_chan_submit(ch, new_skb, new_skb->data,
>+				skb_tailroom(new_skb), 0);
>+	if (WARN_ON(ret < 0))
>+		dev_kfree_skb_any(new_skb);

Here were a little changes last time, looks like:

	ret = cpdma_chan_submit(ch, new_skb, new_skb->data,
				skb_tailroom(new_skb), 0);
	if (ret < 0) {
		WARN_ON(ret == -ENOMEM);
		dev_kfree_skb_any(new_skb);
	}

>+}
>+

[...]

>+
>+static void cpsw_init_host_port(struct cpsw_priv *priv)
>+{
>+	struct cpsw_common *cpsw = priv->cpsw;
>+	u32 control_reg;
>+
>+	/* soft reset the controller and initialize ale */
>+	soft_reset("cpsw", &cpsw->regs->soft_reset);
>+	cpsw_ale_start(cpsw->ale);
>+
>+	/* switch to vlan unaware mode */
>+	cpsw_ale_control_set(cpsw->ale, HOST_PORT_NUM, ALE_VLAN_AWARE,
>+			     CPSW_ALE_VLAN_AWARE);
>+	control_reg = readl(&cpsw->regs->control);
>+	control_reg |= CPSW_VLAN_AWARE | CPSW_RX_VLAN_ENCAP;
>+	writel(control_reg, &cpsw->regs->control);
>+
>+	/* setup host port priority mapping */
>+	writel_relaxed(CPDMA_TX_PRIORITY_MAP,
>+		       &cpsw->host_port_regs->cpdma_tx_pri_map);
>+	writel_relaxed(0, &cpsw->host_port_regs->cpdma_rx_chan_map);

----
>+
>+	/* disable priority elevation */
>+	writel_relaxed(0, &cpsw->regs->ptype);
>+
>+	/* enable statistics collection only on all ports */
>+	writel_relaxed(0x7, &cpsw->regs->stat_port_en);
>+
>+	/* Enable internal fifo flow control */
>+	writel(0x7, &cpsw->regs->flow_control);
---

Would be nice to do the same in old driver.
I mean moving it from ndo_open
Also were thoughts about this.

>+
>+	cpsw_init_host_port_dual_mac(priv);
>+
>+	cpsw_ale_control_set(cpsw->ale, HOST_PORT_NUM,
>+			     ALE_PORT_STATE, ALE_PORT_STATE_FORWARD);
>+}
>+

[...]

>+
>+static int cpsw_ndo_open(struct net_device *ndev)
>+{
>+	struct cpsw_priv *priv = netdev_priv(ndev);
>+	struct cpsw_common *cpsw = priv->cpsw;
>+	int ret;
>+
>+	cpsw_info(priv, ifdown, "starting ndev\n");
>+	ret = pm_runtime_get_sync(cpsw->dev);
>+	if (ret < 0) {
>+		pm_runtime_put_noidle(cpsw->dev);
>+		return ret;
>+	}
>+
>+	netif_carrier_off(ndev);
>+
>+	/* Notify the stack of the actual queue counts. */
>+	ret = netif_set_real_num_tx_queues(ndev, cpsw->tx_ch_num);
>+	if (ret) {
>+		dev_err(priv->dev, "cannot set real number of tx queues\n");
>+		goto err_cleanup;
>+	}
>+
>+	ret = netif_set_real_num_rx_queues(ndev, cpsw->rx_ch_num);
>+	if (ret) {
>+		dev_err(priv->dev, "cannot set real number of rx queues\n");
>+		goto err_cleanup;
>+	}
>+
>+	/* Initialize host and slave ports */
>+	if (!cpsw->usage_count)
>+		cpsw_init_host_port(priv);
>+	cpsw_slave_open(&cpsw->slaves[priv->emac_port - 1], priv);
>+
>+	/* initialize shared resources for every ndev */
>+	if (!cpsw->usage_count) {
>+		ret = cpsw_fill_rx_channels(priv);
>+		if (ret < 0)
>+			goto err_cleanup;
>+
>+		if (cpts_register(cpsw->cpts))
>+			dev_err(priv->dev, "error registering cpts device\n");
>+
>+		napi_enable(&cpsw->napi_rx);
>+		napi_enable(&cpsw->napi_tx);
>+
>+		if (cpsw->tx_irq_disabled) {
>+			cpsw->tx_irq_disabled = false;
>+			enable_irq(cpsw->irqs_table[1]);
>+		}
>+
>+		if (cpsw->rx_irq_disabled) {
>+			cpsw->rx_irq_disabled = false;
>+			enable_irq(cpsw->irqs_table[0]);
>+		}
>+	}
>+
>+	cpsw_restore(priv);
>+
>+	/* Enable Interrupt pacing if configured */
>+	if (cpsw->coal_intvl != 0) {
>+		struct ethtool_coalesce coal;
>+
>+		coal.rx_coalesce_usecs = cpsw->coal_intvl;
>+		cpsw_set_coalesce(ndev, &coal);
>+	}
>+
>+	cpdma_ctlr_start(cpsw->dma);
>+	cpsw_intr_enable(cpsw);
>+	cpsw->usage_count++;
>+
>+	return 0;
>+
>+err_cleanup:
>+	cpdma_ctlr_stop(cpsw->dma);
Here were a little changes also:
Now looks like:
	if (!cpsw->usage_count) {
		cpdma_ctlr_stop(cpsw->dma)
	}


>+	cpsw_slave_stop(&cpsw->slaves[priv->emac_port - 1], priv);
>+	pm_runtime_put_sync(cpsw->dev);
>+	netif_carrier_off(priv->ndev);
>+	return ret;
>+}
>+

[...]

>+
>+static netdev_tx_t cpsw_ndo_start_xmit(struct sk_buff *skb,
>+				       struct net_device *ndev)
>+{
>+	struct cpsw_priv *priv = netdev_priv(ndev);
>+	struct cpsw_common *cpsw = priv->cpsw;
>+	struct cpts *cpts = cpsw->cpts;
>+	struct netdev_queue *txq;
>+	struct cpdma_chan *txch;
>+	int ret, q_idx;
>+
>+	if (skb_padto(skb, CPSW_MIN_PACKET_SIZE)) {
>+		cpsw_err(priv, tx_err, "packet pad failed\n");
>+		ndev->stats.tx_dropped++;
>+		return NET_XMIT_DROP;
>+	}
>+
>+	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
>+	    priv->tx_ts_enabled && cpts_can_timestamp(cpts, skb))
>+		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
>+
>+	q_idx = skb_get_queue_mapping(skb);
>+	if (q_idx >= cpsw->tx_ch_num)
>+		q_idx = q_idx % cpsw->tx_ch_num;
>+
>+	txch = cpsw->txv[q_idx].ch;
>+	txq = netdev_get_tx_queue(ndev, q_idx);
>+	skb_tx_timestamp(skb);
>+	ret = cpdma_chan_submit(txch, skb, skb->data, skb->len,
>+				priv->emac_port);
------------

>+	if (unlikely(ret != 0)) {
>+		cpsw_err(priv, tx_err, "desc submit failed\n");
>+		goto fail;
>+	}
>+
>+	/* If there is no more tx desc left free then we need to
>+	 * tell the kernel to stop sending us tx frames.
>+	 */
>+	if (unlikely(!cpdma_check_free_tx_desc(txch))) {
>+		netif_tx_stop_queue(txq);
>+
>+		/* Barrier, so that stop_queue visible to other cpus */
>+		smp_mb__after_atomic();
>+
>+		if (cpdma_check_free_tx_desc(txch))
>+			netif_tx_wake_queue(txq);
>+	}
>+
>+	return NETDEV_TX_OK;
>+fail:
>+	ndev->stats.tx_dropped++;
>+	netif_tx_stop_queue(txq);
>+
>+	/* Barrier, so that stop_queue visible to other cpus */
>+	smp_mb__after_atomic();
>+
>+	if (cpdma_check_free_tx_desc(txch))
>+		netif_tx_wake_queue(txq);
>+
>+	return NETDEV_TX_BUSY;
>+}
-------------

I have a proposition, here were no reason lastly, but now maybe
it can be optimized a little. Smth like, replace above on:

	if (unlikely(ret != 0)) {
		cpsw_err(priv, tx_err, "desc submit failed\n");
		ndev->stats.tx_dropped++;
		ret = NETDEV_TX_BUSY;
		goto fail
	}

	ret = NETDEV_TX_OK;

	/* If there is no more tx desc left free then we need to
	 * tell the kernel to stop sending us tx frames.
	 */
	if (unlikely(cpdma_check_free_tx_desc(txch)))
		return ret;

fail:
	netif_tx_stop_queue(txq);

	/* Barrier, so that stop_queue visible to other cpus */
	smp_mb__after_atomic();

	if (cpdma_check_free_tx_desc(txch))
		netif_tx_wake_queue(txq);

	return ret;

Result: minus 6 lines and less dupes.

>+
>+

[...]

>+static int cpsw_probe(struct platform_device *pdev)
>+{
>+	const struct soc_device_attribute *soc;
>+	struct device *dev = &pdev->dev;
>+	struct resource *ss_res;
>+	struct cpsw_common *cpsw;
>+	struct gpio_descs *mode;
>+	void __iomem *ss_regs;
>+	int ret = 0, ch;
>+	struct clk *clk;
>+	int irq;
>+
>+	cpsw = devm_kzalloc(dev, sizeof(struct cpsw_common), GFP_KERNEL);
>+	if (!cpsw)
>+		return -ENOMEM;
>+
>+	cpsw_slave_index = cpsw_slave_index_priv;
>+
>+	cpsw->dev = dev;
>+
>+	cpsw->slaves = devm_kcalloc(dev,
>+				    CPSW_SLAVE_PORTS_NUM,
>+				    sizeof(struct cpsw_slave),
>+				    GFP_KERNEL);
>+	if (!cpsw->slaves)
>+		return -ENOMEM;
>+
>+	mode = devm_gpiod_get_array_optional(dev, "mode", GPIOD_OUT_LOW);
>+	if (IS_ERR(mode)) {
>+		ret = PTR_ERR(mode);
>+		dev_err(dev, "gpio request failed, ret %d\n", ret);
>+		return ret;
>+	}
>+
>+	clk = devm_clk_get(dev, "fck");
>+	if (IS_ERR(clk)) {
>+		ret = PTR_ERR(clk);
>+		dev_err(dev, "fck is not found %d\n", ret);
>+		return ret;
>+	}
>+	cpsw->bus_freq_mhz = clk_get_rate(clk) / 1000000;
>+
>+	ss_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>+	ss_regs = devm_ioremap_resource(dev, ss_res);
>+	if (IS_ERR(ss_regs)) {
>+		ret = PTR_ERR(ss_regs);
>+		return ret;
>+	}
>+	cpsw->regs = ss_regs;
>+
>+	irq = platform_get_irq_byname(pdev, "rx");
>+	if (irq < 0)
>+		return irq;
>+	cpsw->irqs_table[0] = irq;
>+
>+	irq = platform_get_irq_byname(pdev, "tx");
>+	if (irq < 0)
>+		return irq;
>+	cpsw->irqs_table[1] = irq;
>+
>+	platform_set_drvdata(pdev, cpsw);
set cpsw, but below ndev

>+	/* This may be required here for child devices. */
>+	pm_runtime_enable(dev);
>+
>+	/* Need to enable clocks with runtime PM api to access module
>+	 * registers
>+	 */
>+	ret = pm_runtime_get_sync(dev);
>+	if (ret < 0) {
>+		pm_runtime_put_noidle(dev);
>+		pm_runtime_disable(dev);
>+		return ret;
>+	}
>+
>+	ret = cpsw_probe_dt(cpsw);
>+	if (ret)
>+		goto clean_dt_ret;
>+
>+	soc = soc_device_match(cpsw_soc_devices);
>+	if (soc)
>+		cpsw->quirk_irq = 1;
>+
>+	cpsw->rx_packet_max = rx_packet_max;
>+	cpsw->descs_pool_size = descs_pool_size;
>+
>+	ret = cpsw_init_common(cpsw, ss_regs, ale_ageout,
>+			       (u32 __force)ss_res->start + CPSW2_BD_OFFSET,
>+			       descs_pool_size);
>+	if (ret)
>+		goto clean_dt_ret;
>+
>+	cpsw->wr_regs = cpsw->version == CPSW_VERSION_1 ?
>+			ss_regs + CPSW1_WR_OFFSET :
>+			ss_regs + CPSW2_WR_OFFSET;
>+
>+	ch = cpsw->quirk_irq ? 0 : 7;
>+	cpsw->txv[0].ch = cpdma_chan_create(cpsw->dma, ch, cpsw_tx_handler, 0);
>+	if (IS_ERR(cpsw->txv[0].ch)) {
>+		dev_err(dev, "error initializing tx dma channel\n");
>+		ret = PTR_ERR(cpsw->txv[0].ch);
>+		goto clean_cpts;
>+	}
>+
>+	cpsw->rxv[0].ch = cpdma_chan_create(cpsw->dma, 0, cpsw_rx_handler, 1);
>+	if (IS_ERR(cpsw->rxv[0].ch)) {
>+		dev_err(dev, "error initializing rx dma channel\n");
>+		ret = PTR_ERR(cpsw->rxv[0].ch);
>+		goto clean_cpts;
>+	}
>+	cpsw_split_res(cpsw);
>+
>+	/* setup netdevs */
>+	ret = cpsw_create_ports(cpsw);
>+	if (ret)
>+		goto clean_unregister_netdev;
>+
>+	/* Grab RX and TX IRQs. Note that we also have RX_THRESHOLD and
>+	 * MISC IRQs which are always kept disabled with this driver so
>+	 * we will not request them.
>+	 *
>+	 * If anyone wants to implement support for those, make sure to
>+	 * first request and append them to irqs_table array.
>+	 */
>+
>+	ret = devm_request_irq(dev, cpsw->irqs_table[0], cpsw_rx_interrupt,
>+			       0, dev_name(dev), cpsw);
>+	if (ret < 0) {
>+		dev_err(dev, "error attaching irq (%d)\n", ret);
>+		goto clean_unregister_netdev;
>+	}
>+
>+	ret = devm_request_irq(dev, cpsw->irqs_table[1], cpsw_tx_interrupt,
>+			       0, dev_name(dev), cpsw);
>+	if (ret < 0) {
>+		dev_err(dev, "error attaching irq (%d)\n", ret);
>+		goto clean_unregister_netdev;
>+	}
>+
>+	ret = cpsw_register_devlink(cpsw);
>+	if (ret)
>+		goto clean_unregister_netdev;
>+
>+	dev_notice(dev, "initialized (regs %pa, pool size %d) hw_ver:%08X %d.%d (%d)\n",
>+		   &ss_res->start, descs_pool_size,
>+		   cpsw->version, CPSW_MAJOR_VERSION(cpsw->version),
>+		   CPSW_MINOR_VERSION(cpsw->version),
>+		   CPSW_RTL_VERSION(cpsw->version));
>+
>+	pm_runtime_put(dev);
>+
>+	return 0;
>+
>+clean_unregister_netdev:
>+	cpsw_unregister_ports(cpsw);
>+clean_cpts:
>+	cpts_release(cpsw->cpts);
>+	cpdma_ctlr_destroy(cpsw->dma);
>+clean_dt_ret:
>+	cpsw_remove_dt(cpsw);
>+	pm_runtime_put_sync(dev);
>+	pm_runtime_disable(dev);
>+	return ret;
>+}
>+
>+static int cpsw_remove(struct platform_device *pdev)
>+{
>+	struct net_device *ndev = platform_get_drvdata(pdev);
now it's cpsw, as in probe?

>+	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
>+	int ret;
>+
>+	ret = pm_runtime_get_sync(&pdev->dev);
>+	if (ret < 0) {
>+		pm_runtime_put_noidle(&pdev->dev);
>+		return ret;
>+	}
>+
>+	cpsw_unregister_devlink(cpsw);
>+	cpsw_unregister_ports(cpsw);
>+
>+	cpts_release(cpsw->cpts);
>+	cpdma_ctlr_destroy(cpsw->dma);
>+	cpsw_remove_dt(cpsw);
>+	pm_runtime_put_sync(&pdev->dev);
>+	pm_runtime_disable(&pdev->dev);
>+	return 0;
>+}
>+

[...]

-- 
Regards,
Ivan Khoronzhuk
