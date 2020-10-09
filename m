Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5651288AD1
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 16:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388742AbgJIO0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 10:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729280AbgJIO0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 10:26:07 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247DDC0613D2;
        Fri,  9 Oct 2020 07:26:07 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id x1so9548899eds.1;
        Fri, 09 Oct 2020 07:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cHvy1KQN5hLuKt6ToeI3sdJ0ZRUbDtCJMWu2DR4x78o=;
        b=Voze/ZFV30MCsweq27VpVXhOCyoYFMibKZjEJwOrtuJLIIo2Ok4RhN+Ie2G+eswXfA
         1q70MwzV9lDxKwjiAuz1Jk0I1QriZaOPrwrKszjDC+3Z5/DnUEtxm5Vwix28gShZZdKk
         vBkyETVLN10wqBfnqIQho2OTVci1QbGGZSVyhtMbVsl9JGiQQq/TcMZCoa/ANGahT6Y5
         +QnQH6J85ytrmM1iD8petUSmD2j5Hs6n/J6L7wHltC+SGlnTXPN/HhVBlzqusY5/KPuj
         La2A3UayCXMjf+ZUfgqWzkR5XqAwpqIjQGzXSERW6dRxVLccjEJNMt1c/aexKuuP0Lq6
         apIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cHvy1KQN5hLuKt6ToeI3sdJ0ZRUbDtCJMWu2DR4x78o=;
        b=XwEu0PfY+XuZjGxRG05QyUJV3+VZ1Jap9CTVH2HeNsF0MPzdcdc2OoCO2LqCh+5YCo
         aVV25MdQlnScEr+oP8j/9qUN9CJjgjYXgVjDMGq2Jidr7cszYxPMJJhe5TDgFjPuyyVs
         BL8ciRozjR82gJbcmMod4itUYmHWeLxe55bhRZYTnvRGa6X7vAh4xRlRSMuTvh1AOLkj
         P596KZbcUmwzqzZfFSRcGktZ8okOsS+7iB9+FqPRvJNGTUr5+htlBd83EVCUKLScziIr
         W0RPr9jV2s/BFwr4QE6RENHbzeV8xzGRaFl0mx7Z1sSM5xqVNv8QuwY98WJWKY4Ms4Fw
         r7wA==
X-Gm-Message-State: AOAM533YUlVI4hHywsbTOflrSSlIdWPDuC3dGJlAn4h74h8/g+Mr+W+s
        8K4ja2HJjICBjETILRqXvsi4OHf58z9YVSZsCp0=
X-Google-Smtp-Source: ABdhPJy53WMWN3WNZMoTcdkRBXF6OkwhMxZOCZHBEzZxaaMBvHj+4P42vcVIHzNnpJkFGujfGV6zw914KUB/EBTpruI=
X-Received: by 2002:a50:e78f:: with SMTP id b15mr15077444edn.104.1602253565716;
 Fri, 09 Oct 2020 07:26:05 -0700 (PDT)
MIME-Version: 1.0
References: <20201006080424.GA6988@pengutronix.de> <CAOMZO5Ds7mm4dWdt_a+HU=V40zjp006JQJbozRCicx9yiqacgg@mail.gmail.com>
In-Reply-To: <CAOMZO5Ds7mm4dWdt_a+HU=V40zjp006JQJbozRCicx9yiqacgg@mail.gmail.com>
From:   Bruno Thomsen <bruno.thomsen@gmail.com>
Date:   Fri, 9 Oct 2020 16:25:49 +0200
Message-ID: <CAH+2xPD=CE+pk_cEC=cLv1nebBBg7X+xDpOFANf3rQ4V2+2Cvw@mail.gmail.com>
Subject: Re: PHY reset question
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>, David Jander <david@protonic.nl>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Fabio and Oleksij

Den ons. 7. okt. 2020 kl. 11.50 skrev Fabio Estevam <festevam@gmail.com>:
>
> Hi Oleksij,
>
> On Tue, Oct 6, 2020 at 5:05 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> >
> > Hello PHY experts,
> >
> > Short version:
> > what is the proper way to handle the PHY reset before identifying PHY?
> >
> > Long version:
> > I stumbled over following issue:
> > If PHY reset is registered within PHY node. Then, sometimes,  we will not be
> > able to identify it (read PHY ID), because PHY is under reset.
> >
> > mdio {
> >         compatible = "virtual,mdio-gpio";
> >
> >         [...]
> >
> >         /* Microchip KSZ8081 */
> >         usbeth_phy: ethernet-phy@3 {
> >                 reg = <0x3>;
> >
> >                 interrupts-extended = <&gpio5 12 IRQ_TYPE_LEVEL_LOW>;
> >                 reset-gpios = <&gpio5 11 GPIO_ACTIVE_LOW>;
> >                 reset-assert-us = <500>;
> >                 reset-deassert-us = <1000>;
> >         };
> >
> >         [...]
> > };
> >
> > On simple boards with one PHY per MDIO bus, it is easy to workaround by using
> > phy-reset-gpios withing MAC node (illustrated in below DT example), instead of
> > using reset-gpios within PHY node (see above DT example).
> >
> > &fec {
> >         [...]
> >         phy-mode = "rmii";
> >         phy-reset-gpios = <&gpio4 12 GPIO_ACTIVE_LOW>;
> >         [...]
>
> I thought this has been fixed by Bruno's series:
> https://www.spinics.net/lists/netdev/msg673611.html

Yes, that has fixed the Microchip/Micrel PHY ID auto detection
issue. I have send a DTS patch v3 that makes use of the newly
added device tree parameter:
https://lkml.org/lkml/2020/9/23/595

/Bruno
