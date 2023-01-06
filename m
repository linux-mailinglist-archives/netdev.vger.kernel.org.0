Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D94660274
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbjAFOpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjAFOpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:45:25 -0500
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5227A80AC2;
        Fri,  6 Jan 2023 06:45:19 -0800 (PST)
Received: by mail-qt1-f177.google.com with SMTP id z12so2183332qtv.5;
        Fri, 06 Jan 2023 06:45:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FM9o+4dBL2fAHSxoEYfs9H0/tqusxwimKiOWUqvowRM=;
        b=sUANAIOEggvrPP3idAY2qnU1CYWizLryVdqDcuRxgeuBzOiNGKwP8D1QUfwzlt2jx6
         ncTfBRlwVXl4Vpc/qd/cqXLOTXOkAicpePBljjdNc83YNnCsnRtsoa9+13gqAmCoFYWQ
         odqG6hCJaOE5Kc+Zhf4B6s/BTcyQYvPHsdOyeZQB4qJDmhakBYNdSaZScnBOEirFxwPx
         OSEumA/EUzhaqIUbhrtW2Yl0moW0uYkJM45Rh+UvkMU5gSVLXNzbHMFpnZG8r8HCNdmS
         GH2MJsGBPj6Wx9lwFfYL45O8wIJ9YjomPZ59wnDfIX5ou7CIuBJBp4jWwHrHxRlZMSL/
         /56g==
X-Gm-Message-State: AFqh2krmAe0hz7AmfFTnBKDUU2+2Me6XiV5YuPShNqn52j1lcnjDEVpY
        akmiJamlRWZbO75e4XFpVeOWcl/LqI5e6Q==
X-Google-Smtp-Source: AMrXdXtR2r3PL1hevSe3bd8jhpjyYckyz55bSywWtd8PaQbG5CYgwKaaQH0w5Aa3OxjYNsCDPSJqzg==
X-Received: by 2002:ac8:7490:0:b0:3ab:65aa:a873 with SMTP id v16-20020ac87490000000b003ab65aaa873mr78073685qtq.24.1673016318288;
        Fri, 06 Jan 2023 06:45:18 -0800 (PST)
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com. [209.85.128.172])
        by smtp.gmail.com with ESMTPSA id w28-20020a05622a191c00b0039cc64bcb53sm581441qtc.27.2023.01.06.06.45.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 06:45:17 -0800 (PST)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-4a263c4ddbaso25756767b3.0;
        Fri, 06 Jan 2023 06:45:17 -0800 (PST)
X-Received: by 2002:a81:7309:0:b0:475:f3f5:c6c with SMTP id
 o9-20020a817309000000b00475f3f50c6cmr6339099ywc.358.1673016317354; Fri, 06
 Jan 2023 06:45:17 -0800 (PST)
MIME-Version: 1.0
References: <20230104141245.8407-1-aford173@gmail.com> <20230104141245.8407-2-aford173@gmail.com>
 <CAMuHMdXQfAJUVsYeN37T_KvXUoEaSqYJ+UWtUehLv-9R9goVzA@mail.gmail.com> <CAHCN7xJQZgLgDH_beWZfvzksEgm87rotfq7T2SMhgzjojJesKg@mail.gmail.com>
In-Reply-To: <CAHCN7xJQZgLgDH_beWZfvzksEgm87rotfq7T2SMhgzjojJesKg@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 6 Jan 2023 15:45:05 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXD_hq8xtrxxCZ_dToJwCKp3CfAiJh-jg5SqeM8qKgyyQ@mail.gmail.com>
Message-ID: <CAMuHMdXD_hq8xtrxxCZ_dToJwCKp3CfAiJh-jg5SqeM8qKgyyQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] Revert "arm64: dts: renesas: Add compatible
 properties to AR8031 Ethernet PHYs"
To:     Adam Ford <aford173@gmail.com>
Cc:     linux-renesas-soc@vger.kernel.org, aford@beaconembedded.com,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adam,

On Fri, Jan 6, 2023 at 3:35 PM Adam Ford <aford173@gmail.com> wrote:
> On Fri, Jan 6, 2023 at 8:28 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Wed, Jan 4, 2023 at 3:12 PM Adam Ford <aford173@gmail.com> wrote:
> > > This reverts commit 18a2427146bf8a3da8fc7825051d6aadb9c2d8fb.
> > >
> > > Due to the part shortage, the AR8031 PHY was replaced with a
> > > Micrel KSZ9131.  Hard-coding the ID of the PHY makes this new
> > > PHY non-operational.  Since previous hardware had shipped,
> > > it's not as simple as just replacing the ID number as it would
> > > break the older hardware.  Since the generic mode can correctly
> > > identify both versions of hardware, it seems safer to revert
> > > this patch.
> > >
> > > Signed-off-by: Adam Ford <aford173@gmail.com>
> >
> > Thanks for your patch!
> >
> > > --- a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
> > > +++ b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
> > > @@ -59,8 +59,6 @@ &avb {
> > >         status = "okay";
> > >
> > >         phy0: ethernet-phy@0 {
> > > -               compatible = "ethernet-phy-id004d.d074",
> > > -                            "ethernet-phy-ieee802.3-c22";
> > >                 reg = <0>;
> > >                 interrupt-parent = <&gpio2>;
> > >                 interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
> >
> > The next line:
> >
> >                 reset-gpios = <&gpio2 10 GPIO_ACTIVE_LOW>;
> >
> > Unfortunately, removing the compatible value will cause regressions
> > for kexec/kdump and for Ethernet driver unbind, as the PHY reset will
> > be asserted before starting the new kernel, or on driver unbind.
> > Due to a deficiency in the Ethernet PHY subsystem, the PHY will be
> > probed while the reset is still asserted, and thus fail probing[1].
>
> FWIW, the bootloader brings the device out of reset.  Would it be

The bootloader is not involved when using kexec/kdump, or when
unbinding the Ethernet driver.

> sufficient to keep  "ethernet-phy-ieee802.3-c22" and drop the
> hard-coded ID?

I am afraid not, as that still requires actual probing to determine
the PHY ID.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
