Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2F835583B
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 17:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345903AbhDFPi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 11:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345879AbhDFPiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 11:38:02 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87674C061760;
        Tue,  6 Apr 2021 08:37:54 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id l9so7378258ils.6;
        Tue, 06 Apr 2021 08:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kbb3/w5YJGsBeXToKy9zRKXFO7bV5Vr6+2zCWM3GMJs=;
        b=PX9wRzFR3GLxYS+v7WJWcQ8w6OA7XNBTFoiOUuDUWcScUAV1KX84PKIhp1MbImARj7
         zfDeUZS/HuyypOgx2s7g8xK+mZiK7QvljysRj8KrtAEqwzl+4q3KnN/sPnzx7utgVxAl
         jHa9z+z3tV7CBTnEwTXN7UQfBShvTFIlms9BxIs6YZZQUVYqHp/YauRctCOH94KI8Byv
         HZbF58xrNEp1QK9sQbUqKZTGxsz5QSUlE31cnd57TfRo+ep4RRsM+6Pl3fy28G5GztVU
         ysc3tAldc1zDgy6wn7bd+LAT3JZM3asHq4gcSdAKF2RzWOQrywSQ2ghQi27IxS3avXbx
         rqug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kbb3/w5YJGsBeXToKy9zRKXFO7bV5Vr6+2zCWM3GMJs=;
        b=Z5ECdo3PdvyRhMLfXbiWXCmAh4UPCDhYFyd39RUdfAugD5iwKDgdin2j6QepitCXIg
         bQK1+WH7Ov4d97w/NNkslJpV4anMlIg1bXzYMZ93yJAvU8zElnCNDWA1rx85kwbo5qzm
         G11k8e69GUxIlhQ73l4+lqzN87AF8F9844hVOwA1YrkqfKeSwBHaC3vrOsas+0nUTJsb
         p1HvBKNDzMZCdGXvcGVe6MCgbKBd4CR0mT6GNDt2f6Ks0UOBcDx7R/PnhxkEXCv/C57n
         qDULHDX/l3TKnDUMQiBRXixojUppDvBNZQYjVAk6NkB2N32pCgeSbR5Du7m2BSHbI2O7
         AvgA==
X-Gm-Message-State: AOAM530Eq45XLrI77QFA4PNfAmAWK7F1AKMzYLVFDZq4CkdwIoMGeVZj
        /G7H9JXvEj6ffg8DWMDjqFb53lOg3DA9zRFHVuo=
X-Google-Smtp-Source: ABdhPJx0Q0y2VRt3hOxfDO1mtz1BBR0nzU1O4AzOcEj955FhecKBLwpJD1/qIY06hhsRlAjlNDN8j2jSd8GUczZS4mA=
X-Received: by 2002:a92:de0c:: with SMTP id x12mr1946080ilm.169.1617723474053;
 Tue, 06 Apr 2021 08:37:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210406141819.1025864-1-dqfext@gmail.com> <20210406141819.1025864-2-dqfext@gmail.com>
 <YGx8c5Jt2D7fB0cO@lunn.ch>
In-Reply-To: <YGx8c5Jt2D7fB0cO@lunn.ch>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Tue, 6 Apr 2021 23:37:51 +0800
Message-ID: <CALW65jYGpTs+30k7vxfLpQaK1sqHf4r7zosSOxp4W5U+Eh-Wvg@mail.gmail.com>
Subject: Re: [RFC net-next 1/4] net: phy: add MediaTek PHY driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-staging@lists.linux.dev,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 6, 2021 at 11:21 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Apr 06, 2021 at 10:18:16PM +0800, DENG Qingfang wrote:
> > Add support for MediaTek PHYs found in MT7530 and MT7531 switches.
>
> Do you know if this PHY is available standalone?

Not that I know of.

>
> > +static int mt7531_phy_config_init(struct phy_device *phydev)
> > +{
> > +     mtk_phy_config_init(phydev);
> > +
> > +     /* PHY link down power saving enable */
> > +     phy_set_bits(phydev, 0x17, BIT(4));
> > +     phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, 0xc6, 0x300);
> > +
> > +     /* Set TX Pair delay selection */
> > +     phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x13, 0x404);
> > +     phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x14, 0x404);
>
> This gets me worried about RGMII delays. We have had bad backwards
> compatibility problems with PHY drivers which get RGMII delays wrong.
>
> Since this is an internal PHY, i suggest you add a test to the
> beginning of mt7531_phy_config_init():
>
>         if (phydev->interface != PHY_INTERFACE_MODE_INTERNAL)
>                 return -EINVAL;

Okay. Will add it to v2.

>
> We can then solve RGMII problems when somebody actually needs RGMII.
>
>    Andrew
