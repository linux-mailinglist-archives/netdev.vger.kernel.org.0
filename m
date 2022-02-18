Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8198E4BB924
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 13:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235169AbiBRM2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 07:28:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235194AbiBRM2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 07:28:30 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609953192F;
        Fri, 18 Feb 2022 04:28:13 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id vz16so14801673ejb.0;
        Fri, 18 Feb 2022 04:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=C1lw7uNZm/xyouZ1Wh64rNvsOy0Q10dXbE6lSVaApf8=;
        b=WLdDx9a9lWqvO19IakmF3Nw0GE1EoDLf1CJkpsB9DRxNNf0td+f3pOypJyNtH+2nsy
         zeY6y9rCqD+b0DV9h6O/hNJrC3ZsydnbYHoHZ9rI5fbliaNDXPWKwHCDPtO1cxT3eYhF
         lVzHtqmPVBSQ2rCamvC83WvfuX+4yhqUzV1Ga1Rq5ppyTvmTAVwYq2LkA9H0RVqf+cg5
         qeS2Em7ftH6RGkJEnHrMUR24t2lSH+vhLq1kAyZIqehHNkovM1oIBds8yk+7WRguw7QC
         hnLecIoTOyI6YeKXlq7fP0G2PpVQKGBeLQFMPaFeeaozVE4MJ2U79hCOKIPkXz7EeI88
         clVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=C1lw7uNZm/xyouZ1Wh64rNvsOy0Q10dXbE6lSVaApf8=;
        b=JfuGellLvYE8RtYKE42P19TDhQXB1kU3fDGF4jNbZfpjY4CS4trGuR0wAYFoA8aNN/
         Mur1cOtr2AN0/wXxM9QHAJlPculdhslKQCiOvMh5MS2jITewpw5Ov2ICOuailcVe8k7y
         G7fflcBDXI9nmeUuseCuHF6zFuaIcvN5O06JT8dj9fBnCWPY83ri6xBr8JuFj5rfBrxK
         nmLzdkNXlswCV7H/b7TO4b1AUtazeyBP4BgFmTarDVnqmOl7S/cj7cPgn9bkNQ0sk3N1
         GRV5sRCqVUYTVVg86apxRJ8hLV7HIgFQOi0EOpq2euijitnz58RlySVHAShe5fVQwMVL
         38qA==
X-Gm-Message-State: AOAM530jdFMA4Ul7MG93veERt67MMKYftJUFt2zz4Li0vYPGl9AIPEQD
        9bfWYAsfPZgeNTCD8/DmfrXyW+Bb9acQyH7Ay7s=
X-Google-Smtp-Source: ABdhPJzmufdHi2qeP40w0kPofkBS5uKHhZyG2fz1SdKqwSpc/U18+vtL7ELPl2edHgikgfAPloTLE3V7DNZe+3Q2RBU=
X-Received: by 2002:a17:907:9956:b0:6cf:cd25:c5a7 with SMTP id
 kl22-20020a170907995600b006cfcd25c5a7mr6007905ejc.635.1645187291927; Fri, 18
 Feb 2022 04:28:11 -0800 (PST)
MIME-Version: 1.0
References: <20220217160528.2662513-1-hardware.evs@gmail.com>
 <AM6PR04MB39761CAFB51985AFC203C535EC379@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <CAEDiaShTrWgA75e8x2deHMHF-53LFiusrVHTxP_Jy4gvaLg_9A@mail.gmail.com> <AM6PR04MB397692A930803C5CB6B1D568EC379@AM6PR04MB3976.eurprd04.prod.outlook.com>
In-Reply-To: <AM6PR04MB397692A930803C5CB6B1D568EC379@AM6PR04MB3976.eurprd04.prod.outlook.com>
From:   EVS Hardware Dpt <hardware.evs@gmail.com>
Date:   Fri, 18 Feb 2022 13:28:00 +0100
Message-ID: <CAEDiaSg8SZWyoiX6jJYCX4HncZks5O8dyyVLOchYD4idGf4rCg@mail.gmail.com>
Subject: Re: [PATCH 1/2] net/fsl: fman: Allow fm_max_frame_sz &
 rx_extra_headroom config from devicetree.
To:     Madalin Bucur <madalin.bucur@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Madalin, Guys,

I didn't have that historical part in mind. So, even if I still think there
are a lot of examples super close to what I'm proposing everywhere in
dts files, devicetree is out of equation.

Could I change the patchset to allow configuration of those two parameters
from config ? I won't remove configuration using module parameters,
just adding (what I think to be) an easier way of configuration.

What do you think?

Regards,
Fred.

Le ven. 18 f=C3=A9vr. 2022 =C3=A0 12:33, Madalin Bucur <madalin.bucur@nxp.c=
om> a =C3=A9crit :
>
> > -----Original Message-----
> > From: EVS Hardware Dpt <hardware.evs@gmail.com>
> > Subject: Re: [PATCH 1/2] net/fsl: fman: Allow fm_max_frame_sz &
> > rx_extra_headroom config from devicetree.
> >
> > Hi Madalin, Guys
> >
> > I know, but it's somewhat difficult to use those parameters on kernel's
> > command line.
> > I don't think it's wrong to also add that in devicetree.
> > No removal, just an added feature.
> >
> > For ethernet node in devicetree, there are a lot of configuration stuff
> > like
> > max-frame-size to allow configuration of MTU
> > (and so potentially enable jumbo) and it's regarded as fine.
> >
> > It's also the goal of this patch. Allow an easy configuration of
> > fsl_fm_max_frm from a dts. I added rx_extra_headroom for the sake of
> > completeness.
> >
> > So I plead for this addition because I don't think it's wrong to do tha=
t
> > and
> > I consider it's nicer to add an optional devicetree property rather tha=
n
> > adding a lot of obscure stuff on kernel's command line.
> >
> > Hope you'll share my point of view.
> >
> > Have a nice weekend Madalin, Guys,
> > Fred.
>
> Hi, Fred,
>
> I understand your concerns in regards to usability but the device trees, =
as
> explained earlier by Jakub, have a different role - they describe the HW,
> rather than configure the SW on it. Removal of such config entries from t=
he
> device tree was one item on a long list to get the DPAA drivers upstreame=
d.
>
> > Le ven. 18 f=C3=A9vr. 2022 =C3=A0 08:23, Madalin Bucur <madalin.bucur@n=
xp.com> a
> > =C3=A9crit :
> > >
> > > > -----Original Message-----
> > > > From: Fred Lefranc <hardware.evs@gmail.com>
> > > > Subject: [PATCH 1/2] net/fsl: fman: Allow fm_max_frame_sz &
> > > > rx_extra_headroom config from devicetree.
> > > >
> > > > Allow modification of two additional Frame Manager parameters :
> > > > - FM Max Frame Size : Can be changed to a value other than 1522
> > > >   (ie support Jumbo Frames)
> > > > - RX Extra Headroom
> > > >
> > > > Signed-off-by: Fred Lefranc <hardware.evs@gmail.com>
> > >
> > > Hi, Fred,
> > >
> > > there are module params already for both, look into
> > >
> > > drivers/net/ethernet/freescale/fman/fman.c
> > >
> > > for fsl_fm_rx_extra_headroom and fsl_fm_max_frm.
> > >
> > > Regards,
> > > Madalin
