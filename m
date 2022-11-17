Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A1862DD02
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 14:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239587AbiKQNlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 08:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234845AbiKQNlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 08:41:45 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A7771F10
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 05:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JE23ZjCA33U5xdzcPG1YYVxsrezoiqkgWTRAnPKZ/b4=; b=TfO0flktrPmaLTcRqogoHYKc5t
        Z+5AND+Kazl93rAexndbTsA5+2DCAKyON5l3stdJH+DZB3C4DJEHGjIRAMh0+e3yYdD9iJ4JDEmEF
        vV1W41O/CV69lFqj6GK5djn8G7ZmWqnDcV777DMl0r53oJkxH4lIIg45HJQcR32j3x6Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ovf8q-002h0e-JH; Thu, 17 Nov 2022 14:41:20 +0100
Date:   Thu, 17 Nov 2022 14:41:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, davem@davemloft.net,
        edumazet@google.com, f.fainelli@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org, olteanv@gmail.com, pabeni@redhat.com
Subject: Re: [PATCH net] net: dsa: sja1105: disallow C45 transactions on the
 BASE-TX MDIO bus
Message-ID: <Y3Y6ABTvfzHUDm2u@lunn.ch>
References: <Y3TldORKPxFUgqH/@lunn.ch>
 <20221117081105.771993-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117081105.771993-1-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 09:11:05AM +0100, Michael Walle wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> > I have a bit rotting patchset which completely separates C22 and C45,
> > i just spend too much time reviewing other code to get my own merged.
> 
> I'm still rebasing your patchset to the latest next as I still
> need it as a base for my patches regarding the maxlinear/microchip phy
> issue :)

Feel free to post it. Just add your own Signed-off-by: after mine.

I can probably help with some of the review comments. I think the
biggest problem i had was some reviews wanted more cleanup, when i was
trying to keep it KISS to reduce the likelihood of breakage.

     Andrew
