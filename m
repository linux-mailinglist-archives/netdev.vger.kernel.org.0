Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534593F41CB
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 23:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbhHVVp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 17:45:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35526 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233019AbhHVVp1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 17:45:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=N5kzTENFinFqWM22WLj1261ADNGD7vdtSBJuR+Ubw6E=; b=Ue
        ZRIRAmdV1hmlYGbXDbBwtvTL18p2VGepDH7dW0BXsgwDTgLWE4K4uw1yNuJugvvAlwjwIVT6p1ZOJ
        o2MBSF/t82QcCROJRsX2y5SeteATJ5lDMf5pYm7IqxkdP27GMJJXI5h19nih0fpW5CNdIR5a62c+u
        9K9/6Fd3k4Bfk6Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mHvGj-003NcU-6l; Sun, 22 Aug 2021 23:44:41 +0200
Date:   Sun, 22 Aug 2021 23:44:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, mir@bang-olufsen.dk,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 2/5] dt-bindings: net: dsa: realtek-smi:
 document new compatible rtl8365mb
Message-ID: <YSLFSVV7kM6528Rl@lunn.ch>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-3-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210822193145.1312668-3-alvin@pqrs.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 09:31:40PM +0200, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> rtl8365mb is a new realtek-smi subdriver for the RTL8365MB-VC 4+1 port
> 10/100/1000M Ethernet switch controller. Its compatible string is
> "realtek,rtl8365mb".
> 
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
