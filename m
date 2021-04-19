Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01467363E32
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 11:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238489AbhDSJEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 05:04:14 -0400
Received: from mail-vs1-f42.google.com ([209.85.217.42]:45817 "EHLO
        mail-vs1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbhDSJEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 05:04:07 -0400
Received: by mail-vs1-f42.google.com with SMTP id r18so11290945vso.12;
        Mon, 19 Apr 2021 02:03:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YToQwZXN38nw8LU8icFLB58IB4Z2bfPdJB1gmWWtNj8=;
        b=A1Gpw+KFRJ5RhzhK+MGm++v8ObABj3dTeD508KFrtbc7QA6wHjlVZ2wNnWA24Wm9qH
         ZKWLhV244NO6o89Q6GspL4KaDDCWQc/Rr0lI8uQM9BsphAET/ujIJWTHUA1h7jBEwzzW
         gv/iCoYzQS4SvHHOcATnexFXSRoVMjraHKTV+/t85IwQkFQaED92dtBjnuALNFqwThKN
         z8L5EyISOQt0QtbWAEW05YxhRnGFqVcyi1gd0L1BXkCfBRVhGOdz52vO39RafdkWMRmK
         kzyLacR5FJFpb72oawG1qLHU0bX4NRH6I6iQwZyC7mGmdOg6y4SDXDXw5wjp8+K6il+R
         G38A==
X-Gm-Message-State: AOAM530na+Q6FqX6tSAED3u+1sIRzHBwXKGnEtFn2I1lwzoVJ8frs1J3
        NlCcjGhqMeS3WvdliarIHFqAUxE0pVenbDkJUPc=
X-Google-Smtp-Source: ABdhPJxHtnj/DXie9H0wxpzVZlSTyniokdUb/gsNNsMkANVtAtzr2mFBhczBYEoBurfSWsjRkBkPBhRAOOMrjVGBWsw=
X-Received: by 2002:a67:7c8c:: with SMTP id x134mr13821818vsc.40.1618823016409;
 Mon, 19 Apr 2021 02:03:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210419042722.27554-1-alice.guo@oss.nxp.com> <20210419042722.27554-4-alice.guo@oss.nxp.com>
 <YH0O907dfGY9jQRZ@atmark-techno.com>
In-Reply-To: <YH0O907dfGY9jQRZ@atmark-techno.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 19 Apr 2021 11:03:24 +0200
Message-ID: <CAMuHMdVY1SLZ0K30T2pimyrR6Mm=VoSTO=L-xxCy2Bj7_kostw@mail.gmail.com>
Subject: Re: [RFC v1 PATCH 3/3] driver: update all the code that use soc_device_match
To:     Dominique MARTINET <dominique.martinet@atmark-techno.com>
Cc:     "Alice Guo (OSS)" <alice.guo@oss.nxp.com>,
        gregkh@linuxfoundation.org, rafael@kernel.org,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net, tony@atomide.com,
        geert+renesas@glider.be, mturquette@baylibre.com, sboyd@kernel.org,
        vkoul@kernel.org, peter.ujfalusi@gmail.com, a.hajda@samsung.com,
        narmstrong@baylibre.com, robert.foss@linaro.org, airlied@linux.ie,
        daniel@ffwll.ch, khilman@baylibre.com, tomba@kernel.org,
        jyri.sarha@iki.fi, joro@8bytes.org, will@kernel.org,
        mchehab@kernel.org, ulf.hansson@linaro.org,
        adrian.hunter@intel.com, kishon@ti.com, kuba@kernel.org,
        linus.walleij@linaro.org, Roy.Pledge@nxp.com, leoyang.li@nxp.com,
        ssantosh@kernel.org, matthias.bgg@gmail.com, edubezval@gmail.com,
        j-keerthy@ti.com, balbi@kernel.org, linux@prisktech.co.nz,
        stern@rowland.harvard.edu, wim@linux-watchdog.org,
        linux@roeck-us.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-clk@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-gpio@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-staging@lists.linux.dev,
        linux-mediatek@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dominique,

CC Arnd (soc_device_match() author)

On Mon, Apr 19, 2021 at 7:03 AM Dominique MARTINET
<dominique.martinet@atmark-techno.com> wrote:
> Alice Guo (OSS) wrote on Mon, Apr 19, 2021 at 12:27:22PM +0800:
> > From: Alice Guo <alice.guo@nxp.com>
> > Update all the code that use soc_device_match
>
> A single patch might be difficult to accept for all components, a each
> maintainer will probably want to have a say on their subsystem?
>
> I would suggest to split these for a non-RFC version; a this will really
> need to be case-by-case handling.
>
> > because add support for soc_device_match returning -EPROBE_DEFER.
>
> (English does not parse here for me)
>
> I've only commented a couple of places in the code itself, but this
> doesn't seem to add much support for errors, just sweep the problem
> under the rug.
>
> > Signed-off-by: Alice Guo <alice.guo@nxp.com>
> > ---
> >
> > diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
> > index 5fae60f8c135..00c59aa217c1 100644
> > --- a/drivers/bus/ti-sysc.c
> > +++ b/drivers/bus/ti-sysc.c
> > @@ -2909,7 +2909,7 @@ static int sysc_init_soc(struct sysc *ddata)
> >       }
> >
> >       match = soc_device_match(sysc_soc_feat_match);
> > -     if (!match)
> > +     if (!match || IS_ERR(match))
> >               return 0;
>
> This function handles errors, I would recommend returning the error as
> is if soc_device_match returned one so the probe can be retried later.

Depends...

> > --- a/drivers/clk/renesas/r8a7795-cpg-mssr.c
> > +++ b/drivers/clk/renesas/r8a7795-cpg-mssr.c
> > @@ -439,6 +439,7 @@ static const unsigned int r8a7795es2_mod_nullify[] __initconst = {
> >
> >  static int __init r8a7795_cpg_mssr_init(struct device *dev)
> >  {
> > +     const struct soc_device_attribute *match;
> >       const struct rcar_gen3_cpg_pll_config *cpg_pll_config;
> >       u32 cpg_mode;
> >       int error;
> > @@ -453,7 +454,8 @@ static int __init r8a7795_cpg_mssr_init(struct device *dev)
> >               return -EINVAL;
> >       }
> >
> > -     if (soc_device_match(r8a7795es1)) {
> > +     match = soc_device_match(r8a7795es1);
> > +     if (!IS_ERR(match) && match) {
>
> Same, return the error.
> Assuming an error means no match will just lead to hard to debug
> problems because the driver potentially assumed the wrong device when
> it's just not ready yet.

When running on R-Car H3, there will always be a match device, as
the SoC device is registered early.

>
> >               cpg_core_nullify_range(r8a7795_core_clks,
> >                                      ARRAY_SIZE(r8a7795_core_clks),
> >                                      R8A7795_CLK_S0D2, R8A7795_CLK_S0D12);
> > [...]
> > diff --git a/drivers/iommu/ipmmu-vmsa.c b/drivers/iommu/ipmmu-vmsa.c
> > index eaaec0a55cc6..13a06b613379 100644
> > --- a/drivers/iommu/ipmmu-vmsa.c
> > +++ b/drivers/iommu/ipmmu-vmsa.c
> > @@ -757,17 +757,20 @@ static const char * const devices_allowlist[] = {
> >
> >  static bool ipmmu_device_is_allowed(struct device *dev)
> >  {
> > +     const struct soc_device_attribute *match1, *match2;
> >       unsigned int i;
> >
> >       /*
> >        * R-Car Gen3 and RZ/G2 use the allow list to opt-in devices.
> >        * For Other SoCs, this returns true anyway.
> >        */
> > -     if (!soc_device_match(soc_needs_opt_in))
> > +     match1 = soc_device_match(soc_needs_opt_in);
> > +     if (!IS_ERR(match1) && !match1)
>
> I'm not sure what you intended to do, but !match1 already means there is
> no error so the original code is identical.
>
> In this case ipmmu_device_is_allowed does not allow errors so this is
> one of the "difficult" drivers that require slightly more thinking.
> It is only called in ipmmu_of_xlate which does return errors properly,
> so in this case the most straightforward approach would be to make
> ipmmu_device_is_allowed return an int and forward errors as well.
>
> ...
> This is going to need quite some more work to be acceptable, in my
> opinion, but I think it should be possible.

In general, this is very hard to do, IMHO. Some drivers may be used on
multiple platforms, some of them registering an SoC device, some of
them not registering an SoC device.  So there is no way to know the
difference between "SoC device not registered, intentionally", and
"SoC device not yet registered".

soc_device_match() should only be used as a last resort, to identify
systems that cannot be identified otherwise.  Typically this is used for
quirks, which should only be enabled on a very specific subset of
systems.  IMHO such systems should make sure soc_device_match()
is available early, by registering their SoC device early.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
