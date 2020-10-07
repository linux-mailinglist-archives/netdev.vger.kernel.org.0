Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1BB286160
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 16:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgJGOlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 10:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728535AbgJGOlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 10:41:06 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D993C061755;
        Wed,  7 Oct 2020 07:41:04 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id 67so2578191iob.8;
        Wed, 07 Oct 2020 07:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4uvuJbqp2TgM0MeuzNLXsDw5kxNnwkNh/n2qJKFZyJ0=;
        b=vTSniMTORk6JwHUBy61VTgju4ZmeVGFMa9l3ZfczOpus9e/QPtQJBDH7NGPEMVvytS
         1qJVEGj7w3rPPGVctm4w/cfqV2nu6gSk3Sl8iTumyj6Q9dceDhsqLLD1zUdn3vBSRXF6
         xMrs0c5T1WqH2hs7ZnAWMDbp953OQuKjabkdQ/gSA1dJmVY8+XIAd7ul1KoO38Gk2UJZ
         qmcnufdHNAj9ZNFR/Hm6zeyPVJJ9qwv569RyzS/I7uBiUSObGDM2YAQrtOoAAJ8prQaR
         VqsMuF1Z8mg3gLHwLO/5pbHAk7faP3AbowCDrf95GugjWfBEwlzeatWZEk0hJHrI5pvc
         TlcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4uvuJbqp2TgM0MeuzNLXsDw5kxNnwkNh/n2qJKFZyJ0=;
        b=XmEfA4eBZQXpekY6FRLN3JvOopR6ZID/l/M598cWfUmIOC8qkoDm713NwmaDUcHDo8
         Dui+us3X8zmu4cowI6Lsr0J3dZ49LtjcBmjlPyFTtfYIUCvTUii/9id4ZK0K9eZU1q5E
         e/S+AxgT02iYAbdgw/gkTVWalwqUe8mkjJQcRif6acX0DdBJK2jPCunyDj6WNxjzCmUT
         Juk2yIBQ81GytnAnOEvA+jt5N4uuqZxC8GO34rg8E7lJxzipXbHKUQgY3Kx19IuOBUVK
         uF3ZPvvVq31001HePTJupwmzuBQAKZQhfdft7awBQz+m1LYHr+ddQZu+CUuJqT7E6idC
         UySw==
X-Gm-Message-State: AOAM530+RHnzCOfJ3buD3jmnjm5txWQNt4x7A00IR2oU5GNZZO4GT6Cf
        M+Iyi3/Vqsy+QnxQ89TZZYEehv9/5u6nrMQu4VQ=
X-Google-Smtp-Source: ABdhPJwoP4V8LyLwVxJO/VdSmbnZ/FR0VBsEv3p8ap+jjhfY4/XGQkRYRbmhTipWFjjhlFv92B9hwcZa2/9pRLf6s34=
X-Received: by 2002:a5d:9b91:: with SMTP id r17mr2542158iom.183.1602081663901;
 Wed, 07 Oct 2020 07:41:03 -0700 (PDT)
MIME-Version: 1.0
References: <20201007101726.3149375-1-a.nogikh@gmail.com> <bec6415925c213a2e3eb86e80d6982b82180f019.camel@sipsolutions.net>
In-Reply-To: <bec6415925c213a2e3eb86e80d6982b82180f019.camel@sipsolutions.net>
From:   Aleksandr Nogikh <a.nogikh@gmail.com>
Date:   Wed, 7 Oct 2020 17:40:52 +0300
Message-ID: <CADpXja8oh2nHpNFjQ-+iDUebPx7R_HcOuoakzmKvHp=kuj8rpA@mail.gmail.com>
Subject: Re: [PATCH 0/2] net, mac80211: enable KCOV remote coverage collection
 for 802.11 frame handling
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, kuba@kernel.org,
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

On Wed, 7 Oct 2020 at 14:48, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Wed, 2020-10-07 at 10:17 +0000, Aleksandr Nogikh wrote:
[...]
> > Aleksandr Nogikh (2):
> >   net: store KCOV remote handle in sk_buff
>
> Can you explain that a bit better? What is a "remote handle"? What does
> it do in the SKB?
>
> I guess I'd have to know more about "kcov_common_handle()" to understand
> this bit.

Normally, KCOV collects coverage information for the code that is
executed inside the system call context. It is easy to identify where
that coverage should go and whether it should be collected at all by
looking at the current process. If KCOV was enabled on that process,
coverage will be stored in a buffer specific to that process.
Howerever, it is not always enough as some handling can happen
elsewhere (e.g. in separate kernel threads).

That is why remote KOV coverage collection was introduced. When it is
impossible to infer KCOV-related info just by looking at the currently
running process, we need to manually pass some information to the code
that is of interest to us.  The information takes the form of 64 bit
integers (remote handles). Zero is the special value that corresponds
to an empty handle. More details on KCOV and remote coverage
collection can be found here: Documentation/dev-tools/kcov.rst.

In this patch, we obtain the remote handle from KCOV (in this case by
executing kcov_common_handle()) and attach it to newly allocated
SKBs. If we're in a system call context, the SKB will be tied to the
process that issued the syscall (if that process is interested in
remote coverage collection). So when
kcov_remote_start_common(skb_get_kcov_handle(skb)) is executed, it is
possible to determine whether coverage is required and where it should
be stored.

I have just realized that the default kcov_handle initialization as it
was implemented in this patch is not really robust. If an skb is
allocated during a hard IRQ, kcov_common_handle() will return a remote
handle for the interrupted thread instead of returning 0, and that is
not desirable since it will occasionally lead to wrong kcov_handles. I
will fix it in the next version of the patch.

> >   mac80211: add KCOV remote annotations to incoming frame processing
>
> This seems fine, but a bit too limited? You tagged
> only ieee80211_tasklet_handler() which calls ieee80211_rx()
> or ieee80211_tx_status(), but
>
> 1) I'm not even sure ieee80211_tx_status() counts (it's processing
> locally generated frames after they round-tripped into the driver
> (although in mesh it could be remote originated but retransmitted
> frames, so I guess it makes some sense?); and
>
> 2) there are many other ways that ieee80211_rx() could get called.
>
> It seems to me it'd make more sense to (also) annotate ieee80211_rx()
> itself?

Yes, it definitely makes more sense to annotate ieee80211_rx()
directly. Collecting coverage for ieee80211_tx_status() does not seem
to be needed now and can be added later if there's a use case for it.

Thank you for the suggestion. I will implement it in the second
version of the patch.

--
Best regards,
Aleksandr
