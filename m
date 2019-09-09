Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14536ADA07
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 15:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbfIINdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 09:33:18 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37296 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbfIINdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 09:33:17 -0400
Received: by mail-ot1-f66.google.com with SMTP id s28so12417678otd.4;
        Mon, 09 Sep 2019 06:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SXwg9Qtd9z+yr6yuTIDFyYnzsJGyQ8uOB6q3KpRENWY=;
        b=r2l4VOtQNE4LjXegCvsut/suXQO9n8TQxjRxoJuVtV3GkUmcm8yZmb2F9VZP/4bPt5
         GMflUhEr6kS8wjIgBP+BZibygrDGaxn2vhlPuO2NvkJG1q3fQGzPXDk5BYPt8p+BrtsW
         TE8KQhHhNcf7PIEcVJDYoS93zAiF6HhtBnqSRbX8FJeoZBildN1p5vro1Juf2XQNnPQ+
         vpcpvB6/TT3FoLDLtrkJaIy2DCHOlHxsd+hUS70bP5eVQEsTSOTDoh+mFbp4QBc/b6Rs
         BxtSY2ZS2+RHJPDU16KfW3pl8E24bHD2/AaH1X4DxcL71KEIDD44roInqj8H8o4xfT3d
         XH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SXwg9Qtd9z+yr6yuTIDFyYnzsJGyQ8uOB6q3KpRENWY=;
        b=knvgg5q+19QgES3SVN0dlEda+lD5PnmKHYNSce8idx7J000Jdx3sMa5wnSrsN4tyh8
         DjaxgO84i+XdR0ofynK/MfzhvDn4AXyEMlGIqeDb3+9T88M9H/+R0oF5ZtcsEqiGI7zv
         0kCREVbSRz3oE76Rj0ketE7tH1G3qFHP7Zc14x5doIxT7m+TzQnVCRn4aq7LGrWlgpw+
         omyZC36vye8f+u+aHiR/YNbJis/kl+lomV7B25S6qIx2awD+2A9H+0sd1kwq4jtCyjvf
         GnLwkfNv7wNUU+Gxb8hWIDcsfZ/u5ZjOgWBJz0FpbGk3cQiYJdNM5cnamSqkat+/3W3d
         C3Fw==
X-Gm-Message-State: APjAAAV+8WXL6gCfCEbd5WJbfvWQxwM8mORpLTVv/Dze4qb/Rv0yF+hC
        OXxosYZCzCgXSSTBXHqO55bfdClui2LL374Uew==
X-Google-Smtp-Source: APXvYqwZbQgomN39nC020gDjS8z7VGgVlu1JFcYIZMXhF0OwkJPDxB8DMO/7h/YiIt3HFpS9ulPHcEbUjD/3jSRNG2A=
X-Received: by 2002:a05:6830:146:: with SMTP id j6mr12438571otp.205.1568035996810;
 Mon, 09 Sep 2019 06:33:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190906213054.48908-1-george.mccollister@gmail.com>
 <20190906213054.48908-3-george.mccollister@gmail.com> <6d8a915f-5f05-c91c-c139-26497376147d@denx.de>
In-Reply-To: <6d8a915f-5f05-c91c-c139-26497376147d@denx.de>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 9 Sep 2019 08:33:05 -0500
Message-ID: <CAFSKS=PMBQyAs_e_AVeOR2MaYgSM7OOUstg9V9e8D4zZngdjKw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: dsa: microchip: add ksz9567 to ksz9477 driver
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 6, 2019 at 4:42 PM Marek Vasut <marex@denx.de> wrote:
>
> On 9/6/19 11:30 PM, George McCollister wrote:
> > Add support for the KSZ9567 7-Port Gigabit Ethernet Switch to the
> > ksz9477 driver. The KSZ9567 supports both SPI and I2C. Oddly the
> > ksz9567 is already in the device tree binding documentation.
> >
> > Signed-off-by: George McCollister <george.mccollister@gmail.com>
> > ---
> >  drivers/net/dsa/microchip/ksz9477.c     | 9 +++++++++
> >  drivers/net/dsa/microchip/ksz9477_i2c.c | 1 +
> >  drivers/net/dsa/microchip/ksz9477_spi.c | 1 +
> >  3 files changed, 11 insertions(+)
> >
> > diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/micr=
ochip/ksz9477.c
> > index 187be42de5f1..50ffc63d6231 100644
> > --- a/drivers/net/dsa/microchip/ksz9477.c
> > +++ b/drivers/net/dsa/microchip/ksz9477.c
> > @@ -1529,6 +1529,15 @@ static const struct ksz_chip_data ksz9477_switch=
_chips[] =3D {
> >               .cpu_ports =3D 0x07,      /* can be configured as cpu por=
t */
> >               .port_cnt =3D 3,          /* total port count */
> >       },
> > +     {
> > +             .chip_id =3D 0x00956700,
> > +             .dev_name =3D "KSZ9567",
> > +             .num_vlans =3D 4096,
> > +             .num_alus =3D 4096,
> > +             .num_statics =3D 16,
> > +             .cpu_ports =3D 0x7F,      /* can be configured as cpu por=
t */
> > +             .port_cnt =3D 7,          /* total physical port count */
>
> I might be wrong, and this is just an idea for future improvement, but
> is .cpu_ports =3D GEN_MASK(.port_cnt, 0) always ?

GENMASK, not GEN_MASK. And I think it would be .cpu_ports =3D
GENMASK(.port_cnt - 1, 0).
I'm not sure if it would always be that. TBH I'm not sure if 0x7F is
even correct. For instance if a port has a PHY should it be excluded
from this mask or only if it doesn't support tail tagging? Maybe
someone would hook the CPU port up with a PHY instead of
RGMII/MII/RMII but it seems quite an odd thing to do.

On the KSZ9567R datasheet it shows 1-7 for this so if actually correct
I believe all ports support tail tagging but maybe some other variants
don't:
Port Operation Control 0 Register
Port N: 1-7
Bit 2 - Tail Tag Enable
When tail tagging is enabled for a port, it designates that port to be
the =E2=80=9Chost=E2=80=9D or =E2=80=9CCPU=E2=80=9D port. Do not enable tai=
l tagging for more than one
port.

My inclination is to leave it as is until a more compelling reason for
changing it arises.

>
> > +     },
> >  };
> >
> >  static int ksz9477_switch_init(struct ksz_device *dev)
> > diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/=
microchip/ksz9477_i2c.c
> > index 85fd0fb43941..c1548a43b60d 100644
> > --- a/drivers/net/dsa/microchip/ksz9477_i2c.c
> > +++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
> > @@ -77,6 +77,7 @@ MODULE_DEVICE_TABLE(i2c, ksz9477_i2c_id);
> >  static const struct of_device_id ksz9477_dt_ids[] =3D {
> >       { .compatible =3D "microchip,ksz9477" },
> >       { .compatible =3D "microchip,ksz9897" },
> > +     { .compatible =3D "microchip,ksz9567" },
> >       {},
> >  };
> >  MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
> > diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/=
microchip/ksz9477_spi.c
> > index 2e402e4d866f..f4198d6f72be 100644
> > --- a/drivers/net/dsa/microchip/ksz9477_spi.c
> > +++ b/drivers/net/dsa/microchip/ksz9477_spi.c
> > @@ -81,6 +81,7 @@ static const struct of_device_id ksz9477_dt_ids[] =3D=
 {
> >       { .compatible =3D "microchip,ksz9893" },
> >       { .compatible =3D "microchip,ksz9563" },
> >       { .compatible =3D "microchip,ksz8563" },
> > +     { .compatible =3D "microchip,ksz9567" },
> >       {},
> >  };
> >  MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
> >
>
> Reviewed-by: Marek Vasut <marex@denx.de>

Thanks.

>
> --
> Best regards,
> Marek Vasut
