Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DAD427B20
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 17:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbhJIPKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 11:10:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58268 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234451AbhJIPKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 11:10:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Pv0+7rWPKrlMw9H5rxG9lpi8X4fA+ytO8wXfsiSyzqk=; b=jhOxGaNBYfgru9lQFvcM9bXGo9
        AGdXQAh8rb3JymlgGd/hl5SzYm+QtLRS5Hk0XhsbgbnpzqzuMrYLgO2Z4K5CMwT1BxEnQ17hOTcGi
        TxZszjHEn53aOW042WyBQ8zP8vh2YrlOtgn4lAgXWaIV6QDXj9SuDFdWqyrvKQt+/WJk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mZDxu-00A9xp-GH; Sat, 09 Oct 2021 17:08:46 +0200
Date:   Sat, 9 Oct 2021 17:08:46 +0200
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
Subject: Re: [net-next PATCH v2 04/15] drivers: net: phy: at803x: better
 describe debug regs
Message-ID: <YWGwfgXcezhgBZ/K@lunn.ch>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
 <20211008002225.2426-5-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008002225.2426-5-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 02:22:14AM +0200, Ansuel Smith wrote:
> Give a name to known debug regs from Documentation instead of using
> unknown hex values.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
