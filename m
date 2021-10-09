Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A22427C63
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 19:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbhJIRbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 13:31:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58440 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229928AbhJIRbU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 13:31:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ltIgk/nb2xd6IuIkrxYnP3jW947p1kEaXwqgn1RCW/4=; b=XW6Lti8PtJNlvZI9GeSlRWgOau
        4HU+/m3AzctdMtpe/9NLc8JoGBSzAB47RzoCcl6Wi4ca9yACKJdCqNrpwQy4Fq3LdOU7vljLV3oNd
        B3P6FjiH+4e1u+dHEmr0wZN8DMtSFhU+0ciCJ+30MvvIp9Fbbuy4Mk7VVRVUC0Zp29Jk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mZG9u-00AAQS-AY; Sat, 09 Oct 2021 19:29:18 +0200
Date:   Sat, 9 Oct 2021 19:29:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 06/15] dt-bindings: net: dsa: qca8k: document
 rgmii_1_8v bindings
Message-ID: <YWHRbs8KCJ2XrF65@lunn.ch>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
 <20211008002225.2426-7-ansuelsmth@gmail.com>
 <YWGy33inSic1PcC5@lunn.ch>
 <YWG1hj5zn/Pvqx0y@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWG1hj5zn/Pvqx0y@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Are ipq8065 & ipq8064 SoCs which the switch is embedded into? So you
> > could look for the top level compatible and set these regulators based
> > on that. No DT property needed.
> > 
> >    Andrew
> 
> The switch is still external for these 2 SoC. If we really want, yes we
> can follow that route and sets only for the 2 SoC. (Considering ipq8065
> is still not present, can I add it anyway in the qca8k code? Will for
> sure propose the ipq8065 dtsi today)

It seems like this is less error prone. If the properties really are
needed, because somebody creates a board with swapped SoC and Switch,
the properties can be added later.

    Andrew
