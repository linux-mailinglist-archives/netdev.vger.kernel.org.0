Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96261C71CF
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 15:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728403AbgEFNjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 09:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728081AbgEFNjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 09:39:32 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C144C061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 06:39:31 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id x25so2655282wmc.0
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 06:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lcPD9YjV/lamWRQSC6aAzi/tnH6cdrik+yDLBVMFIX0=;
        b=CinjkHs9KXZN0PJwhUFVa212qoM6imGI1DTALy31/ixpg04lFlwGAuBNlLUgzuKYEE
         /fiE02ozGdrCRzL8fiGRhHp3F9YxgiHlhvqzxYjseocMvjfD3i3VT6xCFbIIreMd0trY
         DPYDa5/9XW1EOcsFMOS/HyaaRjigZKndoHUXyW2rlKOMniYyiuCSCIYAVzUPrv0/7bY2
         fNPvPrRl8a3sACj/D4A5UmrjWXl8nwKkyBG0LL07AKiRirCRB6yEEhMTZ2NqhHyLiCi5
         6lkKPexP4ZcsurGbPuSfTntrZWdQS0Nrf1ap6JCXVQonhAAt6VWxsuQ97W1WTdb2cV0Y
         FxTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lcPD9YjV/lamWRQSC6aAzi/tnH6cdrik+yDLBVMFIX0=;
        b=RISJ+0h6t3sLp3c8ftDOS84AsFpEEhDy0NVvZoySnGr15ZXJmjcw7HsqsnHlMYkt6U
         pbBdWQTjk3fbB05iRRjvOwgt/Y2RusLn9WM7oOpZZicYggC3Qw0OoY2NrRk9pu4sSwFh
         8jj9lmYX2gJ6vpGg2ZbJnkN7v1egtQuk9jtpbwfPIWbA9IkGvoszqMWFTbsn1w1xon2p
         KQN8EP/O42DUVT2YnAu6W/8LHLKdTycZlqyZoEPnQI5ukrxJ9X+C/TjZkCRfe+CDV0n6
         JTaSb1B3pLrsxOcUkqcEtMv0+dEzSF81hQ0dyGvqCkTZJbtdGC7Au2u0PXA7D3xJystK
         fBJQ==
X-Gm-Message-State: AGi0Pub9Q3XmIgiRv1XT7iccYr6gyjdRdTGRYYcjPOo4TL8bd5vEvKpI
        1H2SigUs274f/SB3IU4YLHEXR8E9TLLHk047WYXD2w==
X-Google-Smtp-Source: APiQypLwj5OWLAeM2fQIAflfyNaGBDZ5ALHJ4TpehOjRpbh8rUzcClerYA53WxygCHy0bqNSf6upmdBsPSmnJfu5fZQ=
X-Received: by 2002:a1c:f20f:: with SMTP id s15mr4241471wmc.114.1588772369252;
 Wed, 06 May 2020 06:39:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200506035106.187948-1-edumazet@google.com>
In-Reply-To: <20200506035106.187948-1-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Wed, 6 May 2020 09:38:51 -0400
Message-ID: <CACSApvZWWFnTHV7KCQOekh_265_vKGk=3+P4qbwY+EpwHO2QyQ@mail.gmail.com>
Subject: Re: [PATCH net] selftests: net: tcp_mmap: clear whole
 tcp_zerocopy_receive struct
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 11:51 PM Eric Dumazet <edumazet@google.com> wrote:
>
> We added fields in tcp_zerocopy_receive structure,
> so make sure to clear all fields to not pass garbage to the kernel.
>
> We were lucky because recent additions added 'out' parameters,
> still we need to clean our reference implementation, before folks
> copy/paste it.
>
> Fixes: c8856c051454 ("tcp-zerocopy: Return inq along with tcp receive zerocopy.")
> Fixes: 33946518d493 ("tcp-zerocopy: Return sk_err (if set) along with tcp receive zerocopy.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Arjun Roy <arjunroy@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Thank you for fixing the self test!

> ---
>  tools/testing/selftests/net/tcp_mmap.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
> index 35505b31e5cc092453ea7b72d9dba45bed2d6549..62171fd638c817dabe2d988f3cfae74522112584 100644
> --- a/tools/testing/selftests/net/tcp_mmap.c
> +++ b/tools/testing/selftests/net/tcp_mmap.c
> @@ -165,9 +165,10 @@ void *child_thread(void *arg)
>                         socklen_t zc_len = sizeof(zc);
>                         int res;
>
> +                       memset(&zc, 0, sizeof(zc));
>                         zc.address = (__u64)((unsigned long)addr);
>                         zc.length = chunk_size;
> -                       zc.recv_skip_hint = 0;
> +
>                         res = getsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE,
>                                          &zc, &zc_len);
>                         if (res == -1)
> --
> 2.26.2.526.g744177e7f7-goog
>
