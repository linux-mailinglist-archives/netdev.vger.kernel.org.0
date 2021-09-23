Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343704167C8
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 23:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243393AbhIWWBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 18:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238517AbhIWWBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 18:01:21 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6373DC061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 14:59:49 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id b20so32139476lfv.3
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 14:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qRRNS2od1/Bexc5EY1FdiTqWnbjxMn9Xh7KI02U2j9k=;
        b=TmY/VUwI6DUm8VQWMsGbqXsMtdVXqnD4mrJi9/FcqubvVyvh5U385sKNId1Du5Wdph
         ovjmgvk1hL1rHMhyQH5vhWKx0o4qoAULMjj6Q1pgqZPwQgk/JIV4bgefzbjmIdP+bhNM
         mYGqciCIZ1++CPksmM6tHb9sOz1goMqltG579OUq71YYbO6UKxrkRocG1o1A1tieTsu3
         NneAndlTIxa6uQMCc9xrJsusap6rKiYAU9XUo8QQ0gtRQO0dCxy9qYXyFv5TeMPOaYi+
         mNEvUUo2opx2nRdyM5JajxSyzF6K1uXzXibTJktiwye8Uir6w6Y8hXT8dfkaEpdMuUe9
         jbdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qRRNS2od1/Bexc5EY1FdiTqWnbjxMn9Xh7KI02U2j9k=;
        b=rBs56zE3V6QkASvRIp0kpy2jheX2QvvaUQIqqliTF1ZxHxn/P383GbmBh+5u1AY1TF
         PHxPvtFtQyP/rKK23BohuWIougM0aSc4//4qJI1Ew1c80tULS8Q5cggDisrABp03aAdm
         fhPwgwaJb0zNvn+VBZHTIRubXi17ajHxkHpimoABAaqFZvusYmyCXJrcaLzyusmiYIQ/
         bk8szkxwqXu3VWUu7qe3WY5LFWFZHYy0Os7Nht1ZJQkR3MAPALbeWfKHkcBSYLMbi2QN
         3KvO+NiwLzvnQgnDe461hbui1d+6r012VYRbWj23pat9wWqloXwNUmCDh7A25qM+XyhM
         HE/Q==
X-Gm-Message-State: AOAM532mRsjI5dqwLDJJGBdrpcEOjmHgntLy01lOPzPqznuIekUbE7k2
        5J+C0W/LLFv4XM0bgSTEltOh4OmhRTxrhnHLlBOC5g==
X-Google-Smtp-Source: ABdhPJyrnHJj3UeJN8VEGNUn+1Bnk8jQ0VFISmxBvHgOV4+6/lBDbQq2q1Py2RKZNNkPbqtKbbeT2IN6zNu4WE6qlH4=
X-Received: by 2002:a2e:4c19:: with SMTP id z25mr7577149lja.145.1632434387711;
 Thu, 23 Sep 2021 14:59:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210913143156.1264570-1-linus.walleij@linaro.org> <20210915071901.1315-1-dqfext@gmail.com>
In-Reply-To: <20210915071901.1315-1-dqfext@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 23 Sep 2021 23:59:36 +0200
Message-ID: <CACRpkdYu7Q5Y88YmBzcBBGycmW92dd0jVhJNUpDFyd65bBq52A@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: tag_rtl4_a: Drop bit 9 from egress frames
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 9:20 AM DENG Qingfang <dqfext@gmail.com> wrote:
> On Mon, Sep 13, 2021 at 04:31:56PM +0200, Linus Walleij wrote:

> > This drops the code setting bit 9 on egress frames on the
> > Realtek "type A" (RTL8366RB) frames.
>
> FYI, on RTL8366S, bit 9 on egress frames is disable learning.
>
> > This bit was set on ingress frames for unknown reason,
>
> I think it could be the reason why the frame is forwarded to the CPU.

Hm I suspect it disable learning on RTL8366RB as well.
Do we have some use for that feature in DSA taggers?

Yours,
Linus Walleij
