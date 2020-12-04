Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D557D2CF556
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 21:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730744AbgLDUJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 15:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbgLDUJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 15:09:52 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D54C0613D1;
        Fri,  4 Dec 2020 12:09:12 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id ck29so7102448edb.8;
        Fri, 04 Dec 2020 12:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4t1dy5iRiZB4Z+/OzIHXwSJSK8rY8jRfJx3So3UXm0Q=;
        b=NZHTcA6d7YsdqBUPEFkSI7fq7cm7J9Fw10khd8L5+/zmv4ZE+yE0bZ3nLcC1OeiL3p
         Y/MLmZRvjpBGboubpgbdGQRF4yKufCK1/3OJdu78bQjaOnjppmD0bwncrwtacJv84+y+
         VtiAlzM7uusXvO+BizPMXmpyfYRePpCHw21IOBhfdM6nbZU4/LQI02E2BM3/SivKttOM
         QNe8snLLbTf3HKeDRBtc7DhaVr3JaJ6seo+B3PVTyk4MzoAIOpsfoKxJpI/7HJEDX/QV
         vb0NU0GLoenDmYTNN/wym/qb386OXKfFz8t+2+yk1+YewTL5hNMb9mNRLwiBb7QHwquB
         aUBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4t1dy5iRiZB4Z+/OzIHXwSJSK8rY8jRfJx3So3UXm0Q=;
        b=Zv6DKYHhvwZqiBuQMivVNQohl9dhFuevMKDHA7XljKCatQbTyFzbTKtcYLu7/oC+42
         DnmfGiVHIHd2ppSlSDG7G+U03U9/rzAK5jWxOmt/IJSt2egTzD+/pNva49kIOY3cOPxg
         7lHs2YAxiY3TG8SCXDjMED8EIJ6PbxpGRbg3aJJXqNCzDli4TIHxHAV57NQ1srMw6Rdx
         ZhyA7y+gr0mp+8d4P7mici4Ax3df8xuY1rtDvE3nSMQYPoFr3BohoeunzCGSX7jJ7SLU
         4+IM/3KXwslEFzxi7g/FMGpkdIt/P2Cioa3bIHJXX0+Z9YKNarjxMMlIerHw0lY3OADH
         Hf+g==
X-Gm-Message-State: AOAM533sdbJguASTrnMF+ECw88lrtkjUlLuJm+T9QBH6QZbyfrx00FsN
        zvrU7ZmRoipWP/lKi4ZT5W01ti0ZqdhQPziAc8o=
X-Google-Smtp-Source: ABdhPJw29Ny5tk93CP19n/cXJG3k+SPWXKMugsVKasXMCXVwC8umIy/MOTY0KX2IylR0UdFMPeB5zvNKRAfkntxWNYs=
X-Received: by 2002:aa7:d9c1:: with SMTP id v1mr9271107eds.115.1607112551102;
 Fri, 04 Dec 2020 12:09:11 -0800 (PST)
MIME-Version: 1.0
References: <20201128225425.19300-1-adrien.grassein@gmail.com>
 <20201129220000.16550-1-adrien.grassein@gmail.com> <20201129224113.GS2234159@lunn.ch>
 <CABkfQAFcSNMeYEepsx0Z6tuaif-dQhE2YBMK54t1hikAvzdASg@mail.gmail.com>
 <20201129230416.GT2234159@lunn.ch> <bb81c90c-d79e-d944-e35e-305da23d9e58@gmail.com>
 <20201130222645.GG2073444@lunn.ch>
In-Reply-To: <20201130222645.GG2073444@lunn.ch>
From:   Adrien Grassein <adrien.grassein@gmail.com>
Date:   Fri, 4 Dec 2020 21:09:00 +0100
Message-ID: <CABkfQAERoudFeUnmLYgh4WKcJ3sh4aahKk6RjA5VHfnb3swpFQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] dt-bindings: net: fsl-fec add mdc/mdio bitbang option
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, fugang.duan@nxp.com,
        davem@davemloft.net, kuba@kernel.org,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        DTML <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I'm not a kernel expert, but I try to find why these patches were
needed in the FSL/Boundary kernel.

I found that the pin muxing in the original kernel was not good for FEC.
It's now working well with the mainline code.

You can delete these patches.

Thanks a lot,
Regards,

Adrien

Le lun. 30 nov. 2020 =C3=A0 23:26, Andrew Lunn <andrew@lunn.ch> a =C3=A9cri=
t :
>
> > >> I am currently upstreaming the "Nitrogen 8m Mini board" that seems t=
o not use a
> > >> "normal" mdio bus but a "bitbanged" one with the fsl fec driver.
> > >
> > > Any idea why?
> > >
> > > Anyway, you should not replicate code, don't copy bitbanging code int=
o
> > > the FEC. Just use the existing bit-banger MDIO bus master driver.
> >
> > Right there should be no need for you to modify the FEC driver at all,
> > there is an existing generic bitbanged MDIO bus driver here:
>
> Hi Florian
>
> Speculation on my part, until i hear back on the Why? question, but
> i'm guessing the board has a wrong pullup on the MDIO line. It takes
> too long for the PHY/FEC to pull the line low at the default
> 2.5MHz. bit-banging is much slower, so it works.
>
> If i'm right, there is a much simpler fix for this. Use the
> clock-frequency property for the MDIO bus to slow the clock down.
>
>         Andrew
