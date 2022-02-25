Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12FA4C4D09
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbiBYR6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiBYR6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:58:20 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3146073070
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kDSIWkqZeHr123vGSy4F7RC/q8+xijbhQyHILYVQL64=; b=m5LlIbOWgw9ZWlyRWxXWtmZxuc
        SWnqv3erj6rkn7opb8aVHbaG4AHJeoxto65p3+dabIIGLuHIjoSpffOJ3EA3Jj52VhTXyYk7sl11V
        vjh+ln7ya4hxUFGWWDF8IQnrSDjyvVTd2VuOOVcb3n8xCbkGhkSPSJ82aUpCHen/DZ3o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nNeqT-008Bep-1k; Fri, 25 Feb 2022 18:57:33 +0100
Date:   Fri, 25 Feb 2022 18:57:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Further phylink changes (was: [PATCH net-next 1/4] net: dsa:
 ocelot: populate supported_interfaces)
Message-ID: <YhkYjTQfHT8MSyCe@lunn.ch>
References: <YhkBfuRJkOG9gVZR@shell.armlinux.org.uk>
 <E1nNdJV-00AsoS-Qi@rmk-PC.armlinux.org.uk>
 <20220225162530.cnt4da7zpo6gxl4z@skbuf>
 <YhkEeENNuIXRkCD7@shell.armlinux.org.uk>
 <20220225181653.00708f13@thinkpad>
 <YhkUidpCbLjrdMAE@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhkUidpCbLjrdMAE@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> ... changing the subject line to show we've drifted off topic ...
> 
> Yes, once we've worked out what the PCS interface should look like in
> order to deal with the 88E6393 errata workaround that needs to be run
> each time the interface changes or whenever we "power up" the PCS.

Hi Russell

The erratas are not limited to 6393. For the 6390 there is an errata
where you need to "power up" the PCS before you change cmode,
otherwise TX works, but RX just drops frames rather than pass them to
the MAC.

I've not looked at the details of your proposal, and maybe it is a
none issue, i just wanted to make sure you are aware of this.

   Andrew
