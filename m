Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0245A29F210
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 17:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbgJ2Qqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 12:46:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726517AbgJ2Qqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 12:46:51 -0400
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D18D206F4;
        Thu, 29 Oct 2020 16:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603990011;
        bh=k+AeyRGH7oHk+OQeeN7dqu0p0gicSzGMVdfk0JX6XCs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VBG2x/whaaBdfsLwj3u2P/2TiXEvnHrf0rB0Z2ZTop8zuJ/IU/qHeir0lGT/EvzBt
         ImverZ+sBlQMXccQ0PpoAVKRxaUPcLYM2Df+5Bqm9PbhMOGKzT1nvnNDoC/v7DeV7r
         0EtTMM4/6hGQAENrfQFfo9hWZG597YT4goGU2QIc=
Date:   Thu, 29 Oct 2020 17:46:40 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 1/5] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <20201029174640.191f68e5@kernel.org>
In-Reply-To: <20201029124141.GR1551@shell.armlinux.org.uk>
References: <20201028221427.22968-1-kabel@kernel.org>
        <20201028221427.22968-2-kabel@kernel.org>
        <20201029124141.GR1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 12:41:41 +0000
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> I think this is probably a better way forward, and I suspect we're going
> to see more of this stuff. I wonder, however, whether the configuration
> should be done here too (selecting page 1). Also, shouldn't we ensure
> that we are on page 1 before attempting any access?

Very well.

> It would be good to pass this through checkpatch - I notice some lines
> seem to be over the 80 character limit now.

Checkpatch does not complain at over 80 characters anymore, but over
100. But I will rewrite it.

> "iterations"

/o\ thx

> > +	val = res[4];
> > +	val <<= 8;
> > +	val |= res[5];  
> 
> Was there something wrong with:
> 
> 	val = res[4] << 8 | res[5];
> 
> here?

For some reason I preferred to use the 3-liner, but I shall rewrite it.

> 
> > +struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c,
> > +			       enum mdio_i2c_type type)  
> 
> Maybe call this "protocol" rather than "type" ?

Very well, thx
