Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D883A662867
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 15:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbjAIOYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 09:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjAIOYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 09:24:44 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2799864DC;
        Mon,  9 Jan 2023 06:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kx8wEP7ydR7MO7JXGJeVfKoITwgD6HJfTtcypWjw9dQ=; b=WNIknlAEQx5/7jHDl6MY5VdpPT
        zzDfEdnmbQYPSLB2Exxr/7bXT4YOLil3R7IUJYUwSABjSijbVv52ph8Wc5TMyiPthjYQ0Vdct4T80
        KJrB4yEcDioB/gyFqyIgNY+89LILEjggYikue9xFF3cOCO9uSdROhC4iK7VkB5NcwKMI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pEt4c-001Zip-I4; Mon, 09 Jan 2023 15:24:26 +0100
Date:   Mon, 9 Jan 2023 15:24:26 +0100
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
Message-ID: <Y7wjmu9P2TXuNMeE@lunn.ch>
References: <cover.1673030528.git.piergiorgio.beruto@gmail.com>
 <b15b3867233c7adf33870460ea442ff9a4f6ad41.1673030528.git.piergiorgio.beruto@gmail.com>
 <Y7m4v8nLEc4bVBDf@lunn.ch>
 <Y7tYT8lkgCugZ7kP@gvm01>
 <Y7wXO7x7Wh7+Hw/Z@lunn.ch>
 <Y7wi3qwG3b6i0x7T@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7wi3qwG3b6i0x7T@gvm01>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 03:21:18PM +0100, Piergiorgio Beruto wrote:
> On Mon, Jan 09, 2023 at 02:31:39PM +0100, Andrew Lunn wrote:
> > Linux tends to ignore Marketing, because Marketing tends to change its
> > mind every 6 months. Also, Linux ignores companies being bought and
> > sold, changing their name. So this PHY will forever be called whatever
> > name you give it here. The vitesse PHY driver is an example of
> > this. They got bought by Microsemi, and then Microchip bought
> > Microsemi. The PHY driver is still called vitesse.c.
> > 
> > How about using the legal name, 'ON Semiconductor
> > Corporation'
> That's perfectly clear Andrew, I can certainly see why Linux should
> ignore marketing.
> 
> Sill, 'ON Semiconductor' is the old company name, the product datasheet can be
> found at www.onsemi.com. I would honestly feel more comfortable using
> the current company name. If you really want the first 'o' to be
> capitalized, then so be it. Hopefully people will not notice :-)

I would prefer it was capitalised, to make it uniform with all the
other entries.

      Andrew
