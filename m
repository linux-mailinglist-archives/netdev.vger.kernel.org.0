Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C027928B39A
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 13:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388018AbgJLLS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 07:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387597AbgJLLS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 07:18:59 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862F8C0613CE;
        Mon, 12 Oct 2020 04:18:59 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id 67so17290987iob.8;
        Mon, 12 Oct 2020 04:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0yEH5NGaTBdVWHmTtAwxYSII40my+xheRGVAOZ2FIJ0=;
        b=s0zYX1Gtb6a7R4xVptYRoP2DcUZbCLyqwpeX8O2s08CM4/OazzTr7bvPHlEA2QVbQR
         dxlGk1LinaNF6E6X5EOF9IdXI9sFzrEz8wfsTq0OyhLXM9LDXoStJNLaomQLKE93AFpb
         RZEwoys22kOh+llg+4kVa7E/V1/6jzT4px7RwyoSbq8J0ury5eznjgjnRTd2QkOf9CTW
         U3oSGVTmjLHw1CkBCbXuLa2nJ7JN7iEAGEdRX8pWMma2hU/Hv+yf0VALmR5yQaOXqCjM
         NlWoYtPBOFZF52fACDVdx2AfhPNBXS/EgZyuSAbyp5zHQ1Nzm3oXPX8bRnDFl4SDLq/n
         4YEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0yEH5NGaTBdVWHmTtAwxYSII40my+xheRGVAOZ2FIJ0=;
        b=WyKeDzLfMThrvUsyL5gqmuWlR/W/RUBcqYujxPAdLSIDXalTz96gvjwv5Y85UQAE0q
         QI+C+vOcHL4vtV7HbADtnvoOqdlhlsUBue9bsazK5aUkK0XiwDlg5eZqAUZtx0pNcSZg
         05x7eUdSyl4S+c+3OZZ5OpN8TSVS2bz/F3unqGtOBsxW6KpUMjayIHjlqUIcz/KDFGYT
         FV2CuvHBfc272ebFXQQCwBFYH1EGYqgHivtHXURBFM4rM9j8JLWUqJQLSuOhdTU8X/dd
         LdNGRLbchzVeWbzZkl42/PKVt97a2rS6W2PZ28hTfA96HMUI7HzEQmxQ0fze7fQPko5J
         EcDg==
X-Gm-Message-State: AOAM531xqOfdjDCX3fQ6u+dp10uzIbWMgOP9r8argvM+UZkYI2xHZTPM
        x4Yf0SgePIOaK0z9tz9myfmTzv+BDHgF9QGM4fY=
X-Google-Smtp-Source: ABdhPJyT6N7/YaHLwHPytf6aOAnxfOXQHBo/t0K69MA8144BlECWnhlqEQoLWsvX9dX3yxLy17u+z83tcVMaPZ2//LA=
X-Received: by 2002:a05:6602:224a:: with SMTP id o10mr15968219ioo.168.1602501538870;
 Mon, 12 Oct 2020 04:18:58 -0700 (PDT)
MIME-Version: 1.0
References: <20201009170202.103512-1-a.nogikh@gmail.com> <5d71472dcef4d88786ea6e8f30f0816f8b920bb7.camel@sipsolutions.net>
In-Reply-To: <5d71472dcef4d88786ea6e8f30f0816f8b920bb7.camel@sipsolutions.net>
From:   Aleksandr Nogikh <a.nogikh@gmail.com>
Date:   Mon, 12 Oct 2020 14:18:47 +0300
Message-ID: <CADpXja8NZDZ_3AMHUMnj90nbQbW2pA_aP=_Y2w2tSfy8EcRZkw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] [PATCH v2 0/3] [PATCH v2 0/3] net, mac80211,
 kernel: enable KCOV remote coverage collection for 802.11 frame handling
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, kuba@kernel.org, akpm@linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        nogikh@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 at 21:50, Johannes Berg <johannes@sipsolutions.net> wrote:
[...]
> Also, unrelated to that (but I see Dmitry CC'ed), I started wondering if
> it'd be helpful to have an easier raw 802.11 inject path on top of say
> hwsim0; I noticed some syzbot reports where it created raw sockets, but
> that only gets you into the *data* plane of the wifi stack, not into the
> *management* plane. Theoretically you could add a monitor interface, but
> right now the wifi setup (according to the current docs on github) is
> using two IBSS interfaces.
>
> Perhaps an inject path on the mac80211-hwsim "hwsim0" interface would be
> something to consider? Or simply adding a third radio that's in
> "monitor" mode, so that a raw socket bound to *that* interface can
> inject with a radiotap header followed by an 802.11 frame, getting to
> arbitrary frame handling code, not just data frames.
>
> Any thoughts?
>
> johannes
>
*sending it again as I forgot to include Cc list*

Hi Johannes,

Thank you for sharing these ideas.

Currently we're injecting frames via mac80211_hwsim (by pretenting to
be wmediumd -
https://github.com/google/syzkaller/blob/4a77ae0bdc5cd75ebe88ce7c896aae6bbf457a29/executor/common_linux.h#L4922).
Injecting via RAW sockets would definitely be a much cleaner way, but
to do that we need to keep a separate monitor interface. That's pretty
hard as the fuzzer is constantly trying to break things, and direct
injection via mac80211_hwsim seems to be a much more robust way - it
will work as long as the virtual device is alive. hwsim0 is
unfortunately not available as fuzzer processes are run in separate
network namespaces, while this one is created during mac80211_hwsim
initialization.

The current approach seems to work fine for management frames - I was
able to create seed programs that inject valid management frames and
these frames have the expected effect on the subsystem (e.g. injecting
AP responses during scan/authentication/authorization forces a station
to believe that it has successfully connected to an AP).

--
Best Regards,
Aleksandr
