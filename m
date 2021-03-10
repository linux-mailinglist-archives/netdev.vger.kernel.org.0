Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384B8334354
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 17:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbhCJQnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 11:43:06 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:44159 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbhCJQmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 11:42:35 -0500
Received: from mail-ot1-f42.google.com ([209.85.210.42]) by
 mrelayeu.kundenserver.de (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MEUaQ-1lVX9u2wYc-00FxFe; Wed, 10 Mar 2021 17:42:32 +0100
Received: by mail-ot1-f42.google.com with SMTP id r24so9910125otq.13;
        Wed, 10 Mar 2021 08:42:31 -0800 (PST)
X-Gm-Message-State: AOAM531618fRSfH256hUIxqYKahUUC7uP0KXysWqtDfdWzToTXK0fmd5
        d0CpnqW8SHKRlbS2Fe6OR65wOB9vlfZLHFB4k6k=
X-Google-Smtp-Source: ABdhPJwWKWol/izxVLT1AnVOt4GuD9z3iMz5KYY704sE+gXiB+rSpGmz56qGx1HmOVASlj0OW4Sd2OtpS9wyLv30UgQ=
X-Received: by 2002:a05:6830:14c1:: with SMTP id t1mr3205568otq.305.1615394550932;
 Wed, 10 Mar 2021 08:42:30 -0800 (PST)
MIME-Version: 1.0
References: <20210310083327.480837-1-krzysztof.kozlowski@canonical.com>
 <20210310083840.481615-1-krzysztof.kozlowski@canonical.com>
 <20210310094527.GA701493@dell> <35c39c81-08e4-24c8-f683-2fa7a7ea71de@redhat.com>
 <1c06cb74-f0b0-66e5-a594-ed1ee9bc876e@canonical.com> <CAK8P3a1CCQwbeH4KiUgif+-HdubVjjZBkMXimEjYkgeh4eJ7cg@mail.gmail.com>
 <52d0489f-0f77-76a2-3269-e3004c6b6c07@canonical.com> <ba2536a6-7c74-0cca-023f-cc6179950d37@canonical.com>
In-Reply-To: <ba2536a6-7c74-0cca-023f-cc6179950d37@canonical.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 10 Mar 2021 17:42:14 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1k7c5X5x=-_-=f=ACwY+uQQ8YEcAGXYfdTdSnqpo96sA@mail.gmail.com>
Message-ID: <CAK8P3a1k7c5X5x=-_-=f=ACwY+uQQ8YEcAGXYfdTdSnqpo96sA@mail.gmail.com>
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
X-Provags-ID: V03:K1:mD3lZEAZ0S3ahdUwhY/PVRP3TJvm32ZYqoFsNwG6SivS7RKw1Mh
 QVu619UGLCDCqL3QGhn65Za9e1SsQVZGEXrC2OsV1oaBBUVSchXZOkaRgazmLDHYDMis2ab
 hnORZ4egk+m90I3uz3EtQgnebCHD/2EEa0wfsYvP22qAdddkMs2JDG7XsaHHn+fu0OZmo4i
 QGU/G3RofrBkKV5C1CLog==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:R6SOznsLKLc=:4ke1NavTQLm1kBpVKYolYR
 P8AABUDrV4FOlQ5g+vrdyJX2h+3ZAruh06VsQlMaZEwfoIFcA2VoIW4+bhbkF+Qz1gCnMNTp4
 Nx/TYs1r3Y1Huph/hL476+n1msLMq0jERp/6bePCmmXy9Ble7eiVWeHnovG/67/v7FT3GQ6OX
 B88PLI93Z+NswgeOetDxadqOZyMun9Cmx6fcOOC19bgxLS0uqHZkLYOFcmZrX+Mdn4DDC/inq
 xV0nhpYWr3hn+2gvd/hcqG+EQbgGB4uJQ2Qa0mWsVvLPE9KpfDK8qOvICTsVbTM4UhtErc/EV
 +nWHCxXQLxTyNOOZQRiQaEg3q+e2WpUD966ea9NclLHUzocxAeb+BIbnQnAMX+LhZ/X52kRJs
 5eP9Aght3jGZaHCEZEhml/zz29wnJa9VqMarblPsJyCyU3Bd60UkLjrG+rQnR
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 4:54 PM Krzysztof Kozlowski
<krzysztof.kozlowski@canonical.com> wrote:
> On 10/03/2021 16:47, Krzysztof Kozlowski wrote:
> > This edac Altera driver is very weird... it uses the same compatible
> > differently depending whether this is 32-bit or 64-bit (e.g. Stratix
> > 10)! On ARMv7 the compatible means for example one IRQ... On ARMv8, we
> > have two. It's quite a new code (2019 from Intel), not some ancient
> > legacy, so it should never have been accepted...
>
> Oh, it's not that horrible as it sounds. They actually have different
> compatibles for edac driver with these differences (e.g. in interrupts).
> They just do not use them and instead check for the basic (common?)
> compatible and architecture... Anyway without testing I am not the
> person to fix the edac driver.

Ok, This should be fixed properly as you describe, but as a quick hack
it wouldn't be hard to just change the #ifdef to check for CONFIG_64BIT
instead of CONFIG_ARCH_STRATIX10 during the rename of the config
symbol.

       Arnd
