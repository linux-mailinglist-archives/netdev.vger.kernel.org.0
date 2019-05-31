Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3AE931674
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 23:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfEaVNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 17:13:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46454 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727005AbfEaVNb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 17:13:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4HlBAjxsU/hStG4cLnPSuN+BIi7pCkBRb4fNZwxKJRU=; b=DkedZkKJNrM04iB+lHG/w0Z6Yv
        4NIRN4v3FmUV09Wvk2DhhFFHqPo5kzGaWw5cZMZxFkIDn+VWOMYViisUbMhE5OF69yfmP+o29jymP
        MCDF+GoHOJ+cq0WhU8jzS9EY8wAvnUbno/lJjDva4OGW5FmXWw3PA7BgHZBscGIguYVE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWoq9-0001WJ-5d; Fri, 31 May 2019 23:13:29 +0200
Date:   Fri, 31 May 2019 23:13:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com
Subject: Re: [PATCH net-next 02/13] net: axienet: clean up MDIO handling
Message-ID: <20190531211329.GE3154@lunn.ch>
References: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
 <1559326545-28825-3-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559326545-28825-3-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 12:15:34PM -0600, Robert Hancock wrote:
> -Allow specifying the MDIO clock divisor explicitly in the device tree,
> rather than always detecting it from the CPU clock which only works on
> the MicroBlaze platform.
> 
> -Centralize all MDIO handling in xilinx_axienet_mdio.c
> 
> -Ensure that MDIO clock divisor is always re-set after resetting the
> device, since it will be cleared.
> 
> -Fixed ordering of MDIO teardown vs. netdev teardown

That sounds like 4 patches, not one.

There are too many thinks mixed up in this patchset. I'm not reviewing
it. Sorry.

    Andrew
