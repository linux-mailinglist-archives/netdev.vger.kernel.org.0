Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452E52FAF15
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 04:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394923AbhASDVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 22:21:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394911AbhASDVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 22:21:36 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5951C061574;
        Mon, 18 Jan 2021 19:20:55 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id h11so7882201ioh.11;
        Mon, 18 Jan 2021 19:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7MVhaKG7Tn8dwOvNkpJZ6mk5gJu3V7+tsTKQ2lqUNQE=;
        b=HD4yG7uJzVIXhW4l5LOOY2Wtb78VGKVvgrBOKpEg8/e3WTdk/g2b3OD5zky4NY7qNP
         0qlAkuB3YWZQtvgm0E4njzDLwumPfzddC5mGulQB28NbWUPw+fPt32WMgONtkQergNDr
         hWeu0gHhFCSUcKSQ1XncMb1xgIC4NwsBxa1dbqAXJP8fv/+3Kzg3h1kxtVFJR2m0duxn
         5kXzMgWqSjS6POeLMRCi2OGi6kxSqkkXzjSBxRul3ZKyTclzcthyiN3RJbUCowWibEAZ
         NT1i5Yo7Ee9UXgpB8jaNZHyfWUNWaM2DMKTezjdSYJnD2Q3fY/igFFyHboIpu/M68fPl
         KEHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7MVhaKG7Tn8dwOvNkpJZ6mk5gJu3V7+tsTKQ2lqUNQE=;
        b=baqYfl29VDlL2wtG8hOJe0jythUpoM1sTFVRF4KrVDYAWlXTslk8YS2++G2SlSk13l
         Vb4QwY0qA8G6mIwQjSQwugAK/AbQMFw/1mx7Tkg3dcBPiKt0EI3oRP1YNCywQ9bWUN4F
         jSIWvcfxAhnpL1y5J4qgp3bvFlYIo3WUSTKIb/pgioWCLxw6OYECB2Po0VMgLdcmxgt8
         2x3uL0Elz5uL847xykhiwJA8dfktcAQTckBjNkhl4dMtDYiouHRd9pm90WBucUijXyLB
         U2mjsyCGUSd3RivoHHH4lszc4Wvv2B/TF6xX8ARIoFYLlkOBNLCe6qv+YEfHrkerIf9B
         GDBA==
X-Gm-Message-State: AOAM533vdoMU4pjsZK+GG+jWpx5ffhogfbeNP7TbU3Q9h/gjUtgnTZ0M
        roaOVdJgriVgq7diVo++xqmO2tnV7DepGR4tjQA=
X-Google-Smtp-Source: ABdhPJzXnPvDBsNuLIJ/wPJ3uimKTNwNlnlHCUgeghHJPjwTzbvrIJD6a+WMcDB8AkkPzw0EUhbbpeUYS71kvSYdUJw=
X-Received: by 2002:a6b:c7c5:: with SMTP id x188mr1480858iof.39.1611026455198;
 Mon, 18 Jan 2021 19:20:55 -0800 (PST)
MIME-Version: 1.0
References: <20210111054428.3273-1-dqfext@gmail.com> <20210111054428.3273-3-dqfext@gmail.com>
 <CACRpkdYA2fWF_1K+2aYoZnBAsm9H3=VHpeT4ZDU5sCdrOUWx=w@mail.gmail.com>
In-Reply-To: <CACRpkdYA2fWF_1K+2aYoZnBAsm9H3=VHpeT4ZDU5sCdrOUWx=w@mail.gmail.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Tue, 19 Jan 2021 11:20:48 +0800
Message-ID: <CALW65jbJ2DFqLw-i91y7oRfRhcukHSAS3A0XMuy4kA+1AtLtLQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] drivers: net: dsa: mt7530: MT7530 optional
 GPIO support
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

On Mon, Jan 18, 2021 at 10:55 PM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> So for offset 0..14 this becomes bits
> 0, 1, 2, 4, 5, 6, 8, 9, 10, 12  ... 18
>
> What is the logic in this and is it what you intend?

Yes. Bit 0..2 are phy 0's LED 0..2, bit 4..6 are phy 1's LED 0..2, etc.

> Please add a comment explaining what the offset is supposed
> to become for offsets 0..14 and why.

I already added to mt7530.h, perhaps I should copy it here?

>
> > +       gc->ngpio = 15;
>
> And it really IS 15 not 16? Not that I know network equipment
> very well...

Yes, 3 LEDs for each phy.

>
> Yours,
> Linus Walleij
