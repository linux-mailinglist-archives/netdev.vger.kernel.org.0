Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6DB22E409
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 04:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgG0CgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 22:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgG0CgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 22:36:05 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93EE6C0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 19:36:04 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id f5so15492057ljj.10
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 19:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ieh3DZz/ti0vfYMvL35HNziScLzBGi41YlUd+VaUoEs=;
        b=J/9jkaX3ev8HtnHu1XElO8C02QHZJ5YVchiyQ7jTN0BFH5bp2TU270vhinZWphnZt1
         kJRT2f7UUWwdbqdEK1VbRx0hU4USdPBybv0Uj+omx9QNpEn9j5DQ7XUf6X3czRF8UoCx
         +Jt2iwSgmLAbAR74IYt75SSpVi49/1hGb0D+3oVTNEuM33TPlGCzn+jd0hUkxfOl3ahr
         7TZYBeI5kiOtWAYlCHUNuiBYndvcsfghlbuoB9Dj3FKOkVFxu2u6qVOqiTlstSMeU74K
         jLRe1JPKwkU7/TAjxRW0BIRxb8SBjBC82iJpdEqiy9KFli5Jc647cLlYv0wts3+dfhtn
         nVWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ieh3DZz/ti0vfYMvL35HNziScLzBGi41YlUd+VaUoEs=;
        b=n6UjtSv3dg5ZLKpW4B3yCODTaKcPk1FWcxhLR7A000UMMENGjLkvo4NgGxSL4DzHUY
         J401J126nmUFplCvFpIDoB18yxoQipF5Nkm0DYloFNdmCXEsB3Upb6NuN3tH15kNJa/5
         lc3qt8tvx6OkHFcGoZgHJTpjLa4Bxv16BtjKc47Q+tPDTOTQRkI47tf49E50zryb9OeI
         PGzhbokmgRw++6yUqHOk91zWsOvq5VKVgvsuXDtjS65Z0YQw+myhjvUIgerqI+p+jEKe
         PPC7pMOEjOYLVly+QcHkvp6gnPyiMBZG3PDZdiPGbae022XdUS2qgH0NfbgDAA+KBTd6
         AvHg==
X-Gm-Message-State: AOAM531XZ9A+ZWUucgbbDgVwzDixsnDrQO3YuUA92fjU2CayqIpuoC5x
        xt+GXRU9wq9W5pE5njMxojZBU50CvWKIFTUXG0g=
X-Google-Smtp-Source: ABdhPJxzg/uKLb8H2cWywYVMAyiBh7JLtEDwb9C1+jqSCID1TuYgUVkpi5qpPqFzHnOuR3acCx2gxLnEsLYsclq+ZHo=
X-Received: by 2002:a2e:545c:: with SMTP id y28mr3752147ljd.448.1595817362978;
 Sun, 26 Jul 2020 19:36:02 -0700 (PDT)
MIME-Version: 1.0
References: <1587996484-3504-1-git-send-email-fugang.duan@nxp.com>
 <20200727012354.GT28704@pendragon.ideasonboard.com> <20200727020631.GW28704@pendragon.ideasonboard.com>
 <20200727021432.GM1661457@lunn.ch> <20200727023310.GA23988@pendragon.ideasonboard.com>
In-Reply-To: <20200727023310.GA23988@pendragon.ideasonboard.com>
From:   Chris Healy <cphealy@gmail.com>
Date:   Sun, 26 Jul 2020 19:35:51 -0700
Message-ID: <CAFXsbZrf11Nj4rzLJfisPr-fFo-+stt-G3-XQ_Mwus_2z0nsAg@mail.gmail.com>
Subject: Re: [RESENT PATCH net--stat 1/1] net: ethernet: fec: Revert "net:
 ethernet: fec: Replace interrupt driven MDIO with polled IO"
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Laurent,

I have the exact same copper PHY.  I just reverted a patch specific to
this PHY and went from broken to working.  Give this a try:

git revert bcf3440c6dd78bfe5836ec0990fe36d7b4bb7d20

Regards,

Chris

On Sun, Jul 26, 2020 at 7:33 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Andrew,
>
> On Mon, Jul 27, 2020 at 04:14:32AM +0200, Andrew Lunn wrote:
> > On Mon, Jul 27, 2020 at 05:06:31AM +0300, Laurent Pinchart wrote:
> > > On Mon, Jul 27, 2020 at 04:24:02AM +0300, Laurent Pinchart wrote:
> > > > On Mon, Apr 27, 2020 at 10:08:04PM +0800, Fugang Duan wrote:
> > > > > This reverts commit 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef.
> > > > >
> > > > > The commit breaks ethernet function on i.MX6SX, i.MX7D, i.MX8MM,
> > > > > i.MX8MQ, and i.MX8QXP platforms. Boot yocto system by NFS mounting
> > > > > rootfs will be failed with the commit.
> > > >
> > > > I'm afraid this commit breaks networking on i.MX7D for me :-( My board
> > > > is configured to boot over NFS root with IP autoconfiguration through
> > > > DHCP. The DHCP request goes out, the reply it sent back by the server,
> > > > but never noticed by the fec driver.
> > > >
> > > > v5.7 works fine. As 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef was merged
> > > > during the v5.8 merge window, I suspect something else cropped in
> > > > between 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef and this patch that
> > > > needs to be reverted too. We're close to v5.8 and it would be annoying
> > > > to see this regression ending up in the released kernel. I can test
> > > > patches, but I'm not familiar enough with the driver (or the networking
> > > > subsystem) to fix the issue myself.
> > >
> > > If it can be of any help, I've confirmed that, to get the network back
> > > to usable state from v5.8-rc6, I have to revert all patches up to this
> > > one. This is the top of my branch, on top of v5.8-rc6:
> > >
> > > 5bbe80c9efea Revert "net: ethernet: fec: Revert "net: ethernet: fec: Replace interrupt driven MDIO with polled IO""
> > > 5462896a08c1 Revert "net: ethernet: fec: Replace interrupt driven MDIO with polled IO"
> > > 824a82e2bdfa Revert "net: ethernet: fec: move GPR register offset and bit into DT"
> > > bfe330591cab Revert "net: fec: disable correct clk in the err path of fec_enet_clk_enable"
> > > 109958cad578 Revert "net: ethernet: fec: prevent tx starvation under high rx load"
> >
> > OK.
> >
> > What PHY are you using? A Micrel?
>
> KSZ9031RNXIA
>
> > And which DT file?
>
> It's out of tree.
>
> &fec1 {
>         pinctrl-names = "default";
>         pinctrl-0 = <&pinctrl_enet1>;
>         assigned-clocks = <&clks IMX7D_ENET1_TIME_ROOT_SRC>,
>                           <&clks IMX7D_ENET1_TIME_ROOT_CLK>;
>         assigned-clock-parents = <&clks IMX7D_PLL_ENET_MAIN_100M_CLK>;
>         assigned-clock-rates = <0>, <100000000>;
>         phy-mode = "rgmii";
>         phy-handle = <&ethphy0>;
>         phy-reset-gpios = <&gpio1 13 GPIO_ACTIVE_LOW>;
>         phy-supply = <&reg_3v3_sw>;
>         fsl,magic-packet;
>         status = "okay";
>
>         mdio {
>                 #address-cells = <1>;
>                 #size-cells = <0>;
>
>                 ethphy0: ethernet-phy@0 {
>                         reg = <1>;
>                 };
>
>                 ethphy1: ethernet-phy@1 {
>                         reg = <2>;
>                 };
>         };
> };
>
> I can provide the full DT if needed.
>
> --
> Regards,
>
> Laurent Pinchart
