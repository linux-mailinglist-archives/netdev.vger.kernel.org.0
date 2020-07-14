Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9086321F23C
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 15:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgGNNPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 09:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728294AbgGNNPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 09:15:50 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168ACC061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:15:50 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f7so21536568wrw.1
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=FxJqrHhg0G0ncHUrHEuIRffmrZYQGuHLCnGks1j1bQM=;
        b=TqSa14w7dWnNYezldSLiuWoHhgo2zcjASexkPXEh+2iGpB2nAcR54Vdz6cuj8Oz9B0
         atzp+jjuGO56jmDKvCcRCNrZPIRHALoy+bV3oqGvUCCyB/SO9HPvF1qSUL8iyjwiM2ZN
         r950qHEUsa//TUKVU5SBVVDe1V/hqHRyghU+A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FxJqrHhg0G0ncHUrHEuIRffmrZYQGuHLCnGks1j1bQM=;
        b=Yj1lziFiAdb6pRvXqwmEVFavuRA2F5DRvQkesvkSZ+vwenoNaGkXTZcvwKQ10pThK2
         1tISD1P1w3+xc9e5u+3eS/tTFG0ube+IXJhWaqdl3IzIB+lKFDNuBuqjEGhriCEHQdQV
         ayiKtErrhgio5K0DVnGz6/m/MMAb/KJRd8nP8lFbDJO4M8gzet+f7Q7QCwMx05F7dbvc
         8rcsut+mpM/4EjCEfQCRpuyEnzCuUlftOYxWzd28GOTpCXwUs8rv/KdUy/1jKqnfDkga
         XcSoBPPBvzD1rhf8HQgV899Oj5bB34fyMvNJzCdVCyElA5HuYvc8huzmLTWMHOdGgp0B
         uo2g==
X-Gm-Message-State: AOAM531SYaLfiHtte1+kNFTLACRJt4h0ex6JKI/gEo38vcX5kkjUT7E4
        GyHgoMV26JDDDWBrLKhbwq7XJ+Xts2NLfg==
X-Google-Smtp-Source: ABdhPJxAejX7e0cIDmVXbcaejKJR9o77DDTzyzXJOg3PPlA6j89HyUpCZ2ISzb4W6Wh0uyKIKLY8xw==
X-Received: by 2002:a5d:62d1:: with SMTP id o17mr5291848wrv.162.1594732548828;
        Tue, 14 Jul 2020 06:15:48 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id e17sm27788229wrr.88.2020.07.14.06.15.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 06:15:48 -0700 (PDT)
Subject: Re: [PATCH net-next v4 05/12] bridge: mrp: Rename br_mrp_port_open to
 br_mrp_ring_port_open
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net, kuba@kernel.org,
        jiri@resnulli.us, ivecera@redhat.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20200714073458.1939574-1-horatiu.vultur@microchip.com>
 <20200714073458.1939574-6-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <622d77e3-6ea0-9a5e-2745-4231dd40b1e8@cumulusnetworks.com>
Date:   Tue, 14 Jul 2020 16:15:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200714073458.1939574-6-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/07/2020 10:34, Horatiu Vultur wrote:
> This patch renames the function br_mrp_port_open to
> br_mrp_ring_port_open. In this way is more clear that a ring port lost
> the continuity because there will be also a br_mrp_in_port_open.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  net/bridge/br_mrp.c         | 6 +++---
>  net/bridge/br_mrp_netlink.c | 2 +-
>  net/bridge/br_private_mrp.h | 2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

> diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
> index 90592af9db619..fe7cf1446b58a 100644
> --- a/net/bridge/br_mrp.c
> +++ b/net/bridge/br_mrp.c
> @@ -213,7 +213,7 @@ static void br_mrp_test_work_expired(struct work_struct *work)
>  		}
>  
>  		if (notify_open && !mrp->ring_role_offloaded)
> -			br_mrp_port_open(p->dev, true);
> +			br_mrp_ring_port_open(p->dev, true);
>  	}
>  
>  	p = rcu_dereference(mrp->s_port);
> @@ -229,7 +229,7 @@ static void br_mrp_test_work_expired(struct work_struct *work)
>  		}
>  
>  		if (notify_open && !mrp->ring_role_offloaded)
> -			br_mrp_port_open(p->dev, true);
> +			br_mrp_ring_port_open(p->dev, true);
>  	}
>  
>  out:
> @@ -537,7 +537,7 @@ static void br_mrp_mrm_process(struct br_mrp *mrp, struct net_bridge_port *port,
>  	 * not closed
>  	 */
>  	if (mrp->ring_state != BR_MRP_RING_STATE_CLOSED)
> -		br_mrp_port_open(port->dev, false);
> +		br_mrp_ring_port_open(port->dev, false);
>  }
>  
>  /* Determin if the test hdr has a better priority than the node */
> diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
> index c4f5c356811f3..acce300c0cc29 100644
> --- a/net/bridge/br_mrp_netlink.c
> +++ b/net/bridge/br_mrp_netlink.c
> @@ -368,7 +368,7 @@ int br_mrp_fill_info(struct sk_buff *skb, struct net_bridge *br)
>  	return -EMSGSIZE;
>  }
>  
> -int br_mrp_port_open(struct net_device *dev, u8 loc)
> +int br_mrp_ring_port_open(struct net_device *dev, u8 loc)
>  {
>  	struct net_bridge_port *p;
>  	int err = 0;
> diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
> index 8841ba847fb29..e93c8f9d4df58 100644
> --- a/net/bridge/br_private_mrp.h
> +++ b/net/bridge/br_private_mrp.h
> @@ -74,6 +74,6 @@ int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
>  				   enum br_mrp_port_role_type role);
>  
>  /* br_mrp_netlink.c  */
> -int br_mrp_port_open(struct net_device *dev, u8 loc);
> +int br_mrp_ring_port_open(struct net_device *dev, u8 loc);
>  
>  #endif /* _BR_PRIVATE_MRP_H */
> 

