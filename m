Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E600F1B5CBE
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 15:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbgDWNk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 09:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727898AbgDWNk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 09:40:57 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED8FC08E934
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 06:40:57 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id g2so2363457plo.3
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 06:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7OeyoNk38Wjopkf6lgvaXOrAS3LptHOEqaiiAav5gjM=;
        b=hr1VCAkex0IvSQ44utzzw44Hp/XmIm9u7oDlOxNH0lk+PmikiuUMIM2EmAiCQJZPY2
         pSt0khExacsYUzKupK8/kpExBr9DGnLvADAm2wp6Le+D1AVtyTEyYJ4QSx+h8yz1b4vK
         8/7a/tN4C8vNQSsYcj/3gsyC9t0w39RZXWyZO5xnAwbyJlS9LeLACwaUYtxZCWkRAadF
         lBrGJ79Oej+0/rsXsAuR4VKSR1CWeV4N+y6LxeDpezOC+ssU4Vr0Rm9lsYmompewME2z
         8obOL4k0twGNwDC4sex+JF4kNEUD+Xo7jQjV494vRXa/KhTAD7VkiubjcpYB1zcd/cXy
         Ls7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7OeyoNk38Wjopkf6lgvaXOrAS3LptHOEqaiiAav5gjM=;
        b=jfNwdr9Ke/7kYClJPt0gTA0DFXPlBkp5//TtBUi2965RkYeYfNpyDBuQ5kCnNEgAAj
         9/bZAxOg23PVTkG9J4tsnRQVXrkPWvh5FQNdMm52AluJERiBEb1s5u0518muxUkEyL67
         8sBjrYhrX4NMnYlm3d20GismBG9VIBxcxCCbxSnAHwMoUA8tKl/LCOyQPDV9XdjxwuLp
         qRaDibVyN+cbwMx4HlKXym83AqWcJna3i2NLytarj9xUGs8PxKi/DSL+xWJt/C64GEcj
         gH9wn+plya2J8dN5qddYmLlwB8HblcQUg4+DYXQY6HeTDzq4OMUZHeuee7yKhH8P7lZt
         qoOw==
X-Gm-Message-State: AGi0PuYxYrR5UE4qH122JLgHAmCwcaLszNJaTahLFUTaQ+9km2tBkyFP
        VIpMijZ7B5qX1doYyCd2G5Y=
X-Google-Smtp-Source: APiQypKfV26lHqLvFass2dYoISW2voQiKAtoIxc6kJ3cDO4URZ+ZqHmJE4l/JsZCKzFWY7EHQUqhJQ==
X-Received: by 2002:a17:90a:ad93:: with SMTP id s19mr708460pjq.73.1587649256931;
        Thu, 23 Apr 2020 06:40:56 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 135sm2595975pfu.125.2020.04.23.06.40.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 06:40:56 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: Add TCP_FORCE_LINGER2 to TCP setsockopt
To:     Cambda Zhu <cambda@linux.alibaba.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
References: <eea2a2c3-79dc-131c-4ef5-ee027b30b701@gmail.com>
 <20200423073529.92152-1-cambda@linux.alibaba.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3e780f88-41df-413c-7a81-6a63fd750605@gmail.com>
Date:   Thu, 23 Apr 2020 06:40:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200423073529.92152-1-cambda@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/20 12:35 AM, Cambda Zhu wrote:
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
>  Changes in v2:
>    - Add int overflow check.
> 
>  include/uapi/linux/capability.h |  1 +
>  include/uapi/linux/tcp.h        |  1 +
>  net/ipv4/tcp.c                  | 11 +++++++++++
>  3 files changed, 13 insertions(+)
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
> index 6d87de434377..d8cd1fd66bc1 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3149,6 +3149,17 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
>  			tcp_enable_tx_delay();
>  		tp->tcp_tx_delay = val;
>  		break;
> +	case TCP_FORCE_LINGER2:
> +		if (val < 0)
> +			tp->linger2 = -1;
> +		else if (val > INT_MAX / HZ)
> +			err = -EINVAL;
> +		else if (val > net->ipv4.sysctl_tcp_fin_timeout / HZ &&
> +			 !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
> +			tp->linger2 = 0;
> +		else
> +			tp->linger2 = val * HZ;
> +		break;
>  	default:
>  		err = -ENOPROTOOPT;
>  		break;
> 

INT_MAX looks quite 

Anyway, I do not think we need a new socket option, since really it will need documentation and add more confusion.

net->ipv4.sysctl_tcp_fin_timeout is the default value for sockets which have tp->linger2 cleared.

Fact that it has been used to cap TCP_LINGER2 was probably a mistake.

What about adding a new define and simply let TCP_LINGER2 use it ?

Really there is no point trying to allow hours or even days for FIN timeout,
and no point limiting a socket from having a value between net->ipv4.sysctl_tcp_fin_timeout and 2 minutes,
at least from security perspective, these values seem legal as far as TCP specs are concerned.



diff --git a/include/net/tcp.h b/include/net/tcp.h
index dcf9a72eeaa6912202e8a1ca6cf800f7401bf517..8dceea9ae87712613243a48edddd83d9ac629295 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -126,6 +126,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
                                  * to combine FIN-WAIT-2 timeout with
                                  * TIME-WAIT timer.
                                  */
+#define TCP_FIN_TIMEOUT_MAX (120 * HZ) /* max TCP_LINGER2 value (two minutes) */
 
 #define TCP_DELACK_MAX ((unsigned)(HZ/5))      /* maximal time to delay before sending an ACK */
 #if HZ >= 100
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6d87de434377e3741314772e5fd866de1c599108..a723fec8704ba4dff235818622e52d67ec9ef489 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3035,7 +3035,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
        case TCP_LINGER2:
                if (val < 0)
                        tp->linger2 = -1;
-               else if (val > net->ipv4.sysctl_tcp_fin_timeout / HZ)
+               else if (val > TCP_FIN_TIMEOUT_MAX / HZ)
                        tp->linger2 = 0;
                else
                        tp->linger2 = val * HZ;


