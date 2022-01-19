Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A7F493D32
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 16:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355780AbiASPbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 10:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355739AbiASPan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 10:30:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A274AC06173F;
        Wed, 19 Jan 2022 07:30:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F5CF61506;
        Wed, 19 Jan 2022 15:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79287C340F7;
        Wed, 19 Jan 2022 15:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642606242;
        bh=OLrV/mw6WcIgeLQa2HMwTaMX8b3pt7TE+xb2FHEMCV8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JgmcjLsM6Gk2PSKImbxj26Qhy6USBLcVwdWBb5lOL2BuvJdLqnvmI1mrDBR7Gc2NG
         SHk21GkjadAmjjhdYDG9vq63f5F11r0UkffNBWH8VoykqWLLEjr2u9nIQIsh0B+87Z
         +dFhkgSjWASpFTmd+Bxx3VSjYyK4GcFfXns351+7xLiXyCQ81CCdJPRTcYtfSHVV5t
         BvjboJtxG3wo3Q6d0qQkQ9F4KukrC27L+PNjZoQsFMyOoQT8BcyXt7AWoLxyJwy00f
         xHP+xMIPOKl12FHwyQgV/AUp95wjom6igJ9X2h/kuGjjnouVqGUM36B7grcBtYDGgB
         qW94ZftrDj4ZQ==
Received: by mail-ed1-f50.google.com with SMTP id c24so11415648edy.4;
        Wed, 19 Jan 2022 07:30:42 -0800 (PST)
X-Gm-Message-State: AOAM5334vNiSZr9UpUfha0QWXYSyKaQ1Ibx5q3CRwIBk2jRZB2FfT5F5
        4J/w/F+7PEoeJk0RBYKuw9qWCTDngk4h7GUFvQ==
X-Google-Smtp-Source: ABdhPJyPYQrXxNSnCkTl5v8yMxjogVTk6EpzYA73WuLgFBNs1oJt1pAj6k4kUcCi7ejRXOlSTI1mdHZMJ5Kr9aWFF9o=
X-Received: by 2002:aa7:c587:: with SMTP id g7mr27455803edq.109.1642606240687;
 Wed, 19 Jan 2022 07:30:40 -0800 (PST)
MIME-Version: 1.0
References: <20220119015038.2433585-1-robh@kernel.org> <de35edd9-b85d-0ed7-98b6-7a41134c3ece@foss.st.com>
In-Reply-To: <de35edd9-b85d-0ed7-98b6-7a41134c3ece@foss.st.com>
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 19 Jan 2022 09:30:28 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLzuYxpsNDNPXF1C=kG6HJea650iRzg1YxvNPDToeBC-A@mail.gmail.com>
Message-ID: <CAL_JsqLzuYxpsNDNPXF1C=kG6HJea650iRzg1YxvNPDToeBC-A@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: Improve phandle-array schemas
To:     Arnaud POULIQUEN <arnaud.pouliquen@foss.st.com>
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
        Vladimir Oltean <olteanv@gmail.com>,
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
        linux-riscv <linux-riscv@lists.infradead.org>,
        "open list:REMOTE PROCESSOR (REMOTEPROC) SUBSYSTEM" 
        <linux-remoteproc@vger.kernel.org>,
        Linux-ALSA <alsa-devel@alsa-project.org>,
        Linux USB List <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 19, 2022 at 9:22 AM Arnaud POULIQUEN
<arnaud.pouliquen@foss.st.com> wrote:
>
> Hello Rob,
>
> On 1/19/22 2:50 AM, Rob Herring wrote:
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
> >
> > Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Chun-Kuang Hu <chunkuang.hu@kernel.org>
> > Cc: Philipp Zabel <p.zabel@pengutronix.de>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > Cc: Vinod Koul <vkoul@kernel.org>
> > Cc: Georgi Djakov <djakov@kernel.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Lee Jones <lee.jones@linaro.org>
> > Cc: Daniel Thompson <daniel.thompson@linaro.org>
> > Cc: Jingoo Han <jingoohan1@gmail.com>
> > Cc: Pavel Machek <pavel@ucw.cz>
> > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Wolfgang Grandegger <wg@grandegger.com>
> > Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Vivien Didelot <vivien.didelot@gmail.com>
> > Cc: Florian Fainelli <f.fainelli@gmail.com>
> > Cc: Vladimir Oltean <olteanv@gmail.com>
> > Cc: Kalle Valo <kvalo@kernel.org>
> > Cc: Viresh Kumar <vireshk@kernel.org>
> > Cc: Stephen Boyd <sboyd@kernel.org>
> > Cc: Kishon Vijay Abraham I <kishon@ti.com>
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > Cc: Kevin Hilman <khilman@kernel.org>
> > Cc: Ulf Hansson <ulf.hansson@linaro.org>
> > Cc: Sebastian Reichel <sre@kernel.org>
> > Cc: Mark Brown <broonie@kernel.org>
> > Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
> > Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> > Cc: Zhang Rui <rui.zhang@intel.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Thierry Reding <thierry.reding@gmail.com>
> > Cc: Jonathan Hunter <jonathanh@nvidia.com>
> > Cc: Sudeep Holla <sudeep.holla@arm.com>
> > Cc: Geert Uytterhoeven <geert+renesas@glider.be>
> > Cc: linux-ide@vger.kernel.org
> > Cc: linux-crypto@vger.kernel.org
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: dmaengine@vger.kernel.org
> > Cc: linux-pm@vger.kernel.org
> > Cc: iommu@lists.linux-foundation.org
> > Cc: linux-leds@vger.kernel.org
> > Cc: linux-media@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Cc: linux-can@vger.kernel.org
> > Cc: linux-wireless@vger.kernel.org
> > Cc: linux-phy@lists.infradead.org
> > Cc: linux-gpio@vger.kernel.org
> > Cc: linux-riscv@lists.infradead.org
> > Cc: linux-remoteproc@vger.kernel.org
> > Cc: alsa-devel@alsa-project.org
> > Cc: linux-usb@vger.kernel.org
> > Signed-off-by: Rob Herring <robh@kernel.org>
> > ---
>
> [...]
>
> >  .../bindings/remoteproc/st,stm32-rproc.yaml   | 33 ++++++--
>
> [...]
>
> > diff --git a/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml b/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
> > index b587c97c282b..be3d9b0e876b 100644
> > --- a/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
> > +++ b/Documentation/devicetree/bindings/remoteproc/st,stm32-rproc.yaml
> > @@ -29,17 +29,22 @@ properties:
> >
> >    st,syscfg-holdboot:
> >      description: remote processor reset hold boot
> > -      - Phandle of syscon block.
> > -      - The offset of the hold boot setting register.
> > -      - The field mask of the hold boot.
> >      $ref: "/schemas/types.yaml#/definitions/phandle-array"
> > -    maxItems: 1
> > +    items:
> > +      - items:
> > +          - description: Phandle of syscon block
> > +          - description: The offset of the hold boot setting register
> > +          - description: The field mask of the hold boot
> >
> >    st,syscfg-tz:
> >      description:
> >        Reference to the system configuration which holds the RCC trust zone mode
> >      $ref: "/schemas/types.yaml#/definitions/phandle-array"
> > -    maxItems: 1
> > +    items:
> > +      - items:
> > +          - description: Phandle of syscon block
> > +          - description: FIXME
> > +          - description: FIXME
>
>          - description: The offset of the trust zone setting register
>          - description: The field mask of the trust zone state
>
> >
> >    interrupts:
> >      description: Should contain the WWDG1 watchdog reset interrupt
> > @@ -93,20 +98,32 @@ properties:
> >      $ref: "/schemas/types.yaml#/definitions/phandle-array"
> >      description: |
> >        Reference to the system configuration which holds the remote
> > -    maxItems: 1
> > +    items:
> > +      - items:
> > +          - description: Phandle of syscon block
> > +          - description: FIXME
> > +          - description: FIXME
>
>          - description: The offset of the power setting register
>          - description: The field mask of the PDDS selection
>
> >
> >    st,syscfg-m4-state:
> >      $ref: "/schemas/types.yaml#/definitions/phandle-array"
> >      description: |
> >        Reference to the tamp register which exposes the Cortex-M4 state.
> > -    maxItems: 1
> > +    items:
> > +      - items:
> > +          - description: Phandle of syscon block with the tamp register
> > +          - description: FIXME
> > +          - description: FIXME
>
>          - description: The offset of the tamp register
>          - description: The field mask of the Cortex-M4 state
>
> >
> >    st,syscfg-rsc-tbl:
> >      $ref: "/schemas/types.yaml#/definitions/phandle-array"
> >      description: |
> >        Reference to the tamp register which references the Cortex-M4
> >        resource table address.
> > -    maxItems: 1
> > +    items:
> > +      - items:
> > +          - description: Phandle of syscon block with the tamp register
> > +          - description: FIXME
> > +          - description: FIXME
>
>          - description: The offset of the tamp register
>          - description: The field mask of the Cortex-M4 resource table address
>
> Please tell me if you prefer that I fix this in a dedicated patch.

Thanks! I'll fold this into this patch.

Rob
