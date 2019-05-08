Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C88941741A
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 10:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfEHIl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 04:41:58 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:59492 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfEHIl6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 04:41:58 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id DD9AC47A7;
        Wed,  8 May 2019 10:41:53 +0200 (CEST)
Received: from localhost (meh.true.cz [local])
        by meh.true.cz (OpenSMTPD) with ESMTPA id a0fd15e7;
        Wed, 8 May 2019 10:41:52 +0200 (CEST)
Date:   Wed, 8 May 2019 10:41:52 +0200
From:   Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v4 02/10] dt-bindings: doc: reflect new NVMEM
 of_get_mac_address behaviour
Message-ID: <20190508084152.GM81826@meh.true.cz>
Reply-To: Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
References: <1556893635-18549-1-git-send-email-ynezz@true.cz>
 <1556893635-18549-3-git-send-email-ynezz@true.cz>
 <CAL_JsqLt6UFU_6bmh3Pc0taXUgMtAEV7kL7eZU13cLOjoakf=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqLt6UFU_6bmh3Pc0taXUgMtAEV7kL7eZU13cLOjoakf=Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rob Herring <robh+dt@kernel.org> [2019-05-07 11:44:57]:

Hi,

> > -- local-mac-address:   the driver is designed to use the of_get_mac_address api
> > -                       only if efuse-mac is 0. When efuse-mac is 0, the MAC
> > -                       address is obtained from local-mac-address. If this
> > -                       attribute is not present, then the driver will use a
> > -                       random MAC address.
> >  - "netcp-device label":        phandle to the device specification for each of NetCP
> >                         sub-module attached to this interface.
> >
> > +The MAC address will be determined using the optional properties defined in
> > +ethernet.txt, as provided by the of_get_mac_address API and only if efuse-mac
> 
> Don't make references to Linux in bindings. You can talk about
> expectations of client programs (e.g Linux, u-boot, BSD, etc.) though.

I've just tried to reword what was already there, anyway, did I understood
your remark properly, would this be more appropriate?

 The MAC address will be determined using the optional properties defined in
 ethernet.txt and only if efuse-mac is set to 0. If any of the optional MAC
 address properties are not present, then the driver will use random MAC
 address.

Thanks!

-- ynezz
