Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F252B39B
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 13:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfE0LxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 07:53:24 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34711 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbfE0LxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 07:53:07 -0400
Received: by mail-lf1-f65.google.com with SMTP id v18so11871735lfi.1
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 04:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jkQ2P05r0CbW3f6Nc/yL+6alMJG9tn6Pn2kcFIlii5k=;
        b=PY1QXMvsBTT+5wZ1zSM7J7vMW6SN5avLhjy0/VrAQXYgaBJepG9Ai4IZ/9tWCgloPb
         5xoxs4mx7F5kZPxhU3rUcPkDpijDA9VjFDacr8eNWaOUIU5yI6kgqzOhfVP+ULykludC
         He0tYpJwaEdc4JONkqP5w9LM5tG8VEM3OzMINepLjOyPzHVkiTktZ0Ed0vAlNnSry+2S
         dZKMWNzwPUdZtF1lir4/GU4Y1GAInSuerD9TN6xfBKjuLkEC3P2XI88cOPHMn1zfmIxt
         xqZ3rLR/SQ2mRuEsRVRa5AMAZgJB6SHjXkonmWx0l6JizB3g8egqrBx24T+iwRjey04U
         IwNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jkQ2P05r0CbW3f6Nc/yL+6alMJG9tn6Pn2kcFIlii5k=;
        b=L5Hkr6z43Juv+jRFciVfehwachT0Rf4NAbTFuoSQ0ztpFYkih69t7ch4uWAshueJWd
         //QLtrhztw4kOlkLsSafQAW3zQVcr55qYxqBF1rXfVGdRVfnWtlq4uxinznHNVU7RIs4
         AIn+DtxS0QPDjpKuVYeDKN2yRXG4C5ZVsjORBa6QJgnjRwJv/5Wa1x2/1a2D8jKz29kk
         Uopo2Ysg9i5eVFZUeawC8hiH3vHDGmhmtVKjdYAIaz1aT4EXduGGnw8/4dIBso2XBYYV
         oF/T2FlyYj6Qx5WIyXCtyxTahN7jduItsC8US3Vow8lKmrjHkNp2FNObTAZDk0s+lSaS
         /NcQ==
X-Gm-Message-State: APjAAAXwKZsWvAdmYX+XyNU1KR7xPkVDA4LXyi1I4qY+a5g5Q3Rpp8uj
        2/npUyqP1EPxu1seKQaxrfcCwpnntcdnK2tjt9HmTOpP
X-Google-Smtp-Source: APXvYqxDK35ZwKMDb6RKZtyYMyBWL/UKHxLG0Pbv1KKjE1/wwOJP3jgzEapl8KPojM3oi55l5N4mhmwF2CTmPtxOxGE=
X-Received: by 2002:ac2:4209:: with SMTP id y9mr19510582lfh.83.1558957985935;
 Mon, 27 May 2019 04:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <1558611952-13295-1-git-send-email-yash.shah@sifive.com>
 <mvmwoihfi9f.fsf@suse.de> <CAJ2_jOEr5J7_-81MjUE63OSFKL-p9whEZ_FDBihojXP2wvadVg@mail.gmail.com>
 <mvm36l0fhm3.fsf@suse.de>
In-Reply-To: <mvm36l0fhm3.fsf@suse.de>
From:   Yash Shah <yash.shah@sifive.com>
Date:   Mon, 27 May 2019 17:22:27 +0530
Message-ID: <CAJ2_jOH344oH=mvo1n9RJDPjT4ArMNBaogqy0dLCOwCcY7Fwuw@mail.gmail.com>
Subject: Re: [PATCH 0/2] net: macb: Add support for SiFive FU540-C000
To:     Andreas Schwab <schwab@suse.de>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?UTF-8?Q?Petr_=C5=A0tetiar?= <ynezz@true.cz>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sachin Ghadi <sachin.ghadi@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 27, 2019 at 1:34 PM Andreas Schwab <schwab@suse.de> wrote:
>
> On Mai 24 2019, Yash Shah <yash.shah@sifive.com> wrote:
>
> > Hi Andreas,
> >
> > On Thu, May 23, 2019 at 6:19 PM Andreas Schwab <schwab@suse.de> wrote:
> >>
> >> On Mai 23 2019, Yash Shah <yash.shah@sifive.com> wrote:
> >>
> >> > On FU540, the management IP block is tightly coupled with the Cadence
> >> > MACB IP block. It manages many of the boundary signals from the MACB IP
> >> > This patchset controls the tx_clk input signal to the MACB IP. It
> >> > switches between the local TX clock (125MHz) and PHY TX clocks. This
> >> > is necessary to toggle between 1Gb and 100/10Mb speeds.
> >>
> >> Doesn't work for me:
> >>
> >> [  365.842801] macb: probe of 10090000.ethernet failed with error -17
> >>
> >
> > Make sure you have applied all the patches needed for testing found at
> > dev/yashs/ethernet branch of:
>
> Nope, try reloading the module.

Yes, I could see the error on reloading the module.
Thanks for the catch. I will fix this in the next version of this patch.

- Yash
