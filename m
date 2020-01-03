Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD72012F56C
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 09:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbgACI1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 03:27:15 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45691 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgACI1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 03:27:15 -0500
Received: by mail-wr1-f66.google.com with SMTP id j42so41591623wrj.12
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 00:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=35RTQHIB4aBu/OJMRUO1ttpY1SNLUiNug20kpxIKBwU=;
        b=iextsuCsZsvZ/KubpEwf5zQqJr+tK17GoLGJLGjKf+WBwZRxVRdJho4JjE7l2pay3X
         21bTWGsJpKmZTnoBUP6XXf33cTttulWYIpfN82ny+nQPRVVdDqIdhVaenoW5fC/EKQ4l
         cEDvzEz/Vq4Z9SIib4Ia0qmaCMJ2jMhKhSiylpQTQJDLOsz4pjVLudC9udby9ppmFeJn
         Y0s+aIkElFR0VA5MnfKPYbqNNLoNLgfyIiNvgdJF0HVmBorYXZt6Cq3H2XNo/RRaCLtl
         QiP6Z59R0FL6N5yZ1Kh77pwocoM0qG0Im5XJeVeWFAHzOv5EhwVkSwKjif8z7D0n2cNt
         SHAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=35RTQHIB4aBu/OJMRUO1ttpY1SNLUiNug20kpxIKBwU=;
        b=hniCvvozL+eBlDxf8TW+4JhDYl2+INPospCTtZP1Ycl2hleBbNxqRjzJvbWUqy9FhJ
         KS+oE+M0fGGLArVCG04lBqZw54vNWEyuashLSmLqKQue5yqci4wdn9V+jcXjI0t2P0XQ
         gF8ynCdSfBcUooKxbDhOLZ0XDylOt8IbmtKJcDz+/ytHA5+ETwhEjJyvYq5f1YC9jxu7
         L3zSyiWbYGNxcpSjBQpudQDeVVUbtbSiywEeB37xzeDFezpK5+4YFKb9cTTbmrY5DgLb
         FUjxdtQCBSjQIDDF9J0oveQ8CTsXM5Dn3m2knV5Hf2i1+kqIwfGfdRF/MGJhKiQZev6N
         XhQQ==
X-Gm-Message-State: APjAAAVS0eemOvUyqfLpRl8JxOxZWi/gE5ne41ff31RCPP2PeGp3jaGl
        h5X6ItUv6ZhDUWOGLTtlbKzXLQ==
X-Google-Smtp-Source: APXvYqwxW6rX1BIWUtC6W8FzeH4mMsRaTJrMHCxn3NNWka/P27LHOet9BT5VZ3f1SG0+rzIt/KUX4A==
X-Received: by 2002:a5d:630c:: with SMTP id i12mr85378600wru.350.1578040033881;
        Fri, 03 Jan 2020 00:27:13 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id q3sm11288844wmc.47.2020.01.03.00.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 00:27:13 -0800 (PST)
Date:   Fri, 3 Jan 2020 09:27:13 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH][bpf-next] bpf: change bpf_skb_generic_push type as void
Message-ID: <20200103082712.GF12930@netronome.com>
References: <1578031353-27654-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1578031353-27654-1-git-send-email-lirongqing@baidu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 02:02:33PM +0800, Li RongQing wrote:
> bpf_skb_generic_push always returns 0, not need to check
> its return, so change its type as void
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

> ---
>  net/core/filter.c | 30 ++++++++++--------------------
>  1 file changed, 10 insertions(+), 20 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 42fd17c48c5f..1cbac34a4e11 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c

...

> @@ -5144,7 +5134,7 @@ BPF_CALL_3(bpf_lwt_seg6_adjust_srh, struct sk_buff *, skb, u32, offset,
>  		if (unlikely(ret < 0))
>  			return ret;
>  
> -		ret = bpf_skb_net_hdr_push(skb, offset, len);
> +		bpf_skb_net_hdr_push(skb, offset, len);

There is a check for (ret < 0) just below this if block.
That is ok becuase in order to get to here (ret < 0) must
be true as per the check a few lines above.

So I think this is ok although the asymmetry with the else arm
of this if statement is not ideal IMHO.

>  	} else {
>  		ret = bpf_skb_net_hdr_pop(skb, offset, -1 * len);
>  	}
> -- 
> 2.16.2
> 
