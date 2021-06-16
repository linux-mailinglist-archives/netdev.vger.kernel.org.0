Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACE73A961D
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 11:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhFPJaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 05:30:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53600 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231686AbhFPJaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 05:30:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623835697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2zVitNKk74Er4xjOzMcHQzU2fhoa7EV3XbSfyR7Byfw=;
        b=YSK3/Y5rsULr16GjOM/lMK4MtgF7UmJCCQe0pBAZFb/HM1aPy/9FQonVqIg3yfakCrUpM7
        AsI2EkS6QdZnBd9F7L0kaSCFZKSi5ohPkN8KCfqXlc+eYRWkW6ylfYPPNmUAKpA//SE7qi
        c5pPMwUzEP8pvDalOVWd7s/4iljOCkM=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-ThSAQky8PwCNVVJjMdpHbw-1; Wed, 16 Jun 2021 05:28:13 -0400
X-MC-Unique: ThSAQky8PwCNVVJjMdpHbw-1
Received: by mail-pj1-f71.google.com with SMTP id om12-20020a17090b3a8cb029016a4ee7d56fso1320947pjb.7
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 02:28:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=2zVitNKk74Er4xjOzMcHQzU2fhoa7EV3XbSfyR7Byfw=;
        b=LM9DNtIDTXlAr0Q7E45lYj4XMiWn9yAlNss4SHOGGhMjpnbPasTh6ugBQ+JvYnX06F
         6uL50NLVa2xsu2OvMg0XWSvy9hdrqf+1KyZnkfiY15TUxy7UWvP3lHqurIPEkjKSJJ+3
         iXZCY+e9NW2s2+wqXbliMYbv62OfLndmgh3YFsSEkQJf1uAScRStElvwn+uLrlAXS7V4
         hil0mctvqQzXmdWoWxkkfQt/oJJROfg3pz8Ow2YdZC1lMXLsAmkkRe+WwyAzZTyIvhEG
         JkJu+8nApKDS0Jg/NFEUGYfYIxSngL/3KE6rJGWEEJH806XmM6yI1wLuPPxMpeE1pAP2
         XbuQ==
X-Gm-Message-State: AOAM531dG1B2RSzuDK5f8E/wRfX83BYelgVNqKIBU0aMe/400blYX+zR
        1jKLlxL9WBMwUIr/Rj6bV2TEwKwWgxFBZ9XT4rqSaRvqltSGah6bNHrdJnhnZdH48VCWO+6fRDv
        oHYO2ViZyjwfA6g7h
X-Received: by 2002:a63:6644:: with SMTP id a65mr3966405pgc.431.1623835692229;
        Wed, 16 Jun 2021 02:28:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxP1r2/tnSACBUqAVJSZsvh4f2v25ZAQ1BpTYQ8qzqXogVVtOU0xvIAm37d5R4P1bneZXCn0Q==
X-Received: by 2002:a63:6644:: with SMTP id a65mr3966377pgc.431.1623835692066;
        Wed, 16 Jun 2021 02:28:12 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d22sm1679372pgb.15.2021.06.16.02.28.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 02:28:11 -0700 (PDT)
Subject: Re: [PATCH net-next v5 03/15] virtio-net: add priv_flags
 IFF_NOT_USE_DMA_ADDR
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
 <20210610082209.91487-4-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6cbab579-93a7-27db-9b8f-0f94f1b20b13@redhat.com>
Date:   Wed, 16 Jun 2021 17:27:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210610082209.91487-4-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/10 ÏÂÎç4:21, Xuan Zhuo Ð´µÀ:
> virtio-net not use dma addr directly. So add this priv_flags
> IFF_NOT_USE_DMA_ADDR.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 0416a7e00914..6c1233f0ab3e 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3064,7 +3064,7 @@ static int virtnet_probe(struct virtio_device *vdev)
>   
>   	/* Set up network device as normal. */
>   	dev->priv_flags |= IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE |
> -			   IFF_TX_SKB_NO_LINEAR;
> +			   IFF_TX_SKB_NO_LINEAR | IFF_NOT_USE_DMA_ADDR;


I wonder instead of doing trick like this, how about teach the virtio 
core to accept DMA address via sg?

Thanks


>   	dev->netdev_ops = &virtnet_netdev;
>   	dev->features = NETIF_F_HIGHDMA;
>   

