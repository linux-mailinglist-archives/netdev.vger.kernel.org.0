Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D115058657F
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 09:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiHAHKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 03:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiHAHKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 03:10:19 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7816C262
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 00:10:11 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id t1so15872669lft.8
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 00:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lessconfused.com; s=lessconfused;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9emDdEzFMs69Gipidjg/4iPnKc74czbXBSfH7BXoX7E=;
        b=Sr72hQDSRLuQjtIWdvTg4GI/F/ghx7wAZJ5xA2IE7SrVxy89DYVfbRwLHbl6upi5PO
         iDCh9ERhAlD6CzLccqGjaoHqeIVFE6CbRMe9P1JcD/LltWBV55SBpYqHCFDTQxq58wmy
         J0TriKfvsvLdoDDSrJIq8xNCyYo+30wOO8P0M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9emDdEzFMs69Gipidjg/4iPnKc74czbXBSfH7BXoX7E=;
        b=lfIsd+YigyzC3LoEhTLi9aHzlXyZ1taQ9Ppd9iX/khagCQ1sP9Wsm+/l+5bYdVxwSY
         u9FVFjW1gzCTFWuLbYsjODChAdGLU+Jx5DNqZEuYXLVGu31mzRWDjNf2Eo4PjAcgiaej
         Yqg8yexGpxrKuib9DeBeDx41s7qHLHUQVonDWWtBVOG8HpGJStLox2YEBjBU50y8F/jm
         ijVI1mb/UoYNmUDinp26vQ50dtUznLAAL8AhmdJ6owMNETwPEGF1wGsUzxrAqNFWFkn1
         /5+9pALaVKNSqTF6mo2lQEQ4am9P57wWoMk1FvhbEDWUqhW+5ZgujTZ1e2Qj0p4JCFaV
         ZQpA==
X-Gm-Message-State: AJIora/quL+2vJCSpfUvhw70jVIeh1hz3wfbrEPcK+8ysDzi8dG4shoL
        CCMKmnB/0ZO7o982J+WW66JoUoNvpySvWb8ElSfuU+9q2Ls=
X-Google-Smtp-Source: AGRyM1vBHdLCnhaNWq0HuuIE7YCt3LPsNRwJNG31/7DbQcPUKGPTpoP0Izd3uAQBHIk9teMUQ7eUriiQ4S/AQJXREb8=
X-Received: by 2002:a05:6512:1584:b0:481:31e4:1489 with SMTP id
 bp4-20020a056512158400b0048131e41489mr5001425lfb.509.1659337809812; Mon, 01
 Aug 2022 00:10:09 -0700 (PDT)
MIME-Version: 1.0
References: <ca9560eb-af9c-3cfa-c35e-388e7e71aab7@gmail.com>
 <CAFBinCCMinq1U2Pqn2LPjC9c+HqfHjvW81b1ENMxdoGmB6byEw@mail.gmail.com> <88d6ef05-f77a-57a2-f34a-e3998a8d70d4@gmail.com>
In-Reply-To: <88d6ef05-f77a-57a2-f34a-e3998a8d70d4@gmail.com>
From:   Da Xue <da@lessconfused.com>
Date:   Mon, 1 Aug 2022 03:09:56 -0400
Message-ID: <CACdvmAgSvsYj6zorYDrBaEUvZzPi_c0XpVzx3fz8nHp8+TXMuQ@mail.gmail.com>
Subject: Re: Meson GXL and Rockchip PHY based on same IP?
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 30, 2022 at 3:31 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 30.07.2022 19:06, Martin Blumenstingl wrote:
> > Hi Heiner,
> >
> > On Sat, Jul 30, 2022 at 5:59 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>
> >> Meson GXL and Rockchip ethernet PHY drivers have quite something in common.
> >> They share a number of non-standard registers, using the same bits
> >> and same bank handling. This makes me think they they may be using
> >> the same IP. However they have different quirk handling. But this
> >> doesn't rule out that actually they would need the same quirk handling.
> > You made me curious and I found the following public Microchip
> > LAN83C185 datasheet: [0]
> > Page 27 has a "SMI REGISTER MAPPING" which matches the definitions in
> > meson-gxl.c.
> > Also on page 33 the interrupt source bits are a 100% match with the
> > INTSRC_* marcos in meson-gxl.c
> >
> Great, thanks for investigating!
>
> > Whether this means that:
> > - Amlogic SoCs embed a LAN83C185
> > - LAN83C185 is based on the same IP core (possibly not even designed
> > by Amlogic or SMSC)
> > - the SMI interface design is something that one hardware engineer
> > brought from one company to another
> > - ...something else
> > is something I can't tell

Per Jerome, both are OmniPHY IP.


> >
> >
> > Best regards,
> > Martin
> >
> >
> > [0] https://ww1.microchip.com/downloads/en/DeviceDoc/LAN83C185-Data-Sheet-DS00002808A.pdf
>
>
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip
