Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61483319312
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 20:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhBKT1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 14:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbhBKT1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 14:27:04 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C05CC061756
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 11:26:24 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id x3so5015826qti.5
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 11:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SPfnsSxHjOU0EO90H+0z4pIXdOqXdbqu3ojr4t/JMSA=;
        b=KJXpTn4FoVCntABO/wHHn91KO2J+Q+z3ozOL0wPxCTOjdE3VwScClNNzKmgw9b1O9K
         SsKKc4aBwTmqZLu1Z0dtK1uLD2pUi4vpQP7RLAl6yOTn5IzB9u0vlnzySrLNd/9yYHLR
         RM0PjSKru9EVccJRkScy6P7b0LV2YqV0qZxIGHf31cZ7CkdpU/aq6+VC4Z97kHMkq43s
         Gs6lvKKqdTofYDWogH66RAcLlQ1JmAsuMcnF49XkAmJd21Gf5Bd6Lmx9sd0Z3ihstj8F
         X/l8J91WVLv7vNhA/TO+iWkqahCakyNOxhYuGbTYUClGFoAoilFB4pDZ25PdfEld9P3j
         lvAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SPfnsSxHjOU0EO90H+0z4pIXdOqXdbqu3ojr4t/JMSA=;
        b=b2391WpjPjiQio9x5W8WN7oUX2nHO+lsTASl1E5nWS2EuAEdKNr4F25YQ6sekaTrAT
         cooZ+lxnEfaI9HwEvFR7vcoM2/Q0ficK+sHV1EsbQkXN9subGjaIj8TN1Qimva+zmYlS
         y7cuNhGmzSta9zC84MfK7XeH3OxpM+OUMXNsVrFimv4WNrwy8I8VMKjLZ7HCTTSrsExp
         uOdzALSnbXrQ09bDS7ChnmAsIvihY3Mvgq6raeHvSdr5LX1/qg+Cb1stNhQOVmzqHUta
         RKXrH/kK+fQhwJDbNq11XioQSLeFjnvTH5r/bVN8wj6U+eSXB9bmo2ljICxtcc6yg4ln
         /Mew==
X-Gm-Message-State: AOAM530MDJW8hMwfiMN96dGpm+VwdrM3CzzvYJNZsi4kaoMbs3Y7jTqN
        8BYU3hPa3vpo+/Zi8wV+LOeQoGJuJq5RzrRYjDXGcQ==
X-Google-Smtp-Source: ABdhPJzi/HMDdzkfbFoD2hx2WTj4HKVz46WWQqa5il0MFIDdf2QKAcCtgCWR5EItM/AR8RN/HDig5gtCFoxpUlC7q5A=
X-Received: by 2002:ac8:a82:: with SMTP id d2mr8771145qti.343.1613071583329;
 Thu, 11 Feb 2021 11:26:23 -0800 (PST)
MIME-Version: 1.0
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
 <1613040542-16500-6-git-send-email-stefanc@marvell.com> <20210211114238.GD1463@shell.armlinux.org.uk>
 <CO6PR18MB38739CA874F3748919C8361CB08C9@CO6PR18MB3873.namprd18.prod.outlook.com>
In-Reply-To: <CO6PR18MB38739CA874F3748919C8361CB08C9@CO6PR18MB3873.namprd18.prod.outlook.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 11 Feb 2021 20:26:10 +0100
Message-ID: <CAPv3WKcXM9CP4bgo5CYdTcZ9ivyAr=4bTArfrAFp7-8dMjiMtQ@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH v13 net-next 05/15] net: mvpp2: add PPv23
 version definition
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

czw., 11 lut 2021 o 12:49 Stefan Chulski <stefanc@marvell.com> napisa=C5=82=
(a):
>
> > ----------------------------------------------------------------------
> > On Thu, Feb 11, 2021 at 12:48:52PM +0200, stefanc@marvell.com wrote:
> > > From: Stefan Chulski <stefanc@marvell.com>
> > >
> > > This patch add PPv23 version definition.
> > > PPv23 is new packet processor in CP115.
> > > Everything that supported by PPv22, also supported by PPv23.
> > > No functional changes in this stage.
> > >
> > > Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> > > Acked-by: Marcin Wojtas <mw@semihalf.com>
> >
> > Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
> >
> > > @@ -7049,6 +7049,11 @@ static int mvpp2_probe(struct platform_device
> > *pdev)
> > >                     priv->port_map |=3D BIT(i);
> > >     }
> > >
> > > +   if (priv->hw_version !=3D MVPP21) {
> > > +           if (mvpp2_read(priv, MVPP2_VER_ID_REG) =3D=3D
> > MVPP2_VER_PP23)
> > > +                   priv->hw_version =3D MVPP23;
> > > +   }
> > > +
> >
> > The only minor comment I have on this is... the formatting of the above=
.
> > Wouldn't:
> >
> >       if (priv->hw_version >=3D MVPP22 &&
> >           mvpp2_read(priv, MVPP2_VER_ID_REG) =3D=3D MVPP2_VER_PP23)
> >               priv->hw_version =3D MVPP23;
> >
> > read better?
> >
> > Do we need to even check priv->hw_version here? Isn't this register
> > implemented in PPv2.1 where it contains the value zero?
>
> Yes, we can just:
>         if (mvpp2_read(priv, MVPP2_VER_ID_REG) =3D=3D MVPP2_VER_PP23)
>                 priv->hw_version =3D MVPP23;
>
>

I checked the A375 specs and cannot see this particular register. Can
you please double check whether this register is in the old version of
the IP and the Functional Spec is incomplete?

Thanks,
Marcin
