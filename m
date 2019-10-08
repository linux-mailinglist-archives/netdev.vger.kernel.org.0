Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89375CF9AA
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 14:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730822AbfJHMVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 08:21:43 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39389 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730316AbfJHMVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 08:21:42 -0400
Received: by mail-qt1-f193.google.com with SMTP id n7so24915256qtb.6
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 05:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FklwAJkWkFfqVhFJwE3uKrY0Kho9xe6Jxjc5x8r/lww=;
        b=ZpKFZWgALaElY3YmkRpS44z1nhbsbA4CWr3DF1adhEAziR15Fah/Ld1OjpLCeGgO04
         BPqmylv2a1g1j8rGnd2tJWuBBNReFhuKUb0eH3CtJhXZnKzsc2VA4DAYoTfjl8dvGYw5
         oRR0gQl2yYRoF6gVCqpF64Z9xaJuVd03MOC+aVhJZB6fKktVjuRnB2bMhcxE5+j1sKoZ
         0V28bUzM/4qrEIQH6xk76Osr3lBbkuoxi8NAg3xI+j25TjGQyfyzhMj9BN6p21OPOKbE
         gTlGFc+WIvK/cc2gDOaxZ590219X7G282kH/mVrBioK+JtonyLlU1i1wsDOiZq0ge1eh
         7wpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FklwAJkWkFfqVhFJwE3uKrY0Kho9xe6Jxjc5x8r/lww=;
        b=UvcFIHgkU8fhilwTTUq9AeRM9lTHBspuk/B019JJaaZXrNv0xEy9JIyellzog4ah/G
         DRWXIVHelxxUCTX89+qiGWh1hdK5vMhdDvyWGBvufRfUqvSn0VmGeOWVIQPv7z04l008
         QoUpK/dRcN7iJFEMPZu3AC1wBx1VoE6rMd9u6r5uNLZNnU9/sunwi9lqJ/u+MyEA089N
         AolkiMFdzTP5NgODuWwAE8jww41sHTZZ4kirfDCtpVCrLQR305O6gk3HSw6qrIZQShnC
         wNV2kqILtg3M4/o7w1mjqF3dupNqHJ2/iF3gPGWYEobjhinCnJWLXosRX20Lw5LR6TG6
         z0Yg==
X-Gm-Message-State: APjAAAXQiTjTb8i1gxrhhEiGoKRhtEfpOEko9zDAZCfezdZl52Phr1zF
        LFd9xFPFBuBhjEr1FKyycMk0KdeAXqk=
X-Google-Smtp-Source: APXvYqzDTRfWEFIZaxa5N0RmwXhVul5Ev/s6YL6Mo0ulEHoZkP274qto3XcEJGfnmFSr6Br9nsi/3w==
X-Received: by 2002:a0c:9846:: with SMTP id e6mr31981908qvd.114.1570537301835;
        Tue, 08 Oct 2019 05:21:41 -0700 (PDT)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id p77sm10176387qke.6.2019.10.08.05.21.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 08 Oct 2019 05:21:41 -0700 (PDT)
Date:   Tue, 8 Oct 2019 14:21:39 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] ipv6: Make ipv6_mc_may_pull() return bool.
Message-ID: <20191008122137.rgdmi2c7aixqx6lq@netronome.com>
References: <20191007.153804.598102160154212516.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007.153804.598102160154212516.davem@davemloft.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 03:38:04PM +0200, David Miller wrote:
> 
> Consistent with how pskb_may_pull() also now does so.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

> ---
>  include/net/addrconf.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/addrconf.h b/include/net/addrconf.h
> index 3f62b347b04a..1bab88184d3c 100644
> --- a/include/net/addrconf.h
> +++ b/include/net/addrconf.h
> @@ -202,11 +202,11 @@ u32 ipv6_addr_label(struct net *net, const struct in6_addr *addr,
>  /*
>   *	multicast prototypes (mcast.c)
>   */
> -static inline int ipv6_mc_may_pull(struct sk_buff *skb,
> -				   unsigned int len)
> +static inline bool ipv6_mc_may_pull(struct sk_buff *skb,
> +				    unsigned int len)
>  {
>  	if (skb_transport_offset(skb) + ipv6_transport_len(skb) < len)
> -		return 0;
> +		return false;
>  
>  	return pskb_may_pull(skb, len);
>  }
> -- 
> 2.21.0
> 
