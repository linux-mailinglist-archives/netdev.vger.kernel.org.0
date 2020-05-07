Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206F91C8DED
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgEGOKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727887AbgEGOKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:10:09 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B18C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 07:10:08 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id s10so2104826plr.1
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 07:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+8DfqjNZ53g+33+QKC252T8QlAeBW815WGE9HHk2qy4=;
        b=SOoC9Uy7KvQ1OTjQL+PvJxwICLGH21b+HbdweiqkEz1AYP9xQ0dRXDbsXp6S98+9rj
         QTTtiJnxgxEC0VXp714ibIMz7ziI+/3ij+mb9m3xQ1ZiwQ6iOkwZ+QSRVIucursSQlES
         q5V+cd1PkXhaLHpapTCFG9Jbef9WXooiKUCCslOF2Eu+SbvaNqgsLxko3L7cA8rzqvyB
         hsaGYqLeONB2Y6cBWP8HcOzi6ZU+U8ypJQf2Vb0rRzK8NsokG2gbVUpj5p4d6ShNZ5ol
         iX3EWd/v51OFhCsrR+Ycv+YdV/GZHqQkvV2sEXZdfB9+TzMmbsosT93OHZBO1Fb8MI+B
         lTHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+8DfqjNZ53g+33+QKC252T8QlAeBW815WGE9HHk2qy4=;
        b=GUd2V5OJAEpY5uF6AKftuyGBSwX7GGmILpdF96Yh69sfVEWMBf1TLr5Re8L4zzDw1q
         mIUqCPU+IIOpFKPOVlrazy3iECgh/PPwP+5jAgj7VC1RaJaF1nFeKWP36mNGUUIr8SHX
         iTrCiK+NJvJhpeZ0UEPPjgdk50xZHTX275nX+hjs0GGTAcfgh09AmeBIWK+dW6sb9dK9
         Mw/cLWtp5S1rZR2zeCaOgPwUGqA1d+6VPHBaNoAVI3N/OPOaiE6gWl9ExQmks6Eg/ypU
         ljfdDoA50bJVldKO2PDdNF46yvQBnqJ56WcEojNfHmtBxWeGSO4/k1Mytn3xq5j5YOfL
         Qf7Q==
X-Gm-Message-State: AGi0PuZb7JjDA727Jr3ZQtZ86fU6rgMWaFXwWZMsnf4CnJB8xr23rik4
        RZoYuwkp1oVeNEpzr39M5dme51SB
X-Google-Smtp-Source: APiQypKNwSW2BxT8/qG7pSl9x3XllWUrkJksjYUWSWmyQFzBFAuamyovfysKB+i9ymAbters/n8b2w==
X-Received: by 2002:a17:90a:a05:: with SMTP id o5mr242076pjo.226.1588860607923;
        Thu, 07 May 2020 07:10:07 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id w126sm4887397pfb.117.2020.05.07.07.10.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 07:10:07 -0700 (PDT)
Subject: Re: [PATCH] net: remove spurious declaration of
 tcp_default_init_rwnd()
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>
References: <20200507075805.4831-1-zenczykowski@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1e307670-79b2-3a8e-65b1-09be046a638b@gmail.com>
Date:   Thu, 7 May 2020 07:10:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200507075805.4831-1-zenczykowski@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/7/20 12:58 AM, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> it doesn't actually exist...
> 
> Test: builds and 'git grep tcp_default_init_rwnd' comes up empty
> Signed-off-by: Maciej Żenczykowski <maze@google.com>
> ---
>  include/net/tcp.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index dcf9a72eeaa6..64f84683feae 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1376,7 +1376,6 @@ static inline void tcp_sack_reset(struct tcp_options_received *rx_opt)
>  	rx_opt->num_sacks = 0;
>  }
>  
> -u32 tcp_default_init_rwnd(u32 mss);
>  void tcp_cwnd_restart(struct sock *sk, s32 delta);
>  
>  static inline void tcp_slow_start_after_idle_check(struct sock *sk)
> 

Right, we should have removed this at the time commit a337531b942b
 ("tcp: up initial rmem to 128KB and SYN rwin to around 64KB") went in.

Signed-off-by: Eric Dumazet <edumazet@google.com>

Thanks !

