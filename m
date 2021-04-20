Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8519365071
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 04:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbhDTCpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 22:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhDTCpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 22:45:38 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30FDC06174A;
        Mon, 19 Apr 2021 19:45:07 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id a11so34889315ioo.0;
        Mon, 19 Apr 2021 19:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6Kc1WbDSgXVF94sOsNH1trNDlACUDpdbFDZEbig89pA=;
        b=kNAT3YzgNvaNZB0qOxA6Rl2nnRij+0GxT5xm9OyKbkef8xLre1BqFzCJnN65aR1rtM
         56wdPz7FSRNTu39vBtx+s9TD7gtmKAGkai5F4plMFXk+sdLz+nNW851qYZ/F3etBPk1U
         fXZ3lc1AatbD9+Aht2Pel0l+6tt5nWUFqxhGvaY8wErivLRkTWnzhrtxwi7ap+7/Vz46
         FSszDXHBqRhJ1PaIcs1x2OampQE65supyYZuVR659CqQpqrB5syZD7B3lgEpnKsyrDRb
         ifu03BHhiy54xNMvgGZ2B5OewxA6OIsNXt8l+BfLTzERvN82KqbvVKzw7K6I6paAiTLs
         V+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6Kc1WbDSgXVF94sOsNH1trNDlACUDpdbFDZEbig89pA=;
        b=fMTQXUgfwXp9oGADPfA6SykdJKwicuobd8IVZu+57aTbkObLzirQmRkV1R+vc5498F
         uJcTPcuGcrGbTr1q56+OnqFpFg42WhgZdc7QrQ4mxgMByA5q0q2oewNjCipB+Vgymbsw
         lc+cG5sxWNqdklaWr6nGo89YD8I06j6BbKrq98lcXSYtzq/c6bBtss2KFt+S5txcGgmg
         lOWwiDcgnY82LJXzvvJC3G29enIFFtd6CnsUg5nPwoX3TjrH40krZvYHEFtbBuredBUl
         /4ronThJX0tQRoV7xApc2Fglpm3zLb724V29Z4jVmrWJxATRzebzoP3Xp01ro01df5L/
         Liwg==
X-Gm-Message-State: AOAM532rI8ivjY2/wT1l5hIqI2b8abi0eoWBh/SQvPza5Om4pVh37sAF
        pIksTHzwm1td0eL89I/cnourG1TWXdyexP32fvisSsKob9/AyA==
X-Google-Smtp-Source: ABdhPJyu3r8FHInxVHB6FMEsM++ZSS/SzxyQ0Ov3kKdZPFntmoTWDCdi5kG/Pu7kLZ/UX5r2ZH7m5Nb4ZfBgNrrPuaQ=
X-Received: by 2002:a02:a302:: with SMTP id q2mr11251853jai.104.1618886706664;
 Mon, 19 Apr 2021 19:45:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210419034253.21322-1-ilya.lipnitskiy@gmail.com> <878s5e94hi.fsf@miraculix.mork.no>
In-Reply-To: <878s5e94hi.fsf@miraculix.mork.no>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Mon, 19 Apr 2021 19:44:55 -0700
Message-ID: <CALCv0x2CzL3PLw+r2f5rU_Uu04wn3kR3R-fn=kAfmksuAsjwLw@mail.gmail.com>
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
>
> I believe that file should go away. These two files are both documenting
> the same compatible property AFAICS.
Removed along with two others in
https://lore.kernel.org/lkml/20210420024222.101615-1-ilya.lipnitskiy@gmail.=
com/T/#u

Ilya
