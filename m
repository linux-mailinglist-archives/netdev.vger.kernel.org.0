Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049182FD2E6
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 15:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390654AbhATOjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 09:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390380AbhATOiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 09:38:50 -0500
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97850C0613C1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:38:10 -0800 (PST)
Received: by mail-vk1-xa34.google.com with SMTP id u22so1456973vke.9
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=q0wiaXWQy9Lg3mlgfsBMY+qpFMPssy5dcJuK0ZbGTiw=;
        b=Rz7UAkx/T+58yj1zO5FzTkfcRPoCjs7U9ldU3+1T9OYisyNbwKFtDXaS4QCGQ2SW7H
         GUe1a031P6TrSPQXLcOORwp7rVZusVc3U4nQVsVyZ6IVMaBORhRfuc4OZ70KULKD9tBz
         T7SHk8659EBaH3te5t1vkcvBmT/73/H6OnWyqydj9h1VEIKNrPdaFmvWxevx5hI41pVB
         HrMx6155QEKDJbZNlbexwBkFgfLGZJ13ax992B4uKxYcCr3wbwiuHpjayjJxDg/fVCt6
         L/8tvQ2pmZzjOfTwU4vSnW6BAApzqvTyXzI1Sn81tiRFoaSttSspK+BcNjh6DAt/3f3o
         +ctA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=q0wiaXWQy9Lg3mlgfsBMY+qpFMPssy5dcJuK0ZbGTiw=;
        b=gPPZpH+lnlJmK4eaLkXCz/b1DYB5j5d6BuQNaQlO870bhohS6FXiiAaSVlkJnwEFFw
         rlzybnjvSDrkWWsSE6pjIkrFINpX7Yj3jxMaiFtr2j6BHl/nfoFfHrRF0AspYIOBnzV1
         gp2oFX0ydrRFazD7vFUUnTg+RvQHkaUInhYRBvro3k5B8Ej6Hg1vaPfap6GCoTFRwYHv
         tUzdo68mCFv74P0/8+RB8wVDZzqtcnn4ftNQB3YzNQAr/7ajOM62w+aiQgBRkzxoGJtD
         M+Dqc/f1Y9y1iKd6JmBE4iWXL9i/bBIWCPNpxPRnWYlZ+R3F8/Fi0WrusE9A1B1ffx5b
         SnrA==
X-Gm-Message-State: AOAM533hRTmKW3oFIyXX+HyjU8ra1fY7qfl6fbSN4ceExp5LLB8eI8lO
        py0POKvCkBk3RN02aXjUAc7MuOVaXPfc2bL1mPQ=
X-Google-Smtp-Source: ABdhPJw065ZkRo/D831fmAc3OXnrHUxAsbXNNZVF3hotUYpvCa/sffpRUq7k9KEWvJG6J7LaqMLGnMGJakztoeyaDHs=
X-Received: by 2002:a1f:17c6:: with SMTP id 189mr6124242vkx.16.1611153489831;
 Wed, 20 Jan 2021 06:38:09 -0800 (PST)
MIME-Version: 1.0
References: <20210118054611.15439-1-gciofono@gmail.com> <20210118115250.GA1428@t-online.de>
 <87a6t6j6vn.fsf@miraculix.mork.no> <CAKSBH7HbaVxyZJRuZPv+t2uBipZAkAYTcyJwRDy-UTB_sD4SJA@mail.gmail.com>
 <87mtx3agza.fsf@miraculix.mork.no>
In-Reply-To: <87mtx3agza.fsf@miraculix.mork.no>
From:   Giacinto Cifelli <gciofono@gmail.com>
Date:   Wed, 20 Jan 2021 15:37:59 +0100
Message-ID: <CAKSBH7ENRJCbkuq2HviDc-RiH8qh9u+oU5c=uNWoNKofCgs95A@mail.gmail.com>
Subject: Re: [PATCH] net: usb: qmi_wwan: added support for Thales Cinterion
 PLSx3 modem family
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     Reinhard Speyerer <rspmn@t-online.de>, netdev@vger.kernel.org,
        rspmn@arcor.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bj=C3=B8rn,


On Wed, Jan 20, 2021 at 2:13 PM Bj=C3=B8rn Mork <bjorn@mork.no> wrote:
>
> Giacinto Cifelli <gciofono@gmail.com> writes:
>
> > Hi Bj=C3=B8rn,
> > I have fixed and resent, but from your comment I might not have
> > selected the right line from maintaner.pl?
> > what I have is this:
> > $ ./scripts/get_maintainer.pl --file drivers/net/usb/qmi_wwan.c
> > "Bj=C3=B8rn Mork" <bjorn@mork.no> (maintainer:USB QMI WWAN NETWORK DRIV=
ER)
> > "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING DRIVERS)
> > Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING DRIVERS)
> > netdev@vger.kernel.org (open list:USB QMI WWAN NETWORK DRIVER)
> > <<<< this seems the right one
> > linux-usb@vger.kernel.org (open list:USB NETWORKING DRIVERS)
> > linux-kernel@vger.kernel.org (open list)
> >
> > I have at the same time sent a patch for another enumeration of the
> > same product, for cdc_ether.  In that case, I have picked the
> > following line, which also looked the best fit:
> >   linux-usb@vger.kernel.org (open list:USB CDC ETHERNET DRIVER)
> >
> > Did I misinterpret the results of the script?
>
> Yes, but I'll be the first to admit that it isn't easy.
>
> netdev is definitely correct, and the most important one.
>
> But in theory you are supposed to use all the listed addresses.  Except
> that I don't think you need to CC David (and Jakub?) since they probably
> read everything in netdev anyway.  And I believe many (most?) people
> leave out the linux-kernel catch-all, since it doesn't provide any extra
> coverage for networking. At least I do.
>
> Then there's the two remaining addresses.  The linux-usb list is
> traditionally CCed on patches touching USB drivers, since the USB
> experts are there and not necessarily in netdev.  And I'd like a copy
> because that's the only way I'll be able to catch these patches.  I
> don't read any of the lists regularily.
>
> This is my interpretation only.  I am sure there are other opinions. But
> as usual, you cannot do anything wrong. The worst that can ever happen
> is that you have to resend a patch or miss my review of it ;-)
>

looks like "welcome to the maze" :D

So, the letter of the instructions would be send all, but up to you to
leave some of them out.
Got it.
I am going to wait a couple of days on the off chance that my patches
are reviewed, then I will resend.

Thank you and regards,
Giacinto
