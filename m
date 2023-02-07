Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53C2168CB69
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 01:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjBGAqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 19:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjBGAqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 19:46:07 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF9D10415;
        Mon,  6 Feb 2023 16:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jlJZFXK63ljlcbUHkeYIW6a7TuIzpnde8zdqpTdl/jk=; b=Yr2EaFOw8wICtE3OGCU6SXMSIp
        2eoRseLg/ZqU1cACxeJKTsq67iTie84jEt33nmaia/d1MCZ490wPerK8mwwJlcjchgj9sKSbcd6eE
        a7t1dBj1CCH/5PlbkRh8NVevt5nFjTYPyotwNDw1KVv7pQzBHi/XxVyTJs814WhsgJtc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pPC7R-004Fhu-6u; Tue, 07 Feb 2023 01:45:57 +0100
Date:   Tue, 7 Feb 2023 01:45:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v5 03/23] net: phy: micrel: add
 ksz9477_get_features()
Message-ID: <Y+GfRU1uAxnAgNQY@lunn.ch>
References: <20230206135050.3237952-1-o.rempel@pengutronix.de>
 <20230206135050.3237952-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206135050.3237952-4-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 02:50:30PM +0100, Oleksij Rempel wrote:
> KSZ8563R, which has same PHYID as KSZ9477 family, will change "EEE control
> and capability 1" (Register 3.20) content depending on configuration of
> "EEE advertisement 1" (Register 7.60). Changes on the 7.60 will affect
> 3.20 register.
> 
> So, instead of depending on register 3.20, driver should set supported_eee.
> 
> Proper supported_eee configuration is needed to make use of generic
> PHY c45 set/get_eee functions provided by next patches.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
