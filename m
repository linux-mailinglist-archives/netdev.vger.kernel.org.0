Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 205D929F72
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 21:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391741AbfEXTzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 15:55:51 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37507 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391181AbfEXTzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 15:55:50 -0400
Received: by mail-ed1-f65.google.com with SMTP id w37so15852446edw.4
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 12:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xYoblHIjWREsb1CER3WlpFrUxZYTNSvxN3lyqahFHXg=;
        b=HsaAIvCecfR5ySvhY0taweNxZutsgKPkGBJSGK4pSU/mqP7bk8TY0dr+I4nTqIdd+2
         1pl/Cfc5473hswJpwZaMmAUAg78o+uuXweXprkzdQYCD4UsctdUh1XeWw+ZxEQDevjHq
         GtvCRiIMwHTgUKKz71p/o6NhWRvMBU7NDLIqk7yRDnsGKEIkXmLRTdaqjY8h2XJuG2As
         5gT3wOK5JqUA4AfLfbzxfhUBj8OFa2q+LkicNkg/U7A50yqz/s5zZ8zqENZpLmF8TUTB
         qhUw2Y6lczpVDKeF0eRWJmemtzPXZtmZt52gTnP7mn2n8fINBUeaRN89Ip8mOko/Ba8S
         rGZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xYoblHIjWREsb1CER3WlpFrUxZYTNSvxN3lyqahFHXg=;
        b=ZjfjlLpg84fYViLc/sdfEHFRJUldaldCJTGBtPyI4QTK242FDLwr51iO+Hxw8xMBLL
         qtZotswopQiTMS79yy+vOBLXBeISKju9x6F2Xmsvzvsb60SP+o6EUAVHHZwxCIXlS0uR
         aij/JhPGaX/f2/5VzqVGR+Hd0EWDOY0r3p6O/u1/UHqqyGaeqh1YUAhgTlgoX+UbSrvs
         hITZowlXmCH6l4HD9+eOf1t58HR1C502a0H3yAusn2L6XIgo7Qkbgk3eMu+T23GBp6Wm
         kVzDlot1DffmimVkIUA1XXQ+LhjUYJp5YOh7PSHyoOAoxUHpvcW8qtzVuJTHV0WdY2h/
         8VAw==
X-Gm-Message-State: APjAAAUPTBdVb42AD1pXnSwBPr9JD8apVOCSzGYlJPp8UGhF47vX6GPO
        JMOMqooEMHURXMzuXLEgPKuJhK3+slexaI2TkJ05r2kf6DUhBw==
X-Google-Smtp-Source: APXvYqwenXurfj9iDxxbfKyTb3pLKxvQCt0MEApNFNrk9zIH1ycwMmVRA4jYZSZ7csktbF8fPdEy72TeRE2fYtTTdxs=
X-Received: by 2002:a17:906:14db:: with SMTP id y27mr12644166ejc.132.1558727749538;
 Fri, 24 May 2019 12:55:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190524102541.4478-1-muvarov@gmail.com> <20190524102541.4478-3-muvarov@gmail.com>
 <4cd0770d-5eca-a153-1ed3-32472a1a8860@gmail.com>
In-Reply-To: <4cd0770d-5eca-a153-1ed3-32472a1a8860@gmail.com>
From:   Maxim Uvarov <muvarov@gmail.com>
Date:   Fri, 24 May 2019 22:55:38 +0300
Message-ID: <CAJGZr0LfJ5YeDRaTOsADLR+YyLQAwZoKhhtSNL1wiYhEu4uk8w@mail.gmail.com>
Subject: Re: [PATCH 2/3] net:phy:dp83867: increase SGMII autoneg timer duration
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=D0=BF=D1=82, 24 =D0=BC=D0=B0=D1=8F 2019 =D0=B3. =D0=B2 20:24, Heiner Kallw=
eit <hkallweit1@gmail.com>:
>
> On 24.05.2019 12:25, Max Uvarov wrote:
> > After reset SGMII Autoneg timer is set to 2us (bits 6 and 5 are 01).
> > That us not enough to finalize autonegatiation on some devices.
> > Increase this timer duration to maximum supported 16ms.
> >
> > Signed-off-by: Max Uvarov <muvarov@gmail.com>
> > ---
> >  drivers/net/phy/dp83867.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> > index afd31c516cc7..66b0a09ad094 100644
> > --- a/drivers/net/phy/dp83867.c
> > +++ b/drivers/net/phy/dp83867.c
> > @@ -297,6 +297,19 @@ static int dp83867_config_init(struct phy_device *=
phydev)
> >                       WARN_ONCE(1, "dp83867: err DP83867_10M_SGMII_CFG\=
n");
> >                       return ret;
> >               }
> > +
> > +             /* After reset SGMII Autoneg timer is set to 2us (bits 6 =
and 5
> > +              * are 01). That us not enough to finalize autoneg on som=
e
> > +              * devices. Increase this timer duration to maximum 16ms.
> > +              */
> In the public datasheet the bits are described as reserved. However, base=
d on
> the value, I suppose it's not a timer value but the timer resolution.

No, it's public:
http://www.ti.com/lit/ds/symlink/dp83867e.pdf page 72.

SGMII Auto-Negotiation Timer Duration.

>
> > +             val =3D phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_CFG=
4);
> > +             val &=3D ~(BIT(5) | BIT(6));
> > +             ret =3D phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_CF=
G4, val);
> > +             if (ret) {
> > +                     WARN_ONCE(1, "dp83867: error config sgmii auto-ne=
g timer\n");
> > +                     return ret;
>
> Same comment as for patch 1.

Yes, the same answer. I want to capture hardware error then silently
return error and then debug it.
WARN is more informative then some random "phy not detected" things.

Max.

>
> > +             }
> > +
> >       }
> >
> >       /* Enable Interrupt output INT_OE in CFG3 register */
> >
>
