Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D30291938AD
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgCZGgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:36:20 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46114 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgCZGgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:36:20 -0400
Received: by mail-pf1-f194.google.com with SMTP id q3so2269096pff.13
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 23:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vmMfSlkNqtMhrnEKTmZxU1g5L1uebNhhkz4Zxjb7H8s=;
        b=qD1vLorQ5c9WJpcglrQTkoZREJc5N2RB1FXf1KSR2jRr5lDAaJ7VIRVl5DuGAO3XsG
         IVsG/iM4zTSylbxurEVjg/NwAsmKdtoIesC0rHiFKfSVd+7NtKwYveB91dXDi3cQmJyv
         Swsi7QhziFmZZ913Tm23+YIXYVIDkBdPhEVcThp7eB/TrFpt35uZvitM7fl6LxStAbvi
         KVYm+pgfmbJfXp5skAUgqa/utqp0Dlf6jOizd+VpQQHkUQYWYhUgWBQGHqVrnIO8Mvmz
         WOcLw/DHmDbDnVnBSyxEE4dTXa0IWQB0NKrjCj1rj/UjWcCN099dbe1Uc0qY4MoBUydK
         rnNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vmMfSlkNqtMhrnEKTmZxU1g5L1uebNhhkz4Zxjb7H8s=;
        b=LUUqC/QvhOdNm55QKpIPW6alEoYZglqzlnToupg2k9yyp1WYpmA0+Ytnq9trFaZ9U0
         D/ggKoUnFyWIgLR1lkhF/mt/R6uxFBqKyZ1a3kh/BCTVgmSISXzUPx6bFqv+Rjb3DuBp
         XTSEUWHlnmZUn8235dGC4N2zYkM6TbOQg8dTm1DHF4U2HAY0eMQeLZbVISjs1v7T2XxA
         03b8ZmeyCKq2zmoYe53GHLFekgyN8I0owR0eHYoWjSpZwbRgMelamaR0bJVng7RxEDyM
         yI2/SfWgxrP0N8+OntAUkRBEUU6LlsBRKTPCF8TL6dtiezaItJKFE2NVZ8YaKsuLawNf
         s1Kg==
X-Gm-Message-State: ANhLgQ0Kodz/j5qH+2tVxornbaoaAfK+xbCOI0kknIPvmFQiqsgDl/UQ
        pOo9OJBUgAvzLNV2XOk6Lic=
X-Google-Smtp-Source: ADFU+vu2ywsm9x3inhMro0xrREFSdSqtJdofLTkNk/Jcm3WYv1I6bIVWFGbrXmcA6m8D0kYWIFyaKQ==
X-Received: by 2002:a05:6a00:2d0:: with SMTP id b16mr7760877pft.241.1585204578385;
        Wed, 25 Mar 2020 23:36:18 -0700 (PDT)
Received: from [192.168.1.18] (i223-218-245-204.s42.a013.ap.plala.or.jp. [223.218.245.204])
        by smtp.googlemail.com with ESMTPSA id f68sm842691pje.0.2020.03.25.23.36.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 23:36:17 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] veth: rely on veth_rq in veth_xdp_flush_bq
 signature
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, brouer@redhat.com, dsahern@gmail.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com
References: <cover.1585163874.git.lorenzo@kernel.org>
 <840c0c7fd83d78e47ed0136d5a032dccf7aef732.1585163874.git.lorenzo@kernel.org>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <fe753d30-b30b-4534-35c7-5ef06c609b96@gmail.com>
Date:   Thu, 26 Mar 2020 15:36:14 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <840c0c7fd83d78e47ed0136d5a032dccf7aef732.1585163874.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/03/26 4:22, Lorenzo Bianconi wrote:
> Substitute net_device point with veth_rq one in veth_xdp_flush_bq,
> veth_xdp_flush and veth_xdp_tx signature. This is a preliminary patch
> to account xdp_xmit counter on 'receiving' veth_rq
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>

> ---
>   drivers/net/veth.c | 30 +++++++++++++++---------------
>   1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index b6505a6c7102..2041152da716 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -468,46 +468,46 @@ static int veth_ndo_xdp_xmit(struct net_device *dev, int n,
>   	return veth_xdp_xmit(dev, n, frames, flags, true);
>   }
>   
> -static void veth_xdp_flush_bq(struct net_device *dev, struct veth_xdp_tx_bq *bq)
> +static void veth_xdp_flush_bq(struct veth_rq *rq, struct veth_xdp_tx_bq *bq)
>   {
>   	int sent, i, err = 0;
>   
> -	sent = veth_xdp_xmit(dev, bq->count, bq->q, 0, false);
> +	sent = veth_xdp_xmit(rq->dev, bq->count, bq->q, 0, false);
>   	if (sent < 0) {
>   		err = sent;
>   		sent = 0;
>   		for (i = 0; i < bq->count; i++)
>   			xdp_return_frame(bq->q[i]);
>   	}
> -	trace_xdp_bulk_tx(dev, sent, bq->count - sent, err);
> +	trace_xdp_bulk_tx(rq->dev, sent, bq->count - sent, err);
>   
>   	bq->count = 0;
>   }
>   
> -static void veth_xdp_flush(struct net_device *dev, struct veth_xdp_tx_bq *bq)
> +static void veth_xdp_flush(struct veth_rq *rq, struct veth_xdp_tx_bq *bq)
>   {
> -	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
> +	struct veth_priv *rcv_priv, *priv = netdev_priv(rq->dev);
>   	struct net_device *rcv;
> -	struct veth_rq *rq;
> +	struct veth_rq *rcv_rq;
>   
>   	rcu_read_lock();
> -	veth_xdp_flush_bq(dev, bq);
> +	veth_xdp_flush_bq(rq, bq);
>   	rcv = rcu_dereference(priv->peer);
>   	if (unlikely(!rcv))
>   		goto out;
>   
>   	rcv_priv = netdev_priv(rcv);
> -	rq = &rcv_priv->rq[veth_select_rxq(rcv)];
> +	rcv_rq = &rcv_priv->rq[veth_select_rxq(rcv)];
>   	/* xdp_ring is initialized on receive side? */
> -	if (unlikely(!rcu_access_pointer(rq->xdp_prog)))
> +	if (unlikely(!rcu_access_pointer(rcv_rq->xdp_prog)))
>   		goto out;
>   
> -	__veth_xdp_flush(rq);
> +	__veth_xdp_flush(rcv_rq);
>   out:
>   	rcu_read_unlock();
>   }
>   
> -static int veth_xdp_tx(struct net_device *dev, struct xdp_buff *xdp,
> +static int veth_xdp_tx(struct veth_rq *rq, struct xdp_buff *xdp,
>   		       struct veth_xdp_tx_bq *bq)
>   {
>   	struct xdp_frame *frame = convert_to_xdp_frame(xdp);
> @@ -516,7 +516,7 @@ static int veth_xdp_tx(struct net_device *dev, struct xdp_buff *xdp,
>   		return -EOVERFLOW;
>   
>   	if (unlikely(bq->count == VETH_XDP_TX_BULK_SIZE))
> -		veth_xdp_flush_bq(dev, bq);
> +		veth_xdp_flush_bq(rq, bq);
>   
>   	bq->q[bq->count++] = frame;
>   
> @@ -559,7 +559,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
>   			orig_frame = *frame;
>   			xdp.data_hard_start = head;
>   			xdp.rxq->mem = frame->mem;
> -			if (unlikely(veth_xdp_tx(rq->dev, &xdp, bq) < 0)) {
> +			if (unlikely(veth_xdp_tx(rq, &xdp, bq) < 0)) {
>   				trace_xdp_exception(rq->dev, xdp_prog, act);
>   				frame = &orig_frame;
>   				stats->rx_drops++;
> @@ -692,7 +692,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
>   		get_page(virt_to_page(xdp.data));
>   		consume_skb(skb);
>   		xdp.rxq->mem = rq->xdp_mem;
> -		if (unlikely(veth_xdp_tx(rq->dev, &xdp, bq) < 0)) {
> +		if (unlikely(veth_xdp_tx(rq, &xdp, bq) < 0)) {
>   			trace_xdp_exception(rq->dev, xdp_prog, act);
>   			stats->rx_drops++;
>   			goto err_xdp;
> @@ -817,7 +817,7 @@ static int veth_poll(struct napi_struct *napi, int budget)
>   	}
>   
>   	if (stats.xdp_tx > 0)
> -		veth_xdp_flush(rq->dev, &bq);
> +		veth_xdp_flush(rq, &bq);
>   	if (stats.xdp_redirect > 0)
>   		xdp_do_flush();
>   	xdp_clear_return_frame_no_direct();
> 
