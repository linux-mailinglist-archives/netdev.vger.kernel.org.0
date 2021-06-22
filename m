Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37AC3B0DA5
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 21:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhFVTb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 15:31:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229786AbhFVTb1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 15:31:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB31961353
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 19:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624390151;
        bh=OkCFHf6y3PDoewX0r/FcG3EK3e4OSyfGXYGp4VKggyk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uAlMLrhRGL74EOppuq20LfVjJA9s1BcaWynedauIqg+fPgtsx6ydb8orBPZTrUU0t
         v7XAQnEh58bDhqPUHhQqo8p9Oje3poNQcnO+N9MTd4QZPLp2ADIA1Rp6TM7nw7i+NF
         13W9OYP+qH/Y/2HShIgKIPDvr7yF7paMQ/Dqvcny0mTU0s0s0SdIPpZhSVYb7E80A5
         nOOo+lDYyKfsT+kI5zwO5tPSUcCdzytrFat/ibjZaHKIZ8FxCD345D2MBJU39bmxr6
         9XCj92RExHu7yteRaSh2F35ItinDpeh9xvh0aGrWiPa3iWNDW/2TNEVFi6lvbhxwao
         npg4icoHGP3bw==
Received: by mail-wr1-f54.google.com with SMTP id j2so14411575wrs.12
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 12:29:11 -0700 (PDT)
X-Gm-Message-State: AOAM530Yn0Fx3tbEZOaTQK4k1Alrve6FuuXdjWh2H5a1O4w9kexZfCmk
        XP+DzFsM0zFbi7FmNgdeBynI1XQHYDtgSL6t2ks=
X-Google-Smtp-Source: ABdhPJyz1uD8VkBt/jj7W7KEcTNtEDXjXj9bjFWf/UJB9DT4rLZp68IWdOWtqoeZVbp+JCwLILM1OebQhL4jJbfMz/w=
X-Received: by 2002:a5d:5650:: with SMTP id j16mr6819503wrw.99.1624390150286;
 Tue, 22 Jun 2021 12:29:10 -0700 (PDT)
MIME-Version: 1.0
References: <60B24AC2.9050505@gmail.com> <60B36A9A.4010806@gmail.com>
 <60B3CAF8.90902@gmail.com> <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
 <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
 <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
 <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
 <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
 <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com>
 <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk> <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com>
 <877dipgyrb.ffs@nanos.tec.linutronix.de> <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk>
 <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com>
 <60D1DAC1.9060200@gmail.com> <CAK8P3a1XaTUgxM3YBa=iHGrLX_Wn66NhTTEXtV=vaNre7K3GOA@mail.gmail.com>
 <60D22F1D.1000205@gmail.com>
In-Reply-To: <60D22F1D.1000205@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 22 Jun 2021 21:26:50 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3Jk+zNnQ5r9gb60deqCmJT+S07VvL3SipKRYXdxM2kPQ@mail.gmail.com>
Message-ID: <CAK8P3a3Jk+zNnQ5r9gb60deqCmJT+S07VvL3SipKRYXdxM2kPQ@mail.gmail.com>
Subject: Re: Realtek 8139 problem on 486.
To:     Nikolai Zhubr <zhubr.2@gmail.com>
Cc:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
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

On Tue, Jun 22, 2021 at 8:32 PM Nikolai Zhubr <zhubr.2@gmail.com> wrote:
> 22.06.2021 16:22, Arnd Bergmann:

> irq 8: 02, edge
> irq 9: 02, level
> irq 10: 02, edge
> irq 11: 02, edge
> irq 12: 02, edge
> irq 13: 02, edge
> irq 14: 02, edge
> irq 15: 02, edge
>
> Now connection also works fine with unmodified 8139too driver.
> The percentage of low-level errors stays very small:
>
> RX packets:13953 errors:1 dropped:2 overruns:1 frame:0
> TX packets:37346 errors:0 dropped:0 overruns:13 carrier:0

Ok, nice!

> This fix looks really nice. Maybe it is right thing to do.

I'll leave that up to Thomas and Maciej to decide, they should have the
best idea of why the x86 pci-irq code looks the way it does today and
what the possible risk with my patch is.

As I said before, I still think we should also merge the 8139 driver patch,
probably without that loop. It's not great, but I'm much more confident
I understand what that does and that the patched version is better than
the current code.

      Arnd
