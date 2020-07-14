Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2FC21F285
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 15:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgGNN3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 09:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgGNN3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 09:29:37 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5C3C061794
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:29:36 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f139so5971930wmf.5
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4HmbsAMObqZGkcA7hG2xxjCG9/cCH7z4XX9t73gu4dA=;
        b=CKze1TiGSjQXnD3dI9mZXRtyO4KfBx8rTKNJ8UMhhZQSrGx+pjmc9KjDpI7Cc0kSq/
         Tal5/+YoT/X7tfFnhfBVNm1c4dJgWaW+ELwMYSS9B3sZrVr4mYAZo+MDrc55iDGVlEiV
         Lye0yBzgrwUHplVBuYa9OjhsyborjclEK4lWo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4HmbsAMObqZGkcA7hG2xxjCG9/cCH7z4XX9t73gu4dA=;
        b=Y27rBYdDFR8Ka664t0cofA0SawAniqj+FdskTFgqM6wioZgLGUKva9KMJNIEjji3yw
         3piOj9vtWHsbXKkxOlKecJWnw5jfU14wRtil5ftOVU/wFcsqpf1+oh6aV7TqmIMxUuxw
         jVtowbaSsgBwFjNVVwkjpjjCDkspvBSY3OOaHmeISbAE2ftyYf+ZVU8bVvmNb+zPBZiY
         f1ppPc3glgNNDlBZZr+G6gJnVP6qKlo0cHRfrB1uUWjvn7N8VM6yqh+Ym95EzNho3F+d
         X2jj1kvLI3BzGRJgkaevKiZ210Hixhrbx6yDce3eT5GW9zJaqlil7gi1q7bytP/9qSxQ
         zEAQ==
X-Gm-Message-State: AOAM533i8ypuBKasY+c/rXLIK1uMamwde7J79fSQ/9uIgy3fuwQk+3aF
        YhO52cDB3q/RYppuWkqC6K81/w==
X-Google-Smtp-Source: ABdhPJyC02bAxpbjIo7tFHGQ0Kf+FQhiG9QsKidBwYlv/AG9V/WaB0iZJUHiYwwOje61BBdFL0+RGA==
X-Received: by 2002:a1c:e143:: with SMTP id y64mr4514377wmg.90.1594733375511;
        Tue, 14 Jul 2020 06:29:35 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id t16sm30280468wru.9.2020.07.14.06.29.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 06:29:34 -0700 (PDT)
Subject: Re: [PATCH net-next v4 12/12] net: bridge: Add port attribute
 IFLA_BRPORT_MRP_IN_OPEN
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net, kuba@kernel.org,
        jiri@resnulli.us, ivecera@redhat.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20200714073458.1939574-1-horatiu.vultur@microchip.com>
 <20200714073458.1939574-13-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <9eeb89c5-865f-2b21-c7c6-7f4479bf4175@cumulusnetworks.com>
Date:   Tue, 14 Jul 2020 16:29:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200714073458.1939574-13-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/07/2020 10:34, Horatiu Vultur wrote:
> This patch adds a new port attribute, IFLA_BRPORT_MRP_IN_OPEN, which
> allows to notify the userspace when the node lost the contiuity of
> MRP_InTest frames.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  include/uapi/linux/if_link.h       | 1 +
>  net/bridge/br_netlink.c            | 3 +++
>  tools/include/uapi/linux/if_link.h | 1 +
>  3 files changed, 5 insertions(+)
> 

It's kind of late by now, but I'd wish these were contained in a nested MRP attribute. :)
Horatiu, do you expect to have many more MRP attributes outside of MRP netlink code?

Perhaps we should at least dump them only for MRP-aware ports, that should be easy.
They make no sense outside of MRP anyway, but increase the size of the dump for all
right now.

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index cc185a007ade8..26842ffd0501d 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -344,6 +344,7 @@ enum {
>  	IFLA_BRPORT_ISOLATED,
>  	IFLA_BRPORT_BACKUP_PORT,
>  	IFLA_BRPORT_MRP_RING_OPEN,
> +	IFLA_BRPORT_MRP_IN_OPEN,
>  	__IFLA_BRPORT_MAX
>  };
>  #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index c532fa65c9834..147d52596e174 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -152,6 +152,7 @@ static inline size_t br_port_info_size(void)
>  #endif
>  		+ nla_total_size(sizeof(u16))	/* IFLA_BRPORT_GROUP_FWD_MASK */
>  		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MRP_RING_OPEN */
> +		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MRP_IN_OPEN */
>  		+ 0;
>  }
>  
> @@ -216,6 +217,8 @@ static int br_port_fill_attrs(struct sk_buff *skb,
>  		       !!(p->flags & BR_NEIGH_SUPPRESS)) ||
>  	    nla_put_u8(skb, IFLA_BRPORT_MRP_RING_OPEN, !!(p->flags &
>  							  BR_MRP_LOST_CONT)) ||
> +	    nla_put_u8(skb, IFLA_BRPORT_MRP_IN_OPEN,
> +		       !!(p->flags & BR_MRP_LOST_IN_CONT)) ||
>  	    nla_put_u8(skb, IFLA_BRPORT_ISOLATED, !!(p->flags & BR_ISOLATED)))
>  		return -EMSGSIZE;
>  
> diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
> index cafedbbfefbe9..781e482dc499f 100644
> --- a/tools/include/uapi/linux/if_link.h
> +++ b/tools/include/uapi/linux/if_link.h
> @@ -344,6 +344,7 @@ enum {
>  	IFLA_BRPORT_ISOLATED,
>  	IFLA_BRPORT_BACKUP_PORT,
>  	IFLA_BRPORT_MRP_RING_OPEN,
> +	IFLA_BRPORT_MRP_IN_OPEN,
>  	__IFLA_BRPORT_MAX
>  };
>  #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
> 

