Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A0C285C19
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 11:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgJGJuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 05:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbgJGJuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 05:50:51 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4D7C061755;
        Wed,  7 Oct 2020 02:50:51 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id c21so1295006ljn.13;
        Wed, 07 Oct 2020 02:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W29CVTFQOrbHJWIGtcHwbbU8fyYPqSAUdw8um37seHc=;
        b=PhTLRYML5i+WZ2rrL1a0Q+1k07nAsqRh1qCiuacrZNElPXfVCAn3shi7uxVE6yv64W
         6uW0xf6cH0BZ5KWsQPWau3tTZL/kt9pChI9zJ0hASFbs5nM+P5l849wCMkS+zMknRlM6
         6KA2onCTFSSoVAwyEb7i1V/2EOoHnHXJv1zDEbpvsrWjcyfD+w5WGPQsTIVMfot6XZ/N
         K/SPR2dyy0+NmlDZcXWCWKh4wqTEEzi9hF/CyYvbMmZL9Cfa3fNmi5T37ny3+h5rxfNu
         npCdKQCbLt/PGzB1TKKrIppTIkoaEc+/fSLmfDZ9b0n9bOP3aOPlWeCyMf2wdy9dROnV
         j/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W29CVTFQOrbHJWIGtcHwbbU8fyYPqSAUdw8um37seHc=;
        b=TQHPtRDz2slyEzToYBeQoYk1knzJEF10Rf8MBVTZ0/FeVGr8TUM8W49HxKUn/rF0dH
         kyLVDSJjBihbhDdi00I5d+Gu3FjOKp/H4UD5aYzXu/FkSzTRSpjItLOYu/qhz4+NuMTl
         fPnZWHe0m7MujbjRhhb5cE89P5OeXAOTKDXuRpVTU2FgDCSLY6O3js8vlQAUlS6wxoK0
         aAUB9gHQUEEQD4GbZhsVznR0q5vE2p+wNRECi0ebcH3QSUYB+yDYtTeOz55RwEFqv3rE
         PFeAS4XSfEvm5hBcynPCmX2F9yo/kzaqRDCXoeW9o8jhSA86z7oFOZNENMXcOl6m6c7I
         FxHw==
X-Gm-Message-State: AOAM531WaXl6XPi2MQFMWjurm71kzYB6DxLjtF5s+YoEBT+eDpW7Edtw
        wV0zYwfSoQKsNmd1q1AHBc3T/o2/MVzs7tQKm4M=
X-Google-Smtp-Source: ABdhPJyU1G8xH1b2NDuoZRIKUhijEVGCYBEf2r79588YCzpOl+BwEWTkFVONRWkOffivR+JU5REL0BJqrWIVxmsfhqM=
X-Received: by 2002:a2e:a550:: with SMTP id e16mr983740ljn.125.1602064249591;
 Wed, 07 Oct 2020 02:50:49 -0700 (PDT)
MIME-Version: 1.0
References: <20201006080424.GA6988@pengutronix.de>
In-Reply-To: <20201006080424.GA6988@pengutronix.de>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 7 Oct 2020 06:50:38 -0300
Message-ID: <CAOMZO5Ds7mm4dWdt_a+HU=V40zjp006JQJbozRCicx9yiqacgg@mail.gmail.com>
Subject: Re: PHY reset question
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, David Jander <david@protonic.nl>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Bruno Thomsen <bruno.thomsen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On Tue, Oct 6, 2020 at 5:05 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>
> Hello PHY experts,
>
> Short version:
> what is the proper way to handle the PHY reset before identifying PHY?
>
> Long version:
> I stumbled over following issue:
> If PHY reset is registered within PHY node. Then, sometimes,  we will not be
> able to identify it (read PHY ID), because PHY is under reset.
>
> mdio {
>         compatible = "virtual,mdio-gpio";
>
>         [...]
>
>         /* Microchip KSZ8081 */
>         usbeth_phy: ethernet-phy@3 {
>                 reg = <0x3>;
>
>                 interrupts-extended = <&gpio5 12 IRQ_TYPE_LEVEL_LOW>;
>                 reset-gpios = <&gpio5 11 GPIO_ACTIVE_LOW>;
>                 reset-assert-us = <500>;
>                 reset-deassert-us = <1000>;
>         };
>
>         [...]
> };
>
> On simple boards with one PHY per MDIO bus, it is easy to workaround by using
> phy-reset-gpios withing MAC node (illustrated in below DT example), instead of
> using reset-gpios within PHY node (see above DT example).
>
> &fec {
>         [...]
>         phy-mode = "rmii";
>         phy-reset-gpios = <&gpio4 12 GPIO_ACTIVE_LOW>;
>         [...]

I thought this has been fixed by Bruno's series:
https://www.spinics.net/lists/netdev/msg673611.html
