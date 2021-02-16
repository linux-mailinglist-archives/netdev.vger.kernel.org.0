Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B3C31C884
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 11:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhBPKMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 05:12:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:55740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229771AbhBPKMj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 05:12:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64EF864D9E;
        Tue, 16 Feb 2021 10:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613470318;
        bh=O9zZWr1BTSfSC7SFTtkQBQ/xVE2twCkTfF2UAJOatvY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LbATF5kC6aiAcsZiQxoiwOyFy2ZGUj0vA+H2IP8rvzsFynEgS7cZbOnjEmM2GoUyn
         TyQN96KPs5t2+58U2GLEFvUi/z/mMFeO+wU7Erc45C7SbZfAm1Dq1irE+hTX+3yWZa
         f313M6wAnbu6w7+Zna5BYl5+VSHNiL5LS6/bKTvEZK87gQdPzRgRG8tSoq3l1jSkR3
         8UPzruHnZDwjBHyXD2jO5K6VdIHboZw2Xq0OqLGzcm3VgcD8schBjAYk7dvwK+VvCA
         2p4K5fGpkaNtVWfr4H7OIYjpdAvUUxYQu5NjT1t0BZlZ+e94QGqblRCeH0MCK6lCwh
         TO6csrcxjnbdw==
Received: by mail-oi1-f177.google.com with SMTP id l19so10667558oih.6;
        Tue, 16 Feb 2021 02:11:58 -0800 (PST)
X-Gm-Message-State: AOAM530UANs0iv5VRC9nJp9BrIlvOQh1d/MVPGTqboxWrNe0kc3xddC4
        ajlofLCobWh2RFffBye8iAFohA3asL5X/VHS3GE=
X-Google-Smtp-Source: ABdhPJzG/H3wVcslxTEnqeZi/ylklV0MYm3BcuNOjYzDqles36eR+lldIhLS+bHC1krCppp8jFjbRAV5JR99yHVjGsE=
X-Received: by 2002:aca:e103:: with SMTP id y3mr1963362oig.11.1613470317705;
 Tue, 16 Feb 2021 02:11:57 -0800 (PST)
MIME-Version: 1.0
References: <20210216130449.3d1f0338@canb.auug.org.au> <OSBPR01MB2983FDFEF1D1E24E7C2DF0F692879@OSBPR01MB2983.jpnprd01.prod.outlook.com>
In-Reply-To: <OSBPR01MB2983FDFEF1D1E24E7C2DF0F692879@OSBPR01MB2983.jpnprd01.prod.outlook.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 16 Feb 2021 11:11:41 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3CYkfOvta9pRwLXkOsARQF=YNWzdh0z1-r6rMDAEGYig@mail.gmail.com>
Message-ID: <CAK8P3a3CYkfOvta9pRwLXkOsARQF=YNWzdh0z1-r6rMDAEGYig@mail.gmail.com>
Subject: Re: linux-next: manual merge of the net-next tree with the arm-soc tree
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 3:20 AM <nobuhiro1.iwamatsu@toshiba.co.jp> wrote:
> >
> > I fixed it up (see below) and can carry the fix as necessary. This
> > is now fixed as far as linux-next is concerned, but any non trivial
> > conflicts should be mentioned to your upstream maintainer when your tree
> > is submitted for merging.  You may also want to consider cooperating
> > with the maintainer of the conflicting tree to minimise any particularly
> > complex conflicts.
> >
>
> This is because the DTS changes are included in net-next. This patch should be merged via the soc tree.
> I had the same problem before. How is it correct to send a DTS patch?
> Should I separate into different series?

I have already sent the pull requests for the dts files to Linus, so that's
not changing any more for this time, and he will just have to fix it up
when he pulls both branches.

In the future, please send all dts updates to soc@kernel.org (after the
binding and driver is merged) rather than together with the device drivers.

Sending the devicetree binding updates is a little trickier, as we tend to
want them merged both with the driver and the dts files. One way to do
this is to have a shared branch for the bindings updates, and then base both
the driver branch and the dts branch on top of the same commits for that.

A simpler alternative is to merge only the driver and binding changes in
one release, and send the dts changes for the following release. This
obviously takes longer to complete.

       Arnd
