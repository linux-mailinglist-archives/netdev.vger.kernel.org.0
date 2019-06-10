Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9853B6B4
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 16:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390675AbfFJOGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 10:06:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41554 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390384AbfFJOGi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 10:06:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=esB67aW0RZub8YkA0JVWDLciy3LkwjDjBUPRpXA14gk=; b=Zr6MPmsyHccFBjYfE/yoka/pE3
        /pt8bM5ZArajPiFOxbkVfWFLYcuKu92KPptuIRu6I/LhdbGle+qHjycDFYJZxOWMVz8QRSjoOLFK5
        tNGrnRGa+9H6SmMsvmnDJdSil2wexHVwRRalJezEHlHze0AWzfGch/41erDGKBebE2I0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1haKwT-0007Dh-Un; Mon, 10 Jun 2019 16:06:33 +0200
Date:   Mon, 10 Jun 2019 16:06:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 3/3] selftests: mlxsw: Add speed and
 auto-negotiation test
Message-ID: <20190610140633.GI8247@lunn.ch>
References: <20190610084045.6029-1-idosch@idosch.org>
 <20190610084045.6029-4-idosch@idosch.org>
 <20190610134820.GG8247@lunn.ch>
 <20190610135848.GB19495@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610135848.GB19495@splinter>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 04:58:48PM +0300, Ido Schimmel wrote:
> On Mon, Jun 10, 2019 at 03:48:20PM +0200, Andrew Lunn wrote:
> > > +		# Skip 56G because this speed isn't supported with autoneg off.
> > > +		if [[ $speed == 56000 ]]; then
> > > +			continue
> > > +		fi
> > 
> > Interesting. How is 56000 represented in ethtool? Listed in both
> > "Supported link modes" and "Advertised link modes"?
> 
> Hi Andrew,
> 
> Yes. We recently sent a patch to error out if autoneg is off: Commit
> 275e928f1911 ("mlxsw: spectrum: Prevent force of 56G").

I never get access to high speed links like this. Do you have a
reference to why 56G needs auto-neg? What makes it different to every
other link mode?

Thanks
	Andrew
