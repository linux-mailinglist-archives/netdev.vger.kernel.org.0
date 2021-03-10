Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3C13341BA
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbhCJPkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:40:15 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:41737 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbhCJPj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 10:39:58 -0500
Received: from mail-ot1-f41.google.com ([209.85.210.41]) by
 mrelayeu.kundenserver.de (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MD5fd-1lT3Ur2NWL-0096PB; Wed, 10 Mar 2021 16:39:56 +0100
Received: by mail-ot1-f41.google.com with SMTP id a17so16786190oto.5;
        Wed, 10 Mar 2021 07:39:55 -0800 (PST)
X-Gm-Message-State: AOAM530bizGt1XwmpPpxiZZ/xaGxr585XYhDYH8XY0JzMYFDEJwMPjDc
        BnmT2xqlS9ZNEKhsfaO6RjjOVwSpazXZgc1Mr28=
X-Google-Smtp-Source: ABdhPJyz+OU7gvgIrSIrSop4e8azU44xAIwSKa5HpTc5C9P44C7QC3z/u5GcCJR7jvFrP3vF9cowRntGlUhuRjPALp4=
X-Received: by 2002:a05:6830:14c1:: with SMTP id t1mr2985547otq.305.1615390794792;
 Wed, 10 Mar 2021 07:39:54 -0800 (PST)
MIME-Version: 1.0
References: <20210310083327.480837-1-krzysztof.kozlowski@canonical.com>
 <20210310083840.481615-1-krzysztof.kozlowski@canonical.com>
 <20210310094527.GA701493@dell> <35c39c81-08e4-24c8-f683-2fa7a7ea71de@redhat.com>
 <1c06cb74-f0b0-66e5-a594-ed1ee9bc876e@canonical.com>
In-Reply-To: <1c06cb74-f0b0-66e5-a594-ed1ee9bc876e@canonical.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 10 Mar 2021 16:39:37 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1CCQwbeH4KiUgif+-HdubVjjZBkMXimEjYkgeh4eJ7cg@mail.gmail.com>
Message-ID: <CAK8P3a1CCQwbeH4KiUgif+-HdubVjjZBkMXimEjYkgeh4eJ7cg@mail.gmail.com>
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
X-Provags-ID: V03:K1:QuxxoViFqMbIcHIb8w99YreoXmfBiRqTKjDeRQuZ1EIzQbW48uR
 XURGz5Z6bEHJF80Qq2RuH+k6iYym+jvmHAIeZz0dEs+iCs3ej/vSMIL0xqMEqoVyHObfzJV
 RY8PF/3byan60umtzRs7qQbCONk1+ki2GAEoscvoUmQ3MqiDfAedEDmPeCOrlpYSkdyoZBQ
 3rHa4qCq8M1Ke4bWsjj4w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:cKEqFz4Ztjg=:l2G4YYzG6B1M6ffbG3dvjl
 GdhjcCZD5IyxBesKT1VCIVbdSN4L9nEKpInyckrxnasm4CFwrcwRWlBNXJRemh9SMElZ1jZDs
 1dViagxvR0p0I1T2tM8NsFToRrhInuStbkq2kn6ztCtAnxS+0QPRHJTelJ5x31SgoxEx/DuvS
 o/0ppoi8iwHMeMoTAFq9wHZGbGh9Ukv1B9v+thOa6LROh6jKmaIhW3HScvcOtNVl1Vm2Ws1CH
 ip9u6Eu0rjH5jRpXVdKAEwoIYErH66LvKlNvb4eC8StFeIXyI5Lon763ic/p1wDm8KemGPoia
 sDGFLZt8XWgpF+XIXOTmLElQwhjsUFNASQ1iZrVioHcZhq+qs7ErI54yAxOHcEFgpeZXgIk/l
 3UsEYXgo+5CyE2NCpKcI5XA+se+Q8DANdZnQhLKLDf3F/3orgLKpxNMXpaaHb
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 4:06 PM Krzysztof Kozlowski
<krzysztof.kozlowski@canonical.com> wrote:
> On 10/03/2021 15:45, Tom Rix wrote:
> > On 3/10/21 1:45 AM, Lee Jones wrote:
>
> Many other architectures do not have vendor prefix (TEGRA, EXYNOS,
> ZYNQMP etc). I would call it the same as in ARMv7 - ARCH_SOCFPGA - but
> the Altera EDAC driver depends on these symbols to be different.
> Anyway, I don't mind using something else for the name.

I agree the name SOCFPGA is confusing, since it is really a class of
device that is made by multiple manufacturers rather than a brand name,
but renaming that now would be equally confusing. If the Intel folks
could suggest a better name that describes all products in the platform
and is less ambiguous, we could rename it to that. I think ARCH_ALTERA
would make sense, but I don't know if that is a name that is getting
phased out. (We once renamed the Marvell Orion platform to ARCH_MVEBU,
but shortly afterwards, Marvell renamed their embedded business unit (EBU)
and the name has no longer made sense since).

Regardless of what name we end up with, I do think we should have the
same name for 32-bit and 64-bit and instead fix the edac driver to do
runtime detection based on the compatible string.

        Arnd
