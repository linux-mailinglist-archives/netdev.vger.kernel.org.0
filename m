Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D022472AA
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 03:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfFPBI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 21:08:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41746 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfFPBI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 21:08:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7679014FB1D7A;
        Sat, 15 Jun 2019 18:08:57 -0700 (PDT)
Date:   Sat, 15 Jun 2019 18:08:54 -0700 (PDT)
Message-Id: <20190615.180854.999160704288745945.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     ioana.ciornei@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phylink: set the autoneg state in
 phylink_phy_change
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190615221328.4diebpopfzyfi4og@shell.armlinux.org.uk>
References: <1560407871-5642-1-git-send-email-ioana.ciornei@nxp.com>
        <20190615.133021.572699563162351841.davem@davemloft.net>
        <20190615221328.4diebpopfzyfi4og@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 15 Jun 2019 18:08:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Sat, 15 Jun 2019 23:13:28 +0100

> On Sat, Jun 15, 2019 at 01:30:21PM -0700, David Miller wrote:
>> From: Ioana Ciornei <ioana.ciornei@nxp.com>
>> Date: Thu, 13 Jun 2019 09:37:51 +0300
>> 
>> > The phy_state field of phylink should carry only valid information
>> > especially when this can be passed to the .mac_config callback.
>> > Update the an_enabled field with the autoneg state in the
>> > phylink_phy_change function.
>> > 
>> > Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
>> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
>> 
>> Applied and queued up for -stable, thanks.
> 
> This is not a fix; it is an attempt to make phylink work differently
> from how it's been designed for the dpaa2 driver.  I've already stated
> that this field is completely meaningless, so I'm surprised you
> applied it.

I'm sorry, I did wait a day or so to see any direct responses to this
patch and I saw no feedback.

I'll revert.

