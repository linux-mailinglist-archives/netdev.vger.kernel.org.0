Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7A42DF394
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 05:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgLTEs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 23:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbgLTEs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 23:48:59 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AAD3C0613CF
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 20:48:19 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id r9so5891614ioo.7
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 20:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d+I+MxhZRgbV94D9EabdQV93ne2lYILR2KlRArwUle8=;
        b=TN1bLPEVwPotLjbi2RZbsJX5S4wR2E4B8mbH1BYhBabbCuGoCKpl2Zf2Y0wdg4XAb0
         suhvR5RwoQ8qEy90zVWD0cnyQhbdCEQWVzUnGlf2ak2e6dJbSTr48/1WtjyFNiJAKjEM
         JsbWEmouQB5DXkCr3q+rfzDllPdYBGYAWdccnKPQS0EBEkFcDF0Zg9s6vByyaSN4zjV+
         jaxyHDVbyX4ZI8IvpttYYc8qvFbefCuCfi9l238hR8oy8paQhTTXoe5wCNrSBmAUUTYx
         HqkwYiAts7Vdmd8DxRsKQW/36d1e0xgpXFb5gSDk/mAIoGMu9WdShnG5Iq6JYlohv0wI
         D2pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d+I+MxhZRgbV94D9EabdQV93ne2lYILR2KlRArwUle8=;
        b=CUhqzXI8z2qlK1CanlRaNwSnsoL7MSl5jDp/loGbsLooaW3FQkjzobccgQow+JetGU
         3HcnwlgbsBkA9Vi+1fa0yXp4TGVY8PDoFbSqkzxFKzADFC/mT//MBViTWzoEuu/Q1Yy+
         vZdgNfHVrW8CcJQly1pt2hIk7DcLOpPYlaaJ2iQFziF+hZf2EZqq+MY/sIC67Ot+Q2yq
         VwY2/1W6yNVouNBxqZpnCvpZDXKO/59dsEPNfn90hy6Ya9ActXUYJWPnFkzuzZn2Q26r
         usub71rvQnAaLj8cJsGsBbFRcQn0kgpJnWPDXvgQuI5M97QcllJk6i6p01fL+6G/dj22
         wSNQ==
X-Gm-Message-State: AOAM532Mawh5SMDSlJ5+kcwe0NPxiLED2VndD9vNk1H1oB4ns7axUJDI
        w5Tque8BgYUsdRrF7AkbydlWcJjocbvunGEVuWM=
X-Google-Smtp-Source: ABdhPJyXPQSHJwF4yd0MdFCn+ETOqT2J1/g879Vm4IgiWsocYgSJZll/tV0usL2TvKecEvQcfCrjdUQLRGLcqOxT2EI=
X-Received: by 2002:a6b:3788:: with SMTP id e130mr10222133ioa.23.1608439698367;
 Sat, 19 Dec 2020 20:48:18 -0800 (PST)
MIME-Version: 1.0
References: <20201219162153.23126-1-dqfext@gmail.com> <20201219162601.GE3008889@lunn.ch>
 <47673b0d-1da8-d93e-8b56-995a651aa7fd@gmail.com> <20201219194831.5mjlmjfbcpggrh45@skbuf>
In-Reply-To: <20201219194831.5mjlmjfbcpggrh45@skbuf>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Sun, 20 Dec 2020 12:48:08 +0800
Message-ID: <CALW65jYtW7EEnXuj2dGSDwYC=3sBLCP0Q9J=tMozkrP6W0gq0w@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: mt7530: rename MT7621 compatible
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Ungerer <gerg@kernel.org>,
        Rene van Dorst <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Sun, Dec 20, 2020 at 3:48 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Andrew, Florian,
>
> On Sat, Dec 19, 2020 at 09:07:13AM -0800, Florian Fainelli wrote:
> > On 12/19/2020 8:26 AM, Andrew Lunn wrote:
> > >> --- a/drivers/net/dsa/mt7530.c
> > >> +++ b/drivers/net/dsa/mt7530.c
> > >> @@ -2688,7 +2688,7 @@ static const struct mt753x_info mt753x_table[] = {
> > >>  };
> > >>
> > >>  static const struct of_device_id mt7530_of_match[] = {
> > >> -  { .compatible = "mediatek,mt7621", .data = &mt753x_table[ID_MT7621], },
> > >> +  { .compatible = "mediatek,mt7621-gsw", .data = &mt753x_table[ID_MT7621], },
> > >>    { .compatible = "mediatek,mt7530", .data = &mt753x_table[ID_MT7530], },
> > >>    { .compatible = "mediatek,mt7531", .data = &mt753x_table[ID_MT7531], },
> > >>    { /* sentinel */ },
> > >
> > > This will break backwards compatibility with existing DT blobs. You
> > > need to keep the old "mediatek,mt7621", but please add a comment that
> > > it is deprecated.
> >
> > Besides, adding -gsw would make it inconsistent with the existing
> > matching compatible strings. While it's not ideal to have the same
> > top-level SoC compatible and having another sub-node within that SoC's
> > DTS have the same compatible, given this would be break backwards
> > compatibility, cannot you stay with what is defined today?
>
> The MT7621 device tree is in staging. I suppose that some amount of
> breaking changes could be tolerated?
>
> But Qingfang, I'm confused when looking at drivers/staging/mt7621-dts/mt7621.dtsi.
>
> /ethernet@1e100000/mdio-bus {
>         switch0: switch0@0 {
>                 compatible = "mediatek,mt7621";
>                 #address-cells = <1>;
>                 #size-cells = <0>;
>                 reg = <0>;
>                 mediatek,mcm;
>                 resets = <&rstctrl 2>;
>                 reset-names = "mcm";
>
>                 ports {
>                         #address-cells = <1>;
>                         #size-cells = <0>;
>                         reg = <0>;
>                         port@0 {
>                                 status = "off";
>                                 reg = <0>;
>                                 label = "lan0";
>                         };
>                         port@1 {
>                                 status = "off";
>                                 reg = <1>;
>                                 label = "lan1";
>                         };
>                         port@2 {
>                                 status = "off";
>                                 reg = <2>;
>                                 label = "lan2";
>                         };
>                         port@3 {
>                                 status = "off";
>                                 reg = <3>;
>                                 label = "lan3";
>                         };
>                         port@4 {
>                                 status = "off";
>                                 reg = <4>;
>                                 label = "lan4";
>                         };
>                         port@6 {
>                                 reg = <6>;
>                                 label = "cpu";
>                                 ethernet = <&gmac0>;
>                                 phy-mode = "trgmii";
>                                 fixed-link {
>                                         speed = <1000>;
>                                         full-duplex;
>                                 };
>                         };
>                 };
>         };
> };
>
> / {
>         gsw: gsw@1e110000 {
>                 compatible = "mediatek,mt7621-gsw";
>                 reg = <0x1e110000 0x8000>;
>                 interrupt-parent = <&gic>;
>                 interrupts = <GIC_SHARED 23 IRQ_TYPE_LEVEL_HIGH>;
>         };
> };
>
> What is the platform device at the memory address 1e110000?
> There is no driver for it. The documentation only has me even more
> confused:
>
> Mediatek Gigabit Switch
> =======================
>
> The mediatek gigabit switch can be found on Mediatek SoCs (mt7620, mt7621).
>
> Required properties:
> - compatible: Should be "mediatek,mt7620-gsw" or "mediatek,mt7621-gsw"
> - reg: Address and length of the register set for the device
> - interrupts: Should contain the gigabit switches interrupt
> - resets: Should contain the gigabit switches resets
> - reset-names: Should contain the reset names "gsw"
>
> Example:
>
> gsw@10110000 {
>         compatible = "ralink,mt7620-gsw";     <- notice how even the example is bad and inconsistent
>         reg = <0x10110000 8000>;
>
>         resets = <&rstctrl 23>;
>         reset-names = "gsw";
>
>         interrupt-parent = <&intc>;
>         interrupts = <17>;
> };
>
> Does the MT7621 contain two Ethernet switches, one accessed over MMIO
> and another over MDIO? Or is it the same switch? I don't understand.
> What is the relationship between the new compatible that you're
> proposing, Qingfang, and the existing device tree bindings?

The current dtsi is copied from OpenWrt, so the existing "mt7621-gsw"
/ "mt7620-gsw" compatible is for their swconfig driver.
MT7621 has only one switch, accessed over MDIO, so the reg property
has no effect.

Should this patch be accepted, the existing gsw nodes can be dropped.
