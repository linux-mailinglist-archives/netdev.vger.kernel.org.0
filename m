Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6DE4AF53A
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 16:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbiBIP30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 10:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiBIP3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 10:29:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CA8C0613C9;
        Wed,  9 Feb 2022 07:29:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9DE0B8220B;
        Wed,  9 Feb 2022 15:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75677C340F3;
        Wed,  9 Feb 2022 15:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644420565;
        bh=QKbyaWB3S3fmmTgA9C2qMw6sAVk5oCS2HfXytBEO+XY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ukJE2TkoXsT/uqmJ0O6LJwl2PMoQvkVZbWaPzGS03qmkZoxX/qdsTBjbXKqXilt00
         oPYkx1G9dBxdvIdrGckFZyX7gKokyQtcPxFS3bil1fXKinqzLMyxh+azL8i10bQnN3
         Ox1qEI2xL/qEWIP98MEsxJnv0wOMPKYWpkaIJU1P5CcM82kJPeYvs7jU89m+NzcOFj
         DoPfCX+K38cr1fSdaJgDNLo5vUGfGsbQohauiAY8/FwRt+IFlEdp0TAQ1ASxw/gjfe
         trCfnU0TiYuMajx/sLvy+7Gyb5HcYTlPuiY/EzW+B0LqoHT+PeGU0aMF53qqYUOE6N
         jdCh3qkO1Rxtg==
Received: by mail-lj1-f173.google.com with SMTP id t14so3921123ljh.8;
        Wed, 09 Feb 2022 07:29:25 -0800 (PST)
X-Gm-Message-State: AOAM5323gRG7FY/v4+HQ5sMhAuR/Y5cMpqWMEN6v7R8zwgHID6azgOUw
        DaseVSpAJ9wjVZgbUDLztlBZs8wHtuQIFCMawQ==
X-Google-Smtp-Source: ABdhPJwwxaQps0NUGLhu/Gr6WrdxbjgZRuJ4qOOpjJzMqWWe1rlQob9iBwPKJirpJue2zFCjhtucaxxLr4aEziUXZe4=
X-Received: by 2002:a17:906:f0cb:: with SMTP id dk11mr2432228ejb.20.1644420551949;
 Wed, 09 Feb 2022 07:29:11 -0800 (PST)
MIME-Version: 1.0
References: <20211228072645.32341-1-luizluca@gmail.com> <Ydx4+o5TsWZkZd45@robh.at.kernel.org>
 <CAJq09z4G40ttsTHXtOywjyusNLSjt_BQ9D78PhwSodJr=4p6OA@mail.gmail.com>
In-Reply-To: <CAJq09z4G40ttsTHXtOywjyusNLSjt_BQ9D78PhwSodJr=4p6OA@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 9 Feb 2022 09:28:59 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJ4SsEzZz=JfFMDDUMXEDfybMZw4BVDcj1MoapM+8jQwg@mail.gmail.com>
Message-ID: <CAL_JsqJ4SsEzZz=JfFMDDUMXEDfybMZw4BVDcj1MoapM+8jQwg@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: dsa: realtek-smi: convert to YAML schema
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 29, 2022 at 10:02 AM Luiz Angelo Daros de Luca
<luizluca@gmail.com> wrote:
>
> Thanks Rob, now that the code side is merged, I'm back to docs.

Sigh, bindings are supposed to be accepted first...

>
>
> > > +      interrupt-controller:
> > > +        description: see interrupt-controller/interrupts.txt
> >
> > Don't need generic descriptions. Just 'true' here is fine.
>
> Do you really mean quoted true, like in "description: 'true' "?
> Without quotes it will fail

interrupt-controller: true

> >
> > > +
> > > +      interrupts:
> > > +        description: TODO
> >
> > You have to define how many interrupts and what they are.
>
> I didn't write the interruption code and Linus and Alvin might help here.
>
> The switch has a single interrupt pin that signals an interruption happened.

Then it's 1 interrupt?

> The code reads a register to multiplex to these interruptions:
>
> INT_TYPE_LINK_STATUS = 0,
> INT_TYPE_METER_EXCEED,
> INT_TYPE_LEARN_LIMIT,
> INT_TYPE_LINK_SPEED,
> INT_TYPE_CONGEST,
> INT_TYPE_GREEN_FEATURE,
> INT_TYPE_LOOP_DETECT,
> INT_TYPE_8051,
> INT_TYPE_CABLE_DIAG,
> INT_TYPE_ACL,
> INT_TYPE_RESERVED, /* Unused */
> INT_TYPE_SLIENT,

Unless the DT needs to route all these interrupts to multiple nodes,
then the switch needs to be an interrupt-controller.

>
> And most of them, but not all, multiplex again to each port.

Now I'm lost. So it's 1 per port, not 1 for the switch?

> However, the linux driver today does not care about any of these
> interruptions but INT_TYPE_LINK_STATUS. So it simply multiplex only
> this the interruption to each port, in a n-cell map (n being number of
> ports).
> I don't know what to describe here as device-tree should be something
> independent of a particular OS or driver.

You shouldn't need to know what Linux does to figure this out.

>
> Anyway, I doubt someone might want to plug one of these interruptions
> outside the switch driver. Could it be simple as this:
>
>       interrupts:
>        minItems: 3
>        maxItems: 10
>        description:
>          interrupt mapping one per switch port
>
> Once realtek-smi.yaml settles, I'll also send the realtek-mdio.yaml.
>
> Regards,
>
> Luiz
