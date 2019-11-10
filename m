Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C38B0F6A0D
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 17:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKJQNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 11:13:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59050 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbfKJQNM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 11:13:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Od8keoRFFMyMQjoq3wA7qSMBH+BeEVO4MGOrwsTVzOQ=; b=gVLgmTRv0W7BOIw5eJ3ZegMEXR
        yKgij1w8dfcoIyiKXVVCoRxQqSh8gCb8CQjmKZrqcRHp123VZS+0qiFOHMmDcx09E+1o1WkIDmTwM
        2Oasa5uGbR3C18v+sTnnu2yCPGsORoQOcSFTlf/jSX/71bd95wGVLV3dLu7RbRQhGRx8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTppr-0006oX-4f; Sun, 10 Nov 2019 17:13:07 +0100
Date:   Sun, 10 Nov 2019 17:13:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: add core phylib sfp support
Message-ID: <20191110161307.GC25889@lunn.ch>
References: <20191110142226.GB25745@shell.armlinux.org.uk>
 <E1iTo7N-0005Sj-Nk@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iTo7N-0005Sj-Nk@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 02:23:05PM +0000, Russell King wrote:
> Add core phylib help for supporting SFP sockets on PHYs.  This provides
> a mechanism to inform the SFP layer about PHY up/down events, and also
> unregister the SFP bus when the PHY is going away.

Hi Russell

What does the device tree binding look like? I think you have SFP
proprieties in the PHYs node?

Thanks
	Andrew
