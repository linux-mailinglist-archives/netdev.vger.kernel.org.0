Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363D74AFB7F
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 19:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240686AbiBISr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 13:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240825AbiBISpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 13:45:54 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B368C03F938;
        Wed,  9 Feb 2022 10:43:27 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id i21so4332857pfd.13;
        Wed, 09 Feb 2022 10:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=++8mApk7RkWt9IYMQQmWE9VHiPI6DBwLCpnWFPssygI=;
        b=qGy++wR4TC8B3MD+skcOoU0Rz0NlIDn//t1PfiTRzziEWiC1QzxRUkyF3jiknY45eG
         MVQ1DwUkKDi3GRrni4fQawxf3YkxOlRs64seslgvIUD3L0SeJOyAGvrCse0s5u6wfwL6
         oG5fIm+bBQ4JYQC80X97WqYBXewbVESuOD3ySzW1MD9KHJQ71miaauYI01NuBqL8sX0w
         AOM9pD6xeYX5HlmeErEWysd++M+ebcvTQJnfVFrBc13ZBRbCGljmQth2gKDJaW9rOyLd
         jN8qOtjLjM/3TQ2yST8qk0H34cgEevysDmnCEi2YjnKnvn9lQWK/Uq/Zd9lConzXy+oo
         /cSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=++8mApk7RkWt9IYMQQmWE9VHiPI6DBwLCpnWFPssygI=;
        b=NahHbVmPIsJL4R7rcRWaf2Mce3piCOgOs/P6uNW088XRkYc4uvhccdQXpSsNajrtRy
         5ROjxyfuQcx8Ww7iHOWFEtvyfeTbLtdt10bTG9SW7ErwDSOSTkvameW7V9UtzWyOth4x
         FXcy29OI2naOiSCmxmouh4XuOgQoaHH7M8GywnPBO+pRYUI5Q0wbSV37wDECEYd/sPc4
         xh3BBqhcX3e8CdmOZPmAfHTe1hnPzI5nAstXmUoUjyTUglF4XEFAVqYeILFjsULe9QE/
         zoqAYjUrtsU34KaY7etvj7A2oFi/Q7kEj25ADxbz8Ex7G5/lKToJC4TgCKk/4I0Y/OJl
         cv6w==
X-Gm-Message-State: AOAM533nkqijhXfn4m3cKwN5GDOOfGrYZDqnyRSIfJKUckaVU2Gl8boO
        99PrysjkJxpVeFpB8liA4VicweWJV5gWMC4IGZ0nJ2r0K7GgOR4s
X-Google-Smtp-Source: ABdhPJzoiadJc5PSqYDMUBE96R7/2wNLf+6aj2O+i3AwgRvSjPRvqapEiu8YingYuFXFOgzq0w+N7jlBAFrrthRVY2A=
X-Received: by 2002:a63:6c01:: with SMTP id h1mr2996139pgc.118.1644432206694;
 Wed, 09 Feb 2022 10:43:26 -0800 (PST)
MIME-Version: 1.0
References: <20211228072645.32341-1-luizluca@gmail.com> <Ydx4+o5TsWZkZd45@robh.at.kernel.org>
 <CAJq09z4G40ttsTHXtOywjyusNLSjt_BQ9D78PhwSodJr=4p6OA@mail.gmail.com>
 <CAL_JsqJ4SsEzZz=JfFMDDUMXEDfybMZw4BVDcj1MoapM+8jQwg@mail.gmail.com>
 <87zgn0gf3k.fsf@bang-olufsen.dk> <YgP7jgswRQ+GR4P2@lunn.ch>
In-Reply-To: <YgP7jgswRQ+GR4P2@lunn.ch>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Wed, 9 Feb 2022 15:43:15 -0300
Message-ID: <CAJq09z49EEMxtBTs9q0sg3nn0VrSi0M=DkQTJ_n=QmgTr1aonw@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: dsa: realtek-smi: convert to YAML schema
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Rob Herring <robh@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > However, the linux driver today does not care about any of these
> > interruptions but INT_TYPE_LINK_STATUS. So it simply multiplex only
> > this the interruption to each port, in a n-cell map (n being number of
> > ports).
> > I don't know what to describe here as device-tree should be something
> > independent of a particular OS or driver.
>
> You shouldn't need to know what Linux does to figure this out.

The Linux driver is masquerading all those interruptions into a single
"link status changed". If interrupts property is about what the HW
sends to us, it is a single pin.

  interrupt-controller:
   type: object
   description: |
     This defines an interrupt controller with an IRQ line (typically
     a GPIO) that will demultiplex and handle the interrupt from the single
     interrupt line coming out of one of the Realtek switch chips. It most
     importantly provides link up/down interrupts to the PHY blocks inside
     the ASIC.

   properties:

     interrupt-controller: true

     interrupts:
       maxItems: 1
       description:
         A single IRQ line from the switch, either active LOW or HIGH

     '#address-cells':
       const: 0

     '#interrupt-cells':
       const: 1

   required:
     - interrupt-controller
     - '#address-cells'
     - '#interrupt-cells'

Now as it is also an interrupt-controller, shouldn't I document what it emits?
I've just sent the new version and we can discuss it there.

> >  - one interrupt for the switch
> >  - the switch is an interrupt-controller
> >  - ... and is the interrupt-parent for the phy nodes.
>
> This pattern is pretty common for DSA switches, which have internal
> PHYs. You can see this in the mv88e6xxx binding for example.

The issue is that those similar devices are still not in yaml format.

>       Andrew
