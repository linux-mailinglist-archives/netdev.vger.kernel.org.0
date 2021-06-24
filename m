Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B5F3B2A5E
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 10:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbhFXIdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 04:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231826AbhFXIdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 04:33:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 684E161403
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 08:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624523445;
        bh=y0FA5nRj8Gho2wqQeQ7LZIyLixNTu/t/xqW01xvPE6I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=n2n89OQv2LdrLGnhQwEnbcHMxsBxoMZIWda5c6Ofqqfft98Yhz7Qkfiv0f+izF+zJ
         Kqgn5/u/WGNE2xIMayThVMms9ZO4WdWU8SVnFoBp0Rpy4S1B3wGexq9vaopLr/eMYY
         XdmHy9qVExjbh+4W7GfqVaTa7UpR4zC5amzjo6KWtnsBgEaK1R53+hzbim603sw8ga
         Oq+1pTFfpOqGeRq3ux6cP/rRkK9izPziyF1QIJsnjmVNFlZCF0aIYSRUcy7SI1JpzQ
         T5H9lnrea0GMEtEWeROlFZ99DJMWEMwHWzAbplPyLT22qGtDqml/v1ZuZSXvkMzWoO
         IXVHVsZxrKcgg==
Received: by mail-wr1-f48.google.com with SMTP id j1so5639515wrn.9
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 01:30:45 -0700 (PDT)
X-Gm-Message-State: AOAM533CC6rP9XNE6TwJpiY7xXypr9sDQLx1HWX8QQl2deDYr+RIY0Xh
        RzHqgWt6gx7vtYf8VQTSQTAAX6GGx0uLT5Aptfo=
X-Google-Smtp-Source: ABdhPJwJxvOwNfL2PR4KSGY6167bv2EfVJ6cYPSSszIWz/Hq720nG35f5UbFk6dRF/Mh6ZuA1rY7PFWZxMFIotsjnBg=
X-Received: by 2002:a5d:5650:: with SMTP id j16mr3010905wrw.99.1624523443902;
 Thu, 24 Jun 2021 01:30:43 -0700 (PDT)
MIME-Version: 1.0
References: <60B24AC2.9050505@gmail.com> <60B514A0.1020701@gmail.com>
 <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
 <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
 <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
 <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
 <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com>
 <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk> <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com>
 <877dipgyrb.ffs@nanos.tec.linutronix.de> <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk>
 <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com>
 <60D1DAC1.9060200@gmail.com> <CAK8P3a1XaTUgxM3YBa=iHGrLX_Wn66NhTTEXtV=vaNre7K3GOA@mail.gmail.com>
 <60D22F1D.1000205@gmail.com> <CAK8P3a3Jk+zNnQ5r9gb60deqCmJT+S07VvL3SipKRYXdxM2kPQ@mail.gmail.com>
 <60D361FF.70905@gmail.com> <alpine.DEB.2.21.2106240044080.37803@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2106240044080.37803@angie.orcam.me.uk>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 24 Jun 2021 10:28:21 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0u+usoPon7aNOAB_g+Jzkhbz9Q7-vyYci1ReHB6c-JMQ@mail.gmail.com>
Message-ID: <CAK8P3a0u+usoPon7aNOAB_g+Jzkhbz9Q7-vyYci1ReHB6c-JMQ@mail.gmail.com>
Subject: Re: Realtek 8139 problem on 486.
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Nikolai Zhubr <zhubr.2@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 1:39 AM Maciej W. Rozycki <macro@orcam.me.uk> wrote:
>
> On Wed, 23 Jun 2021, Nikolai Zhubr wrote:
>
> > > As I said before, I still think we should also merge the 8139 driver patch,
> > > probably without that loop. It's not great, but I'm much more confident
> > > I understand what that does and that the patched version is better than
> > > the current code.
> >
> > Yes, the 'poll' approach apparently works stable and does not cause any
> > measurable performance decrease. But it would need some carefull
> > cleanup/review, especially WRT locking.

Right, I forgot you saw that one WARN_ON trigger. If you enable KALLSYMS
and BUGVERBOSE, it should become obvious what that one is about.

> >  Now that all real event handling work
> > is happening in the poll function, it still has to be protected against the
> > (potentially also long-running) reset function which in current design can be
> > called e.g. from a different thread due to tx timeout, and this does not look
> > good, but it is a bit beyond my capability to arrange it better. Besides, the
> > idea was to keep the fix simple and avoid a massive rework...

Since the calls are just moved from hardirq to softirq context, it should
be possible to do this without changing the locking state of any bit, by
just making sure that irqs are disabled during the code that was part of
the hardirq handler.

If you remove the loop, you can move the spin_lock_irqsave(&tp->lock)
back down  after the rx handler.

Anything on top of that can be done as a cleanup or simplification.

>  The simplest fix is not always the right one.

Sure, but in this case, a fairly simple change can help make this driver
work on any machine that for whatever reason treats the IRQ as
edge triggered.

>  I've now posted a small patch series that adds a PCI IRQ router for the
> SiS85C497 device.

Thanks a lot, that should help avoid the same problem on
this chipset with other drivers.

        Arnd
