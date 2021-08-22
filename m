Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6140D3F424D
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 01:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbhHVXPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 19:15:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35674 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229969AbhHVXPM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 19:15:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qoEqpPVVbeRsWtNrIfC23kC8b2rXSc6F94tquu56HzE=; b=JMh7LcX1c7mr3CELHp7jjU7YtI
        r3V52Q131j+1eBbOG3HJAQ3GmBboWISu0WIWGfpG188W0aYHgd/oImLfW67T5QBc9OQXuGv50J/ta
        rlCZdr9FTjx/bHFc71nPDMYqh+dUY7pCrCtSxs1WBpOcAU2NrJ0lSaSpwUcA7yjmxHyE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mHwfZ-003O96-AV; Mon, 23 Aug 2021 01:14:25 +0200
Date:   Mon, 23 Aug 2021 01:14:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 3/5] net: dsa: tag_rtl8_4: add realtek 8
 byte protocol 4 tag
Message-ID: <YSLaUUe0eBeMQYtj@lunn.ch>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-4-alvin@pqrs.dk>
 <YSLJervLt/xNIKHn@lunn.ch>
 <eeca192a-ef7f-0553-1b4a-1c38d9892ea0@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eeca192a-ef7f-0553-1b4a-1c38d9892ea0@bang-olufsen.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> + */
> >> +
> >> +#include <linux/etherdevice.h>
> >> +#include <linux/bits.h>
> >> +
> >> +#include "dsa_priv.h"
> >> +
> >> +#define RTL8_4_TAG_LEN			8
> >> +#define RTL8_4_ETHERTYPE		0x8899
> > 
> > Please add this to include/uapi/linux/if_ether.h

Maybe call it ETH_P_REALTEK, and comment /* Multiple Proprietary
protocols */ ?

If you do it in an individual patch, you can explain more in the
commit message about it being used for different protocols by Realtek,
and that no assumptions should be made when trying to decode it.

	  Andrew
