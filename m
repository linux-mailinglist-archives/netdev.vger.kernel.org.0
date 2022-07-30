Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F8F585B5A
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 19:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235251AbiG3RGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 13:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbiG3RGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 13:06:24 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9655015A29
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 10:06:23 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 141so12695992ybn.4
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 10:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d9jZByFHQCyHogd7tOw0PgH6PJzZQDfjzIJ2GEdJkb0=;
        b=q2KYoe4LNMLDlobLn76ATzjWRjL5WqiMo5wnjXVVnr47rZ8bCp/pH56LiunZLGZV9j
         eUUIeZwnhSXNFlTf65cT6IvQEz44LpdLf1aj0XDQIkDK6LfiyKZr5HwFPuKG02FnkJq/
         jVoJ4USdc/SxsbHc2OfmRDDDfrEEfxqfqtmsalV3YE8nNwDsHi+NdkPovM19otjZp6Kc
         OYuTHc2GILanQ2APU3eJG1uUF/PGGipCz38j1Rp8QcwxeHnLaDPFmOx3yeS2aeyToqNv
         HBm1sInYDbtsnAfHonsXVPP0Gcmcs9Ger2sW1P5o5vf75twyynMWbRa7ArrO0YA/uHrk
         wHSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d9jZByFHQCyHogd7tOw0PgH6PJzZQDfjzIJ2GEdJkb0=;
        b=n9GY7dI8Z378I+RlGOMlWPVNAiYoJZSpyCM24x16QWrFcx44Fv48EbO0Gy3gFHgyOS
         YEhw8Psczer20K4EJyZEhaDtIjS+8ztIozYPYR0LfesRAY/I+UCAJRdR4B1asYQhIDDx
         Js41nGMmmq1A7wScV93SxVZcE7hihlWA/V4fSHL2LjI6ntwvBeYdAas0zJXpgs+w5vIM
         0N93Np2kG4MVJVXq4ky1b09KKBhque2JEKFEPP41v6sNOIcm39BKNgBkSDOJ7fjG1yX4
         i/ZzqlifK3rKlzZFCJac9zb4MFjA8bCfHE7Fa81MI9KqycQVozZe80hKRiro/+woWvD/
         644Q==
X-Gm-Message-State: ACgBeo1iaPCs1UbK6o4YzYOhiXAAROhru5zz1y+aWoDdFmSOQjgByUQz
        IH136uQWWFqlCzcnyI6dYymldy3oaNwf4VBbeROciG5rU5I=
X-Google-Smtp-Source: AA6agR5/t09I7F6CDAX+uVllvGeHwUJ4JzDvCBXaiLEPyPSzdqM/i6i4hRE5J8vI5lU7FJIuSb2GYaZo+AVGk1idM1Q=
X-Received: by 2002:a25:c401:0:b0:670:ee96:38de with SMTP id
 u1-20020a25c401000000b00670ee9638demr6085433ybf.339.1659200782656; Sat, 30
 Jul 2022 10:06:22 -0700 (PDT)
MIME-Version: 1.0
References: <ca9560eb-af9c-3cfa-c35e-388e7e71aab7@gmail.com>
In-Reply-To: <ca9560eb-af9c-3cfa-c35e-388e7e71aab7@gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 30 Jul 2022 19:06:11 +0200
Message-ID: <CAFBinCCMinq1U2Pqn2LPjC9c+HqfHjvW81b1ENMxdoGmB6byEw@mail.gmail.com>
Subject: Re: Meson GXL and Rockchip PHY based on same IP?
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

On Sat, Jul 30, 2022 at 5:59 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> Meson GXL and Rockchip ethernet PHY drivers have quite something in common.
> They share a number of non-standard registers, using the same bits
> and same bank handling. This makes me think they they may be using
> the same IP. However they have different quirk handling. But this
> doesn't rule out that actually they would need the same quirk handling.
You made me curious and I found the following public Microchip
LAN83C185 datasheet: [0]
Page 27 has a "SMI REGISTER MAPPING" which matches the definitions in
meson-gxl.c.
Also on page 33 the interrupt source bits are a 100% match with the
INTSRC_* marcos in meson-gxl.c

Whether this means that:
- Amlogic SoCs embed a LAN83C185
- LAN83C185 is based on the same IP core (possibly not even designed
by Amlogic or SMSC)
- the SMI interface design is something that one hardware engineer
brought from one company to another
- ...something else
is something I can't tell


Best regards,
Martin


[0] https://ww1.microchip.com/downloads/en/DeviceDoc/LAN83C185-Data-Sheet-DS00002808A.pdf
