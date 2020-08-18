Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7BE2489FB
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 17:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgHRPgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 11:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbgHRPgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 11:36:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C541C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 08:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jVEpB0sqGDy2odyY3lUTdJf5Al15L9iS3ewsz9EUXIY=; b=gp19kZGF1nwya4kkeEee2+LIR
        IpRB46UWOQf9f5Y3FPByYoTJ0MfAdyWWRu2rJd4tXnZMtPTcrZBUP4fZEUrDboA3nRqz1LbbJYomo
        Csnm1P5jgp1NYXjo0sPe+8kueWHgkwmpb8IQmSu21aXtVOtepkzCbJZ4KrVVMbSBuJKnV+9Yj/itx
        W8YeSU8BAVI1nndFS/pZhgKTlHsP1cAd3H7sOOkbLYnc/AOfv3I6Ki8h6rEhN2EqSyB8TW8bnGNcR
        Mz734UYD2uIYjrX5QnMaFizkXobCtbIoHVqUDM19Sa5SIOa6iqO20nhZ+D/jvPdmtFPBw7wPEHZKr
        BW+1d+CUQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54110)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k83fN-0000cy-WD; Tue, 18 Aug 2020 16:36:50 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k83fN-0001W4-Fq; Tue, 18 Aug 2020 16:36:49 +0100
Date:   Tue, 18 Aug 2020 16:36:49 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 0/4] Support for RollBall 10G copper SFP
 modules
Message-ID: <20200818153649.GD1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
 <20200817134909.GY1551@shell.armlinux.org.uk>
 <20200818154305.2b7e191c@dellmb.labs.office.nic.cz>
 <20200818150834.GC1551@shell.armlinux.org.uk>
 <20200818173055.01e4bf01@dellmb.labs.office.nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200818173055.01e4bf01@dellmb.labs.office.nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 05:30:55PM +0200, Marek Behún wrote:
> On Tue, 18 Aug 2020 16:08:35 +0100
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> 
> > > Otherwise it looks nice. I will test this. On what branch does this
> > > apply?  
> > 
> > My unpublished tip of the universe development.  Here's a version on
> > the clearfog branch:
> 
> Russell, it seems you do not have commit
> 
> e11703330a5d ("net: phy: marvell10g: support XFI rate matching mode")
> 
> in that branch.

I don't.  That commit is in 5.9-rc1, I'm based on 5.8 at the moment.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
