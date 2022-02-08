Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203654ACE25
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 02:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242236AbiBHBsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 20:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344962AbiBHBmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 20:42:31 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CB1C043180
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 17:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=C0o5EvMmSv4YkfC1tR7YpfFH9A7w3zbuj9FNyziXHdc=; b=WzTwsxZcPHwkafOLgQg4XgH916
        bxVv26+fjyX6VDmjArBQpauC3sLH6HS5CpknelxLPMsKpwpHTMpfBNlTKylnbTstxECRx1FBC2AFm
        IsK1FkanqMkvGfL/iWhDCEaNTIOb1qzTlsOqyAbi2HZ9LpZL6RaESInlaAMsVIP+tl/4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nHFWS-004jc2-1U; Tue, 08 Feb 2022 02:42:24 +0100
Date:   Tue, 8 Feb 2022 02:42:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Oleksij Rempel <linux@rempel-privat.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>
Subject: Re: [PATCH net 1/7] net: dsa: mv88e6xxx: don't use devres for mdiobus
Message-ID: <YgHKgEAoPOKH7wE6@lunn.ch>
References: <20220207161553.579933-1-vladimir.oltean@nxp.com>
 <20220207161553.579933-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207161553.579933-2-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 06:15:47PM +0200, Vladimir Oltean wrote:
> As explained in commits:
> 74b6d7d13307 ("net: dsa: realtek: register the MDIO bus under devres")
> 5135e96a3dd2 ("net: dsa: don't allocate the slave_mii_bus using devres")
> 
> mdiobus_free() will panic when called from devm_mdiobus_free() <-
> devres_release_all() <- __device_release_driver(), and that mdiobus was
> not previously unregistered.

...
 
> Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
> Reported-by: Rafael Richter <Rafael.Richter@gin.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
