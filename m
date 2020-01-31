Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF0514EED3
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 15:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbgAaOzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 09:55:06 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:35029 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728825AbgAaOzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 09:55:05 -0500
Received: by mail-yw1-f67.google.com with SMTP id i190so4939391ywc.2
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 06:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SDj5kNjMiLc1TNHQMyijHY5lqlqUv2q9y5ctnKAZRBM=;
        b=bqZKRFmycIWRiGhpMQzPAIBZjoFVrYuo2SZLTiBQn9hk3BIfxPOgtiasQqrKsz2M5R
         xcr70sdeXtlmRgqAkxi4MwwCCGAkJhHqVAsDAT18gQB8K95aCL2+v7W3tf6GiQuTk9wx
         zSsFPc/QZmAsiQnT6xuRc+WOhhu4GLqhGs9PXg0H7dCfbwXXOUvKNyrwN6IBwhS4kjJP
         xqgIEUk70E2YY22PIZpKwKrFtorhvE2J/tl5xnCl5++MsQJJfl74Og7nGC7EhicDGutJ
         s6D889kI9JFG1is8ZQK56+B9Cjutnn92mtrnjX6fCu2blz9jNuBePoRzER6x6s+DTbFF
         UPKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SDj5kNjMiLc1TNHQMyijHY5lqlqUv2q9y5ctnKAZRBM=;
        b=YjGPfsS0XYTD/Ewjj7qKo0gdaI0ekn/+1RA+gqNR4znvszTKwNdBo2YjxmSiJRqrvf
         8brDyt2XcG7Li12aN++8MPLhyNvF5jl6CPUhrximW3g7VY4f8G5kopz7VwTnQAOFjSZ5
         e/Z8ojIZQeSyehPZb3otIRPrb8n0V9s1NH4JWol18Wl+Ab5XW4AEGQI+KQjr7Mz8FxPF
         XAPnF44mSSRyxLfWSR+mFBCQotuIpLpnIK+ae5Vhb/M2Zhaw8tGhRtKgRUg1CqoJGyv9
         V96O0Cua4vKR3dJ9xtF1XNFWIj7UMnxBiXEpYNl2VbBs2R8l1FjjiXEq/tOG1jq+Z6Si
         Qiag==
X-Gm-Message-State: APjAAAWDOvbPvlxD+xiWB8o0+xk+vJzTSQOEo/ELoQIBWQ9H9RmnCcAO
        AqdGNeQFPctgm4LGQ3HTA0k880YCJdioOW+00wnaPw==
X-Google-Smtp-Source: APXvYqyvp5cLvKH6z6kEMndeCtof01VGlsZXoDmYcGmrhf/gmPmDw9GCx5N5tQtW9+VSCDoYF9vhN4WVGMlTHp5v3c0=
X-Received: by 2002:a25:d112:: with SMTP id i18mr8262683ybg.364.1580482504570;
 Fri, 31 Jan 2020 06:55:04 -0800 (PST)
MIME-Version: 1.0
References: <20200131122421.23286-1-sjpark@amazon.com> <20200131122421.23286-2-sjpark@amazon.com>
In-Reply-To: <20200131122421.23286-2-sjpark@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 31 Jan 2020 06:54:53 -0800
Message-ID: <CANn89iK3usa_bAfnD37VKvS45Qf6FH+H4fo-9zNrGGanc=7uAw@mail.gmail.com>
Subject: Re: [PATCH 1/3] net/ipv4/inet_timewait_sock: Fix inconsistent comments
To:     sjpark@amazon.com
Cc:     David Miller <davem@davemloft.net>, Shuah Khan <shuah@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, sj38.park@gmail.com,
        aams@amazon.com, SeongJae Park <sjpark@amazon.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 4:24 AM <sjpark@amazon.com> wrote:
>
> From: SeongJae Park <sjpark@amazon.de>
>
> Commit ec94c2696f0b ("tcp/dccp: avoid one atomic operation for timewait
> hashdance") mistakenly erased a comment for the second step of
> `inet_twsk_hashdance()`.  This commit restores it for better
> readability.
>
> Signed-off-by: SeongJae Park <sjpark@amazon.de>
> ---
>  net/ipv4/inet_timewait_sock.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
> index c411c87ae865..fbfcd63cc170 100644
> --- a/net/ipv4/inet_timewait_sock.c
> +++ b/net/ipv4/inet_timewait_sock.c
> @@ -120,6 +120,7 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
>
>         spin_lock(lock);
>
> +       /* Step 2: Hash TW into tcp ehash chain. */

This comment adds no value, please do not bring it back.

net-next is closed, now is not the time for cosmetic changes.

Also take a look at Documentation/networking/netdev-FAQ.rst
