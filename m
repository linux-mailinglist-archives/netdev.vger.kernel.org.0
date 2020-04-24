Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6BD1B76A9
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 15:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgDXNMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 09:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgDXNMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 09:12:42 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE4BC09B045
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 06:12:42 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id b2so9868139ljp.4
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 06:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RGGRDHQXBK1Kdt01wMsi8QUeYk6tmntpaLA8lOBA4Cc=;
        b=AFGvXf/LbemwYbd/hy+qejDSTYCV2URKhbr5e0DiAh1ZiILkYDSFqTBcT5tJYz5/Y8
         tVlneqaJEGCJNVIFOPLB8vA3SkGLzyn26pgKO0KsuH0iVCHuPT9JOGtJ1za0TLc0mXdm
         MG9J4Ep6CknCQScPkd7eE+E+7hCYPtYZzwxPE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RGGRDHQXBK1Kdt01wMsi8QUeYk6tmntpaLA8lOBA4Cc=;
        b=L6X8QDiVzXQjtJdb2hMDF905vzXh+h2gCdlfEwN9NRN6ptxHY3ZaG/eq5ZR0/Td2ZB
         GbfgYRCn6nZ4L56Uu2NPyUkRkcupOvYq5wcgX/7Hv2V6QV1WTR8arJ3IrRZjdz5dG7yW
         Dq1WUD8qyRmrmdnDxYwi7jhY/ocRv5SOpA6TVieh97y3s14ZeRMy32OnH80l2Edq4eZz
         ZHyM+L1ymiLbexnvuEJOtASScJ6K6b19s3DucvGh/QPQkidpect30xitz7UQJ+dQE17/
         3Pp9/bFrqGALxqfh+J0oa6u3om46XfLXXfUJNZKZ4tLeraYo2uRFuo7Jz+ABH+ZDnDCF
         yfwQ==
X-Gm-Message-State: AGi0Pua7PziHmbFrHDqjzjpuCK66boLHsWMMVmgVgbclXaAUhtAZJA5E
        sGFs9CWat79N2sqnUSzM8H6E3Q==
X-Google-Smtp-Source: APiQypJu8UJHr3mOPhMTc2LzrFAo02CL8t2odBY6ea//tcWLs3qW6OFhDkiS1sMgJl+l6HRvxBDq0Q==
X-Received: by 2002:a2e:5746:: with SMTP id r6mr5806700ljd.15.1587733960629;
        Fri, 24 Apr 2020 06:12:40 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 12sm3196578ljq.0.2020.04.24.06.12.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 06:12:39 -0700 (PDT)
Subject: Re: [PATCH net-next v3 04/11] net: bridge: Add port attribute
 IFLA_BRPORT_MRP_RING_OPEN
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, davem@davemloft.net,
        jiri@resnulli.us, ivecera@redhat.com, kuba@kernel.org,
        roopa@cumulusnetworks.com, olteanv@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20200422161833.1123-1-horatiu.vultur@microchip.com>
 <20200422161833.1123-5-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <1f2767bf-8ca4-781f-b35a-1ed5a169c206@cumulusnetworks.com>
Date:   Fri, 24 Apr 2020 16:12:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200422161833.1123-5-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/04/2020 19:18, Horatiu Vultur wrote:
> This patch adds a new port attribute, IFLA_BRPORT_MRP_RING_OPEN, which allows
> to notify the userspace when the port lost the continuite of MRP frames.
> 
> This attribute is set by kernel whenever the SW or HW detects that the ring is
> being open or closed.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  include/uapi/linux/if_link.h       | 1 +
>  net/bridge/br_netlink.c            | 3 +++
>  tools/include/uapi/linux/if_link.h | 1 +
>  3 files changed, 5 insertions(+)
> 
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 61e0801c82df..4a295deb933b 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -343,6 +343,7 @@ enum {
>  	IFLA_BRPORT_NEIGH_SUPPRESS,
>  	IFLA_BRPORT_ISOLATED,
>  	IFLA_BRPORT_BACKUP_PORT,
> +	IFLA_BRPORT_MRP_RING_OPEN,
>  	__IFLA_BRPORT_MAX
>  };
>  #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index 43dab4066f91..4084f1ef8641 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -151,6 +151,7 @@ static inline size_t br_port_info_size(void)
>  		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MULTICAST_ROUTER */
>  #endif
>  		+ nla_total_size(sizeof(u16))	/* IFLA_BRPORT_GROUP_FWD_MASK */
> +		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MRP_RING_OPEN */
>  		+ 0;
>  }
>  
> @@ -213,6 +214,8 @@ static int br_port_fill_attrs(struct sk_buff *skb,
>  	    nla_put_u16(skb, IFLA_BRPORT_GROUP_FWD_MASK, p->group_fwd_mask) ||
>  	    nla_put_u8(skb, IFLA_BRPORT_NEIGH_SUPPRESS,
>  		       !!(p->flags & BR_NEIGH_SUPPRESS)) ||
> +	    nla_put_u8(skb, IFLA_BRPORT_MRP_RING_OPEN, !!(p->flags &
> +							  BR_MRP_LOST_CONT)) ||
>  	    nla_put_u8(skb, IFLA_BRPORT_ISOLATED, !!(p->flags & BR_ISOLATED)))
>  		return -EMSGSIZE;
>  
> diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
> index 024af2d1d0af..70dae9ba16f4 100644
> --- a/tools/include/uapi/linux/if_link.h
> +++ b/tools/include/uapi/linux/if_link.h
> @@ -343,6 +343,7 @@ enum {
>  	IFLA_BRPORT_NEIGH_SUPPRESS,
>  	IFLA_BRPORT_ISOLATED,
>  	IFLA_BRPORT_BACKUP_PORT,
> +	IFLA_BRPORT_MRP_RING_OPEN,
>  	__IFLA_BRPORT_MAX
>  };
>  #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
> 

Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

