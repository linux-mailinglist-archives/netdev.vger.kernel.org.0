Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3573558CD
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 18:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346212AbhDFQHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 12:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232672AbhDFQHL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 12:07:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0437F613CD;
        Tue,  6 Apr 2021 16:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617725223;
        bh=q0TkxKOZJRUCAT/XfYl1YgZ73jKyqtq9Ikqkmc/zUi0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GyMC15T1zs1/FkyzEWXhAoZRPjYf8iTv0ebdRrGUWbDRkWlLvORRumrMafdLcFCPg
         QYAZApT/4mG9b41oyajNyffAC8dI7OmznHPc+ULgGQh2OqecWYYejnHKLedqaksmnJ
         PP1659XHUsMr+O1Y/6e52Q9+lpjus3evEJ6fVn/B9eozisxj459ekoIp7vEDHVFHZV
         lm2ubBW0wfV/VPYrf6t+4zRTnX3c4wmEQBb/nHHG+X9MDGsMD6e6/GGGLb34tFBGLk
         xhOSYoPuGNxibwmqk6EXHR7Mm53VggW8AkrwLSI9FN6q6NkBEO7h9nxcxSwFaUVAwE
         hixdnahlEquUQ==
Received: by mail-ej1-f46.google.com with SMTP id l4so22791104ejc.10;
        Tue, 06 Apr 2021 09:07:02 -0700 (PDT)
X-Gm-Message-State: AOAM532tCEc1ec/cqhIG6i5ecMjc0SJzqXvQN9hT38ry1bxlVS9Gy+96
        t3V9h29VQZMAvALCDpqTiTrKCwKn8gF0m+PC1g==
X-Google-Smtp-Source: ABdhPJzMoSMQygWRDajEWdidSk67pVGpnygV7Dy6GVwOgacbGBH3WitosU5sKMxxu8argY+oQjgYUzFyQ6EbAAfWYTg=
X-Received: by 2002:a17:906:490e:: with SMTP id b14mr6455459ejq.303.1617725221514;
 Tue, 06 Apr 2021 09:07:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210406141819.1025864-1-dqfext@gmail.com> <20210406141819.1025864-2-dqfext@gmail.com>
 <CAAOTY_8snSTcguhyB9PJBWydqNaWZL3V4zXiYULVp5n48fN24w@mail.gmail.com> <CALW65jbbQSFbgjsMkKCyFWnbkLOenM_+2q6K7BQG5bc4-R0CpA@mail.gmail.com>
In-Reply-To: <CALW65jbbQSFbgjsMkKCyFWnbkLOenM_+2q6K7BQG5bc4-R0CpA@mail.gmail.com>
From:   Chun-Kuang Hu <chunkuang.hu@kernel.org>
Date:   Wed, 7 Apr 2021 00:06:50 +0800
X-Gmail-Original-Message-ID: <CAAOTY__4CdGjD-66jJcQVCuzSWOUe7gLxrZ4GAfBAuaOcvX8wA@mail.gmail.com>
Message-ID: <CAAOTY__4CdGjD-66jJcQVCuzSWOUe7gLxrZ4GAfBAuaOcvX8wA@mail.gmail.com>
Subject: Re: [RFC net-next 1/4] net: phy: add MediaTek PHY driver
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
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
        linux-kernel <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-staging@lists.linux.dev, DTML <devicetree@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DENG Qingfang <dqfext@gmail.com> =E6=96=BC 2021=E5=B9=B44=E6=9C=886=E6=97=
=A5 =E9=80=B1=E4=BA=8C =E4=B8=8B=E5=8D=8811:57=E5=AF=AB=E9=81=93=EF=BC=9A
>
> On Tue, Apr 6, 2021 at 11:47 PM Chun-Kuang Hu <chunkuang.hu@kernel.org> w=
rote:
> >
> > Hi, Qingfang:
> >
> > DENG Qingfang <dqfext@gmail.com> =E6=96=BC 2021=E5=B9=B44=E6=9C=886=E6=
=97=A5 =E9=80=B1=E4=BA=8C =E4=B8=8B=E5=8D=8810:19=E5=AF=AB=E9=81=93=EF=BC=
=9A
> > > --- a/drivers/net/phy/Kconfig
> > > +++ b/drivers/net/phy/Kconfig
> > > @@ -207,6 +207,11 @@ config MARVELL_88X2222_PHY
> > >           Support for the Marvell 88X2222 Dual-port Multi-speed Ether=
net
> > >           Transceiver.
> > >
> > > +config MEDIATEK_PHY
> >
> > There are many Mediatek phy drivers in [1], so use a specific name.
>
> So "MEDIATEK_MT7530_PHY" should be okay?

This is ok, but this name looks only for one SoC.
MEDIATEK_ETHERNET_PHY could support more SoC, how do you think?

Regards,
Chun-Kuang.

>
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
tree/drivers/phy/mediatek?h=3Dv5.12-rc6
> >
> > Regards,
> > Chun-Kuang.
