Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF703646CC
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 17:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239416AbhDSPNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 11:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhDSPNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 11:13:00 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4310C06174A;
        Mon, 19 Apr 2021 08:12:29 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id x16so35252617iob.1;
        Mon, 19 Apr 2021 08:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=enuxCBzOZSQQTThLvTHnDCBlihynTSHnXViR8rDBbQQ=;
        b=Jg7U7ipVmPDaLTK17RAAkpjGW0FoPQs+7OlUy+j89+geITJnhZvHkWherjiRVDAt5T
         sjBI57LusNfXqTaaIuYrZKirU6Ij+Wy0aha0OiMDG10sogLWOsr70QsFrlY59DZEfZ2o
         E6dUvyk4OOjNVdz37XumfoopH3wnI8kASbul2Q60t52qwVgxrBHH3ZkV9snAjkuNiIBF
         0DElQfdZ78U8e0KH0jlkROoZl6fPARkFGtb1rIP8h+HLLLh5Tg9VfrR4si6xZfekwEFA
         2uaQrXmS7S9mocFWnmuTvPrqKQqKlcgBSIwBopBWFscgX0+GsDxpEhr5kP7A4rjQs2bp
         gX5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=enuxCBzOZSQQTThLvTHnDCBlihynTSHnXViR8rDBbQQ=;
        b=m/FROK/GjSKikLUyHt29VSphnEPaBd6WPWhDHQaFFRV8XyhuAZFzrjcpnbZpW+Sc5r
         GfMfX7xbQNtWwHuo6j/EOluZijcEU0uzPZUxMGdDiScU44E/Q/q3g2zzTZPErGl3uinG
         13eWHqLtId8sWkZ8iX1E8WhrXOl3TqCAl4C/LpWpGJv9wcg8D4Z2Nb+Ht6Q3cIw9XckP
         DhR+XFQBWD4ORY9xB5jc44/O+llDrC9T/H2V91XZSlewVN8+J3waN29fy9K1neLeEL9v
         WkCtVcBuOeL3rYOZPaE5wsAdY69TKvdsvOQUM1dqGpFMIK+WRRCtNVv94FJIHp2LW96s
         4VRw==
X-Gm-Message-State: AOAM532gXCEAMMIgsko2k7tRwIT/xuQPyVHKrGIjssBxm7bpglVv9yck
        wnw6j/OS4BI03iu7+ViPnJNVKr7X32p3IKPBups=
X-Google-Smtp-Source: ABdhPJxoUl6YJfpW7AMeJwEOa5A6FXIH6OX8VLWw+H7/eB475YO1aN9eBJmUgllZaJjRPtUS8JmaST9N86i7Ln04Gig=
X-Received: by 2002:a6b:b542:: with SMTP id e63mr11488250iof.144.1618845149416;
 Mon, 19 Apr 2021 08:12:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210419034253.21322-1-ilya.lipnitskiy@gmail.com> <878s5e94hi.fsf@miraculix.mork.no>
In-Reply-To: <878s5e94hi.fsf@miraculix.mork.no>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Mon, 19 Apr 2021 08:12:18 -0700
Message-ID: <CALCv0x1Z2rXJtRTh9WQfPMBfVkfosg00kqEmo1uB6RJeNLptJw@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: mediatek: support MT7621 SoC
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Greg Ungerer <gerg@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sean Wang <sean.wang@kernel.org>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 18, 2021 at 11:24 PM Bj=C3=B8rn Mork <bjorn@mork.no> wrote:
>
> Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com> writes:
>
> > Add missing binding documentation for SoC support that has been in plac=
e
> > since v5.1
> >
> > Fixes: 889bcbdeee57 ("net: ethernet: mediatek: support MT7621 SoC ether=
net hardware")
> > Cc: Bj=C3=B8rn Mork <bjorn@mork.no>
> > Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> > ---
> >  Documentation/devicetree/bindings/net/mediatek-net.txt | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/Documentation/devicetree/bindings/net/mediatek-net.txt b/D=
ocumentation/devicetree/bindings/net/mediatek-net.txt
> > index 72d03e07cf7c..950ef6af20b1 100644
> > --- a/Documentation/devicetree/bindings/net/mediatek-net.txt
> > +++ b/Documentation/devicetree/bindings/net/mediatek-net.txt
> > @@ -10,6 +10,7 @@ Required properties:
> >  - compatible: Should be
> >               "mediatek,mt2701-eth": for MT2701 SoC
> >               "mediatek,mt7623-eth", "mediatek,mt2701-eth": for MT7623 =
SoC
> > +             "mediatek,mt7621-eth": for MT7621 SoC
> >               "mediatek,mt7622-eth": for MT7622 SoC
> >               "mediatek,mt7629-eth": for MT7629 SoC
> >               "ralink,rt5350-eth": for Ralink Rt5350F and MT7628/88 SoC
>
>
> Thanks for taking care of this!
>
> Note, however, that this compatible value is defined in
> Documentation/devicetree/bindings/net/ralink,rt2880-net.txt
Good point. I don't think there is a driver in-tree for that binding.
It looks like commit 663148e48a66 ("Documentation: DT: net: add docs
for ralink/mediatek SoC ethernet binding") should just be reverted and
the three documents (mediatek,mt7620-gsw.txt; ralink,rt2880-net.txt;
ralink,rt3050-esw.txt) removed. Any objections?

Ilya
