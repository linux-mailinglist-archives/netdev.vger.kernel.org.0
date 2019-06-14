Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 273AC46B4B
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 22:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfFNUy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 16:54:29 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39669 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfFNUy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 16:54:28 -0400
Received: by mail-pf1-f196.google.com with SMTP id j2so2111515pfe.6
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 13:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OKHkgrIbFIJQCw8wD1XxUrC5d565aFWlPJdUMDKpdyQ=;
        b=UYNvvqHsSN3OaOxZAwJbcHL/kAM6bZCt067wRLaW4K0iLAEnyEuF49dvaz4R2zUK11
         7rG44DxDakEJrq1wsGwvd3paGg/qc/a2juliCIwXm3mrmA0s+IpB93Q0zFwd5ntNN1JC
         DDiqbbQ4uHNrbwHy8I+7jSU82ex56I/A91uD186Frx7w406ZHmXMf69GhoL6OFtnBZfs
         81sTgsbYzCOXOuUJ9Ug6qekjUNk+wtcozA3VKnwDhvQO4HHPEoiS9x+4nftynLX3XOpu
         k/y7UnfgwWcCh0eMSL2wPUzWbe5Pl0H92YIhGvtJ6UTckOAUReRQu1mYr0xEqcVLnhXi
         i8jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OKHkgrIbFIJQCw8wD1XxUrC5d565aFWlPJdUMDKpdyQ=;
        b=k8OtmFHPPdGsjZcWHfGG1XW2WxPzJDeE4RrnHna0Jk54UMRIr3QWgE88eAFQ449z2I
         hbToNYbrcjR9d1TW1xSOTuv+5mFk/nhz03UYviqIwLr270hwkP2qDZApBxJv1PQI2SHD
         XA5zsbl2hwMmtHFQ9mOIFuRVca59LgCGUUDD1aV42BCwFbRBvB0v0/18hEAqktOrL4i7
         kryqaaTziFCsLfQBqWfGN4Hssfv/+gWEQoVnPidTytJEGd4iC4xN4DTqjRsS/2K6hZQF
         ocQk6U/qDpfkTXHk3WpXARUoBSG+3TK0VbFNRl9a/6mECk0PJW/hqXhQp+ObmOaB1Iwi
         xqBQ==
X-Gm-Message-State: APjAAAVXKQCZvh3VMpSnpjv/64dncl+XAoVyPMm224u+3yUj9TP4A+1W
        dzNXpCGQTmAeavuGcxHnq7JEHeu2t9xDKZ+8Nl2DlS1kWk4=
X-Google-Smtp-Source: APXvYqxJQiLj537BJ3ZR5Sc93ULFhtds6hlQxqUz2ekknc3TBei1vqS5haeJD3AIue6VRnuxGWBLCLJqsyCPEP1Wv9Y=
X-Received: by 2002:a63:306:: with SMTP id 6mr24636738pgd.263.1560545667771;
 Fri, 14 Jun 2019 13:54:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190614171713.89262-1-nhuck@google.com>
In-Reply-To: <20190614171713.89262-1-nhuck@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 14 Jun 2019 13:54:16 -0700
Message-ID: <CAKwvOd=jFYn=7NGPD8UDx3_g30qD+40bCjzmWJJSzmb6pNUusQ@mail.gmail.com>
Subject: Re: [PATCH] wl18xx: Fix Wunused-const-variable
To:     Nathan Huckleberry <nhuck@google.com>, eliad@wizery.com,
        arik@wizery.com
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 10:17 AM 'Nathan Huckleberry' via Clang Built
Linux <clang-built-linux@googlegroups.com> wrote:
>
> Clang produces the following warning
>
> drivers/net/wireless/ti/wl18xx/main.c:1850:43: warning: unused variable
> 'wl18xx_iface_ap_cl_limits' [-Wunused-const-variable] static const struct
> ieee80211_iface_limit wl18xx_iface_ap_cl_limits[] = { ^
> drivers/net/wireless/ti/wl18xx/main.c:1869:43: warning: unused variable
> 'wl18xx_iface_ap_go_limits' [-Wunused-const-variable] static const struct
> ieee80211_iface_limit wl18xx_iface_ap_go_limits[] = { ^
>
> The commit that added these variables never used them. Removing them.

Previous thread, for context:
https://groups.google.com/forum/#!topic/clang-built-linux/1Lu1GT9ic94

Looking at drivers/net/wireless/ti/wl18xx/main.c, there 4 globally
declared `struct ieee80211_iface_limit` but as your patch notes, only
2 are used.  The thing is, their uses are in a `struct
ieee80211_iface_limit []`.

Looking at
$ git blame drivers/net/wireless/ti/wl18xx/main.c -L 1850
points to
commit 7845af35e0de ("wlcore: add p2p device support")
Adding Eliad and Arik to the thread; it's not clear to me what the
these variables were supposed to do, but seeing as the code in
question was already dead, this is no functional change from a user's
perspective.  With that in mind:
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

So I'd at least add the tag.
Fixes: 7845af35e0de ("wlcore: add p2p device support")

> --- a/drivers/net/wireless/ti/wl18xx/main.c
> +++ b/drivers/net/wireless/ti/wl18xx/main.c
> @@ -1847,44 +1847,6 @@ static const struct ieee80211_iface_limit wl18xx_iface_ap_limits[] = {
>         },
>  };
>
> -static const struct ieee80211_iface_limit wl18xx_iface_ap_cl_limits[] = {
> -       {
> -               .max = 1,
> -               .types = BIT(NL80211_IFTYPE_STATION),
> -       },
> -       {
> -               .max = 1,
> -               .types = BIT(NL80211_IFTYPE_AP),
> -       },
> -       {
> -               .max = 1,
> -               .types = BIT(NL80211_IFTYPE_P2P_CLIENT),
> -       },
> -       {
> -               .max = 1,
> -               .types = BIT(NL80211_IFTYPE_P2P_DEVICE),
> -       },
> -};
> -
> -static const struct ieee80211_iface_limit wl18xx_iface_ap_go_limits[] = {
> -       {
> -               .max = 1,
> -               .types = BIT(NL80211_IFTYPE_STATION),
> -       },
> -       {
> -               .max = 1,
> -               .types = BIT(NL80211_IFTYPE_AP),
> -       },
> -       {
> -               .max = 1,
> -               .types = BIT(NL80211_IFTYPE_P2P_GO),
> -       },
> -       {
> -               .max = 1,
> -               .types = BIT(NL80211_IFTYPE_P2P_DEVICE),
> -       },
> -};
> -

-- 
Thanks,
~Nick Desaulniers
