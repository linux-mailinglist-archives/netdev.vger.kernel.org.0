Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCEB493D1A
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 16:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355603AbiASP3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 10:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239385AbiASP3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 10:29:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1756EC061574;
        Wed, 19 Jan 2022 07:29:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9019B819A8;
        Wed, 19 Jan 2022 15:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4752AC340E1;
        Wed, 19 Jan 2022 15:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642606153;
        bh=eiP3xCZsCy88f8i33Qm5tHFJtlYCUAmvYn1cMS/h6LE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=a1WhpjxBW76ppWC5NPQu3gcXaPudaJQcMYu2CBoHZ0XQiZo/7ksRdpxkZb91tdu/w
         +nmtdV0f3zs9tqwtd8c50aA64/Ghdigk7DPTH3eWsqjgkDk6YNoqW70R1VqwNPf77P
         BxrASO6fJWADBfklho94SpUV+Ns3dcYvuMvy4eCWVkknJIXIyILdgA1+l6bEOq5BPM
         sPDrnZ0J/9ZK8VnsQjMahl6rC5G+rAdOASApyChfeuiQW7s8gusxthFDqzqSeSvO82
         eulFdXsOtsCS+H6JFNGTDoU8tVkv5qEUuEiR6BZvxVRmZz+/nzsl3+8dBQulQ44ZKx
         2dUxK8S+SUplw==
Received: by mail-ed1-f42.google.com with SMTP id c24so11395914edy.4;
        Wed, 19 Jan 2022 07:29:13 -0800 (PST)
X-Gm-Message-State: AOAM531beTrn6sMtXhlbguo8Oy7wLeyu7aIrn3R0voTzTgA6NoyXcXks
        d/JEEUPpBqsok1jSBhZdsjj0EX0pdkTavG3QQw==
X-Google-Smtp-Source: ABdhPJyIYkyo1vqpmGZeQ86/fG6wkTZGxnD2kYhf8PsblQjCHqdJn557iPYrUwhbvXoPPN23Wd86PLfRtc/FtNJz2Yw=
X-Received: by 2002:a17:906:7801:: with SMTP id u1mr8098133ejm.82.1642606151522;
 Wed, 19 Jan 2022 07:29:11 -0800 (PST)
MIME-Version: 1.0
References: <20220119015038.2433585-1-robh@kernel.org> <20220119103542.el3yuqds6ihpkthn@skbuf>
In-Reply-To: <20220119103542.el3yuqds6ihpkthn@skbuf>
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 19 Jan 2022 09:28:59 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKeTmew8ZaNsXqVsXCrkW9zb1V2JcANRVPXyEHqZnVWzA@mail.gmail.com>
Message-ID: <CAL_JsqKeTmew8ZaNsXqVsXCrkW9zb1V2JcANRVPXyEHqZnVWzA@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: Improve phandle-array schemas
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Vinod Koul <vkoul@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Lee Jones <lee.jones@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Jingoo Han <jingoohan1@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Viresh Kumar <vireshk@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:DMA GENERIC OFFLOAD ENGINE SUBSYSTEM" 
        <dmaengine@vger.kernel.org>,
        "open list:THERMAL" <linux-pm@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-can@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "open list:GENERIC PHY FRAMEWORK" <linux-phy@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-riscv@lists.infradead.org, linux-remoteproc@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 19, 2022 at 4:35 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Tue, Jan 18, 2022 at 07:50:38PM -0600, Rob Herring wrote:
> > The 'phandle-array' type is a bit ambiguous. It can be either just an
> > array of phandles or an array of phandles plus args. Many schemas for
> > phandle-array properties aren't clear in the schema which case applies
> > though the description usually describes it.
> >
> > The array of phandles case boils down to needing:
> >
> > items:
> >   maxItems: 1
> >
> > The phandle plus args cases should typically take this form:
> >
> > items:
> >   - items:
> >       - description: A phandle
> >       - description: 1st arg cell
> >       - description: 2nd arg cell
> >
> > With this change, some examples need updating so that the bracketing of
> > property values matches the schema.
> > ---
> (...)
> > diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> > index 702df848a71d..c504feeec6db 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> > @@ -34,6 +34,8 @@ properties:
> >        full routing information must be given, not just the one hop
> >        routes to neighbouring switches
> >      $ref: /schemas/types.yaml#/definitions/phandle-array
> > +    items:
> > +      maxItems: 1
> >
> >    ethernet:
> >      description:
>
> For better or worse, the mainline cases of this property all take the
> form of:
>
> arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
>                                 link = <&switch1port9 &switch2port9>;
>                                 link = <&switch1port10 &switch0port10>;
> arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
>                                                 link = <&switch1port6
>                                                         &switch2port9>;
>                                                 link = <&switch1port5
>                                                         &switch0port5>;
> arch/arm/boot/dts/vf610-zii-scu4-aib.dts
>                                                 link = <&switch1port10
>                                                         &switch3port10
>                                                         &switch2port10>;
>                                                 link = <&switch3port10
>                                                         &switch2port10>;
>                                                 link = <&switch1port9
>                                                         &switch0port10>;
>
> So not really an array of phandles.

Either form is an array. The DT yaml encoding maintains the
bracketing, so how the schema is defined matters. To some extent the
tools will process the schema to support both forms of bracketing, but
this has turned out to be fragile and just doesn't work for phandle
arrays. I'm working on further changes that will get rid of the yaml
encoded DT format and validate DTB files directly. These obviously
have no bracketing and needing the DTS source files to change goes
away. However, to be able to construct the internal format for
validation, I do need the schemas to have more information on what
exactly the phandle-array contains.

Rob
