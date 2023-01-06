Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31656660219
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbjAFO2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234409AbjAFO2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:28:11 -0500
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6D07BDFA;
        Fri,  6 Jan 2023 06:28:10 -0800 (PST)
Received: by mail-qt1-f182.google.com with SMTP id c7so2105415qtw.8;
        Fri, 06 Jan 2023 06:28:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sTTGdSaTAYfgyHoEh6QlDUjZgdx3Q8oPnHfz8VzgQOg=;
        b=Q6CmC3NSakWvriapeKHNhR0OIaHEZCG0AJi6GytUNWSynftDKGy88mKe/CgoZzUhcH
         UKqbRLh6aMUnhsfJR57mUHt6eH5n54xDqvbsP77ff7AsQ9j3xL8v60duoEmOzhsDdQ9J
         KCpCQ0X5199tKnUMsjKvVAvAXcnedSk/3bSFevwAb8xNAwslcoUkK5BoxYQrjzDTLCDU
         YDsQQg4N4bgyNIbapGE9ntR0Nj3SkNYNRor58gWkgAKS/wuEJDCpPXWU8kUSN22WIHzG
         sc5b1WiXbT3uLT3VcnRDMU0i+lJezTqfPeDCeJiWhwERCNtfeneGnGTqaKJkDuqBS0Si
         XGQQ==
X-Gm-Message-State: AFqh2koNmMqSeVrZ8VVt3if8eUCJxfjqZOc2wMOO4A84AKLoRhg4mR1Q
        xpiZLB0jHUUfGR45ZfVPx5kQPfsNZ6DEhQ==
X-Google-Smtp-Source: AMrXdXvqrl1jwQBvcq1sKQK95248AgIOxEt9qyToLcHNUhEjpUkj+LCGd4pcfPPT7STTMxoNXQHODQ==
X-Received: by 2002:ac8:6049:0:b0:3a6:8b77:7eef with SMTP id k9-20020ac86049000000b003a68b777eefmr72958306qtm.38.1673015288853;
        Fri, 06 Jan 2023 06:28:08 -0800 (PST)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id ge9-20020a05622a5c8900b003a7e38055c9sm553291qtb.63.2023.01.06.06.28.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 06:28:08 -0800 (PST)
Received: by mail-yb1-f176.google.com with SMTP id 203so1984437yby.10;
        Fri, 06 Jan 2023 06:28:08 -0800 (PST)
X-Received: by 2002:a25:b944:0:b0:7b2:4421:82be with SMTP id
 s4-20020a25b944000000b007b2442182bemr806049ybm.380.1673015287896; Fri, 06 Jan
 2023 06:28:07 -0800 (PST)
MIME-Version: 1.0
References: <20230104141245.8407-1-aford173@gmail.com> <20230104141245.8407-2-aford173@gmail.com>
In-Reply-To: <20230104141245.8407-2-aford173@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 6 Jan 2023 15:27:56 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXQfAJUVsYeN37T_KvXUoEaSqYJ+UWtUehLv-9R9goVzA@mail.gmail.com>
Message-ID: <CAMuHMdXQfAJUVsYeN37T_KvXUoEaSqYJ+UWtUehLv-9R9goVzA@mail.gmail.com>
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

CC Ethernet phy

On Wed, Jan 4, 2023 at 3:12 PM Adam Ford <aford173@gmail.com> wrote:
> This reverts commit 18a2427146bf8a3da8fc7825051d6aadb9c2d8fb.
>
> Due to the part shortage, the AR8031 PHY was replaced with a
> Micrel KSZ9131.  Hard-coding the ID of the PHY makes this new
> PHY non-operational.  Since previous hardware had shipped,
> it's not as simple as just replacing the ID number as it would
> break the older hardware.  Since the generic mode can correctly
> identify both versions of hardware, it seems safer to revert
> this patch.
>
> Signed-off-by: Adam Ford <aford173@gmail.com>

Thanks for your patch!

> --- a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
> +++ b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
> @@ -59,8 +59,6 @@ &avb {
>         status = "okay";
>
>         phy0: ethernet-phy@0 {
> -               compatible = "ethernet-phy-id004d.d074",
> -                            "ethernet-phy-ieee802.3-c22";
>                 reg = <0>;
>                 interrupt-parent = <&gpio2>;
>                 interrupts = <11 IRQ_TYPE_LEVEL_LOW>;

The next line:

                reset-gpios = <&gpio2 10 GPIO_ACTIVE_LOW>;

Unfortunately, removing the compatible value will cause regressions
for kexec/kdump and for Ethernet driver unbind, as the PHY reset will
be asserted before starting the new kernel, or on driver unbind.
Due to a deficiency in the Ethernet PHY subsystem, the PHY will be
probed while the reset is still asserted, and thus fail probing[1].

Is there a (new) proper way to handle this?
Perhaps the issue has been fixed in the PHY subsystem meanwhile?

Thanks!

[1] https://lore.kernel.org/all/cover.1631174218.git.geert+renesas@glider.be

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
