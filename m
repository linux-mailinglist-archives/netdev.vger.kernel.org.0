Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605D521DD81
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbgGMQjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730196AbgGMQjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:39:03 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31520C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:39:03 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id y10so17978629eje.1
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JLncd2tVzGmBrlKWepA/2Cjz0He0lhd8jA7tJ2R5QSU=;
        b=N4fgrgIvbcH9lXr5z0ZgEiiJGBq1Br17CZhezKqqVFbonOJaVPhAZ0Ew0k5knCdrUp
         XiCqnZbhkgXgzN+K83Mchd5D3t56lFSSF2M9ILrpP+UHAdzYLGk/pRg8/MnVHEB6LGMw
         wfBhKy/Ftxtir/UDdWeyMz4aW0XIUxyzDdc6sbrIJPGxEHwFB9u79VHO9ufMf+aDKQlD
         v0eDptw+6MYITHc1d1ABDAnbNk4Jm/QGoMUqztEXBXGyFE0FtZhHu+MOgmRHa4FpIWt3
         TZQ8758Aj8up5u1yQeKIOC15JXjdsmldyE4m9efuF1EkjiamkT2LomVTU3H4Mgti7G5R
         hn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JLncd2tVzGmBrlKWepA/2Cjz0He0lhd8jA7tJ2R5QSU=;
        b=UOGqXg5fpado0SB5OHkNoWGa0OlCujYg/W/aU9SD/2ZWsV/8e7BOoLvB6Qkh/mWl5N
         oLSjBVJhdIlo1vPiB+L18ZQ5oWLes+/KSBYfuwVtqbtk6mkEzwc7KlntEKmzI2O9HSd0
         QcQEKugixA+wpa5Fx2PiK3S/sVjsk8VF8/TYt0e71LXCHyMlSYYPlKOd3fqrohSjocpA
         3yfG1VyidKblKQm6iHt8u4W/pkDzKQ1dcYyZeU/I+aVt5DEAWbrrGh4KT91E82e2A5Pb
         cMSpnwujzSFpK3DC/0s2g43rz0zHC+2LI21A8/JHR9fnKMvfudiLtH7D4LbSX/WuAN09
         fppQ==
X-Gm-Message-State: AOAM530J2tE/kwg8jZrMyINCOOsFM5itmrWom5fKm4Cgyg3vpkB1jcTX
        13tvdLrAbM9O2/4ITtQFAx8FjAKHCHNaNUw4bk9Q
X-Google-Smtp-Source: ABdhPJzw5Q/ONvYVSfpPn/oZ6nhUP89z0cEl3dBx7hH0g0pgyF/NepaKXWbMzlHGXQzJOWQU9tekiQ1gpYikRFaMhlU=
X-Received: by 2002:a17:906:4757:: with SMTP id j23mr503832ejs.431.1594658341760;
 Mon, 13 Jul 2020 09:39:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200712231516.1139335-1-andrew@lunn.ch> <20200712231516.1139335-7-andrew@lunn.ch>
In-Reply-To: <20200712231516.1139335-7-andrew@lunn.ch>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 13 Jul 2020 12:38:50 -0400
Message-ID: <CAHC9VhTY09Tw_-m9aUt0j=wP6J2iTZqpnHA1DHP8AOpOKCLaTA@mail.gmail.com>
Subject: Re: [PATCH net-next 06/20] net: ipv4: kerneldoc fixes
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 12, 2020 at 7:15 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> Simple fixes which require no deep knowledge of the code.
>
> Cc: Paul Moore <paul@paul-moore.com>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  net/ipv4/cipso_ipv4.c | 6 ++++--
>  net/ipv4/ipmr.c       | 3 +++
>  net/ipv4/tcp_input.c  | 1 -
>  net/ipv4/tcp_output.c | 2 ++
>  net/ipv4/tcp_timer.c  | 2 +-
>  net/ipv4/udp.c        | 6 +++---
>  6 files changed, 13 insertions(+), 7 deletions(-)

Thanks Andrew.  For the cipso_ipv4.c changes ...

Acked-by: Paul Moore <paul@paul-moore.com>

> diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> index 0f1b9065c0a6..2eb71579f4d2 100644
> --- a/net/ipv4/cipso_ipv4.c
> +++ b/net/ipv4/cipso_ipv4.c
> @@ -283,7 +283,7 @@ static int cipso_v4_cache_check(const unsigned char *key,
>
>  /**
>   * cipso_v4_cache_add - Add an entry to the CIPSO cache
> - * @skb: the packet
> + * @cipso_ptr: pointer to CIPSO IP option
>   * @secattr: the packet's security attributes
>   *
>   * Description:
> @@ -1535,6 +1535,7 @@ unsigned char *cipso_v4_optptr(const struct sk_buff *skb)
>
>  /**
>   * cipso_v4_validate - Validate a CIPSO option
> + * @skb: the packet
>   * @option: the start of the option, on error it is set to point to the error
>   *
>   * Description:
> @@ -2066,7 +2067,7 @@ void cipso_v4_sock_delattr(struct sock *sk)
>
>  /**
>   * cipso_v4_req_delattr - Delete the CIPSO option from a request socket
> - * @reg: the request socket
> + * @req: the request socket
>   *
>   * Description:
>   * Removes the CIPSO option from a request socket, if present.
> @@ -2158,6 +2159,7 @@ int cipso_v4_sock_getattr(struct sock *sk, struct netlbl_lsm_secattr *secattr)
>  /**
>   * cipso_v4_skbuff_setattr - Set the CIPSO option on a packet
>   * @skb: the packet
> + * @doi_def: the DOI structure
>   * @secattr: the security attributes
>   *
>   * Description:

-- 
paul moore
www.paul-moore.com
