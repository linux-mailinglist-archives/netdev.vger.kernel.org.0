Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8920D4FC14
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 16:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfFWOv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 10:51:29 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46475 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFWOv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 10:51:29 -0400
Received: by mail-pl1-f196.google.com with SMTP id e5so5404235pls.13
        for <netdev@vger.kernel.org>; Sun, 23 Jun 2019 07:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9aswWNf5856xYMZUnpB6wJcl00EhCG2Y2NQ+kXBx/AA=;
        b=cKLOvjq64ytEr6SP/gHS2Faw6FquubyVXanbJoKEZpmCK9G+ghXYQbdADAnveeI4Jv
         TbX34ZNM690GYvLdXP+DeR1zsM4bnmFYRpednpFeQfnjYHJQIDryDZq09Fqro86IjrkG
         pew3OkZowtcZRD0kP5dGV2UIs+k8fjOm2jbECbLO9VeYecaOs05GVCmPQeilMvOegCms
         ZqGrVFmAinRPC6266122Lccszikh3HFFr38D4WsS0qfUVr9TyM+fjvZ48UuJ12dY2fgZ
         FVPPi4sU9qJjunPR5qvvQqo1IwNIaDL9Y2C0n1c8QLUcczFYGlLxON/gEvWbcjJ59fSe
         gUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9aswWNf5856xYMZUnpB6wJcl00EhCG2Y2NQ+kXBx/AA=;
        b=FsVrCXlRZoOl3N1jeD6vOyj2HHb6n7Tg79a2yu5ROnyqw6p2pXFrXidaEgMXF6XbnI
         400wFsD3qvq8LOeXEnCu05krCFDxK07AAUqFKPjSCawepSZQPYbktQN7UIKpwCCXWo6B
         IFUJWl5Jw+3buMOxLqvbC1xMjjVHQdyhsLFCgBGyBBjZrH2OrZu4gsSZBLuodKuFCz6a
         vuy24rlLLu4VOxyWN6InouYqtstKJsEfFxGaIQQxHMBl703QQ1PeHCv21zS5tLNSFGG1
         HzbtfCp578U+Idna09B5L5gwXxiTmtycjswp18q6XX/6YbBfnqpCagMOPuc8WKgaeZ3b
         /YrQ==
X-Gm-Message-State: APjAAAWdQB9NhxxwMozacTc/SgrYDmPDSTKJ+9PNIjeOT6I7SYf+Kz+/
        ZygucQcWMoDSCcIq5svB8+REFDq4hdE=
X-Google-Smtp-Source: APXvYqyoFTJSg0cZq2qWfb198e/qqCEJOwo88CbaHyC0H5ZRCmXf+KNudb4WdfvhI1NoaC2oxq2mww==
X-Received: by 2002:a17:902:6848:: with SMTP id f8mr12400577pln.102.1561301488073;
        Sun, 23 Jun 2019 07:51:28 -0700 (PDT)
Received: from localhost ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id f17sm8255563pgv.16.2019.06.23.07.51.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 23 Jun 2019 07:51:27 -0700 (PDT)
Date:   Sun, 23 Jun 2019 16:51:11 +0200
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
To:     <sameehj@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: Re: [RFC V1 net-next 1/1] net: ena: implement XDP drop support
Message-ID: <20190623165111.00001300@gmail.com>
In-Reply-To: <20190623070649.18447-2-sameehj@amazon.com>
References: <20190623070649.18447-1-sameehj@amazon.com>
        <20190623070649.18447-2-sameehj@amazon.com>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 Jun 2019 10:06:49 +0300
<sameehj@amazon.com> wrote:

> From: Sameeh Jubran <sameehj@amazon.com>
> 
> This commit implements the basic functionality of drop/pass logic in the
> ena driver.
> 
> Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 83 +++++++++++++++++++-
>  drivers/net/ethernet/amazon/ena/ena_netdev.h | 29 +++++++
>  2 files changed, 111 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 20ec8ff03..3d65c0771 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -33,10 +33,10 @@
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
>  #ifdef CONFIG_RFS_ACCEL
> +#include <linux/bpf_trace.h>
>  #include <linux/cpu_rmap.h>
>  #endif /* CONFIG_RFS_ACCEL */
>  #include <linux/ethtool.h>
> -#include <linux/if_vlan.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/numa.h>
> @@ -105,11 +105,82 @@ static void update_rx_ring_mtu(struct ena_adapter *adapter, int mtu)
>  		adapter->rx_ring[i].mtu = mtu;
>  }
>  
> +static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
> +{
> +	struct bpf_prog *xdp_prog = rx_ring->xdp_bpf_prog;
> +	u32 verdict = XDP_PASS;
> +
> +	rcu_read_lock();
> +
> +	if (!xdp_prog)
> +		goto out;
> +
> +	verdict = bpf_prog_run_xdp(xdp_prog, xdp);
> +
> +	if (unlikely(verdict == XDP_ABORTED))
> +		trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
> +	else if (unlikely(verdict > XDP_REDIRECT))

Shouldn't this be verdict >= XDP_TX at this point? You're not providing XDP TX
resources in this patch and you're saying that only drop/pass actions are
supported.

> +		bpf_warn_invalid_xdp_action(verdict);
> +out:
> +	rcu_read_unlock();
> +	return verdict;
> +}
> +
> +static int ena_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
> +{
> +	struct ena_adapter *adapter = netdev_priv(netdev);
> +	struct bpf_prog *old_bpf_prog;
> +	int i;
> +
> +	if (ena_xdp_allowed(adapter)) {
> +		old_bpf_prog = xchg(&adapter->xdp_bpf_prog, prog);
> +
> +		for (i = 0; i < adapter->num_queues; i++)
> +			xchg(&adapter->rx_ring[i].xdp_bpf_prog, prog);
> +
> +		if (old_bpf_prog)
> +			bpf_prog_put(old_bpf_prog);
> +
> +	} else {
> +		netif_err(adapter, drv, adapter->netdev, "Failed to set xdp program, the current MTU (%d) is larger than the maximal allowed MTU (%lu) while xdp is on",
> +			  netdev->mtu, ENA_XDP_MAX_MTU);

Consider using netlink's extack mechanism. Downside of this approach is that you
can't use format specifiers, so you won't tell user about the max allowed mtu
size for XDP case, but OTOH the message is printed right in front of user's
face in console, no need to look into dmesg.

> +		return -EFAULT;
> +	}
> +
> +	return 0;
> +}
> +
> +/* This is the main xdp callback, it's used by the kernel to set/unset the xdp
> + * program as well as to query the current xdp program id.
> + */
> +static int ena_xdp(struct net_device *netdev, struct netdev_bpf *bpf)
> +{
> +	struct ena_adapter *adapter = netdev_priv(netdev);
> +
> +	switch (bpf->command) {
> +	case XDP_SETUP_PROG:
> +		return ena_xdp_set(netdev, bpf->prog);
> +	case XDP_QUERY_PROG:
> +		bpf->prog_id = adapter->xdp_bpf_prog ?
> +			adapter->xdp_bpf_prog->aux->id : 0;
> +		break;
> +	default:

Again, consider the following:
NL_SET_ERR_MSG_MOD(bpf->extack, "Unsupported XDP command");

> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
>  static int ena_change_mtu(struct net_device *dev, int new_mtu)
>  {
>  	struct ena_adapter *adapter = netdev_priv(dev);
>  	int ret;
>  
> +	if (new_mtu > ENA_XDP_MAX_MTU && ena_xdp_present(adapter)) {
> +		netif_err(adapter, drv, dev,
> +			  "Requested MTU value is not valid while xdp is enabled new_mtu: %d max mtu: %lu min mtu: %d\n",
> +			  new_mtu, ENA_XDP_MAX_MTU, ENA_MIN_MTU);
> +		return -EINVAL;
> +	}
>  	ret = ena_com_set_dev_mtu(adapter->ena_dev, new_mtu);
>  	if (!ret) {
>  		netif_dbg(adapter, drv, dev, "set MTU to %d\n", new_mtu);
> @@ -888,6 +959,15 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
>  	va = page_address(rx_info->page) + rx_info->page_offset;
>  	prefetch(va + NET_IP_ALIGN);
>  
> +	if (ena_xdp_present_ring(rx_ring)) {
> +		rx_ring->xdp.data = va;
> +		rx_ring->xdp.data_meta = rx_ring->xdp.data;
> +		rx_ring->xdp.data_hard_start = rx_ring->xdp.data -
> +			rx_info->page_offset;
> +		rx_ring->xdp.data_end = rx_ring->xdp.data + len;
> +		if (ena_xdp_execute(rx_ring, &rx_ring->xdp) != XDP_PASS)
> +			return NULL;
> +	}

Hmm running XDP program within the function that is supposed to handle skb
seems a bit not intuitive. Couldn't you have this logic before the ena_rx_skb()
call in ena_clean_rx_irq?

Another thing, from performance perspective IMO it would be better to operate on
local struct xdp_buff, rather than accessing it from rx_ring.

>  	if (len <= rx_ring->rx_copybreak) {
>  		skb = ena_alloc_skb(rx_ring, false);
>  		if (unlikely(!skb))
> @@ -2549,6 +2629,7 @@ static const struct net_device_ops ena_netdev_ops = {
>  	.ndo_change_mtu		= ena_change_mtu,
>  	.ndo_set_mac_address	= NULL,
>  	.ndo_validate_addr	= eth_validate_addr,
> +	.ndo_bpf		= ena_xdp,
>  };
>  
>  static int ena_device_validate_params(struct ena_adapter *adapter,
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
> index f2b6e2e05..e17965f7a 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
> @@ -35,6 +35,7 @@
>  
>  #include <linux/bitops.h>
>  #include <linux/etherdevice.h>
> +#include <linux/if_vlan.h>
>  #include <linux/inetdevice.h>
>  #include <linux/interrupt.h>
>  #include <linux/netdevice.h>
> @@ -139,6 +140,14 @@
>  
>  #define ENA_MMIO_DISABLE_REG_READ	BIT(0)
>  
> +/* The max MTU size is configured to be the ethernet frame without the overhead
> + * of the ethernet header, which can have VLAN header, and the frame check
> + * sequence (FCS).
> + * The buffer sizes we share with the device are defined to be ENA_PAGE_SIZE
> + */
> +#define ENA_XDP_MAX_MTU (ENA_PAGE_SIZE - ETH_HLEN - ETH_FCS_LEN - \
> +				VLAN_HLEN)
> +
>  struct ena_irq {
>  	irq_handler_t handler;
>  	void *data;
> @@ -288,6 +297,8 @@ struct ena_ring {
>  
>  	u8 *push_buf_intermediate_buf;
>  	int empty_rx_queue;
> +	struct bpf_prog *xdp_bpf_prog;
> +	struct xdp_buff xdp;
>  } ____cacheline_aligned;
>  
>  struct ena_stats_dev {
> @@ -380,6 +391,9 @@ struct ena_adapter {
>  	enum ena_regs_reset_reason_types reset_reason;
>  
>  	u8 ena_extra_properties_count;
> +
> +	/* XDP structures */
> +	struct bpf_prog *xdp_bpf_prog;
>  };
>  
>  void ena_set_ethtool_ops(struct net_device *netdev);
> @@ -394,4 +408,19 @@ int ena_update_queue_sizes(struct ena_adapter *adapter,
>  
>  int ena_get_sset_count(struct net_device *netdev, int sset);
>  
> +static inline bool ena_xdp_present(struct ena_adapter *adapter)
> +{
> +	return !!adapter->xdp_bpf_prog;
> +}
> +
> +static inline bool ena_xdp_present_ring(struct ena_ring *ring)
> +{
> +	return !!ring->xdp_bpf_prog;
> +}
> +
> +static inline bool ena_xdp_allowed(struct ena_adapter *adapter)
> +{
> +	return adapter->netdev->mtu <= ENA_XDP_MAX_MTU;
> +}
> +
>  #endif /* !(ENA_H) */

