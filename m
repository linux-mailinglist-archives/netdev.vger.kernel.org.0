Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0222A336EA0
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 10:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhCKJP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 04:15:28 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:36025 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbhCKJPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 04:15:12 -0500
Received: from mail-ot1-f53.google.com ([209.85.210.53]) by
 mrelayeu.kundenserver.de (mreue011 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MFbFW-1lWvnJ0PaY-00H7e9; Thu, 11 Mar 2021 10:15:07 +0100
Received: by mail-ot1-f53.google.com with SMTP id 75so854357otn.4;
        Thu, 11 Mar 2021 01:15:06 -0800 (PST)
X-Gm-Message-State: AOAM530eVF7rVrpAp1XLvQIrseRQla+swzeBKntkJBil4am9F6BNaHgT
        /7lc/bi2WdFhGObsvTlTFukx3xklGp4XhWG4Fm0=
X-Google-Smtp-Source: ABdhPJyn+biUFqeUpWbgYz+onSoY1lB5lZXnaVdOJ59ivfe6fWw6B/LYP9dm97k0WNF1I7ZVkGTZlALTwC9lFjwxZew=
X-Received: by 2002:a05:6830:14c1:: with SMTP id t1mr6129948otq.305.1615454105254;
 Thu, 11 Mar 2021 01:15:05 -0800 (PST)
MIME-Version: 1.0
References: <20210310083327.480837-1-krzysztof.kozlowski@canonical.com>
 <20210310083840.481615-1-krzysztof.kozlowski@canonical.com>
 <20210310094527.GA701493@dell> <35c39c81-08e4-24c8-f683-2fa7a7ea71de@redhat.com>
 <1c06cb74-f0b0-66e5-a594-ed1ee9bc876e@canonical.com> <CAK8P3a1CCQwbeH4KiUgif+-HdubVjjZBkMXimEjYkgeh4eJ7cg@mail.gmail.com>
 <52d0489f-0f77-76a2-3269-e3004c6b6c07@canonical.com> <ba2536a6-7c74-0cca-023f-cc6179950d37@canonical.com>
 <CAK8P3a1k7c5X5x=-_-=f=ACwY+uQQ8YEcAGXYfdTdSnqpo96sA@mail.gmail.com> <fb0d8ca3-ac46-f547-02b0-7f47ff8fff6b@canonical.com>
In-Reply-To: <fb0d8ca3-ac46-f547-02b0-7f47ff8fff6b@canonical.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 11 Mar 2021 10:14:49 +0100
X-Gmail-Original-Message-ID: <CAK8P3a05VkttECKTgonxKCSjJR0W4V1TRrUYMydgUGywbCSCWQ@mail.gmail.com>
Message-ID: <CAK8P3a05VkttECKTgonxKCSjJR0W4V1TRrUYMydgUGywbCSCWQ@mail.gmail.com>
Subject: Re: [RFC v2 3/5] arm64: socfpga: rename ARCH_STRATIX10 to ARCH_SOCFPGA64
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Tom Rix <trix@redhat.com>, Lee Jones <lee.jones@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Moritz Fischer <mdf@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        linux-edac@vger.kernel.org, linux-fpga@vger.kernel.org,
        Networking <netdev@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com, arm-soc <arm@kernel.org>,
        SoC Team <soc@kernel.org>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:8zSo19FEMGDxyiVQDBPRPGNk7oUpBJKvj23wAA3LeoGeGTVaVDe
 tYcAtEWJuc6QF3xHchWKOFHw7SzdIyvsUGzwG5ZCAIbpfSiEs2I44sZv8Ig0uLr7MILLENl
 cggEdUK03qWlQ/08UCGbvsKoo6DI2tigOl0tTfxiLh2W3CnAAeAKnlFxyt1SxNWb91t9oNT
 f3uj0KvErM5ZZx+1XApng==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:DHa3uyTr8Bg=:mYAf3HuyZSpvNDQzaYFPIa
 LQ8jH4G5xwF5IsG18LSCUNEXu4cXgmL7HkSnx6t4Odmq50eV26cIJzOSX95EuRoTU568WFmVF
 6D6D2deAwUPjNAd5o/5141PGlP5tMgZPA3BihdFgV9Vw8oifzBng1y8RuPF4IX6cUvqY5NNbz
 en5TQeAfMSBlKae749fUXQxsregl6IgMbfo+qesr2t5g5x2bCVIUzGqMysf6XNbekDVasEP3g
 6EXFmth3Dl/KzQzYt3UXUELR8LXIo7HFiARyafcLr85kuYQpClWDo5ZRL1uOd+ggzsJb/7YIE
 CGe/BYpm/a3+KFbtnRLNP15PnpWixRxwkjNUvGXUaeCU9viIXWzITSL9ZLlZatpM1k3BK4VZp
 gadboAk6GmkTmKrcXZfqvdunIX95jT0D0bli/LjuuMhmXSPV40LWZHonSaELFmzWfjcBHMIJ5
 z3Fq8/5O8dgcvuQ3hGKZOMoL+YW/IWvOOEsxT4sU+CK9ihrHpjVf/eIrZ8h4RNFNvXWG6gPgJ
 M+CdNro9r1nbTqwf74QTm4hvH8nIJCY5WcW0ZvCL+Ii/J7pF2RXZfOlA/V0c0xtqA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 8:08 AM Krzysztof Kozlowski
<krzysztof.kozlowski@canonical.com> wrote:
> On 10/03/2021 17:42, Arnd Bergmann wrote:
> > On Wed, Mar 10, 2021 at 4:54 PM Krzysztof Kozlowski
> > <krzysztof.kozlowski@canonical.com> wrote:
> >> On 10/03/2021 16:47, Krzysztof Kozlowski wrote:
> >>> This edac Altera driver is very weird... it uses the same compatible
> >>> differently depending whether this is 32-bit or 64-bit (e.g. Stratix
> >>> 10)! On ARMv7 the compatible means for example one IRQ... On ARMv8, we
> >>> have two. It's quite a new code (2019 from Intel), not some ancient
> >>> legacy, so it should never have been accepted...
> >>
> >> Oh, it's not that horrible as it sounds. They actually have different
> >> compatibles for edac driver with these differences (e.g. in interrupts).
> >> They just do not use them and instead check for the basic (common?)
> >> compatible and architecture... Anyway without testing I am not the
> >> person to fix the edac driver.
> >
> > Ok, This should be fixed properly as you describe, but as a quick hack
> > it wouldn't be hard to just change the #ifdef to check for CONFIG_64BIT
> > instead of CONFIG_ARCH_STRATIX10 during the rename of the config
> > symbol.
>
> This would work. The trouble with renaming ARCH_SOCFPGA into
> ARCH_INTEL_SOCFPGA is that still SOCFPGA will appear in many other
> Kconfig symbols or even directory paths.
>
> Let me use ARCH_INTEL_SOCFPGA for 64bit here and renaming of 32bit a
> little bit later.

Maybe you can introduce a hidden 'ARCH_INTEL_SOCFPGA' option first
and select that from both the 32-bit and the 64-bit platforms in the first step.

That should decouple the cleanups, so you can change the drivers to
(only) 'depends on ARCH_INTEL_SOCFPGA' before removing the other
names.

        Arnd
