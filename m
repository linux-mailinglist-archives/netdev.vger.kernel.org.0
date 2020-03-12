Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41550182FE5
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 13:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgCLMIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 08:08:52 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36672 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgCLMIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 08:08:52 -0400
Received: by mail-ed1-f67.google.com with SMTP id b18so2529567edu.3
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 05:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=uRYufJzQHKGZRrGPTQE3hdsMWbWI5VY+gFIPtzKXm8o=;
        b=rd/K0cvZU3QNfWA41cyLbyaXiJlUmzx6i67dOmSLYHmABhAXxh7brnAeGIVK7ZoM6K
         eci2tgMTW2+OB56WpLQ9mI/3r/etQIfQAYTOZxG1/+ek58fhf0isBAvggCsq8ZMSEIY0
         fScyWlwFwATBsATK9oV6ToavHYi+LAEIfBIIaqDKjAPTe76tKRak/BmRf3O+GlVT14yf
         fTWSI1EdPuceyjGyyMH6wLl0IE/D+S7tSLfGY8fxIthrkKIrKX+e2lexmvEFMdPy/nl+
         3/npwTe527skRE3aXTEA6oycS+Uyp0uscRzbbLVN4RRVNmoB8qK7y27/tELZ0ZD+D/0S
         ck7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:to:cc:references:in-reply-to
         :subject:date:message-id:mime-version:content-transfer-encoding
         :content-language:thread-index;
        bh=uRYufJzQHKGZRrGPTQE3hdsMWbWI5VY+gFIPtzKXm8o=;
        b=nLQ5a1tHliQ89Wn7Tm3G7d5UWmEM8t0z27olQB1LymqEVvLIZk4TR2t0q78Rvx4OfY
         CrgppmKOCYcMbcExN5IUjQcsHDOtmT8f36TFPa7GMywtYKVUKleIPeNaXu+KdqxIOmI+
         Fk4r/EqKaTevFWsES0TMeE9Y+R0FHBiFev2Xz49p1/TppxVFgH3QbSXZ/iFoI6V/2+eA
         S6CYc2PnDUw4hFcEejqphjDYQQpeBlRvp2WyI1g+vkXEUJ+oblEZLBXjLR/Ue0GUobUP
         JM/6OTxgcMjEwoZlAFOi0UcWb7Geen8YVmQKbUpG5gUwzR+YyCSw2hXAMeKwV5efDWjB
         KWzA==
X-Gm-Message-State: ANhLgQ3/uvzjj6A6UW+lSETfMywHd5rBib5NbMuU0+MErGJ3od3Cq8Kb
        +0+Gv4OsAwDasPe/eqYQZkA=
X-Google-Smtp-Source: ADFU+vs99+sIAtmVXybKe/h1zVoJBmzQfEbbxXEe/U2s3KC6Iwsy8WmVZJ4S61dYX6yw/PfMK+GSYw==
X-Received: by 2002:a17:906:5e42:: with SMTP id b2mr1098475eju.266.1584014928016;
        Thu, 12 Mar 2020 05:08:48 -0700 (PDT)
Received: from CBGR90WXYV0 (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id c20sm4797314edt.67.2020.03.12.05.08.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Mar 2020 05:08:47 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: "Paul Durrant" <paul@xen.org>
Reply-To: <paul@xen.org>
To:     "'Denis Kirjanov'" <kda@linux-powerpc.org>,
        <netdev@vger.kernel.org>
Cc:     <jgross@suse.com>, <ilias.apalodimas@linaro.org>,
        <wei.liu@kernel.org>
References: <1584011425-4589-1-git-send-email-kda@linux-powerpc.org>
In-Reply-To: <1584011425-4589-1-git-send-email-kda@linux-powerpc.org>
Subject: RE: [PATCH net-next v3] xen-netfront: add basic XDP support
Date:   Thu, 12 Mar 2020 12:08:46 -0000
Message-ID: <005001d5f866$fbeca400$f3c5ec00$@xen.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-gb
Thread-Index: AQIan3i4VoYROqnCuDYFrWdPtxB7vKe7hBFQ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Denis Kirjanov <kda@linux-powerpc.org>
> Sent: 12 March 2020 11:10
> To: netdev@vger.kernel.org
> Cc: jgross@suse.com; ilias.apalodimas@linaro.org; wei.liu@kernel.org; paul@xen.org; Denis Kirjanov
> <kda@linux-powerpc.org>
> Subject: [PATCH net-next v3] xen-netfront: add basic XDP support
> 
> the patch adds a basic xdo logic to the netfront driver

This commit comment is by no means adequate. For a start xen-netback is also changed. Please also give some detail about what the
patch is doing and why.

> 
> v3:
> - added XDP_TX support (tested with xdping echoserver)
> - added XDP_REDIRECT support (tested with modified xdp_redirect_kern)
> - moved xdp negotiation to xen-netback
> 
> v2:
> - avoid data copying while passing to XDP
> - tell xen-natback that we need the headroom space
> 
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
> ---
>  drivers/net/xen-netback/common.h |   1 +
>  drivers/net/xen-netback/rx.c     |   9 +-
>  drivers/net/xen-netback/xenbus.c |  27 +++++
>  drivers/net/xen-netfront.c       | 240 ++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 274 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
> index 05847eb..0750c6f 100644
> --- a/drivers/net/xen-netback/common.h
> +++ b/drivers/net/xen-netback/common.h
> @@ -280,6 +280,7 @@ struct xenvif {
>  	u8 ip_csum:1;
>  	u8 ipv6_csum:1;
>  	u8 multicast_control:1;
> +	u8 xdp_enabled:1;
> 
>  	/* Is this interface disabled? True when backend discovers
>  	 * frontend is rogue.
> diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
> index ef58870..a110a59 100644
> --- a/drivers/net/xen-netback/rx.c
> +++ b/drivers/net/xen-netback/rx.c
> @@ -33,6 +33,11 @@
>  #include <xen/xen.h>
>  #include <xen/events.h>
> 
> +static inline int xenvif_rx_xdp_offset(struct xenvif *vif)
> +{
> +	return (vif->xdp_enabled ? XDP_PACKET_HEADROOM : 0);
> +}
> +
>  static bool xenvif_rx_ring_slots_available(struct xenvif_queue *queue)
>  {
>  	RING_IDX prod, cons;
> @@ -356,7 +361,7 @@ static void xenvif_rx_data_slot(struct xenvif_queue *queue,
>  				struct xen_netif_rx_request *req,
>  				struct xen_netif_rx_response *rsp)
>  {
> -	unsigned int offset = 0;
> +	unsigned int offset = xenvif_rx_xdp_offset(queue->vif);
>  	unsigned int flags;
> 
>  	do {
> @@ -389,7 +394,7 @@ static void xenvif_rx_data_slot(struct xenvif_queue *queue,
>  			flags |= XEN_NETRXF_extra_info;
>  	}
> 
> -	rsp->offset = 0;
> +	rsp->offset = xenvif_rx_xdp_offset(queue->vif);
>  	rsp->flags = flags;
>  	rsp->id = req->id;
>  	rsp->status = (s16)offset;

I'm confused... largely due to the total lack of explanation of what this patch is doing... Why are you messing with the guest RX
side here? If you want to squash the extra header then it can be stripped in the copy (which it looks like you do) with no need to
expose a non-zero offset to the guest.

> diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
> index 286054b..0949c6b 100644
> --- a/drivers/net/xen-netback/xenbus.c
> +++ b/drivers/net/xen-netback/xenbus.c
> @@ -393,6 +393,20 @@ static void set_backend_state(struct backend_info *be,
>  	}
>  }
> 
> +static void read_xenbus_frontend_xdp(struct backend_info *be,
> +				      struct xenbus_device *dev)
> +{
> +	struct xenvif *vif = be->vif;
> +	unsigned int val;
> +	int err;
> +
> +	err = xenbus_scanf(XBT_NIL, dev->otherend,
> +			   "feature-xdp", "%u", &val);
> +	if (err < 0)
> +		return;
> +	vif->xdp_enabled = val;
> +}
> +
>  /**
>   * Callback received when the frontend's state changes.
>   */
> @@ -417,6 +431,11 @@ static void frontend_changed(struct xenbus_device *dev,
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
> @@ -1036,6 +1055,14 @@ static int netback_probe(struct xenbus_device *dev,
>  			goto abort_transaction;
>  		}
> 
> +		/* we can adjust a headroom for netfront XDP processing */
> +		err = xenbus_printf(xbt, dev->nodename,
> +				    "feature-xdp-headroom", "%d", 1);
> +		if (err) {
> +			message = "writing feature-xdp-headroom";
> +			goto abort_transaction;
> +		}
> +

Unconditionally enabling? I'd like a modparam for this.

>  		/* We don't support rx-flip path (except old guests who
>  		 * don't grok this feature flag).
>  		 */
> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> index 482c6c8..d298b36 100644
> --- a/drivers/net/xen-netfront.c
> +++ b/drivers/net/xen-netfront.c
> @@ -44,6 +44,8 @@
>  #include <linux/mm.h>
>  #include <linux/slab.h>
>  #include <net/ip.h>
> +#include <linux/bpf.h>
> +#include <linux/bpf_trace.h>
> 
>  #include <xen/xen.h>
>  #include <xen/xenbus.h>
> @@ -102,6 +104,8 @@ struct netfront_queue {
>  	char name[QUEUE_NAME_SIZE]; /* DEVNAME-qN */
>  	struct netfront_info *info;
> 
> +	struct bpf_prog __rcu *xdp_prog;
> +
>  	struct napi_struct napi;
> 
>  	/* Split event channels support, tx_* == rx_* when using
> @@ -144,6 +148,8 @@ struct netfront_queue {
>  	struct sk_buff *rx_skbs[NET_RX_RING_SIZE];
>  	grant_ref_t gref_rx_head;
>  	grant_ref_t grant_rx_ref[NET_RX_RING_SIZE];
> +
> +	struct xdp_rxq_info xdp_rxq;
>  };
> 
>  struct netfront_info {
> @@ -159,6 +165,8 @@ struct netfront_info {
>  	struct netfront_stats __percpu *rx_stats;
>  	struct netfront_stats __percpu *tx_stats;
> 
> +	bool netback_has_xdp_headroom;
> +
>  	atomic_t rx_gso_checksum_fixup;
>  };
> 
> @@ -167,6 +175,9 @@ struct netfront_rx_info {
>  	struct xen_netif_extra_info extras[XEN_NETIF_EXTRA_TYPE_MAX - 1];
>  };
> 
> +static int xennet_xdp_xmit(struct net_device *dev, int n,
> +			   struct xdp_frame **frames, u32 flags);
> +
>  static void skb_entry_set_link(union skb_entry *list, unsigned short id)
>  {
>  	list->link = id;
> @@ -406,7 +417,8 @@ static void xennet_tx_buf_gc(struct netfront_queue *queue)
>  			queue->grant_tx_ref[id] = GRANT_INVALID_REF;
>  			queue->grant_tx_page[id] = NULL;
>  			add_id_to_freelist(&queue->tx_skb_freelist, queue->tx_skbs, id);
> -			dev_kfree_skb_irq(skb);
> +			if (skb)
> +				dev_kfree_skb_irq(skb);

Why? dev_kfree_skb_irq() will happily deal with a NULL value.

>  		}
> 
>  		queue->tx.rsp_cons = prod;
> @@ -778,6 +790,52 @@ static int xennet_get_extras(struct netfront_queue *queue,
>  	return err;
>  }
> 
> +u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
> +		   struct xen_netif_rx_response *rx, struct bpf_prog *prog,
> +		   struct xdp_buff *xdp)
> +{
> +	struct xdp_frame *xdpf;
> +	u32 len = rx->status;
> +	u32 act = XDP_PASS;
> +	int err;
> +
> +	xdp->data_hard_start = page_address(pdata);
> +	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
> +	xdp_set_data_meta_invalid(xdp);
> +	xdp->data_end = xdp->data + len;
> +	xdp->rxq = &queue->xdp_rxq;
> +	xdp->handle = 0;
> +
> +	act = bpf_prog_run_xdp(prog, xdp);
> +	switch (act) {
> +	case XDP_TX:
> +		xdpf = convert_to_xdp_frame(xdp);
> +		err = xennet_xdp_xmit(queue->info->netdev, 1,
> +				&xdpf, 0);
> +		if (unlikely(err < 0))
> +			trace_xdp_exception(queue->info->netdev, prog, act);
> +		break;
> +	case XDP_REDIRECT:
> +		err = xdp_do_redirect(queue->info->netdev, xdp, prog);
> +		if (unlikely(err))
> +			trace_xdp_exception(queue->info->netdev, prog, act);
> +		xdp_do_flush();
> +		break;
> +	case XDP_PASS:
> +	case XDP_DROP:
> +		break;
> +
> +	case XDP_ABORTED:
> +		trace_xdp_exception(queue->info->netdev, prog, act);
> +		break;
> +
> +	default:
> +		bpf_warn_invalid_xdp_action(act);
> +	}
> +
> +	return act;
> +}
> +
>  static int xennet_get_responses(struct netfront_queue *queue,
>  				struct netfront_rx_info *rinfo, RING_IDX rp,
>  				struct sk_buff_head *list)
> @@ -792,6 +850,9 @@ static int xennet_get_responses(struct netfront_queue *queue,
>  	int slots = 1;
>  	int err = 0;
>  	unsigned long ret;
> +	struct bpf_prog *xdp_prog;
> +	struct xdp_buff xdp;
> +	u32 verdict;
> 
>  	if (rx->flags & XEN_NETRXF_extra_info) {
>  		err = xennet_get_extras(queue, extras, rp);
> @@ -827,6 +888,21 @@ static int xennet_get_responses(struct netfront_queue *queue,
> 
>  		gnttab_release_grant_reference(&queue->gref_rx_head, ref);
> 
> +		rcu_read_lock();
> +		xdp_prog = rcu_dereference(queue->xdp_prog);
> +		if (xdp_prog) {
> +			/* currently only a single page contains data */
> +			WARN_ON_ONCE(skb_shinfo(skb)->nr_frags != 1);

How's this going to work for jumbo frames?

  Paul

> +			verdict = xennet_run_xdp(queue,
> +				       skb_frag_page(&skb_shinfo(skb)->frags[0]),
> +				       rx, xdp_prog, &xdp);
> +			if (verdict != XDP_PASS && verdict != XDP_TX) {
> +				err = -EINVAL;
> +				goto next;
> +			}
> +
> +		}
> +		rcu_read_unlock();
>  		__skb_queue_tail(list, skb);
> 
>  next:
> @@ -1261,6 +1337,144 @@ static void xennet_poll_controller(struct net_device *dev)
>  }
>  #endif

