Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE6D1CD892
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 13:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbgEKLdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 07:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729824AbgEKLdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 07:33:12 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A41C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 04:33:12 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id h4so17677639wmb.4
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 04:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=CfQ35Gierj7cnoZ6zkhbpo55AGLyOeq+dDa1WEyqhsU=;
        b=kdC4S9p45pwtzQtASDaPHd4vqn2rCi3TV0dntFKxsjYJNzMiBGjCGmndmYawfO8VpZ
         +T//g/025QAIjHrq6KJ+PtXZeWU3PGhDNz8S/0v3Un9AMEtjaECb4s+YmdR3Ctii3epy
         P4FTICTUlixLsPU/nnM/blFqESPXugz2S01VGBgM34noeuf2UldXZGmD0dvAT4czpxYl
         20XpX2Kh5ye2DgfRC/pYyUgaKSKLY54uvUR+fXn78NXpFjQ3P3i3G7gsGt9U6hPaTiS6
         0b+tuosy3MpJ4MCftyCW+bGRegb/eM+PD1IVWUOzJ8KhT9wPsfi99NhIuf2FOZU3Mqw5
         LYwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:to:cc:references:in-reply-to
         :subject:date:message-id:mime-version:content-transfer-encoding
         :content-language:thread-index;
        bh=CfQ35Gierj7cnoZ6zkhbpo55AGLyOeq+dDa1WEyqhsU=;
        b=A6pI2nQRymv5XNUqzp8sFF0WpOYmtjNa276FLZg94Jlo5k6RpRu1NdAJzglLMWo45O
         hyIvL0QzUOLfL0vAgUSpvVbKBlJIL6YdbjPRHE8g0KqMErnAzzIf1dqK/9q23PsldXj/
         PTIaHTEAx6S8EEJIK/B9NRZ2WasfTiKQeCuq+RzqjTYl0TWNwn4xuUW9bRyMium6hFpr
         uIXLqHVJp+lvp9HzsEQUNO52AmSKYn6mSF/vKKUM6VmRAiTPTsZJMvDKP5H1HZcI6Gqk
         EY17JLC5/6FJ1u10wV6qzc2gL/XRX6v6bAWFSc0k9ONN9i3LFkImQLXfdSiDtOxMqOee
         mzOA==
X-Gm-Message-State: AGi0PuZAekjbyRN4EaqKajzsrBhN87wuKzu9PVZhJYkPfcveVfp+HuT7
        xtJyc7/Zjw60pqvPgsuXpB4=
X-Google-Smtp-Source: APiQypIYwEzhHcptmeeCZXKx0UWisPM1uiTCigVy4u4m7Rjbedk4kN0h/BgJ4pNUk+5278KRdsw8dw==
X-Received: by 2002:a1c:7212:: with SMTP id n18mr32861502wmc.53.1589196791040;
        Mon, 11 May 2020 04:33:11 -0700 (PDT)
Received: from CBGR90WXYV0 ([54.239.6.188])
        by smtp.gmail.com with ESMTPSA id 32sm17495757wrg.19.2020.05.11.04.33.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 04:33:10 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: "Paul Durrant" <paul@xen.org>
Reply-To: <paul@xen.org>
To:     "'Denis Kirjanov'" <kda@linux-powerpc.org>,
        <netdev@vger.kernel.org>
Cc:     <brouer@redhat.com>, <jgross@suse.com>, <wei.liu@kernel.org>,
        <ilias.apalodimas@linaro.org>
References: <1589192541-11686-1-git-send-email-kda@linux-powerpc.org> <1589192541-11686-3-git-send-email-kda@linux-powerpc.org>
In-Reply-To: <1589192541-11686-3-git-send-email-kda@linux-powerpc.org>
Subject: RE: [PATCH net-next v9 2/2] xen networking: add XDP offset adjustment to xen-netback
Date:   Mon, 11 May 2020 12:33:08 +0100
Message-ID: <000c01d62787$f2e59a10$d8b0ce30$@xen.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-gb
Thread-Index: AQIU9PmTVpNq2fLG8JgzWe5HwULahQDzXzdtqB2JyBA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Denis Kirjanov <kda@linux-powerpc.org>
> Sent: 11 May 2020 11:22
> To: netdev@vger.kernel.org
> Cc: brouer@redhat.com; jgross@suse.com; wei.liu@kernel.org; paul@xen.org; ilias.apalodimas@linaro.org
> Subject: [PATCH net-next v9 2/2] xen networking: add XDP offset adjustment to xen-netback
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
> index ef58870..c97c98e 100644
> --- a/drivers/net/xen-netback/rx.c
> +++ b/drivers/net/xen-netback/rx.c
> @@ -33,6 +33,11 @@
>  #include <xen/xen.h>
>  #include <xen/events.h>
> 
> +static int xenvif_rx_xdp_offset(struct xenvif *vif)
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
> index 286054b..d447191 100644
> --- a/drivers/net/xen-netback/xenbus.c
> +++ b/drivers/net/xen-netback/xenbus.c
> @@ -393,6 +393,20 @@ static void set_backend_state(struct backend_info *be,
>  	}
>  }
> 
> +static void read_xenbus_frontend_xdp(struct backend_info *be,
> +				     struct xenbus_device *dev)
> +{
> +	struct xenvif *vif = be->vif;
> +	unsigned int val;
> +	int err;
> +
> +	err = xenbus_scanf(XBT_NIL, dev->otherend,
> +			   "feature-xdp", "%u", &val);
> +	if (err != 1)
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

I think this being the only call to read_xenbus_frontend_xdp() is still a problem. What happens if netback is reloaded against a
netfront that has already enabled 'feature-xdp'? AFAICT vif->xdp_enabled would remain false after the reload.

  Paul

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


