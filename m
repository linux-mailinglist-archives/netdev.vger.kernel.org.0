Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3112F29F8B1
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgJ2Wxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:53:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgJ2Wxu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 18:53:50 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9012820639;
        Thu, 29 Oct 2020 22:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604012029;
        bh=vVIepqf0LdqjiVYa1FHZc0BB4bnaAwNxIG7DNzxHnLs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OtcTUj4uj72xIFNlphT4dsFMCPUDdEL9tXwYcqBOJAyXDzXVh+FvWZjeN7YeO5vHp
         uJGEBxUr+L8t8G0EoNVbmN0U2KO0G0Fqe1OJoXfgNUOE/Ybg+Ag/nV4isT2n2RyqRj
         eCDkmhaHvbUteHn8cSF8zfHThYclrA3OyFrroFHs=
Date:   Thu, 29 Oct 2020 15:53:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 1/5] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <20201029155348.1cb7555a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201029134107.GV1551@shell.armlinux.org.uk>
References: <20201028221427.22968-1-kabel@kernel.org>
        <20201028221427.22968-2-kabel@kernel.org>
        <20201029124141.GR1551@shell.armlinux.org.uk>
        <20201029125439.GK933237@lunn.ch>
        <20201029134107.GV1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 13:41:07 +0000 Russell King - ARM Linux admin wrote:
> On Thu, Oct 29, 2020 at 01:54:39PM +0100, Andrew Lunn wrote:
> > > It would be good to pass this through checkpatch - I notice some lines
> > > seem to be over the 80 character limit now.  
> > 
> > Hi Russell
> > 
> > The limit got raised to something higher. I personally prefer 80, and
> > if a file is using 80, new code would be inconsistent with old code if
> > it did not use 80. So your request is reasonable anyway.  
> 
> Hi Andrew,
> 
> I do most of my kernel hacking on the Linux console, so 80x25 is the
> limit of what I see - and depending on the editor I'm using, lines
> longer than 80 characters are chopped to 80 characters unless I scroll
> to the right (which then makes moving up and down problematical.) So,
> the files I'm responsible for are likely to stay requiring an 80
> character width.

+1

Maybe we should patch checkpatch to still enforce 80 for networking.
