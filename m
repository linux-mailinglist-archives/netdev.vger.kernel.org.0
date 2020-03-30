Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF0891980BC
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 18:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgC3QQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 12:16:25 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39289 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728167AbgC3QQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 12:16:24 -0400
Received: by mail-pg1-f193.google.com with SMTP id g32so2837596pgb.6
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 09:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RepHLtXjOeLCmQxpdp33cqqDhxy59woVYyZ/e1TIakU=;
        b=JRitrEJ7RwVaXYSAZFyg5zGNSLDyJolPdm0St9y9W5CDs78QenWwSjEvOmzHRjLFWA
         q0AJ6HGxgOuB2putotDSsIi+qOwk6AMeWOft//s9YlFyS8aI+9mMr6Tcjxv1SRVi67BW
         GG0QMY/RNxGXcF5qbO6uLRZ/GeVOWqRLt03bzk4GkMmQMxP1p6EuixMmm2T5FtCb3Rq4
         uCUvs3nZLos5XS+67f9UrXg0jCXFvHKXffy2pOBsHHMBUFMcd4NakHsmlxK8ES95Fcm8
         uM/1T5LjEaDhiNwJo2sWrKy3x5bTSUr6BH3TgOBoKQMZbfmGZub4DaL+nUD88ZimYM6H
         Dg4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RepHLtXjOeLCmQxpdp33cqqDhxy59woVYyZ/e1TIakU=;
        b=Zd7tpZVawjgX2uP8GK4KS623weSQQXbTmJZMgxUAl9vA/uSPOta1od+OgJ82468hBF
         rlLSSrmf3naZoPOqyAbwqzDx3cSp1Czk/S7uQIbKlIVVQbq0dj+1cecFPTnTLD+stuYC
         QKz+ttmH5iAzY3ku/hn2vUXUHbFmuqXr6hhpa7NRUr/ITSLsmXjJeKdaieAciF5PK5nN
         HGSWJaTNMfsHZGP1aE8FmFKo0u1kXn5O6FZMBz+Ucs7K5roKjnlFTvjwhETC4MUJCdBz
         6WQ9TMG53mY8RsYwFIFW2WnhatJN7a3UqfwBp6bU+3ZriFrphQjeXsyiKlcsDH1IByCn
         akcA==
X-Gm-Message-State: AGi0PuaFPSWUIWW7J2Q40qQ5A+0q3a9ypaySjW1zI03EZ8J6I+9VPmOV
        Kfn6zfg/S4AOX8ee9Ur/yy8=
X-Google-Smtp-Source: APiQypKlP5OZLEriVGkNcPEHHAVSfvnmIEbPIeZI+uerYtB0P8mzbnGLZ0jiTvks4oa8Ysz2p5aSpQ==
X-Received: by 2002:a63:64c4:: with SMTP id y187mr8418718pgb.36.1585584983349;
        Mon, 30 Mar 2020 09:16:23 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id z15sm10592982pfg.152.2020.03.30.09.16.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 09:16:22 -0700 (PDT)
Subject: Re: [PATCH net] inet_diag: add cgroup id attribute
To:     Dmitry Yakunin <zeil@yandex-team.ru>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     khlebnikov@yandex-team.ru
References: <20200330081101.GA16030@yandex-team.ru>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <95a66a3d-46b3-1955-1b4b-b0d6e1586bde@gmail.com>
Date:   Mon, 30 Mar 2020 09:16:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200330081101.GA16030@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/30/20 1:11 AM, Dmitry Yakunin wrote:
> This patch adds cgroup v2 id to common inet diag message attributes.
> This allows investigate sockets on per cgroup basis when
> net_cls/net_prio cgroup not used.
> 
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> ---
>  include/linux/inet_diag.h      | 6 +++++-
>  include/uapi/linux/inet_diag.h | 1 +
>  net/ipv4/inet_diag.c           | 7 +++++++
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
> index c91cf2d..8bc5e7d 100644
> --- a/include/linux/inet_diag.h
> +++ b/include/linux/inet_diag.h
> @@ -66,7 +66,11 @@ static inline size_t inet_diag_msg_attrs_size(void)
>  		+ nla_total_size(1)  /* INET_DIAG_SKV6ONLY */
>  #endif
>  		+ nla_total_size(4)  /* INET_DIAG_MARK */
> -		+ nla_total_size(4); /* INET_DIAG_CLASS_ID */
> +		+ nla_total_size(4)  /* INET_DIAG_CLASS_ID */
> +#ifdef CONFIG_CGROUPS
> +		+ nla_total_size(8)  /* INET_DIAG_CGROUP_ID */


nla_total_size_64bit(sizeof(u64))


> +#endif
> +		;
>  }
>  int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
>  			     struct inet_diag_msg *r, int ext,
> diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
> index a1ff345..dc87ad6 100644
> --- a/include/uapi/linux/inet_diag.h
> +++ b/include/uapi/linux/inet_diag.h
> @@ -154,6 +154,7 @@ enum {
>  	INET_DIAG_CLASS_ID,	/* request as INET_DIAG_TCLASS */
>  	INET_DIAG_MD5SIG,
>  	INET_DIAG_ULP_INFO,
> +	INET_DIAG_CGROUP_ID,
>  	__INET_DIAG_MAX,
>  };
>  
> diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
> index 8c83775..ba0bb14 100644
> --- a/net/ipv4/inet_diag.c
> +++ b/net/ipv4/inet_diag.c
> @@ -161,6 +161,13 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
>  			goto errout;
>  	}
>  
> +#ifdef CONFIG_CGROUPS
> +	if (nla_put_u64_64bit(skb, INET_DIAG_CGROUP_ID,
> +			      cgroup_id(sock_cgroup_ptr(&sk->sk_cgrp_data)),
> +			      INET_DIAG_PAD))
> +		goto errout;
> +#endif
> +
>  	r->idiag_uid = from_kuid_munged(user_ns, sock_i_uid(sk));
>  	r->idiag_inode = sock_i_ino(sk);
>  
> 
