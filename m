Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A68F81B2F6
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 11:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbfEMJfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 05:35:45 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:37461 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbfEMJfp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 05:35:45 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 5E283383E;
        Mon, 13 May 2019 11:35:41 +0200 (CEST)
Received: from localhost (meh.true.cz [local])
        by meh.true.cz (OpenSMTPD) with ESMTPA id 466aa462;
        Mon, 13 May 2019 11:35:40 +0200 (CEST)
Date:   Mon, 13 May 2019 11:35:39 +0200
From:   ynezz <ynezz@ibawizard.net>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "john@phrozen.org" <john@phrozen.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alban Bedel <albeu@free.fr>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH net 0/3] add property "nvmem_macaddr_swap" to swap
 macaddr bytes order
Message-ID: <20190513082625.GA14498@ibawizard.net>
References: <1557476567-17397-4-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-3-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-2-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
 <20190510112822.GT81826@meh.true.cz>
 <20190510113155.mvpuhe4yzxdaanei@flea>
 <VI1PR0402MB3600516CFAD9227B0E175DF4FF0F0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <VI1PR0402MB3600516CFAD9227B0E175DF4FF0F0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andy Duan <fugang.duan@nxp.com> [2019-05-13 03:38:32]:

> From: Maxime Ripard <maxime.ripard@bootlin.com> Sent: Friday, May 10, 2019 7:32 PM
> > 
> > It looks to me that it should be abstracted away by the nvmem interface and
> > done at the provider level, not the customer.
> > 
> If to implement add above features like Petr Štetiar described, it should be abstracted
> In nvmem core driver.

Maxime made it clear, that network layer as a consumer of the nvmem provider
doesn't need to know about this byte order swapping details, so this byte
order swapping should be implemented in nvmem as well, as a bonus it doesn't
matter if you're going to swap 3, 6 or whatever other amount of bytes
described by the reg property, so this functionality could be reused which is
always good.

-- ynezz
