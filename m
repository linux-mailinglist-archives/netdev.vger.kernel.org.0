Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D20D518CEBA
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 14:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbgCTNWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 09:22:53 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41290 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbgCTNWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 09:22:52 -0400
Received: by mail-pg1-f195.google.com with SMTP id b1so3073394pgm.8
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 06:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bfF1ba7JxG8l2nk5zDq/O6XUrI8PGweJ4GUaBo3/8w4=;
        b=i9Blyc9KZ0JnI8vRdrJsgLeLPK5hiSChQZkAoZth00tAqzrZCokbIlglZD5NfTOGQ5
         3g8FMiO5OfstmGQCASZhs+1H/dtRxyuczL01vxyxfBwaUiRuFN+V5lyiTpfLHapUudTZ
         xZFxHP4m+stbsbIMuoIzx8BOOcdxzt/O8r339Z2FgmCZSJ99onE3Cag28lp1tbDGG8O1
         S3rn5k2PbDA3zDHXSeDUDpHU2dRu3uPSN95aIouMgPnXin4dOcGWG8m2N7P7lzDHg3wF
         b2HKQqZF8tSAc43FX7xi5i19IIKZ62s9UKwJNmVkFOh66pdzNWwKUovSux5Glz8bus/I
         aGwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bfF1ba7JxG8l2nk5zDq/O6XUrI8PGweJ4GUaBo3/8w4=;
        b=cN8RNLT/K6FeEBfI7mMBubjnUCtH+jNywneQF3xcJz0lWGoBvtoZvpsVLAVSpchJBq
         dFKK2t4+lg6Dnc7447D2rsrC7c8Hjw8fYWDN+ZGBJii+XcLKW2+6gdYVzGu/gooXPMoJ
         qAePNLzcZDIhkymlp+Op3jEAPj0/sBskrlnqGrE5kB4bLruU0yf04/uOky+f6j5NAMSA
         7QZL7EPW9Fpa+vJbl4cKhr0T08eP9Ks0PhWPs3Ffk3qMeRFnUJdyqLetzbBOVDtavTgy
         YooSL2GYU6jkw7a0o4GkQt23E4ZtSjhPjoSxesYn3/RHkcJ3gadybdoHVMHH/5pRRRF6
         StNg==
X-Gm-Message-State: ANhLgQ321AqT9u1PdI6I+Lt7fc3Sg4k0gBN3kRudGSq2uH+1vdErEDk/
        +iJcAv0AsoyiZKAQWltOBfA=
X-Google-Smtp-Source: ADFU+vuMkCtzsOTUYDtYEcgopbEfUtNR2ZikbgjQgLvQRXiQvqASA6vwXtX1iwyu9Gn4nn40pHWm+A==
X-Received: by 2002:a63:2447:: with SMTP id k68mr8410593pgk.368.1584710571630;
        Fri, 20 Mar 2020 06:22:51 -0700 (PDT)
Received: from [192.168.1.18] (i223-218-245-204.s42.a013.ap.plala.or.jp. [223.218.245.204])
        by smtp.googlemail.com with ESMTPSA id k189sm5472730pgc.24.2020.03.20.06.22.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 06:22:51 -0700 (PDT)
Subject: Re: [PATCH net-next 4/5] veth: introduce more xdp counters
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, brouer@redhat.com, dsahern@gmail.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com
References: <cover.1584635611.git.lorenzo@kernel.org>
 <0763c17646523acb4dc15aaec01decb4efe11eac.1584635611.git.lorenzo@kernel.org>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <a3555c02-6cb1-c40c-65bb-12378439b12f@gmail.com>
Date:   Fri, 20 Mar 2020 22:22:48 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <0763c17646523acb4dc15aaec01decb4efe11eac.1584635611.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/03/20 1:41, Lorenzo Bianconi wrote:
> Introduce xdp_xmit counter in order to distinguish between XDP_TX and
> ndo_xdp_xmit stats. Introduce the following ethtool counters:
> - rx_xdp_tx
> - rx_xdp_tx_errors
> - tx_xdp_xmit
> - tx_xdp_xmit_errors
> - rx_xdp_redirect

Thank you for working on this!

> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
...
> @@ -395,7 +404,8 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>   	}
>   
>   	rcv_priv = netdev_priv(rcv);
> -	rq = &rcv_priv->rq[veth_select_rxq(rcv)];
> +	qidx = veth_select_rxq(rcv);
> +	rq = &rcv_priv->rq[qidx];
>   	/* Non-NULL xdp_prog ensures that xdp_ring is initialized on receive
>   	 * side. This means an XDP program is loaded on the peer and the peer
>   	 * device is up.
> @@ -424,6 +434,17 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>   	if (flags & XDP_XMIT_FLUSH)
>   		__veth_xdp_flush(rq);
>   
> +	rq = &priv->rq[qidx];

I think there is no guarantee that this rq exists. Qidx is less than 
rcv->real_num_rx_queues, but not necessarily less than 
dev->real_num_rx_queues.

> +	u64_stats_update_begin(&rq->stats.syncp);

So this can cuase NULL pointer dereference.

Toshiaki Makita

> +	if (ndo_xmit) {
> +		rq->stats.vs.xdp_xmit += n - drops;
> +		rq->stats.vs.xdp_xmit_err += drops;
> +	} else {
> +		rq->stats.vs.xdp_tx += n - drops;
> +		rq->stats.vs.xdp_tx_err += drops;
> +	}
> +	u64_stats_update_end(&rq->stats.syncp);
> +
>   	if (likely(!drops)) {
>   		rcu_read_unlock();
>   		return n;
> @@ -437,11 +458,17 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>   	return ret;
>   }
>   
> +static int veth_ndo_xdp_xmit(struct net_device *dev, int n,
> +			     struct xdp_frame **frames, u32 flags)
> +{
> +	return veth_xdp_xmit(dev, n, frames, flags, true);
> +}
> +
>   static void veth_xdp_flush_bq(struct net_device *dev, struct veth_xdp_tx_bq *bq)
>   {
>   	int sent, i, err = 0;
>   
> -	sent = veth_xdp_xmit(dev, bq->count, bq->q, 0);
> +	sent = veth_xdp_xmit(dev, bq->count, bq->q, 0, false);
>   	if (sent < 0) {
>   		err = sent;
>   		sent = 0;
> @@ -753,6 +780,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
>   	}
>   
>   	u64_stats_update_begin(&rq->stats.syncp);
> +	rq->stats.vs.xdp_redirect += stats->xdp_redirect;
>   	rq->stats.vs.xdp_bytes += stats->xdp_bytes;
>   	rq->stats.vs.xdp_drops += stats->xdp_drops;
>   	rq->stats.vs.rx_drops += stats->rx_drops;
> @@ -1172,7 +1200,7 @@ static const struct net_device_ops veth_netdev_ops = {
>   	.ndo_features_check	= passthru_features_check,
>   	.ndo_set_rx_headroom	= veth_set_rx_headroom,
>   	.ndo_bpf		= veth_xdp,
> -	.ndo_xdp_xmit		= veth_xdp_xmit,
> +	.ndo_xdp_xmit		= veth_ndo_xdp_xmit,
>   };
>   
>   #define VETH_FEATURES (NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HW_CSUM | \
> 
