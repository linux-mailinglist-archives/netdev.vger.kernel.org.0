Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702BD6CC099
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 15:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbjC1NX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 09:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjC1NXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 09:23:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D83F7DB3;
        Tue, 28 Mar 2023 06:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aHmFILwMVGQQJcPzLZQGMuTJzK2MYr3DqFR1hRipmhg=; b=AxqH/FeMM8p70qAoeFrfoapGW7
        ApO1GC73ZDvUVw+qAKtGWeafwdHTVI5kVg0MsVbyYpuGaRlOLoIcVt5djKrVns1Xn2j12b6AWz2Xx
        p1lP/bDnJzktas+5aLFZSc125/Pqro3WzfAQxIWJMoAI2blp2pJVWpg2vnvpvAxWnTvaihXBxNhsU
        XYv4b5djHkU3KtyipgXk8JDoMD+EgWURTbbSJAGPvb5d93qKjd1Ebo/EQsbYCnY6wxraHHIE9KOiM
        Z/BBCersucJNyNbYo4du4Kj6TnLcS3uAyWolmJtUT3wYwIsEVC0E8IOldUlNhCf4MALd4/iXG9iI8
        nb+j+Ysg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48388)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ph9Ie-0006Ii-MJ; Tue, 28 Mar 2023 14:23:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ph9Ib-0006VO-At; Tue, 28 Mar 2023 14:23:41 +0100
Date:   Tue, 28 Mar 2023 14:23:41 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC net-next 6/7] net: dsa: mv88e6xxx: provide software
 node for default settings
Message-ID: <ZCLqXRKHh+VjCg8v@shell.armlinux.org.uk>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8f-00Dvo9-KT@rmk-PC.armlinux.org.uk>
 <ZB24fDEqwx53Rthm@kuha.fi.intel.com>
 <ZB3YGWTWLYyecgw7@shell.armlinux.org.uk>
 <ZCFvtuyelA+WoeqK@kuha.fi.intel.com>
 <ZCF2BLvGoaD/RGCS@shell.armlinux.org.uk>
 <ZCGkhUh20OK6rEck@kuha.fi.intel.com>
 <ZCGpDlaJ7+HmPQiB@shell.armlinux.org.uk>
 <ZCG6D7KV/0W0FUoI@shell.armlinux.org.uk>
 <ZCLZFA964zu/otQJ@kuha.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCLZFA964zu/otQJ@kuha.fi.intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 03:09:56PM +0300, Heikki Krogerus wrote:
> The problem is that the function you are proposing will be exploited
> silently - people will use NULL as the parent without anybody
> noticing. Everything will work for a while, because everybody will
> first only have a single device for that driver. But as time goes by
> and new hardware appears, suddenly there are multiple devices for
> those drivers, and the conflict start to appear.

So, an easy solution would be to reject a call to
fwnode_create_named_software_node() when parent is NULL, thereby
preventing named nodes at the root level.

> At that point the changes that added the function call will have
> trickled down to the stable trees, so the distros are affected. Now we
> are no longer talking about a simple cleanup that fixes the issue. In
> the unlikely, but possible case, this will turn into ABI problem if

There is no such thing as stable APIs for internal kernel interfaces.

Documentation/process/stable-api-nonsense.rst

> As you pointed out, this kind of risks we have to live with kbojects,
> struct device stuff and many others, but the thing is, with the
> software node and device property APIs right now we don't. So the fact
> that a risk exists in one place just isn't justification to accept the
> same risk absolutely everywhere.

Meanwhile, firmware descriptions explicitly permit looking up nodes by
their names, but here we are, with the software node maintainers
basically stating that they don't wish to support creating software
nodes with explicit names.

> Russell, if you have some good arguments for accepting your proposal,
> I assure you I will agree with you, but so far all you have given are
> attacks on a sketch details and statements like that "I think you're
> making a mountain out of a mole". Those just are not good enough.

Basically, I think you are outright wrong for all the reasons I have
given in all my emails on this subject.

Yes, I accept there is a *slight* risk of abuse, but I see it as no
different from the risk from incorrect usage of any other kernel
internal interface. Therefore I just do not accept your argument
that we should not have this function, and I do not accept your
reasoning.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
