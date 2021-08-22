Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F3B3F424E
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 01:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhHVXRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 19:17:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35692 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229969AbhHVXRP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 19:17:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RSMrc/2TBu6Gn8lVKV6FpVq2C5iEiWw8VjuIwmiDnOY=; b=AZ1rzncnJiwoAq1yafjIV+lbQr
        tL8Jr/4w0vIBNU67j5dksJWzuhlB1J+TD7H5X0KUE1vCGfG7oOgnOeCIBU/ozI/WxCak9UW+VuQS8
        ZjaFh6qfLxNFfpqFkY1/clcI4GIYlCvF1l1TOeuRWdYg5YIRzLZLf/wVVqB6eZrpdNeI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mHwhY-003OAF-Tf; Mon, 23 Aug 2021 01:16:28 +0200
Date:   Mon, 23 Aug 2021 01:16:28 +0200
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
Subject: Re: [RFC PATCH net-next 1/5] net: dsa: realtek-smi: fix mdio_free
 bug on module unload
Message-ID: <YSLazK4TbG5wjHbu@lunn.ch>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-2-alvin@pqrs.dk>
 <YSLEZmuWlD5kUOlx@lunn.ch>
 <cb38f340-a410-26a4-43be-5f549c980ff3@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb38f340-a410-26a4-43be-5f549c980ff3@bang-olufsen.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> No, there isn't. I neglected to mention in the rtl8365mb patch that I 
> reworked the IRQ setup (compared with rtl8366rb) so that it could be 
> torn down in a neat way. So you will see that the new driver does it 
> properly, but I did not touch rtl8366rb because I am not using it. I am 
> happy to do the same to rtl8366rb but I don't think I should make it 
> part of this series. What do you think?

Lets see if Linus has time. He can probably model the change based on
what you have done here.

     Andrew
