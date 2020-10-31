Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3693C2A18FA
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 18:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgJaRYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 13:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgJaRYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 13:24:18 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846EEC0617A6;
        Sat, 31 Oct 2020 10:24:17 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id r10so4593470plx.3;
        Sat, 31 Oct 2020 10:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NjBHU8qzToli1jk/dnHlPgg8io2y0iFb2YfpGU6yl40=;
        b=J1pXr9734jdPcs6wxMZP6yARmrvNTRmwQ95qChOqLUXZBpsiKN8s+TgayuSyWEPnTi
         lwzCJg/02JSBzsp3RuDrhUYiXTbcVOJxJlhNl9YG9fa2gf5cW1B4JI2XA0X0WEb+Y2ti
         r8gYy4jaDUH0Hk/SbNaBg49rCBq2XP9m7A546n4J6MTUjhfGUUtzOhrfgdIcR7G6qXag
         ISskEoQENc0SA/kgnDLlDCy4UgQcLLzmgGK+/arYWm7wBee4dMIqCyJTwbn3YgqtlleM
         03sihZep3PUL7GRBs/7vbyUvfNS+084RiccF0tw+adxdBL0msV+n1I8zRZeya0ZRJJv6
         FQyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NjBHU8qzToli1jk/dnHlPgg8io2y0iFb2YfpGU6yl40=;
        b=kWoSDfYfjbBqty63RgPYrKdA9Y310ptpXJRFbLnnr7oZ198h7jySN7I5vR+gsk2XZU
         KwIZDyESrPEwiv9yZ8g19mITq24xlWN0IQKMdcpebZCcADl22KLHCpCrWNC10gzRzwcf
         AuDAV6PriOxu08gRZ2Co/DoXdPprXNRRZ6Jxzd0ZG11xex24Jp33E78S6h0FjnSKrEXD
         Jk1dYoYaDMrpQBm4I/CrX5JVg/juhi5lzguOkxnRexlOZt3vPvTVv8G0Vgmd9JQkEOZN
         X6n2s2z4cFsmPsDImBIe5aBjiLbGWMMe3ZLfTvfV9TZFXnpUnX59DaM/KE2DIqJulA6v
         JNow==
X-Gm-Message-State: AOAM531wxJVLcXsarSsyM+h4k2y9x8aLhgYdp/yRVjaUmqPHOLZyWBbJ
        U4a6IOdV8t78uzvpUD2z2NHcE6ph0RduVS/Uujw=
X-Google-Smtp-Source: ABdhPJy29U0nO/yNzxVnIuo1Yscg8nufmwyOAIIs/O7Id27037vNaQmdpqvHT+dosSXKnbhYhU1Y5/VCWUmqXRdADB4=
X-Received: by 2002:a17:90a:aa91:: with SMTP id l17mr8985182pjq.198.1604165057150;
 Sat, 31 Oct 2020 10:24:17 -0700 (PDT)
MIME-Version: 1.0
References: <20201028070504.362164-1-xie.he.0141@gmail.com>
 <20201030200705.6e2039c2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAJht_EOk43LdKVU4qH1MB5pLKcSONazA9XsKJUMTG=79TJ-3Rg@mail.gmail.com> <20201031095146.5e6945a1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031095146.5e6945a1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 31 Oct 2020 10:24:06 -0700
Message-ID: <CAJht_EP5njqgcLBq1x_-6BidtgFbfBTYXtM5AgPDLqsMLESA4A@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dlci: Deprecate the DLCI driver (aka the
 Frame Relay layer)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 9:51 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> > > The usual way of getting rid of old code is to move it to staging/
> > > for a few releases then delete it, like Arnd just did with wimax.
> >
> > Oh. OK. But I see "include/linux/if_frad.h" is included in
> > "net/socket.c", and there's still some code in "net/socket.c" related
> > to it. If we move all these files to "staging/", we need to change the
> > "include" line in "net/socket.c" to point to the new location, and we
> > still need to keep a little code in "net/socket.c". So I think if we
> > move it to "staging/", we can't do this in a clean way.
>
> I'd just place that code under appropriate #ifdef CONFIG_ so we don't
> forget to remove it later.  It's just the dlci_ioctl_hook, right?

Searching "dlci" (case insensitive) in "net/socket.c", I found there
were 3 areas with "dlci.c" related code. I also found there were 2
macro definitions in "include/uapi/linux/sockios.h".

> Maybe others have better ideas, Arnd?
