Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93001B52DD
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 05:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgDWDBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 23:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgDWDBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 23:01:13 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5ADC03C1AA
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 20:01:13 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id y6so1801858pjc.4
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 20:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f45EMOOlhhPCnkNNq/mCteXnrbwWaC2ghFpy0uA+WOg=;
        b=qUP8jEkQiCIAjVaklnVtrmwVj5ZHEiMzXAXzIVRe4/HigdHvzAyinrwaeyk93bldT3
         V3ORl38cA87DsHsm0R6EH+YqrerFlRfSduYX+DR5dACnRIr/0iuV0XfozxiVIZRj8sRP
         lGZLkAIXKc70gXYoVzEvNiN6elZtGU3djC4dcJov3faQhWIOnsip4dXOoxaRTvAmxHFU
         JUeN8K8ot2LAECXiDjEp0hDvVx431SBGmX7vt2WN8AzbPwzTSNSYpz1QJB14pKyeDimn
         BM7kh5GGXadEm3yM2Lq8D5lifm7UzgbFxTOdAWreL4gKC85esXXjT3H7epxRqknXUV5S
         7Hgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f45EMOOlhhPCnkNNq/mCteXnrbwWaC2ghFpy0uA+WOg=;
        b=XJSUtx8UpDNoFuYc6cWEJSpCUBMoeUcDTwb0krU+/STkm5J45Qrizz60XesWJBs9W/
         NzZQAmZDXKQ9xTaBbw0ZNdt+YJQWHzGZmHthmFVwsJK4WnNA4s2j49zkpWe9eEKwD3aq
         uzWFqPZGyJApry169RCkTWmi4U2Ej6k19CkicfYKBkVS9dX3095tPS/F9bACWJJGcmOr
         z2py64B1B2ojOfzXjGjivtrjKEkkGQIFXVOel6DuCbKp8famQswnSESPhO/ETAPFxA6f
         IbLnEl6I0aesm+gWbG1t/TnInt5qJzZzaax1BnzvXy6sRrK6d+i8uDFUgWLz6pyH0G5P
         QoHg==
X-Gm-Message-State: AGi0PuZ3/A9ytkgIxLSNLNqD9hcYyirhd0+8jwk6mBla7fWsbv5p0AjW
        WgDSfapLfs80cUoYuAgnWmYtrnt8
X-Google-Smtp-Source: APiQypL7I21RGA4H04tdRCCtOXc4aSrc7OqdIl8D7D3+KWGeYBcY20qOy4prkQGZqDjExSVcPuwRkw==
X-Received: by 2002:a17:90a:c702:: with SMTP id o2mr1930825pjt.196.1587610873193;
        Wed, 22 Apr 2020 20:01:13 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id i6sm957985pfg.138.2020.04.22.20.01.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 20:01:12 -0700 (PDT)
Subject: Re: [PATCH net-next] net: Add TCP_FORCE_LINGER2 to TCP setsockopt
To:     Cambda Zhu <cambda@linux.alibaba.com>,
        netdev <netdev@vger.kernel.org>
Cc:     Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
References: <20200421121737.3269-1-cambda@linux.alibaba.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <eea2a2c3-79dc-131c-4ef5-ee027b30b701@gmail.com>
Date:   Wed, 22 Apr 2020 20:01:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200421121737.3269-1-cambda@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/21/20 5:17 AM, Cambda Zhu wrote:
> This patch adds a new TCP socket option named TCP_FORCE_LINGER2. The
> option has same behavior as TCP_LINGER2, except the tp->linger2 value
> can be greater than sysctl_tcp_fin_timeout if the user_ns is capable
> with CAP_NET_ADMIN.
> 
> As a server, different sockets may need different FIN-WAIT timeout and
> in most cases the system default value will be used. The timeout can
> be adjusted by setting TCP_LINGER2 but cannot be greater than the
> system default value. If one socket needs a timeout greater than the
> default, we have to adjust the sysctl which affects all sockets using
> the system default value. And if we want to adjust it for just one
> socket and keep the original value for others, all the other sockets
> have to set TCP_LINGER2. But with TCP_FORCE_LINGER2, the net admin can
> set greater tp->linger2 than the default for one socket and keep
> the sysctl_tcp_fin_timeout unchanged.
> 
> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
> ---
>  include/uapi/linux/capability.h | 1 +
>  include/uapi/linux/tcp.h        | 1 +
>  net/ipv4/tcp.c                  | 9 +++++++++
>  3 files changed, 11 insertions(+)
> 
> diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
> index 272dc69fa080..0e30c9756a04 100644
> --- a/include/uapi/linux/capability.h
> +++ b/include/uapi/linux/capability.h
> @@ -199,6 +199,7 @@ struct vfs_ns_cap_data {
>  /* Allow multicasting */
>  /* Allow read/write of device-specific registers */
>  /* Allow activation of ATM control sockets */
> +/* Allow setting TCP_LINGER2 regardless of sysctl_tcp_fin_timeout */
>  
>  #define CAP_NET_ADMIN        12
>  
> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> index f2acb2566333..e21e0ce98ca1 100644
> --- a/include/uapi/linux/tcp.h
> +++ b/include/uapi/linux/tcp.h
> @@ -128,6 +128,7 @@ enum {
>  #define TCP_CM_INQ		TCP_INQ
>  
>  #define TCP_TX_DELAY		37	/* delay outgoing packets by XX usec */
> +#define TCP_FORCE_LINGER2	38	/* Set TCP_LINGER2 regardless of sysctl_tcp_fin_timeout */
>  
>  
>  #define TCP_REPAIR_ON		1
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 6d87de434377..898a675d863e 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3149,6 +3149,15 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
>  			tcp_enable_tx_delay();
>  		tp->tcp_tx_delay = val;
>  		break;
> +	case TCP_FORCE_LINGER2:
> +		if (val < 0)
> +			tp->linger2 = -1;
> +		else if (val > net->ipv4.sysctl_tcp_fin_timeout / HZ &&
> +			 !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
> +			tp->linger2 = 0;
> +		else
> +			tp->linger2 = val * HZ;

This multiply could overflow.

Since tp->linger2 is an int, and a negative value has a specific meaning,
you probably should have some sanity checks.

Even if the old TCP_LINGER2 silently put a 0,
maybe a new option should return an error if val*HZ would overflow.



> +		break;
>  	default:
>  		err = -ENOPROTOOPT;
>  		break;
> 
