Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB28F20348B
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 12:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgFVKKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 06:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbgFVKKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 06:10:13 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E2AC061794
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 03:10:13 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id g18so6978267wrm.2
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 03:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=RvYwhlKHnbE7IMX02D/u+6KXVc8W2QDwTYDhW8eoE0Q=;
        b=aGRSTuAUJ5LTn/urzYahmsKkXwr1F4t8dNugUarOKJ9PgOmWoJ5ZVivINQMezUtlRJ
         NCffJtHGsrmyDnw7SIbz6Q3FLYAXnqGv5JmE9+w6nlWWBeLeQ5dXXPWKZhCD3o1fm64W
         hdVPQyiZStiyBdwwQtcd16JG6uYa84lLhxHIMvCW1c0g2OgLQRnTaj8TiFHdW20QcU6Y
         5jNjPEXA/nfXWdaUxCkbLMPxBRItPsJ/ci+GVuWZlswcFL5uBnVM8x2sG4Qh3lHxlMhV
         yrszPR7nes4qNNC1IK3/XaExa1tBRWEKW8G2l0aLs10SdsQ4B8NvwOd8/lECKUGdpov/
         jXMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:to:cc:references:in-reply-to
         :subject:date:message-id:mime-version:content-transfer-encoding
         :content-language:thread-index;
        bh=RvYwhlKHnbE7IMX02D/u+6KXVc8W2QDwTYDhW8eoE0Q=;
        b=RfeMyKmIeNHa5hDN6O6xi+JsFx5j6KTUZg+Lsvh1OdZmEHGnxujpepa7o2M7PnYKRH
         LFhBeiY0gGZ+AAtyb54Xa/OeCCpapwtZnK6xTxH10WsF8Ybcityv/q5/aMXx3C+LCtUz
         aGdpj9aO9jeR55hsaSgDFyBPBGyjb/SzPvHqbXTuUCzQvEusM3aR18jMht7dahIuGxoc
         BMttL4pGAyFURI3FeiQ506bEnryZasZO9Fekh6Swpw88NB1RGlIRp/phITsR5OHfJ6Ju
         sBRk2sEx5iP5orgyyRpncGcETaADlbF6XA3YXI/pOxRglzula1QbJJATDLzEyoohNvUk
         azZg==
X-Gm-Message-State: AOAM5311JEJNaQ29x/m7qae2fXFneFWQSBOxQdojrTSX25Y2bUCVzX1c
        PCnyEvePRNeg6JhY6313CyI=
X-Google-Smtp-Source: ABdhPJyh5n3mWJeI8vDqBRo/VokTgPCXXvocypEJxeeJbYsJgIBN5yLLaB2AlmtAISz12X0J3bYKPw==
X-Received: by 2002:adf:e285:: with SMTP id v5mr17988375wri.129.1592820612190;
        Mon, 22 Jun 2020 03:10:12 -0700 (PDT)
Received: from CBGR90WXYV0 (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id g18sm16141015wme.17.2020.06.22.03.10.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jun 2020 03:10:11 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: "Paul Durrant" <paul@xen.org>
Reply-To: <paul@xen.org>
To:     "'Denis Kirjanov'" <kda@linux-powerpc.org>,
        <netdev@vger.kernel.org>
Cc:     <brouer@redhat.com>, <jgross@suse.com>, <wei.liu@kernel.org>,
        <ilias.apalodimas@linaro.org>
References: <1592817672-2053-1-git-send-email-kda@linux-powerpc.org> <1592817672-2053-4-git-send-email-kda@linux-powerpc.org>
In-Reply-To: <1592817672-2053-4-git-send-email-kda@linux-powerpc.org>
Subject: RE: [PATCH net-next v10 3/3] xen networking: add XDP offset adjustment to xen-netback
Date:   Mon, 22 Jun 2020 11:10:10 +0100
Message-ID: <001f01d6487d$50ae9960$f20bcc20$@xen.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-gb
Thread-Index: AQKsasFAvtPuuP5Bcly80krHiwHvswKYhLIXpyNfYIA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Denis Kirjanov <kda@linux-powerpc.org>
> Sent: 22 June 2020 10:21
> To: netdev@vger.kernel.org
> Cc: brouer@redhat.com; jgross@suse.com; wei.liu@kernel.org; paul@xen.org; ilias.apalodimas@linaro.org
> Subject: [PATCH net-next v10 3/3] xen networking: add XDP offset adjustment to xen-netback
> 
> the patch basically adds the offset adjustment and netfront
> state reading to make XDP work on netfront side.
> 
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
> ---
>  drivers/net/xen-netback/common.h    |  4 ++++
>  drivers/net/xen-netback/interface.c |  2 ++
>  drivers/net/xen-netback/netback.c   |  7 +++++++
>  drivers/net/xen-netback/rx.c        | 15 ++++++++++++++-
>  drivers/net/xen-netback/xenbus.c    | 32 ++++++++++++++++++++++++++++++++
>  5 files changed, 59 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
> index 05847eb..f14dc10 100644
> --- a/drivers/net/xen-netback/common.h
> +++ b/drivers/net/xen-netback/common.h
> @@ -281,6 +281,9 @@ struct xenvif {
>  	u8 ipv6_csum:1;
>  	u8 multicast_control:1;
> 
> +	/* headroom requested by xen-netfront */
> +	u16 netfront_xdp_headroom;
> +
>  	/* Is this interface disabled? True when backend discovers
>  	 * frontend is rogue.
>  	 */
> @@ -395,6 +398,7 @@ static inline pending_ring_idx_t nr_pending_reqs(struct xenvif_queue *queue)
>  irqreturn_t xenvif_interrupt(int irq, void *dev_id);
> 
>  extern bool separate_tx_rx_irq;
> +extern bool provides_xdp_headroom;
> 
>  extern unsigned int rx_drain_timeout_msecs;
>  extern unsigned int rx_stall_timeout_msecs;
> diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
> index 0c8a02a..fc16edd 100644
> --- a/drivers/net/xen-netback/interface.c
> +++ b/drivers/net/xen-netback/interface.c
> @@ -483,6 +483,8 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
>  	vif->queues = NULL;
>  	vif->num_queues = 0;
> 
> +	vif->netfront_xdp_headroom = 0;
> +

How about just 'xdp_headroom'? It's shorter to type :-)

>  	spin_lock_init(&vif->lock);
>  	INIT_LIST_HEAD(&vif->fe_mcast_addr);
> 
> diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
> index 315dfc6..6dfca72 100644
> --- a/drivers/net/xen-netback/netback.c
> +++ b/drivers/net/xen-netback/netback.c
> @@ -96,6 +96,13 @@
>  module_param_named(hash_cache_size, xenvif_hash_cache_size, uint, 0644);
>  MODULE_PARM_DESC(hash_cache_size, "Number of flows in the hash cache");
> 
> +/* The module parameter tells that we have to put data
> + * for xen-netfront with the XDP_PACKET_HEADROOM offset
> + * needed for XDP processing
> + */
> +bool provides_xdp_headroom = true;
> +module_param(provides_xdp_headroom, bool, 0644);
> +
>  static void xenvif_idx_release(struct xenvif_queue *queue, u16 pending_idx,
>  			       u8 status);
> 
> diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
> index ef58870..c5e9e14 100644
> --- a/drivers/net/xen-netback/rx.c
> +++ b/drivers/net/xen-netback/rx.c
> @@ -258,6 +258,19 @@ static void xenvif_rx_next_skb(struct xenvif_queue *queue,
>  		pkt->extra_count++;
>  	}
> 
> +	if (queue->vif->netfront_xdp_headroom) {
> +		struct xen_netif_extra_info *extra;
> +
> +		extra = &pkt->extras[XEN_NETIF_EXTRA_TYPE_XDP - 1];
> +
> +		memset(extra, 0, sizeof(struct xen_netif_extra_info));
> +		extra->u.xdp.headroom = queue->vif->netfront_xdp_headroom;
> +		extra->type = XEN_NETIF_EXTRA_TYPE_XDP;
> +		extra->flags = 0;
> +
> +		pkt->extra_count++;
> +	}
> +
>  	if (skb->sw_hash) {
>  		struct xen_netif_extra_info *extra;
> 
> @@ -356,7 +369,7 @@ static void xenvif_rx_data_slot(struct xenvif_queue *queue,
>  				struct xen_netif_rx_request *req,
>  				struct xen_netif_rx_response *rsp)
>  {
> -	unsigned int offset = 0;
> +	unsigned int offset = queue->vif->netfront_xdp_headroom;
>  	unsigned int flags;
> 
>  	do {
> diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
> index 286054b..c67abc5 100644
> --- a/drivers/net/xen-netback/xenbus.c
> +++ b/drivers/net/xen-netback/xenbus.c
> @@ -393,6 +393,22 @@ static void set_backend_state(struct backend_info *be,
>  	}
>  }
> 
> +static void read_xenbus_frontend_xdp(struct backend_info *be,
> +				      struct xenbus_device *dev)
> +{
> +	struct xenvif *vif = be->vif;
> +	u16 headroom;
> +	int err;
> +
> +	err = xenbus_scanf(XBT_NIL, dev->otherend,
> +			   "netfront-xdp-headroom", "%hu", &headroom);

Isn't it just "xdp-headroom"? That's what the comments in netif.h state.

> +	if (err < 0) {
> +		vif->netfront_xdp_headroom = 0;
> +		return;
> +	}

What is a reasonable value for maximum headroom? Do we really want to allow values all the way up to 65535?

  Paul

> +	vif->netfront_xdp_headroom = headroom;
> +}
> +
>  /**
>   * Callback received when the frontend's state changes.
>   */
> @@ -417,6 +433,11 @@ static void frontend_changed(struct xenbus_device *dev,
>  		set_backend_state(be, XenbusStateConnected);
>  		break;
> 
> +	case XenbusStateReconfiguring:
> +		read_xenbus_frontend_xdp(be, dev);
> +		xenbus_switch_state(dev, XenbusStateReconfigured);
> +		break;
> +
>  	case XenbusStateClosing:
>  		set_backend_state(be, XenbusStateClosing);
>  		break;
> @@ -947,6 +968,8 @@ static int read_xenbus_vif_flags(struct backend_info *be)
>  	vif->ipv6_csum = !!xenbus_read_unsigned(dev->otherend,
>  						"feature-ipv6-csum-offload", 0);
> 
> +	read_xenbus_frontend_xdp(be, dev);
> +
>  	return 0;
>  }
> 
> @@ -1036,6 +1059,15 @@ static int netback_probe(struct xenbus_device *dev,
>  			goto abort_transaction;
>  		}
> 
> +		/* we can adjust a headroom for netfront XDP processing */
> +		err = xenbus_printf(xbt, dev->nodename,
> +				    "feature-xdp-headroom", "%d",
> +				    provides_xdp_headroom);
> +		if (err) {
> +			message = "writing feature-xdp-headroom";
> +			goto abort_transaction;
> +		}
> +
>  		/* We don't support rx-flip path (except old guests who
>  		 * don't grok this feature flag).
>  		 */
> --
> 1.8.3.1


