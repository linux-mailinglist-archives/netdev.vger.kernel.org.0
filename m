Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF81D660244
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbjAFOdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235292AbjAFOcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:32:46 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717698110B;
        Fri,  6 Jan 2023 06:32:37 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id y5so1178241pfe.2;
        Fri, 06 Jan 2023 06:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=st9MR927WV2EbzuKefqey2/C+I5iBh6i8vt5jvXyVCs=;
        b=a6L2tgg3QGCq+XMQ7WcOUm/d6W6nF11Eh/w4QbvVjauxnQByRat6CDtIsj5gU6GZCp
         NLQ4uTzcEbN5aApCBAT9ti6ZYUoy49weQ6OhA840cxPWM9NbzHwD56XDkwAQzrY2H1Be
         UjHvk8s1w+gVFmhEv23sk5OYDUhkqYz8mD29yBh5voOKUtrf+GbeFPg2QT++SqfCHqdJ
         E6Kc830M+PBQGA8ZcSq1JImL5bmseOm3HREDyAvtK4VDelSyGu+rOadzkgkg7Zd6zhz1
         BZfI7cC/ygum12ltjVdiu0393WnQujPa3GEA1gMUqova9ET+brOG8bHh6RrA7dX0vlzA
         5Abg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=st9MR927WV2EbzuKefqey2/C+I5iBh6i8vt5jvXyVCs=;
        b=xxeeeYpeozxvE6/gF4nCF3Z7/VD+OjFYQa6Y7UwVibtjSLa6kQfw6n5SDBtXsX+0yj
         6YbC7ISecQ9BSW7yn2BV768wrXnbqy6PzE0TpzWR4NXs3WC1V/06Bdc+8+JOg8JzZWdB
         J43jKpkozlI5M3r3i2MUXYRHOdt3f8nxMLqIeXguClGdg9leIVbOz6s8vFpkhuqJec0k
         woDq9E3otM3Y3e2P15LseFcnYt9ju242qBr97nmupAKaBIF2g9TwFAeGdn3uWf97voLY
         oYJuqUNfXONXAVPmVduKnrmhKVgeiGJe3+aCkvIJCgshbz4YzHU9JU3jDiVktc+draxW
         mMmQ==
X-Gm-Message-State: AFqh2kp7LPPfJVaqOAdcKRGSZ0QN9txdmhnueqNoZsFOuTAh5y3dQkw1
        ibymE+uMG6u6eu62axwT16XwnIVNaDwsYJVBujE=
X-Google-Smtp-Source: AMrXdXuan1xOPXQg5PyrO4df+rhGuUN5GxD7tqhAlzUQzezXNbYz0PWxCa1jDnm4LAxO7m9X1+c6Y0tBrqGXxSjwZaE=
X-Received: by 2002:a65:674e:0:b0:48d:a8d8:6f73 with SMTP id
 c14-20020a65674e000000b0048da8d86f73mr2518561pgu.396.1673015556953; Fri, 06
 Jan 2023 06:32:36 -0800 (PST)
MIME-Version: 1.0
References: <20230104141245.8407-1-aford173@gmail.com> <20230104141245.8407-2-aford173@gmail.com>
 <CAMuHMdXQfAJUVsYeN37T_KvXUoEaSqYJ+UWtUehLv-9R9goVzA@mail.gmail.com>
In-Reply-To: <CAMuHMdXQfAJUVsYeN37T_KvXUoEaSqYJ+UWtUehLv-9R9goVzA@mail.gmail.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Fri, 6 Jan 2023 08:32:25 -0600
Message-ID: <CAHCN7xJQZgLgDH_beWZfvzksEgm87rotfq7T2SMhgzjojJesKg@mail.gmail.com>
Subject: Re: [PATCH 2/4] Revert "arm64: dts: renesas: Add compatible
 properties to AR8031 Ethernet PHYs"
To:     Geert Uytterhoeven <geert@linux-m68k.org>
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
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 6, 2023 at 8:28 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Adam,
>
> CC Ethernet phy
>
> On Wed, Jan 4, 2023 at 3:12 PM Adam Ford <aford173@gmail.com> wrote:
> > This reverts commit 18a2427146bf8a3da8fc7825051d6aadb9c2d8fb.
> >
> > Due to the part shortage, the AR8031 PHY was replaced with a
> > Micrel KSZ9131.  Hard-coding the ID of the PHY makes this new
> > PHY non-operational.  Since previous hardware had shipped,
> > it's not as simple as just replacing the ID number as it would
> > break the older hardware.  Since the generic mode can correctly
> > identify both versions of hardware, it seems safer to revert
> > this patch.
> >
> > Signed-off-by: Adam Ford <aford173@gmail.com>
>
> Thanks for your patch!
>
> > --- a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
> > +++ b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
> > @@ -59,8 +59,6 @@ &avb {
> >         status = "okay";
> >
> >         phy0: ethernet-phy@0 {
> > -               compatible = "ethernet-phy-id004d.d074",
> > -                            "ethernet-phy-ieee802.3-c22";
> >                 reg = <0>;
> >                 interrupt-parent = <&gpio2>;
> >                 interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
>
> The next line:
>
>                 reset-gpios = <&gpio2 10 GPIO_ACTIVE_LOW>;
>
> Unfortunately, removing the compatible value will cause regressions
> for kexec/kdump and for Ethernet driver unbind, as the PHY reset will
> be asserted before starting the new kernel, or on driver unbind.
> Due to a deficiency in the Ethernet PHY subsystem, the PHY will be
> probed while the reset is still asserted, and thus fail probing[1].

FWIW, the bootloader brings the device out of reset.  Would it be
sufficient to keep  "ethernet-phy-ieee802.3-c22" and drop the
hard-coded ID?

thanks,

adam
>
> Is there a (new) proper way to handle this?
> Perhaps the issue has been fixed in the PHY subsystem meanwhile?
>
> Thanks!
>
> [1] https://lore.kernel.org/all/cover.1631174218.git.geert+renesas@glider.be
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
