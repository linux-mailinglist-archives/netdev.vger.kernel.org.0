Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2EE3A8EF9
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 04:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbhFPCr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 22:47:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232001AbhFPCr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 22:47:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623811552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cREO+84GhaG5TSQl9UHRbi28vd29E0zqu5N4+PU4txo=;
        b=Hf3zwnkNSqNDexTah4Mjw1p5kM3WoQs5V5IBh5SfqioCHM4/6yGwHiW9hNvlQRdIlbE/+z
        MyKXZ2vQfheRZoBkjeRbsgyt4ps/gDAAbnTTLUvjJ2xRBCb9jgSm2ClkWIN+Dk/zCU0Grh
        PUHjXOr2ncqJ3EgxAwYCCkVV6zz33xA=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-URzKBGXIOGus9ijJ_4uc6g-1; Tue, 15 Jun 2021 22:45:50 -0400
X-MC-Unique: URzKBGXIOGus9ijJ_4uc6g-1
Received: by mail-pg1-f198.google.com with SMTP id 17-20020a630b110000b029022064e7cdcfso567753pgl.10
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 19:45:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=cREO+84GhaG5TSQl9UHRbi28vd29E0zqu5N4+PU4txo=;
        b=njYjp5PTh5Q5Crxx5qRnAhR5jgtFwQXiAEA/E7BKGsBFEvKN2uNwva25O28UCJHZb2
         ixyBmH974XKOavEjrJezfCqVEULim6jSY+UdJYUrj2E+XtUMULTUqhNqwid4kT+jexN6
         3L2D4jdNEUw7Z/jABT6Xd555gLBntiTU6eqpXgw3G6zme0QYw9S9ZNfhv3XGnIoQluNa
         hn2wCWSOLLGjPRZwdUYlKwbMFumGt2c6Vcb7TTwkHliGSa9LewQv5yO21eBYV/MZ7O78
         wzERAZ736+wQ2IUB5yXnzrTp/MutNR+Zbc3hGZZwETdOE/sd7M094G2haCfvg77qMK94
         1UgA==
X-Gm-Message-State: AOAM531n7Y7eFpmgNWPi1+ccyjot+kTlc2yz7k3IftvCIaVTCeHp6kNt
        yxILQ1gtN+xxo7q3l+0uZjeF/14gWsauWTbpzFLMJyfz2cQm7rPZPfQKWu/T3bV1OzQVrE/Wi/g
        fdpQsefb4UhioJOXL
X-Received: by 2002:a65:55ca:: with SMTP id k10mr1758110pgs.230.1623811549292;
        Tue, 15 Jun 2021 19:45:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwl4zILdzduWVKN6947QbWSl9bXWj464tsCNzVX/0FMV9w3qxQCTNGemvzXREXrtn0nT4bUoQ==
X-Received: by 2002:a65:55ca:: with SMTP id k10mr1758088pgs.230.1623811548826;
        Tue, 15 Jun 2021 19:45:48 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id em22sm4056653pjb.27.2021.06.15.19.45.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 19:45:48 -0700 (PDT)
Subject: Re: [PATCH net-next v5 07/15] virtio-net: standalone
 virtnet_aloc_frag function
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust . li" <dust.li@linux.alibaba.com>
References: <20210610082209.91487-1-xuanzhuo@linux.alibaba.com>
 <20210610082209.91487-8-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8da41980-e306-c0ae-03e2-83c20e2e84f0@redhat.com>
Date:   Wed, 16 Jun 2021 10:45:40 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210610082209.91487-8-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/10 ÏÂÎç4:22, Xuan Zhuo Ð´µÀ:
> This logic is used by small and merge when adding buf, and the
> subsequent patch will also use this logic, so it is separated as an
> independent function.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasiowang@redhat.com>


> ---
>   drivers/net/virtio_net.c | 29 ++++++++++++++++++++---------
>   1 file changed, 20 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index d791543a8dd8..3fd87bf2b2ad 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -264,6 +264,22 @@ static struct xdp_frame *ptr_to_xdp(void *ptr)
>   	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
>   }
>   
> +static char *virtnet_alloc_frag(struct receive_queue *rq, unsigned int len,
> +				int gfp)
> +{
> +	struct page_frag *alloc_frag = &rq->alloc_frag;
> +	char *buf;
> +
> +	if (unlikely(!skb_page_frag_refill(len, alloc_frag, gfp)))
> +		return NULL;
> +
> +	buf = (char *)page_address(alloc_frag->page) + alloc_frag->offset;
> +	get_page(alloc_frag->page);
> +	alloc_frag->offset += len;
> +
> +	return buf;
> +}
> +
>   static void __free_old_xmit(struct send_queue *sq, bool in_napi,
>   			    struct virtnet_sq_stats *stats)
>   {
> @@ -1190,7 +1206,6 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
>   static int add_recvbuf_small(struct virtnet_info *vi, struct receive_queue *rq,
>   			     gfp_t gfp)
>   {
> -	struct page_frag *alloc_frag = &rq->alloc_frag;
>   	char *buf;
>   	unsigned int xdp_headroom = virtnet_get_headroom(vi);
>   	void *ctx = (void *)(unsigned long)xdp_headroom;
> @@ -1199,12 +1214,10 @@ static int add_recvbuf_small(struct virtnet_info *vi, struct receive_queue *rq,
>   
>   	len = SKB_DATA_ALIGN(len) +
>   	      SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> -	if (unlikely(!skb_page_frag_refill(len, alloc_frag, gfp)))
> +	buf = virtnet_alloc_frag(rq, len, gfp);
> +	if (unlikely(!buf))
>   		return -ENOMEM;
>   
> -	buf = (char *)page_address(alloc_frag->page) + alloc_frag->offset;
> -	get_page(alloc_frag->page);
> -	alloc_frag->offset += len;
>   	sg_init_one(rq->sg, buf + VIRTNET_RX_PAD + xdp_headroom,
>   		    vi->hdr_len + GOOD_PACKET_LEN);
>   	err = virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, gfp);
> @@ -1295,13 +1308,11 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
>   	 * disabled GSO for XDP, it won't be a big issue.
>   	 */
>   	len = get_mergeable_buf_len(rq, &rq->mrg_avg_pkt_len, room);
> -	if (unlikely(!skb_page_frag_refill(len + room, alloc_frag, gfp)))
> +	buf = virtnet_alloc_frag(rq, len + room, gfp);
> +	if (unlikely(!buf))
>   		return -ENOMEM;
>   
> -	buf = (char *)page_address(alloc_frag->page) + alloc_frag->offset;
>   	buf += headroom; /* advance address leaving hole at front of pkt */
> -	get_page(alloc_frag->page);
> -	alloc_frag->offset += len + room;
>   	hole = alloc_frag->size - alloc_frag->offset;
>   	if (hole < len + room) {
>   		/* To avoid internal fragmentation, if there is very likely not

