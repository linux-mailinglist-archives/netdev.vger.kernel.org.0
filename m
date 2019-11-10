Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0A12F6A9E
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 18:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfKJRwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 12:52:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59236 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726684AbfKJRwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 12:52:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=iVKl+3MMYgW162rXUWMshk45wYB5ADLH3+fA5rA43Ws=; b=NDnXBLOFHBkULdVZQ94lWJrXQb
        DFYUW7/8/Nm8cHJxT8P9nnWt1mq96ESYWHpa1wMrh+MyQ8n56kFJWABU3w3EaMq2KEW1Pn+/Rn1Ry
        V7b5nqNn3Hp7xjZBFf0CEYu5YKzqlJ8YJvLydxN3+oGXhXJKoHB1w/hVBCzV3pNMFPag=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTrNp-0007Am-NZ; Sun, 10 Nov 2019 18:52:17 +0100
Date:   Sun, 10 Nov 2019 18:52:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/17] Allow slow to initialise GPON modules to
 work
Message-ID: <20191110175217.GL25889@lunn.ch>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191110140530.GA25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 02:05:30PM +0000, Russell King - ARM Linux admin wrote:
> Some GPON modules take longer than the SFF MSA specified time to
> initialise and respond to transactions on the I2C bus for either
> both 0x50 and 0x51, or 0x51 bus addresses.  Technically these modules
> are non-compliant with the SFP Multi-Source Agreement, they have
> been around for some time, so are difficult to just ignore.

Hi Russell

We are seeing quite a few SFP/SFF which violate the spec. Do you think
there is any value in naming and shaming in the kernel logs SFP which
don't conform to the standard? If you need to wait longer than 1
second for the EEPROM to become readable, print the vendor name from
the EEPROM and warn it is not conforment. If the diagnostic page is
not immediately available, again, print the vendor name warn it is not
conforment?

      Andrew
