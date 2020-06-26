Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07F120AFF9
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 12:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgFZKou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 06:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbgFZKou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 06:44:50 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20413C08C5C1
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 03:44:50 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id a6so8611477wmm.0
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 03:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=hwlc7SBmoq8Kb32v6yRjPReWTM1bVasgk8BTvQ1JY7M=;
        b=KULUIb6FSs6vStmrHICylL40TJU8CTgjk8nwn1ipafwb7vjoq8Cjmj6PZWlZv6Fu/S
         2ggofV4rqPGXuVN0Af9LchW2yYIefqyR9xQiTArhMsBNvVQzPXuTbCdQWl4XLfzMF46z
         WOxyEPBF+tp15okLtDwlbX7i64H9+QlKmdXGQY5wSDJ1LY1bLkkaanJKK9wgu6byuT9+
         uUOHDfgayL+n6nYZOgK0V2XWqnaRvdjXmWIAMb0omiciz9UymS1gaEO0XGECUtK2GW6C
         FtM4DQNSnKHpQY/7a6d1qMF4btAdtlVGrsqT2DTH/pTkpfd4LvEK6XVMtdNmqg0Atal/
         E2dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:to:cc:references:in-reply-to
         :subject:date:message-id:mime-version:content-transfer-encoding
         :content-language:thread-index;
        bh=hwlc7SBmoq8Kb32v6yRjPReWTM1bVasgk8BTvQ1JY7M=;
        b=k6feKIJMUimil1Nzu4FFj1x4dwElmmcsBTU0UzCHV8yTTbq1xSYhe/RY/H03ay0UOt
         DOuhRH1nQThOtmRbvfHgnNhQ4sY/7zctkVa3l6CyiQH0yWQ4iaZjKMtFGkrVFPK/y3LU
         D7fahPggUSj76a6f1FZZ0TR00w0QK1IR9eVS3mnVJSYO+fadaHZMxofEYgDb4fx++wrP
         ResnrkaE2RI90NBMJXBhYgZXu0wXwUHkefNGjm5YLt4/RBXkJS/pcmgVUyF3o3vrhnZT
         b1NejzSfdadt4i8V5YLv9rQhOAzvwx4V/AJQdmUUZhUrxw4YrxWvlXfXPc2Up40VuOfJ
         3yYw==
X-Gm-Message-State: AOAM533yu0+FYqqC4QY0mewKQx33FK+/bn25JI1eHPvPlJDQE6vYfCnu
        7MgbPgp0O2XeW4rkbHWTuxM=
X-Google-Smtp-Source: ABdhPJy9hoYYETlxH/l3nm7ZAhucS5aFhufXizCo+ZQ7KZ0jIb5Xg5Bho4y1h3gyVfmDGvMgnHA7/g==
X-Received: by 2002:a1c:65d5:: with SMTP id z204mr2698463wmb.15.1593168288839;
        Fri, 26 Jun 2020 03:44:48 -0700 (PDT)
Received: from CBGR90WXYV0 (54-240-197-236.amazon.com. [54.240.197.236])
        by smtp.gmail.com with ESMTPSA id x185sm4871859wmg.41.2020.06.26.03.44.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2020 03:44:48 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: "Paul Durrant" <paul@xen.org>
Reply-To: <paul@xen.org>
To:     "'Denis Kirjanov'" <kda@linux-powerpc.org>,
        <netdev@vger.kernel.org>
Cc:     <brouer@redhat.com>, <jgross@suse.com>, <wei.liu@kernel.org>,
        <ilias.apalodimas@linaro.org>
References: <1593167674-1065-1-git-send-email-kda@linux-powerpc.org> <1593167674-1065-4-git-send-email-kda@linux-powerpc.org>
In-Reply-To: <1593167674-1065-4-git-send-email-kda@linux-powerpc.org>
Subject: RE: [PATCH net-next v11 3/3] xen networking: add XDP offset adjustment to xen-netback
Date:   Fri, 26 Jun 2020 11:44:47 +0100
Message-ID: <000601d64ba6$d01dda40$70598ec0$@xen.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-gb
Thread-Index: AQKyrh82wsIkaiSUefNhQ2a615KSuwEYLZVDpykvnSA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Denis Kirjanov <kda@linux-powerpc.org>
> Sent: 26 June 2020 11:35
> To: netdev@vger.kernel.org
> Cc: brouer@redhat.com; jgross@suse.com; wei.liu@kernel.org; paul@xen.org; ilias.apalodimas@linaro.org
> Subject: [PATCH net-next v11 3/3] xen networking: add XDP offset adjustment to xen-netback
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
>  drivers/net/xen-netback/xenbus.c    | 34 ++++++++++++++++++++++++++++++++++
>  5 files changed, 61 insertions(+), 1 deletion(-)
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

I'd still prefer the shorter name of 'xdp_headroom'. With that fixed...

Reviewed-by: Paul Durrant <paul@xen.org>

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
> index 286054b..f321068 100644
> --- a/drivers/net/xen-netback/xenbus.c
> +++ b/drivers/net/xen-netback/xenbus.c
> @@ -393,6 +393,24 @@ static void set_backend_state(struct backend_info *be,
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
> +			   "xdp-headroom", "%hu", &headroom);
> +	if (err != 1) {
> +		vif->netfront_xdp_headroom = 0;
> +		return;
> +	}
> +	if (headroom > XEN_NETIF_MAX_XDP_HEADROOM)
> +		headroom = XEN_NETIF_MAX_XDP_HEADROOM;
> +	vif->netfront_xdp_headroom = headroom;
> +}
> +
>  /**
>   * Callback received when the frontend's state changes.
>   */
> @@ -417,6 +435,11 @@ static void frontend_changed(struct xenbus_device *dev,
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
> @@ -947,6 +970,8 @@ static int read_xenbus_vif_flags(struct backend_info *be)
>  	vif->ipv6_csum = !!xenbus_read_unsigned(dev->otherend,
>  						"feature-ipv6-csum-offload", 0);
> 
> +	read_xenbus_frontend_xdp(be, dev);
> +
>  	return 0;
>  }
> 
> @@ -1036,6 +1061,15 @@ static int netback_probe(struct xenbus_device *dev,
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


