Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE0A3DBE80
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 20:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbhG3Ssm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 14:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhG3Ssl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 14:48:41 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40722C06175F;
        Fri, 30 Jul 2021 11:48:36 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id nd39so18514716ejc.5;
        Fri, 30 Jul 2021 11:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uqEJ2tVk3zcOiShzikPvptoGMxHSTS5A52RutoFqS7U=;
        b=VNTu8gtySpaaA9sS+BurTr8F6HP1kt3TtaG4MO5SiuRWtmvH7Sakptp3Na+wiVsa/s
         2Y4mylYfnuM0mgcDzsgHIhomZVBtEHzHlkEeSaLecHZbynPSffYazJ8t0eP/i9csiEii
         6JL9U9aRmmywVGZ+XCUSFeMacWg/AVZaUvGaYkUlJbZyrqOu1KeesnWEl++Kv+O86JLA
         rPKlUEALxQp0A8anLlu/17bvg7zST/3nzp2t5YecKTzuyvXkoD7Wdv6XcNz2gL4SMQ7b
         o6MkSsXFpIE1XNLLI4CvNGbcJWKdiKgsMrbFf5eW5kDMsmD7ZJajr+a7NJDISKaaxgO1
         NLww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uqEJ2tVk3zcOiShzikPvptoGMxHSTS5A52RutoFqS7U=;
        b=razWqjpueQDKEs1y6NnhUjY249tbc2LiZcJjltg1zdO4d9mXoeLzaIljFiItRdWXbQ
         9AuDgULLKGLtrPhzA9duUD0mQsxWBCE5sFbvBSBa/BIummwxPUvYwq7uvKqk5u9VU9UQ
         piqGpIIa4RS9X0kQ8Eb2hDR8G5ie5OTPT/loZB2hBSQbVibxInAkF+E2bOrYujoFxTOW
         8+21atvDhgzN1baf7bM4DUY8cIUCxJK1R8Q2ps96WniHTsorvz8AekDYgyv+YWecsovf
         Mb38WMSsWBTXrohIAFKk0rTpf+souds4FoWRGeHfOJUCN2WBHCSekSI3cdZTi0RHMi4M
         podQ==
X-Gm-Message-State: AOAM533Yn9CyK1r8TSgZYTnpLXL3uuNy3eGJs8iFwrw9CrsnhqJwTRCX
        +kljrw8b8YZuD8pNZaFNgzryT3CuhYpj+t/qXXg=
X-Google-Smtp-Source: ABdhPJxgQtN17xHqQ9vhmBTo79gnekMn6vV9DVxYUb4Z8lYNCc/M1ZY0V2WSXXxuXrzrj3X0lwDN3T2Pea8nFfVmiLw=
X-Received: by 2002:a17:907:7848:: with SMTP id lb8mr3992214ejc.494.1627670914923;
 Fri, 30 Jul 2021 11:48:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210729201100.3994-1-linux.amoon@gmail.com> <20210729201100.3994-3-linux.amoon@gmail.com>
 <a360877260a877819ad8eef7f63c370e0c16c640.camel@pengutronix.de>
In-Reply-To: <a360877260a877819ad8eef7f63c370e0c16c640.camel@pengutronix.de>
From:   Anand Moon <linux.amoon@gmail.com>
Date:   Sat, 31 Jul 2021 00:18:23 +0530
Message-ID: <CANAwSgSHFfzq4BYZN4wRUWcfc8+G5X9MvTUJu86MGBGFfQPSYA@mail.gmail.com>
Subject: Re: [PATCHv1 2/3] ARM: dts: meson: Use new reset id for reset controller
To:     Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-amlogic@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        devicetree <devicetree@vger.kernel.org>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Emiliano Ingrassia <ingrassia@epigenesys.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Philipp,

Thanks for your review comments.

On Fri, 30 Jul 2021 at 15:16, Philipp Zabel <p.zabel@pengutronix.de> wrote:
>
> On Fri, 2021-07-30 at 01:40 +0530, Anand Moon wrote:
> > Used new reset id for reset controller as it conflict
> > with the core reset id.
> >
> > Fixes: b96446541d83 ("ARM: dts: meson8b: extend ethernet controller description")
> >
> > Cc: Jerome Brunet <jbrunet@baylibre.com>
> > Cc: Neil Armstrong <narmstrong@baylibre.com>
> > Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> > Signed-off-by: Anand Moon <linux.amoon@gmail.com>
> > ---
> >  arch/arm/boot/dts/meson8b.dtsi  | 2 +-
> >  arch/arm/boot/dts/meson8m2.dtsi | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm/boot/dts/meson8b.dtsi b/arch/arm/boot/dts/meson8b.dtsi
> > index c02b03cbcdf4..cb3a579d09ef 100644
> > --- a/arch/arm/boot/dts/meson8b.dtsi
> > +++ b/arch/arm/boot/dts/meson8b.dtsi
> > @@ -511,7 +511,7 @@ &ethmac {
> >       tx-fifo-depth = <2048>;
> >
> >       resets = <&reset RESET_ETHERNET>;
> > -     reset-names = "stmmaceth";
> > +     reset-names = "ethreset";
>
> This looks like an incompatible change. Is the "stmmaceth" reset not
> used? It is documented as "MAC reset signal" in [1]. So a PHY reset
> should be separate from this.
>
> [1] Documentation/devicetree/bindings/net/snps,dwmac.yaml
>
From the above device tree binding is been used below.
  reset-names:
    const: stmmaceth

While testing new reset driver changes I was getting conflict with
reset id, see the below links
hence I opted for a new reset-names = "ethreset".

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/stmicro/stmmac/stmmac.h?h=v5.14-rc3#n12
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c?h=v5.14-rc3#n598

> regards
> Philipp

Thanks

-Anand
