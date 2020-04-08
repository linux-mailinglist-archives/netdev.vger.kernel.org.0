Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 119AC1A1A0E
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 04:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgDHCmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 22:42:47 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:36201 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgDHCmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 22:42:46 -0400
Received: by mail-vs1-f66.google.com with SMTP id 184so3821274vsu.3;
        Tue, 07 Apr 2020 19:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xgCzGC1kvy7uz42NyKbeHibJLU8sxqBfQKH68cIgT/g=;
        b=cx9Qsi72wzKy/XU4FQqkeYKTGUFhM0z6j2FN6hQ65ZDbSG9Emo3vh/laboSbSnP6Oy
         UKsa+Rjeyr2pB+zcaQksgYunG/grjh5B57OJUwQ8UVnfCi7JOjFuBKf/CL+EJUW1iIth
         IkP5YmBGan3ewUJ37DrS+yyfl4r6mlUnzvalEBgUnlXIPgck3UhI1TBRlNu3vc9nOHgS
         ryzIFGnV/08OZxcYNbwPcVvTdSGP13UaVz1g9ANQew/e6G3/kUe8EvPEZFMtWJSyMfJs
         7dgSlnecvYQyY9hve7Uky1gutfpHci0ERR/WaJ2/eyEx6Di5lMzQuI9K9kIOaomz3waK
         Rmyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xgCzGC1kvy7uz42NyKbeHibJLU8sxqBfQKH68cIgT/g=;
        b=aFfnRM58wKEBV7WVY8hivrJfYN9PJtNaf7zRM6Q4b5Ud6Act/Hwd12P63NodzmnV8A
         zDMM6vEGpj74HTw0qX1NMvz68n1cwOm/bz2PRn+ulgl9jake71QhZZFh3xNBseWYIsXy
         StFbhMbpLHDDPp6tY2ibkxBFGKolDcsqyWOjElR1rH4mOgAtDM91KDHY8Ic6JC7s5xYB
         XdbxGQEfS4tHptfqge/9o4fHYOO0V6XqTt/1vxvgX211q0mPv4OKi6nFC61hP0tFjaxT
         aKperIgSmfoo8qGbaov2GTDTTKiJJfEw7jgH7OSaaCZ7e3h8luhLSLB+FxeB/9MhZ0Y1
         TytA==
X-Gm-Message-State: AGi0PuZCdi4ej61ZEMndxC+G3kOy38UrXJx/kWa3xXlWxREN53CVDYP+
        D0j0gv5CoKLyLsZezjErsC5OyiJcUp8K+eyHYdE=
X-Google-Smtp-Source: APiQypJgKZShAtHyReSHvnIKPU4K34SOKUvabdLuLm2C8WyckZcMyaZpynMpdqqE3w5V3IRWj8tpywcTktVgv0y9y7A=
X-Received: by 2002:a67:1b81:: with SMTP id b123mr4371610vsb.172.1586313763887;
 Tue, 07 Apr 2020 19:42:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200407055837.3508017-1-alistair@alistair23.me>
 <20200407055837.3508017-3-alistair@alistair23.me> <CA+E=qVf_Zr6JXQVxRuUdTWL7oxq5dRp+jeHF8PWDSozyFZMaCw@mail.gmail.com>
In-Reply-To: <CA+E=qVf_Zr6JXQVxRuUdTWL7oxq5dRp+jeHF8PWDSozyFZMaCw@mail.gmail.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Tue, 7 Apr 2020 19:42:17 -0700
Message-ID: <CAKmqyKM=YGq98E2dWu2BczTxHVOO86XW9Et1z_u8DOSJMtHdyQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] arm64: allwinner: Enable Bluetooth and WiFi on
 sopine baseboard
To:     Vasily Khoruzhick <anarsoul@gmail.com>
Cc:     Alistair Francis <alistair@alistair23.me>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        devicetree <devicetree@vger.kernel.org>,
        arm-linux <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 6, 2020 at 11:53 PM Vasily Khoruzhick <anarsoul@gmail.com> wrote:
>
> On Mon, Apr 6, 2020 at 10:58 PM Alistair Francis <alistair@alistair23.me> wrote:
> >
> > The sopine board has an optional RTL8723BS WiFi + BT module that can be
> > connected to UART1. Add this to the device tree so that it will work
> > for users if connected.
>
> It's optional, so patch should have 'DO-NOT-MERGE' tag and appropriate
> change should go into dt overlay.

I was hoping to enable WiFi/Bluetooth by default, even though it's an
optional add-on for the board.

Alistair

>
> > Signed-off-by: Alistair Francis <alistair@alistair23.me>
> > ---
> >  .../allwinner/sun50i-a64-sopine-baseboard.dts | 23 +++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> >
> > diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
> > index 2f6ea9f3f6a2..f4be1bc56b07 100644
> > --- a/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
> > +++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
> > @@ -103,6 +103,16 @@ ext_rgmii_phy: ethernet-phy@1 {
> >         };
> >  };
> >
> > +&mmc1 {
> > +       pinctrl-names = "default";
> > +       pinctrl-0 = <&mmc1_pins>;
> > +       vmmc-supply = <&reg_dldo4>;
> > +       vqmmc-supply = <&reg_eldo1>;
> > +       non-removable;
> > +       bus-width = <4>;
> > +       status = "okay";
> > +};
> > +
> >  &mmc2 {
> >         pinctrl-names = "default";
> >         pinctrl-0 = <&mmc2_pins>;
> > @@ -174,6 +184,19 @@ &uart0 {
> >         status = "okay";
> >  };
> >
> > +&uart1 {
> > +       pinctrl-names = "default";
> > +       pinctrl-0 = <&uart1_pins>, <&uart1_rts_cts_pins>;
> > +       uart-has-rtscts = <1>;
> > +       status = "okay";
> > +
> > +       bluetooth {
> > +               compatible = "realtek,rtl8723bs-bt";
> > +               device-wake-gpios = <&r_pio 0 5 GPIO_ACTIVE_HIGH>; /* PL5 */
> > +               host-wake-gpios = <&r_pio 0 6 GPIO_ACTIVE_HIGH>; /* PL6 */
> > +       };
> > +};
> > +
> >  /* On Pi-2 connector */
> >  &uart2 {
> >         pinctrl-names = "default";
> > --
> > 2.25.1
> >
