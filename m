Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3689768CB7F
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 01:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjBGAyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 19:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjBGAyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 19:54:47 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1DA33470;
        Mon,  6 Feb 2023 16:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4CrvK76rrD+R3wcfuu8uheBctEOoX8lxcQWUqv+cAh0=; b=xqmzBiYavYtrBVnALt2wa6aAIu
        IbQWkl2TsFyF1xQp/cJFF2mlLS9i0yJRGAe3kHk6pumq66hiXIAjirEDVZXUHX6osgpjx8MU4lkZv
        nC8nU1226Ah229BaBzEyPTYF7Ayxfp20diFWAvDDdSiQbNMUmj0aLl70F2iXoriPhIMg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pPCFo-004FkA-DG; Tue, 07 Feb 2023 01:54:36 +0100
Date:   Tue, 7 Feb 2023 01:54:36 +0100
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
Subject: Re: [PATCH net-next v5 08/23] net: phy: migrate phy_init_eee() to
 genphy_c45_eee_is_active()
Message-ID: <Y+GhTEpwx+jP8S09@lunn.ch>
References: <20230206135050.3237952-1-o.rempel@pengutronix.de>
 <20230206135050.3237952-9-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206135050.3237952-9-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 02:50:35PM +0100, Oleksij Rempel wrote:
> Reduce code duplicated by migrating phy_init_eee() to
> genphy_c45_eee_is_active().
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

This makes sense, but as i said in a different thread, i think the
MAC/PHY API needs improving at some point, which could result in this
function going away. But this patchset is big enough as it is.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
