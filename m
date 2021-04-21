Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8AB3674FC
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 00:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343534AbhDUWHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 18:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343546AbhDUWHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 18:07:43 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0E6C06138B;
        Wed, 21 Apr 2021 15:05:11 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id v13so20122366ilj.8;
        Wed, 21 Apr 2021 15:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rAa4AoVI0mgDiNi0ZbvS/C0L5MD8lJf8UDLKotBP8xg=;
        b=NgfkNeqlHpLkUliop4vSn2+q3bezFt4oUiYnYkVpX01B4brnA9l6x+juMYSzOtTB48
         BKseTAOyeV6JlEJoUJ28mLgIPB2Qo7n24pmw1/FEn+K5OSvM0CYu/pOsdArZgjitUR+I
         uqNePPO7zltP7rdrn0QB8a5KdE8xoyDTQAPOUmAMq0PZDq3trnFEJn8gcRXDxR0uDsLz
         Bxg0yyma+8GHPbMabPll4tYUQfkwnjxY4be5vAKuQfqTyjDqFroVyiNPWrcwY2nEvmtL
         Rb/6fV2HOo3x1vEp8skjD+hCwsE+jb50gNMMgzYEebAV34lB+BFQulUjsG2TX7Yn1PwH
         EtHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rAa4AoVI0mgDiNi0ZbvS/C0L5MD8lJf8UDLKotBP8xg=;
        b=FGN600LiKmG4bkTOC1jRjMaVulj1s/i1WNnOkj9yYYAIDz97VRW59m5XjCB3gUqj4r
         mzz2+z1y7y8TN4TjQItDaPBiaEqpSxvA500rgmSef3OMBIeWT6fQ5BOpwnpdwrZi5/RQ
         2Ob6FewidIQMA49oyHd8SbKBLL7ebAXLpeLaGXV4rc4CL8We25CwgwNlw/XTeUJfxMRL
         ZbVrAln1RaS6JqHg6Jf20j+IvtOp3ynIIo8KJ0VSoMOoRrZhWfqfenu1wrrD0PT7FtA+
         2K8MdWJYg0nIAryg+IyyBloug7VzZOR65DWNrh7PPK03ziuMur0WXiiaVFE31JtOncM3
         G8zA==
X-Gm-Message-State: AOAM531RMhLYViQiJ1umt5spX2sojQHLuxS1wrtVp+sN5iAPEJcbAxlU
        8fglUwXX5LjHFpKRij0arrl1pTYXutkvLeKiPNOcdHBOxm0=
X-Google-Smtp-Source: ABdhPJyy8zjyVhV7MgOS92BeZ44BHIMqlDzDWnyjkS+KK4s+CWFrwXkjY7c42OJE4rzEu6qf4Z8SjZFA58w0xTdd5bM=
X-Received: by 2002:a05:6e02:cad:: with SMTP id 13mr136419ilg.77.1619042710645;
 Wed, 21 Apr 2021 15:05:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210420024222.101615-1-ilya.lipnitskiy@gmail.com> <20210421220302.GA1637795@robh.at.kernel.org>
In-Reply-To: <20210421220302.GA1637795@robh.at.kernel.org>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Wed, 21 Apr 2021 15:04:59 -0700
Message-ID: <CALCv0x2oSXBT-6LteYtr9J5XmmDuer_=sbCgB5CBXWe_cKk2sA@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: mediatek/ralink: remove unused bindings
To:     Rob Herring <robh@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Crispin <john@phrozen.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Wed, Apr 21, 2021 at 3:03 PM Rob Herring <robh@kernel.org> wrote:
>
> On Mon, Apr 19, 2021 at 07:42:22PM -0700, Ilya Lipnitskiy wrote:
> > Revert commit 663148e48a66 ("Documentation: DT: net: add docs for
> > ralink/mediatek SoC ethernet binding")
> >
> > No in-tree drivers use the compatible strings present in these bindings,
> > and some have been superseded by DSA-capable mtk_eth_soc driver, so
> > remove these obsolete bindings.
>
> Looks like maybe OpenWRT folks are using these. If so, you can't revert
> them.
Indeed, there are out of tree drivers for some of these. I wasn't sure
what the dt-binding policy was for such use cases - can you point me
to a definitive reference?

Ilya
>
> >
> > Cc: John Crispin <john@phrozen.org>
> > Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> > ---
> >  .../bindings/net/mediatek,mt7620-gsw.txt      | 24 --------
> >  .../bindings/net/ralink,rt2880-net.txt        | 59 -------------------
> >  .../bindings/net/ralink,rt3050-esw.txt        | 30 ----------
> >  3 files changed, 113 deletions(-)
> >  delete mode 100644 Documentation/devicetree/bindings/net/mediatek,mt7620-gsw.txt
> >  delete mode 100644 Documentation/devicetree/bindings/net/ralink,rt2880-net.txt
> >  delete mode 100644 Documentation/devicetree/bindings/net/ralink,rt3050-esw.txt
> >
> > diff --git a/Documentation/devicetree/bindings/net/mediatek,mt7620-gsw.txt b/Documentation/devicetree/bindings/net/mediatek,mt7620-gsw.txt
> > deleted file mode 100644
> > index 358fed2fab43..000000000000
> > --- a/Documentation/devicetree/bindings/net/mediatek,mt7620-gsw.txt
> > +++ /dev/null
> > @@ -1,24 +0,0 @@
> > -Mediatek Gigabit Switch
> > -=======================
> > -
> > -The mediatek gigabit switch can be found on Mediatek SoCs (mt7620, mt7621).
> > -
> > -Required properties:
> > -- compatible: Should be "mediatek,mt7620-gsw" or "mediatek,mt7621-gsw"
> > -- reg: Address and length of the register set for the device
> > -- interrupts: Should contain the gigabit switches interrupt
> > -- resets: Should contain the gigabit switches resets
> > -- reset-names: Should contain the reset names "gsw"
> > -
> > -Example:
> > -
> > -gsw@10110000 {
> > -     compatible = "ralink,mt7620-gsw";
> > -     reg = <0x10110000 8000>;
> > -
> > -     resets = <&rstctrl 23>;
> > -     reset-names = "gsw";
> > -
> > -     interrupt-parent = <&intc>;
> > -     interrupts = <17>;
> > -};
> > diff --git a/Documentation/devicetree/bindings/net/ralink,rt2880-net.txt b/Documentation/devicetree/bindings/net/ralink,rt2880-net.txt
> > deleted file mode 100644
> > index 9fe1a0a22e44..000000000000
> > --- a/Documentation/devicetree/bindings/net/ralink,rt2880-net.txt
> > +++ /dev/null
> > @@ -1,59 +0,0 @@
> > -Ralink Frame Engine Ethernet controller
> > -=======================================
> > -
> > -The Ralink frame engine ethernet controller can be found on Ralink and
> > -Mediatek SoCs (RT288x, RT3x5x, RT366x, RT388x, rt5350, mt7620, mt7621, mt76x8).
> > -
> > -Depending on the SoC, there is a number of ports connected to the CPU port
> > -directly and/or via a (gigabit-)switch.
> > -
> > -* Ethernet controller node
> > -
> > -Required properties:
> > -- compatible: Should be one of "ralink,rt2880-eth", "ralink,rt3050-eth",
> > -  "ralink,rt3050-eth", "ralink,rt3883-eth", "ralink,rt5350-eth",
> > -  "mediatek,mt7620-eth", "mediatek,mt7621-eth"
> > -- reg: Address and length of the register set for the device
> > -- interrupts: Should contain the frame engines interrupt
> > -- resets: Should contain the frame engines resets
> > -- reset-names: Should contain the reset names "fe". If a switch is present
> > -  "esw" is also required.
> > -
> > -
> > -* Ethernet port node
> > -
> > -Required properties:
> > -- compatible: Should be "ralink,eth-port"
> > -- reg: The number of the physical port
> > -- phy-handle: reference to the node describing the phy
> > -
> > -Example:
> > -
> > -mdio-bus {
> > -     ...
> > -     phy0: ethernet-phy@0 {
> > -             phy-mode = "mii";
> > -             reg = <0>;
> > -     };
> > -};
> > -
> > -ethernet@400000 {
> > -     compatible = "ralink,rt2880-eth";
> > -     reg = <0x00400000 10000>;
> > -
> > -     #address-cells = <1>;
> > -     #size-cells = <0>;
> > -
> > -     resets = <&rstctrl 18>;
> > -     reset-names = "fe";
> > -
> > -     interrupt-parent = <&cpuintc>;
> > -     interrupts = <5>;
> > -
> > -     port@0 {
> > -             compatible = "ralink,eth-port";
> > -             reg = <0>;
> > -             phy-handle = <&phy0>;
> > -     };
> > -
> > -};
> > diff --git a/Documentation/devicetree/bindings/net/ralink,rt3050-esw.txt b/Documentation/devicetree/bindings/net/ralink,rt3050-esw.txt
> > deleted file mode 100644
> > index 87e315856efa..000000000000
> > --- a/Documentation/devicetree/bindings/net/ralink,rt3050-esw.txt
> > +++ /dev/null
> > @@ -1,30 +0,0 @@
> > -Ralink Fast Ethernet Embedded Switch
> > -====================================
> > -
> > -The ralink fast ethernet embedded switch can be found on Ralink and Mediatek
> > -SoCs (RT3x5x, RT5350, MT76x8).
> > -
> > -Required properties:
> > -- compatible: Should be "ralink,rt3050-esw"
> > -- reg: Address and length of the register set for the device
> > -- interrupts: Should contain the embedded switches interrupt
> > -- resets: Should contain the embedded switches resets
> > -- reset-names: Should contain the reset names "esw"
> > -
> > -Optional properties:
> > -- ralink,portmap: can be used to choose if the default switch setup is
> > -  llllw or wllll
> > -- ralink,led_polarity: override the active high/low settings of the leds
> > -
> > -Example:
> > -
> > -esw@10110000 {
> > -     compatible = "ralink,rt3050-esw";
> > -     reg = <0x10110000 8000>;
> > -
> > -     resets = <&rstctrl 23>;
> > -     reset-names = "esw";
> > -
> > -     interrupt-parent = <&intc>;
> > -     interrupts = <17>;
> > -};
> > --
> > 2.31.1
> >
