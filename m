Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 928A486C19
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 23:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390392AbfHHVKE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Aug 2019 17:10:04 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40872 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732427AbfHHVKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 17:10:03 -0400
Received: by mail-lj1-f194.google.com with SMTP id m8so56596305lji.7
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 14:10:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=evKrNs0X1uQHFupHQ4e1H+JbvwSVldaodvk2360XbX8=;
        b=ZJmpQJraQpCcfefxDVRFenqE4FNet/kfd/co0xEHQ7gXJbyUnhFmRi+fEjAex0sNEY
         +0W4Koh5zb4Sn7O+nBmJzE5x4hWUSfPW+XPvzIsBBs3KSo2cTwL1cXs5jtFH/jwOWVRD
         eZu38LIuizVBJrSGvCxF1Z4DQRhO4yP7bXoAsvXcD6tCNkBwEuOEfhnk77fbXoePTewn
         SvAFuh7TjofWtpMQSx5YZfiwrx3T1u2BlkxNr4S06Ck2HMFcaBh8HBIkI+ElrYTAO5wB
         a3X/C3gbkp2irZLCTPNU4QpgkncZXX4VuE5mlCKktHkCTROofOMsdx5KnhAu4sBkxzdR
         cMPg==
X-Gm-Message-State: APjAAAVJ2hBG2CQ2VHzAqTR5U4pV/sOIOCTV17mPPpohE+OnhS77Heiw
        ogoE793X5nBcbGH1prTuQKBXGjJu9X8=
X-Google-Smtp-Source: APXvYqyOjKHv4xjkGM7YZ0YwOTFm8msd+yhzY/ZtxPj7OZIf+VEC7vhSlgb3K8lPwftE/QL+VPRjQA==
X-Received: by 2002:a2e:9048:: with SMTP id n8mr9425484ljg.37.1565298600375;
        Thu, 08 Aug 2019 14:10:00 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id b2sm24868lje.98.2019.08.08.14.09.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 14:09:59 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id a30so4835296lfk.12
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 14:09:59 -0700 (PDT)
X-Received: by 2002:a19:cbc4:: with SMTP id b187mr10182066lfg.27.1565298599300;
 Thu, 08 Aug 2019 14:09:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190714200501.1276-1-valentin@longchamp.me> <CADYrJDwvwVThmOwHZ4Moqenf=-iqoHC+yJ_uxtrD8sDso33rjg@mail.gmail.com>
 <2243421e574c72c5e75d27cc0122338e2e0bde63.camel@buserror.net> <VI1PR04MB55679AAE8DDC3160B9CCE073ECDC0@VI1PR04MB5567.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB55679AAE8DDC3160B9CCE073ECDC0@VI1PR04MB5567.eurprd04.prod.outlook.com>
From:   Valentin Longchamp <valentin@longchamp.me>
Date:   Thu, 8 Aug 2019 23:09:49 +0200
X-Gmail-Original-Message-ID: <CADYrJDxsQ3H7b_BHOfmfTNb1OuXt+vzTg4k8Goj8tKPaaOMz_g@mail.gmail.com>
Message-ID: <CADYrJDxsQ3H7b_BHOfmfTNb1OuXt+vzTg4k8Goj8tKPaaOMz_g@mail.gmail.com>
Subject: Re: [PATCH] powerpc/kmcent2: update the ethernet devices' phy properties
To:     Madalin-cristian Bucur <madalin.bucur@nxp.com>
Cc:     Scott Wood <oss@buserror.net>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le mar. 30 juil. 2019 à 11:44, Madalin-cristian Bucur
<madalin.bucur@nxp.com> a écrit :
>
> > -----Original Message-----
> >
> > > Le dim. 14 juil. 2019 à 22:05, Valentin Longchamp
> > > <valentin@longchamp.me> a écrit :
> > > >
> > > > Change all phy-connection-type properties to phy-mode that are better
> > > > supported by the fman driver.
> > > >
> > > > Use the more readable fixed-link node for the 2 sgmii links.
> > > >
> > > > Change the RGMII link to rgmii-id as the clock delays are added by the
> > > > phy.
> > > >
> > > > Signed-off-by: Valentin Longchamp <valentin@longchamp.me>
> >
> > I don't see any other uses of phy-mode in arch/powerpc/boot/dts/fsl, and I see
> > lots of phy-connection-type with fman.  Madalin, does this patch look OK?
> >
> > -Scott
>
> Hi,
>
> we are using "phy-connection-type" not "phy-mode" for the NXP (former Freescale)
> DPAA platforms. While the two seem to be interchangeable ("phy-mode" seems to be
> more recent, looking at the device tree bindings), the driver code in Linux seems
> to use one or the other, not both so one should stick with the variant the driver
> is using. To make things more complex, there may be dependencies in bootloaders,
> I see code in u-boot using only "phy-connection-type" or only "phy-mode".
>
> I'd leave "phy-connection-type" as is.

So I have finally had time to have a look and now I understand what
happens. You are right, there are bootloader dependencies: u-boot
calls fdt_fixup_phy_connection() that somehow in our case adds (or
changes if already in the device tree) the phy-connection-type
property to a wrong value ! By having a phy-mode in the device tree,
that is not changed by u-boot and by chance picked up by the kernel
fman driver (of_get_phy_mode() ) over phy-connection-mode, the below
patch fixes it for us.

I agree with you, it's not correct to have both phy-connection-type
and phy-mode. Ideally, u-boot on the board should be reworked so that
it does not perform the above wrong fixup. However, in an "unfixed"
.dtb (I have disabled fdt_fixup_phy_connection), the device tree in
the end only has either phy-connection-type or phy-mode, according to
what was chosen in the .dts file. And the fman driver works well with
both (thanks to the call to of_get_phy_mode() ). I would therefore
argue that even if all other DPAA platforms use phy-connection-type,
phy-mode is valid as well. (Furthermore we already have hundreds of
such boards in the field and we don't really support "remote" u-boot
update, so the u-boot fix is going to be difficult for us to pull).

Valentin

>
> Madalin
>
> > > > ---
> > > >  arch/powerpc/boot/dts/fsl/kmcent2.dts | 16 +++++++++++-----
> > > >  1 file changed, 11 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/arch/powerpc/boot/dts/fsl/kmcent2.dts
> > > > b/arch/powerpc/boot/dts/fsl/kmcent2.dts
> > > > index 48b7f9797124..c3e0741cafb1 100644
> > > > --- a/arch/powerpc/boot/dts/fsl/kmcent2.dts
> > > > +++ b/arch/powerpc/boot/dts/fsl/kmcent2.dts
> > > > @@ -210,13 +210,19 @@
> > > >
> > > >                 fman@400000 {
> > > >                         ethernet@e0000 {
> > > > -                               fixed-link = <0 1 1000 0 0>;
> > > > -                               phy-connection-type = "sgmii";
> > > > +                               phy-mode = "sgmii";
> > > > +                               fixed-link {
> > > > +                                       speed = <1000>;
> > > > +                                       full-duplex;
> > > > +                               };
> > > >                         };
> > > >
> > > >                         ethernet@e2000 {
> > > > -                               fixed-link = <1 1 1000 0 0>;
> > > > -                               phy-connection-type = "sgmii";
> > > > +                               phy-mode = "sgmii";
> > > > +                               fixed-link {
> > > > +                                       speed = <1000>;
> > > > +                                       full-duplex;
> > > > +                               };
> > > >                         };
> > > >
> > > >                         ethernet@e4000 {
> > > > @@ -229,7 +235,7 @@
> > > >
> > > >                         ethernet@e8000 {
> > > >                                 phy-handle = <&front_phy>;
> > > > -                               phy-connection-type = "rgmii";
> > > > +                               phy-mode = "rgmii-id";
> > > >                         };
> > > >
> > > >                         mdio0: mdio@fc000 {
> > > > --
> > > > 2.17.1
> > > >
> > >
> > >
>
