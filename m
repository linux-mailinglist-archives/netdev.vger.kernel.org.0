Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858A3366FBD
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 18:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbhDUQNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 12:13:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235591AbhDUQN2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 12:13:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E3D961450;
        Wed, 21 Apr 2021 16:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619021575;
        bh=8jqI6aiH4hwiHUgcEN1wRksGRNJ3OFRgxcK50mKzTYw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fPQcWTXKg4IZRaXn4/53Yl4hzHzapNVbn+DLd1wwgWAjBax7AgkREfPjUsErp4H3M
         jNmMiZ5rPN9f1ZGfy30vQvByCVwwkKhIMSoFglUgUgJETzjLcpNVHGzU+XAWdC4Sq2
         4DajKoc79CxkU0iCv5gL5N+Oo6N2h9YonTOrOCgvGEvTrnBpnh/iYEVV6atDJlFoWX
         gSynMO0aG14h+kWt17RQQqyFQ10/83koXf9icg5K3RmFoJWADw2q3iAK2gxcNtC56f
         GFTU+ScXneP80QZzU+z0fVZ8zZew4jGc5g/HZAcQJfxbOgi57+gJewRRfIY26ho9KK
         CHpSqL7gZO/5w==
Received: by mail-ej1-f44.google.com with SMTP id u21so64362697ejo.13;
        Wed, 21 Apr 2021 09:12:55 -0700 (PDT)
X-Gm-Message-State: AOAM530bJlJvZpMkxBK3AVWKj9uFKx8Fx4d5R4KXihtbcTxn3RbzsQXN
        CEtw2uwI1AeF03LX428vpexTQbagimZnHiV3/A==
X-Google-Smtp-Source: ABdhPJxOKAdqZq6IBYcoFGb3nyhYuCkTa9hB/kMgxIzc6Zfwc8YSVY7+dSAiZk8bwd57agaZVZVrL3grCvYgGpATndc=
X-Received: by 2002:a17:907:70d3:: with SMTP id yk19mr33344448ejb.108.1619021573865;
 Wed, 21 Apr 2021 09:12:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210419154659.44096-1-ilya.lipnitskiy@gmail.com>
 <20210419154659.44096-3-ilya.lipnitskiy@gmail.com> <20210420195132.GA3686955@robh.at.kernel.org>
 <CALCv0x2SG=0kBRnxfSPxi+FvaBK=QGPHQkHWHvTXOw64KawPUQ@mail.gmail.com> <trinity-47c2d588-093d-4054-a16f-81d76aa667e0-1619013874284@3c-app-gmx-bs34>
In-Reply-To: <trinity-47c2d588-093d-4054-a16f-81d76aa667e0-1619013874284@3c-app-gmx-bs34>
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 21 Apr 2021 11:12:41 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKne=ASOyd0E9GakVvDvaXDauHOOU5NgxU8X8ySvyrAcw@mail.gmail.com>
Message-ID: <CAL_JsqKne=ASOyd0E9GakVvDvaXDauHOOU5NgxU8X8ySvyrAcw@mail.gmail.com>
Subject: Re: Re: [PATCH net-next v2 2/2] net: ethernet: mediatek: support
 custom GMAC label
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 9:05 AM Frank Wunderlich
<frank-w@public-files.de> wrote:
>
> Hi,
>
> for dsa slave-ports there is already a property "label", but not for mast=
er/cpu-ports

Is that because slave ports are external and master are not? If so,
that makes sense.

> https://elixir.bootlin.com/linux/v5.12-rc8/source/arch/arm64/boot/dts/med=
iatek/mt7622-bananapi-bpi-r64.dts#L163
>
> handled here:
>
> https://elixir.bootlin.com/linux/v5.12-rc8/source/net/dsa/dsa2.c#L1113
>
> @ilya maybe you can rename slave-ports instead of master-port without cod=
e change?
>
> i also prefer a more generic way to name interfaces in dts, not only in t=
he mtk-driver, but the udev-approach is a way too, but this needs to be con=
figured on each system manually...a preset by kernel/dts will be nice (at l=
east to distinguish master/cpu- and user-ports).


Seems like it could be possible to want to distinguish port types for
reasons other than just what to name the device. Better to describe
that difference in DT and then base the device name off of that.

If you just want fixed numbering, then 'aliases' node is generally how
that is done (either because it sneaks in or fatigue from arguing
fixed /dev nodes are an anti-feature). There's already 'ethernetN'
which u-boot uses, but the kernel so far does not.

Rob
