Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD52242A6B
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 15:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgHLNd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 09:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbgHLNd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 09:33:29 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334EAC06174A
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 06:33:29 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id BE3BA140954;
        Wed, 12 Aug 2020 15:33:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597239206; bh=rSGj8Mhpt0uuznefb6dJk8somr1tHRNpoKhwo94Lf70=;
        h=Date:From:To;
        b=JwA8frhMd7SGSpJQB63Zq9+2NvHGA6Q+6yL/QN4EJO8m3u+XrgL4Yz6vcFVFhX5/w
         fLGqyMQHBbmbA3yG2d5DM+W22ujw0w/Fiw7wxyoDq4iNkvgURmQRtUNfMhq9HDrRh+
         fi6Q9m0JG/+07JOfEr4PIgZL32BLG1RakQ/k4OeQ=
Date:   Wed, 12 Aug 2020 15:33:26 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 2/4] net: phy: sfp: add support for
 multigig RollBall modules
Message-ID: <20200812153326.71b84e45@dellmb.labs.office.nic.cz>
In-Reply-To: <20200811151552.GM1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
        <20200810220645.19326-3-marek.behun@nic.cz>
        <20200811151552.GM1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Aug 2020 16:15:53 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> > +	if (rollball) {
> > +		/* TODO: try to write this to EEPROM */
> > +		id.base.extended_cc = SFF8024_ECC_10GBASE_T_SFI;  
> 
> Should we really be "fixing" vendors EEPROMs for them?
> 

Are you reffering to the TODO comment or the id.base.extended_cc
assignment?
If the comment, well, your code does it for cotsworks modules, but I am
actually indifferent.
If the assignment - either this needs to be done or the
sfp_probe_for_phy and sfp_may_have_phy functions have to be changed so
that they check for rollball module by vendor ID.

Marek
