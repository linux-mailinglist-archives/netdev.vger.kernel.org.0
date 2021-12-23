Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A64D47E8CA
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 21:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350260AbhLWUaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 15:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350259AbhLWUaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 15:30:15 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C03C061757
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 12:30:15 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id by39so10836027ljb.2
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 12:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Odt0JsRPKSwzZrSogY/TSKmJxhU81pD7uS/KWPJG7aw=;
        b=AgIToA7aaUbbuygVsn68Z8gYx2R+pQYR1IGhjy1yu+LyX5dNysFzXbkdgswMVTwTep
         0hI1Ae/3TaPJPhWnCgvYHJ1VxnHq4l/eFg5e3kj/JRuOb7mac6NKG5+ybt3ENDX/mSaq
         0xzI/qhLfARJdv2pkCjradsG9Wzj6pj4xZ8TfjQHTecXRkE4KDhq9AUTCvqpomHD7nct
         wHr7wkKfJp2gGHQWmp3oI6tTwBS2Vz6LouKFC6ASCZELLqgy8+qcg8nboxxGhWJcEIzj
         dWufJ966D9lg/OGYmwR5V+BL41B2Pi6FMkc2jhL5RAoV/B9HXcKhRs6Rytt/j7+GidI2
         UWIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Odt0JsRPKSwzZrSogY/TSKmJxhU81pD7uS/KWPJG7aw=;
        b=QO/VdsQ7uHEOCV3Xc0gSv9wZkUEfIT0L52vpPMyegZnpQMMekdyBvJuKmxqByBhAxH
         IzYd3B6FiqURsolFH4wdfJc2SwdeCe28yETVTWr7ifeXijqckRc9lqjtNkeAvkPiurr2
         0zlw9wxN072FL3RLlHB/CZBAFdI0AB3RHNyUNWIzWd0yHebP5UaY33LHpq5TPm83DhiG
         kRgO5ydM7DiyxpcfQ5azmKX/AXwBrLr1ka5gW5vbrYyPi4TJswx5WUYDCILxDIDmZjyB
         CIDm3Ok6pSuV5Lwq7UYZa6Q72dFB63A9H4D1dygx4glcf4y87VF+1EDUWES7bj5pUWR4
         yOig==
X-Gm-Message-State: AOAM533xswPV7k0FRv9UtVHYaoNFZvUR/lnEhLCzQxu/qsvcGUp2lUA9
        GMtQDn5WyJTHuXQVtRtHyiMNhl1nRHEZAS4LV8xImQ==
X-Google-Smtp-Source: ABdhPJyYWN/xeRMF+9Dfpv8zcB/XlMiakJ1FyMZHUYzjhf10Y8zM74gGT8+Mckyyk2oE+tUZO5jm/ikoSyjgvNoCFBc=
X-Received: by 2002:a2e:908b:: with SMTP id l11mr2705599ljg.62.1640291413074;
 Thu, 23 Dec 2021 12:30:13 -0800 (PST)
MIME-Version: 1.0
References: <20211223162848.3243702-1-trix@redhat.com>
In-Reply-To: <20211223162848.3243702-1-trix@redhat.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 23 Dec 2021 12:30:01 -0800
Message-ID: <CAKwvOd=dLjMAim_FRNyWegzEjy0_1vF2xVW1hNPQ55=32qO4Wg@mail.gmail.com>
Subject: Re: [PATCH] mac80211: initialize variable have_higher_than_11mbit
To:     trix@redhat.com
Cc:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        nathan@kernel.org, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 23, 2021 at 8:29 AM <trix@redhat.com> wrote:
>
> From: Tom Rix <trix@redhat.com>
>
> Clang static analysis reports this warnings
>
> mlme.c:5332:7: warning: Branch condition evaluates to a
>   garbage value
>     have_higher_than_11mbit)
>     ^~~~~~~~~~~~~~~~~~~~~~~
>
> have_higher_than_11mbit is only set to true some of the time in
> ieee80211_get_rates() but is checked all of the time.  So
> have_higher_than_11mbit needs to be initialized to false.

LGTM. There's only one caller of ieee80211_get_rates() today; if there
were others, they could make a similar mistake in the future. An
alternate approach: ieee80211_get_rates() could unconditionally write
false before the loop that could later write true. Then call sites
don't need to worry about this conditional assignment. Perhaps that
would be preferable? If not:

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

>
> Fixes: 5d6a1b069b7f ("mac80211: set basic rates earlier")
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  net/mac80211/mlme.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 51f55c4ee3c6e..766cbbc9c3a72 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -5279,7 +5279,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
>          */
>         if (new_sta) {
>                 u32 rates = 0, basic_rates = 0;
> -               bool have_higher_than_11mbit;
> +               bool have_higher_than_11mbit = false;
>                 int min_rate = INT_MAX, min_rate_index = -1;
>                 const struct cfg80211_bss_ies *ies;
>                 int shift = ieee80211_vif_get_shift(&sdata->vif);
> --
> 2.26.3
>


-- 
Thanks,
~Nick Desaulniers
