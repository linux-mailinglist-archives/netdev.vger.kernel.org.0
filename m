Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5FE066271E
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbjAINcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236892AbjAINcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:32:10 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0D71EC67;
        Mon,  9 Jan 2023 05:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vePePHbs+qQUDjlfX65V+DdCZ2Hrj2lqp1xp3j40q2c=; b=p/J6DgzeDlZ+UvxoBM+Xyje0QR
        ruNd2wDzrr6wjnKI7PzOFyeOc/gUyXVrZkKI6zz9/Gd44skS13s3+CGGBqejKSAz7nMEyU4mD64ER
        cB2TewXF+H9Y89e+XqLFwWq1vHbbeDBqKg4zquGuwd2UEEbx6wu1wc5QQM+dJ9yhmBAQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pEsFX-001ZK6-JZ; Mon, 09 Jan 2023 14:31:39 +0100
Date:   Mon, 9 Jan 2023 14:31:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org
Subject: Re: [PATCH v2 net-next 5/5] drivers/net/phy: add driver for the
 onsemi NCN26000 10BASE-T1S PHY
Message-ID: <Y7wXO7x7Wh7+Hw/Z@lunn.ch>
References: <cover.1673030528.git.piergiorgio.beruto@gmail.com>
 <b15b3867233c7adf33870460ea442ff9a4f6ad41.1673030528.git.piergiorgio.beruto@gmail.com>
 <Y7m4v8nLEc4bVBDf@lunn.ch>
 <Y7tYT8lkgCugZ7kP@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7tYT8lkgCugZ7kP@gvm01>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 12:57:03AM +0100, Piergiorgio Beruto wrote:
> On Sat, Jan 07, 2023 at 07:23:59PM +0100, Andrew Lunn wrote:
> > > +++ b/drivers/net/phy/Kconfig
> > > @@ -264,6 +264,13 @@ config NATIONAL_PHY
> > >  	help
> > >  	  Currently supports the DP83865 PHY.
> > >  
> > > +config NCN26000_PHY
> > > +	tristate "onsemi 10BASE-T1S Ethernet PHY"
> > > +	help
> > > +	  Adds support for the onsemi 10BASE-T1S Ethernet PHY.
> > > +	  Currently supports the NCN26000 10BASE-T1S Industrial PHY
> > > +	  with MII interface.
> > > +
> > >  config NXP_C45_TJA11XX_PHY
> > >  	tristate "NXP C45 TJA11XX PHYs"
> > 
> > These are actually sorted by the tristate string, which is what you
> > see when you use
> > 
> > make menuconfig
> > 
> > So 'onsemi' should be after 'NXP TJA11xx PHYs support'. Also, all the
> > other entries capitalise the first word.
> As for the order I fixed it. Thanks for noticing.
> 
> Regarding the capitalization, I have a little problem here. 'onsemi' is a
> brand and according to company rules it MUST be written all in
> lowercase. I know we're not obliged to follow any company directive here, but 
> as wierd as it might sound, I'd rather keep it lowercase just not to get 
> comments later on trying to fix this, if you agree...

Linux tends to ignore Marketing, because Marketing tends to change its
mind every 6 months. Also, Linux ignores companies being bought and
sold, changing their name. So this PHY will forever be called whatever
name you give it here. The vitesse PHY driver is an example of
this. They got bought by Microsemi, and then Microchip bought
Microsemi. The PHY driver is still called vitesse.c.

How about using the legal name, 'ON Semiconductor
Corporation'

	Andrew
