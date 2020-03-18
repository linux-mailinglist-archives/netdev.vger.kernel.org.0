Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8002F189947
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 11:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgCRK1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 06:27:31 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38084 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgCRK1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 06:27:30 -0400
Received: by mail-qk1-f194.google.com with SMTP id h14so37760917qke.5
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 03:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=3gAFtGbjEc0Sspnx5s3dxsl/jGXPezugDqG5VIdSxrc=;
        b=RbG8SZdCP8LwQo5hGROtW6AZ5PLYkPjxkluHa/saZEqmahP9WVH3uE0l2/j+eJC9i8
         dk3JKD6MLYc11S5X1l3M60Z1+ETuBUlNVpZ8wE0aIPbk2+Oc6ioIAvVUNxxoquWwmmkt
         08+B1w3/m52suWy1ySarba7HTlIJ5Zt+niLMCfuP8irfoNuaH3rLTfkSFpVKAx0Wk0kE
         /1Nrl6IeMZd5opLdTRgsAH5YQNbnxwzEgsr2TMXkU0hqI4zc+Lf1JPWTQ4U3pWxiKtgk
         9KynV2cTHZDyUzTNa0oGt68SzPN81+xPPcPNPVz1AxP/8Y6yeIrvQOqZRBhPYwv/qKI8
         +Wtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:to:cc:references:in-reply-to
         :subject:date:message-id:mime-version:content-transfer-encoding
         :content-language:thread-index;
        bh=3gAFtGbjEc0Sspnx5s3dxsl/jGXPezugDqG5VIdSxrc=;
        b=AEVhzTpuTnra2T+UTMPSrbcvWciMH29GUfg8B13THnOa0B/iM1D/beBADrU9waBaTZ
         SZauWtIGLjVKnBQnA0kYyOm6s3X5bNF2JvIbDi5yuwmYlbL6/oJPGkCwCsDwjsxZKOJM
         V5xv4wRoD/uVU1y3glmTmJd6krz0u3JbA+NQ/DUTvJYZCvk+TYgyjMt8k0B4Sz5XtWLl
         +AH6FiqTxy9IpgBL1s1Y2KWbR+iHO7i7NP7wPYWlp2NUwAqBxjCA8cjH9Tcn5e7TuE7o
         Ov3pwBjNAXahwHoOQBUFbIBLkXS5RHyn+nKdvrGzj0Ypu+2o/WwyFe9pn6A8FB0kbkOV
         h5qg==
X-Gm-Message-State: ANhLgQ0K9pCZkgFZCVsOBTwATzYhacFXyhoLEJtfSuELv6Hneh3BgCQH
        StAweGgauf+WEMUz9fm7zkQ=
X-Google-Smtp-Source: ADFU+vt6B6BXy+WicXrmdEL0AbCo7obsF1cQ15MBXhH5nX30H8YYg6SqB6s4RAhA9+TsW47m2nULuQ==
X-Received: by 2002:a05:620a:1236:: with SMTP id v22mr3202292qkj.101.1584527249005;
        Wed, 18 Mar 2020 03:27:29 -0700 (PDT)
Received: from CBGR90WXYV0 ([54.239.6.187])
        by smtp.gmail.com with ESMTPSA id h20sm3761142qka.78.2020.03.18.03.27.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Mar 2020 03:27:28 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: "Paul Durrant" <paul@xen.org>
Reply-To: <paul@xen.org>
To:     "'Denis Kirjanov'" <kda@linux-powerpc.org>,
        <netdev@vger.kernel.org>
Cc:     <jgross@suse.com>, <ilias.apalodimas@linaro.org>,
        <wei.liu@kernel.org>
References: <1584364176-23346-1-git-send-email-kda@linux-powerpc.org>
In-Reply-To: <1584364176-23346-1-git-send-email-kda@linux-powerpc.org>
Subject: RE: [PATCH net-next v4] xen networking: add basic XDP support for xen-netfront
Date:   Wed, 18 Mar 2020 10:27:26 -0000
Message-ID: <006201d5fd0f$d2f25010$78d6f030$@xen.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-gb
Thread-Index: AQIJYp7NaZTVBO7JfwY5QrFOx5gV0qfnKk2w
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Denis Kirjanov <kda@linux-powerpc.org>
> Sent: 16 March 2020 13:10
> To: netdev@vger.kernel.org
> Cc: jgross@suse.com; ilias.apalodimas@linaro.org; wei.liu@kernel.org; paul@xen.org; Denis Kirjanov
> <kda@linux-powerpc.org>
> Subject: [PATCH net-next v4] xen networking: add basic XDP support for xen-netfront
> 
> The patch adds a basic XDP processing to xen-netfront driver.
> 
> We ran an XDP program for an RX response received from netback
> driver. Also we request xen-netback to adjust data offset for
> bpf_xdp_adjust_head() header space for custom headers.
> 
> v4:
> - added verbose patch descriprion
> - don't expose the XDP headroom offset to the domU guest
> - add a modparam to netback to toggle XDP offset
> - don't process jumbo frames for now
> 
> v3:
> - added XDP_TX support (tested with xdping echoserver)
> - added XDP_REDIRECT support (tested with modified xdp_redirect_kern)
> - moved xdp negotiation to xen-netback
> 
> v2:
> - avoid data copying while passing to XDP
> - tell xen-netback that we need the headroom space
> 
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
> ---
>  drivers/net/xen-netback/common.h  |   2 +
>  drivers/net/xen-netback/netback.c |   7 ++
>  drivers/net/xen-netback/rx.c      |   7 +-
>  drivers/net/xen-netback/xenbus.c  |  28 +++++
>  drivers/net/xen-netfront.c        | 240 +++++++++++++++++++++++++++++++++++++-
>  5 files changed, 282 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
> index 05847eb..4a148d6 100644
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
> @@ -395,6 +396,7 @@ static inline pending_ring_idx_t nr_pending_reqs(struct xenvif_queue *queue)
>  irqreturn_t xenvif_interrupt(int irq, void *dev_id);
> 
>  extern bool separate_tx_rx_irq;
> +extern bool provides_xdp_headroom;
> 
>  extern unsigned int rx_drain_timeout_msecs;
>  extern unsigned int rx_stall_timeout_msecs;
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
> index ef58870..aba826b 100644
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

No need for the brackets here.

[snip]
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

Can you drop this? I said previously that it is unnecessary.

  Paul


