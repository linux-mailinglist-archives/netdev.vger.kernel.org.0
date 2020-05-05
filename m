Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57601C58EB
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729933AbgEEOTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730501AbgEEOTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:19:32 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861E9C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 07:19:30 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id q8so1809277eja.2
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 07:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:thread-index
         :content-language;
        bh=RPVJ1Cm6RscP4uQIF5FvAwU+Yy9r2eCYm4VgtmJgX5Q=;
        b=sjk6KGqJ8ycxOs9/9XVJ9DFHSO6qCYfp9lQaA5UKGs8ATaIuyA6QRVO94pjX0enqWo
         N7oXROVrDxM49Dk2mf4z/xwjKCTKIyxjvYMI+9qIOJ/5p3Zph3Xn/PXz2I6BiBtbSok3
         C4KglkTOHu7zVZLoaaVlNoXxwxRM0U5XcgCEHfLh9lNvZ1oeDD8kqHPy7ZsNOyMN47rw
         N3ma5MPgmOxfYX3mUDgj2w+sK1l99MPB2osMfMJXG7rKVuLc8ECDYrq+H+AwKcjBkav+
         5kqUIb3/VYSr0FY8YOR7iorO+hHhj6wuO8zuEJFbeM1sv9pg7VqvIYzExYbC6U2Sa/JZ
         y4aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:to:cc:references:in-reply-to
         :subject:date:message-id:mime-version:content-transfer-encoding
         :thread-index:content-language;
        bh=RPVJ1Cm6RscP4uQIF5FvAwU+Yy9r2eCYm4VgtmJgX5Q=;
        b=Gk7X+JKuLyTnQn9p7zKhckD3Q2YcQ/HBRR5QEvW0ozoGLw+yMQTUjzm7ObkEeiz9ZO
         vEty1eUYq+0yFDUUXqPY86KnA9Idul/kw0g6aVsT8gft/df8WDu0yl7w5LPn9e5qROYG
         U9jMmd0lMR/v8TcU7XmvzvuO9pinYmA6zz2Y5yZ1a4XPFSymdjSwnuLksQRul533l/Ns
         zA8eqdUTNWdVgFHgdBoG153raOdZHK4c9mD3zKOLcygeCCCyItxkwSuo1JVXv6mAP9wn
         +W6bZZeWtUYYVtmFzt1M8Pl0vOos0NGx5qUUQhg+xpsDxk05UpjM6vUyrMqytK8UvFRA
         OSrA==
X-Gm-Message-State: AGi0Puakpo70XF4jebn6KZ+9eTWE3BwAM50v4E95kjbcaqL38jJU/qF0
        liJJQluEwOUqkIprnLIR6uA=
X-Google-Smtp-Source: APiQypK96jNxpfLUMYeFrp7+B6kco0vADLAyjTYppweon8KKa9BfHDsM4+s8CVIOXvZ2zRLZvwA4ag==
X-Received: by 2002:a17:906:2511:: with SMTP id i17mr2902788ejb.165.1588688369259;
        Tue, 05 May 2020 07:19:29 -0700 (PDT)
Received: from CBGR90WXYV0 ([54.239.6.186])
        by smtp.gmail.com with ESMTPSA id n7sm282435edt.69.2020.05.05.07.19.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2020 07:19:28 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: "Paul Durrant" <paul@xen.org>
Reply-To: <paul@xen.org>
To:     "'Denis Kirjanov'" <kda@linux-powerpc.org>,
        <netdev@vger.kernel.org>
Cc:     <jgross@suse.com>, <wei.liu@kernel.org>,
        <ilias.apalodimas@linaro.org>
References: <1588581474-18345-1-git-send-email-kda@linux-powerpc.org> <1588581474-18345-2-git-send-email-kda@linux-powerpc.org>
In-Reply-To: <1588581474-18345-2-git-send-email-kda@linux-powerpc.org>
Subject: RE: [PATCH net-next v7 2/2] xen networking: add XDP offset adjustment to xen-netback
Date:   Tue, 5 May 2020 15:19:27 +0100
Message-ID: <004201d622e8$2fff5cf0$8ffe16d0$@xen.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQE3/rdtCvsSNPb5s7Kxs8cJj/qIbwLQYVL2qb9Kv/A=
Content-Language: en-gb
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Denis Kirjanov <kda@linux-powerpc.org>
> Sent: 04 May 2020 09:38
> To: netdev@vger.kernel.org
> Cc: jgross@suse.com; wei.liu@kernel.org; paul@xen.org; ilias.apalodimas@linaro.org
> Subject: [PATCH net-next v7 2/2] xen networking: add XDP offset adjustment to xen-netback
> 
> the patch basically adds the offset adjustment and netfront
> state reading to make XDP work on netfront side.
> 
> Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>
> ---
>  drivers/net/xen-netback/common.h  |  2 ++
>  drivers/net/xen-netback/netback.c |  7 +++++++
>  drivers/net/xen-netback/rx.c      |  7 ++++++-
>  drivers/net/xen-netback/xenbus.c  | 28 ++++++++++++++++++++++++++++
>  4 files changed, 43 insertions(+), 1 deletion(-)
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
> index ef58870..1c0cf8a 100644
> --- a/drivers/net/xen-netback/rx.c
> +++ b/drivers/net/xen-netback/rx.c
> @@ -33,6 +33,11 @@
>  #include <xen/xen.h>
>  #include <xen/events.h>
> 
> +static inline int xenvif_rx_xdp_offset(struct xenvif *vif)
> +{
> +	return vif->xdp_enabled ? XDP_PACKET_HEADROOM : 0;
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
> diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
> index 286054b..7c0450e 100644
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

xenbus_scanf() returns the number of successfully parsed values so you ought to be checking for != 1 here.

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

Is the frontend always expected to trigger a re-configure, or could feature-xdp already be enabled prior to connection?

> +		xenbus_switch_state(dev, XenbusStateReconfigured);
> +		break;
> +
>  	case XenbusStateClosing:
>  		set_backend_state(be, XenbusStateClosing);
>  		break;
> @@ -1036,6 +1055,15 @@ static int netback_probe(struct xenbus_device *dev,
>  			goto abort_transaction;
>  		}
> 
> +		/* we can adjust a headroom for netfront XDP processing */
> +		err = xenbus_printf(xbt, dev->nodename,
> +				    "feature-xdp-headroom", "%d",
> +				    !!provides_xdp_headroom);

provides_xdp_headroom is bool so the !! ought to be unnecessary.

  Paul

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


