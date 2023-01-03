Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDDC65C99D
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 23:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238730AbjACWXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 17:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238729AbjACWVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 17:21:43 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3350417409;
        Tue,  3 Jan 2023 14:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ezBxF58/iYt4ytGREKmk4EHJi+NewNz9aFNzcPhEcYw=; b=Un/ZBjj4THLRJFaI3jBbBXkucy
        xUI45WocO2gEO94eHnU3fsLtEM94vFQJoIlVZX/9HlebD8cYZ7AqzkZbTzQyfpm0busc46Zl6wGIt
        orx2qJbtdDR/A1TDXLQ7OuLpdyKD1cZGfboGkfGZTaIqpEBt9qpW3+rKCOOc0Vaow2HK5bdhWWEC8
        r5gDwaYGw4UWlrG6yIp6FVO6QyJLujP2p0BqvDTT/bJOW+4aVLyerujnJl7TQK2UWv/0/aekLlGsV
        YmDgPgPWpRE2fqy4vb9DmQJznADN+64HklkJ1Lop1Ji3UZM0WuswEq/SYcVpdud1/JF7ssBuVDZhL
        lBF6XAkQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35956)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pCpdY-0005wc-Hc; Tue, 03 Jan 2023 22:20:00 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pCpdR-0002SM-O6; Tue, 03 Jan 2023 22:19:53 +0000
Date:   Tue, 3 Jan 2023 22:19:53 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH RFC net-next v2 03/12] net: mdio: mdiobus_register:
 update validation test
Message-ID: <Y7SqCRkYkhQCLs8z@shell.armlinux.org.uk>
References: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-3-ddb37710e5a7@walle.cc>
 <Y7P/45Owf2IezIpO@shell.armlinux.org.uk>
 <37247c17e5e555dddbc37c3c63a2cadb@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37247c17e5e555dddbc37c3c63a2cadb@walle.cc>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Tue, Jan 03, 2023 at 11:21:08AM +0100, Michael Walle wrote:
> Hi Russell,
> 
> Am 2023-01-03 11:13, schrieb Russell King (Oracle):
> > On Wed, Dec 28, 2022 at 12:07:19AM +0100, Michael Walle wrote:
> > > +	if (!bus || !bus->name)
> > > +		return -EINVAL;
> > > +
> > > +	/* An access method always needs both read and write operations */
> > > +	if ((bus->read && !bus->write) ||
> > > +	    (!bus->read && bus->write) ||
> > > +	    (bus->read_c45 && !bus->write_c45) ||
> > > +	    (!bus->read_c45 && bus->write_c45))
> > 
> > I wonder whether the following would be even more readable:
> > 
> > 	if (!bus->read != !bus->write || !bus->read_c45 != !bus->write_c45)
> 
> That's what Andrew had originally. But there was a comment from Sergey [1]
> which I agree with. I had a hard time wrapping my head around that, so I
> just listed all the possible bad cases.

The only reason I suggested it was because when looked at your code,
it also took several reads to work out what it was trying to do!

Would using !!bus->read != !!bus->write would help or make it worse,
!!ptr being the more normal way to convert something to a boolean?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
