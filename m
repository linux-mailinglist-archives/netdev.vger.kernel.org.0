Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D54341983BD
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 20:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgC3SuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 14:50:17 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:51460 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgC3SuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 14:50:17 -0400
Received: by mail-pj1-f67.google.com with SMTP id w9so8019107pjh.1
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 11:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GG5fh5QK/c+4veIPwC2YhxGCiOTe8xzbutf8UHp7f0M=;
        b=KPdxhT+ms8Uz5ol4HmUl8G1g3Vqxzf4h7abWx4biHBMx+QWGA0ZHjOh8RgFwY7lZGp
         DB7phv8iJi0fKYrzATmyz16NNg8ORPREAmf38oMUuN3XAxT8LiMLB/fXQ7pbuhaGCxWw
         o1wgxZ4i8KzckNlMJ/ly+n51VcY0xqaRFR1y5r/2QGNXj+yBdAtAKJbvDhG4ONWppAX9
         jPQ/ASjkIoLxFBEhNz/+p8tgNZyIQ7tr9L58fmwLAA4b5XFciDfR2WzDElvX4mwl0ahQ
         VTwtTsM8ExKGYfLbO0tH2JRhDXI+JnvKurYYt7cgwLTR1YTx0ic653OL7b7bq2OXPhB8
         ZK7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GG5fh5QK/c+4veIPwC2YhxGCiOTe8xzbutf8UHp7f0M=;
        b=k6mRkXXiF6mQvcJu61HbezMx5k6+GVy1mqaBQJLCZbi9HJP407UaN0fmXFH8nmjv2v
         mM8dgcBCJ2XC9kGJu3X6N1hxbGMrC1J6hnAjVTspbYsPB5C+ZfWnGN5ba01aNs08pTXy
         NPj+dxl51hlXgwXXiYkSH6hEsPCUhAw1ndjSAeBLPmgg4ynSmaXJFTgGwnMGLQa0diqF
         eXpUcIJDutpAbCZzcWhfkEqANpGVWOXtiMhnd1dF248FtlZbo8Y9Lgb7YEcfp5ut2Sol
         N8del8c/MKI/IA8WHmswLAqi63gRa/e2bQrGu5UgDH4C/OaOKHVkw70bc3ZSvihzzfb4
         6pvQ==
X-Gm-Message-State: ANhLgQ0+dNFNw0M25Hc1QO2NWkOfh4nO4hsg+Mp7JjPjwMoESKaRBmqY
        2+XSYtrrzxtJCVBhHRZ06xQ=
X-Google-Smtp-Source: ADFU+vsLbT3zEcT6GuA/uN0cWqmJuwCqFxuKovE8CE61rFdxYZCCm/u25V8niYy0elDwKLuPEoeorQ==
X-Received: by 2002:a17:902:7886:: with SMTP id q6mr13980262pll.237.1585594216534;
        Mon, 30 Mar 2020 11:50:16 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id z6sm10173525pgg.39.2020.03.30.11.50.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 11:50:15 -0700 (PDT)
Subject: Re: [PATCH v2 net] inet_diag: add cgroup id attribute
To:     Dmitry Yakunin <zeil@yandex-team.ru>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     khlebnikov@yandex-team.ru
References: <20200330113803.GA19490@yandex-team.ru>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b7a87a9d-c412-618c-7420-6563e1e097d3@gmail.com>
Date:   Mon, 30 Mar 2020 11:50:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200330113803.GA19490@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/30/20 4:38 AM, Dmitry Yakunin wrote:
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
> +#ifdef CONFIG_SOCK_CGROUP_DATA
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
> +#ifdef CONFIG_SOCK_CGROUP_DATA
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
