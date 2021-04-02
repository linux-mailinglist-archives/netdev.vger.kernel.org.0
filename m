Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDAA3530EB
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 23:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbhDBVwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 17:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhDBVwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 17:52:39 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92229C0613E6;
        Fri,  2 Apr 2021 14:52:37 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v4so5701914wrp.13;
        Fri, 02 Apr 2021 14:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0D3yR4mwHZximTiiGKEshzmtM/8eZp0phj8T3N7q8hU=;
        b=VhIbkQ8GifO1Kold2N36Dl+IBm9vGNjEEu7C+H5TjDwowZmIcwBT6NKVH7KMUusRKt
         45NWbH7kcNez4CByoTXR4DrMvqs1iK3mci6uup4Fo3aZXeFiUlGO3qHO7tNEyQ2ht4Ed
         /6ysmzqd2yN0SBJSJWAoAV1ukFesygtwPBvC/ixuep6wU6eIvw2dALQqCEJnq1CitIMk
         DIh6p5bdWKn/Z4J09UVBNOyGHDkEQeOt8tdzjcOrR/T75hu5x6AnAsWEZONZ4MRUgbvD
         5R3g2TO5l4dkp3DnosLiJ1j5UoRYYQAbBuHXNBDbPP3ydB79at9tF9Rjn0evSJH3P8LO
         OmjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0D3yR4mwHZximTiiGKEshzmtM/8eZp0phj8T3N7q8hU=;
        b=gVmshYrIBHn2h4t66mpUKRsnO/1Ws3GvPJGJyFexAa0HLhKzabdm03QjWfzCahqLyh
         JEvJ81B6ripL53azUpIMWpFp5SfgFRheqBoMYfmdxscgzyxn7betC18lQCxOzFJX0obz
         fiQVTI5q2PN5JVeNS+vTDKdRGyxwINDO/tLakMi1zTMYD1Bn/eVpBS2J08i1jJH6P02H
         X0U2H4IiA362MPOilxZ0Q8vpd/b8rp8l8pOeCNF6/ePDOS0KadXvgI19UXRiEslOjSNv
         IXtgvXI7EFzIYkeXM3PleAsj4FsvR4Z7vKjbI7pQEBXT2sj3fQbfQgwuvYFuLBNu3nLj
         I8ng==
X-Gm-Message-State: AOAM531boc6eMOjqjybjV6jcqEoJG6XBnU/ypQbSSRt2a96TkAdCVjqX
        XKQzEKz0EWniKSSfWdGGPQ5h5+3Meds=
X-Google-Smtp-Source: ABdhPJxyxdxHMrmTC90ok7QpGYrc6s0AhLL8/F76PIq5A42Fs/tJ7Uwxl2cp1R7+yYmIwpqfdf60CQ==
X-Received: by 2002:a5d:518c:: with SMTP id k12mr17291690wrv.15.1617400356233;
        Fri, 02 Apr 2021 14:52:36 -0700 (PDT)
Received: from debian64.daheim (p5b0d78f7.dip0.t-ipconnect.de. [91.13.120.247])
        by smtp.gmail.com with ESMTPSA id j14sm15702918wrw.69.2021.04.02.14.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 14:52:35 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.94)
        (envelope-from <chunkeey@gmail.com>)
        id 1lSRhE-000RAM-Ux; Fri, 02 Apr 2021 23:52:34 +0200
Subject: Re: [PATCH] carl9170: remove get_tid_h
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <68efad7a597159e22771d37fc8b4a8a613866d60.1617399010.git.christophe.jaillet@wanadoo.fr>
From:   Christian Lamparter <chunkeey@gmail.com>
Message-ID: <0c1b2ce3-f599-e2cc-9c5d-c01d77486f44@gmail.com>
Date:   Fri, 2 Apr 2021 23:52:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <68efad7a597159e22771d37fc8b4a8a613866d60.1617399010.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/04/2021 23:31, Christophe JAILLET wrote:
> 'get_tid_h()' is the same as 'ieee80211_get_tid()'.
> So this function can be removed to save a few lines of code.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Christian Lamparter <chunkeey@gmail.com>

> ---
>   drivers/net/wireless/ath/carl9170/carl9170.h | 7 +------
>   drivers/net/wireless/ath/carl9170/tx.c       | 2 +-
>   2 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
> index 0d38100d6e4f..84a8ce0784b1 100644
> --- a/drivers/net/wireless/ath/carl9170/carl9170.h
> +++ b/drivers/net/wireless/ath/carl9170/carl9170.h
> @@ -631,14 +631,9 @@ static inline u16 carl9170_get_seq(struct sk_buff *skb)
>   	return get_seq_h(carl9170_get_hdr(skb));
>   }
>   
> -static inline u16 get_tid_h(struct ieee80211_hdr *hdr)
> -{
> -	return (ieee80211_get_qos_ctl(hdr))[0] & IEEE80211_QOS_CTL_TID_MASK;
> -}
> -
>   static inline u16 carl9170_get_tid(struct sk_buff *skb)
>   {
> -	return get_tid_h(carl9170_get_hdr(skb));
> +	return ieee80211_get_tid(carl9170_get_hdr(skb));
>   }
>   
>   static inline struct ieee80211_vif *
> diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
> index 6b8446ff48c8..88444fe6d1c6 100644
> --- a/drivers/net/wireless/ath/carl9170/tx.c
> +++ b/drivers/net/wireless/ath/carl9170/tx.c
> @@ -394,7 +394,7 @@ static void carl9170_tx_status_process_ampdu(struct ar9170 *ar,
>   	if (unlikely(!sta))
>   		goto out_rcu;
>   
> -	tid = get_tid_h(hdr);
> +	tid = ieee80211_get_tid(hdr);
>   
>   	sta_info = (void *) sta->drv_priv;
>   	tid_info = rcu_dereference(sta_info->agg[tid]);
> 

