Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EFF3B898E
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 22:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbhF3UM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 16:12:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35372 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233847AbhF3UMz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 16:12:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=Ig7RKvljMw8o5azQdcqEm8EeKT2flaMTGXZFDtCWtcY=; b=1V
        +MXh5XfQBSeRgST9+g6qlQzdOW5feFyRCrVspWLOjPuvdDpu1KLuDpDjqCcZx7sTRh0tTouKOF1TM
        LCT8UYUyVytr2gUfGXYVaVWagEZZTWjkxPL4GeUd4YsQBVW+YztpeFTLfMNzdV//qxqh3J7eZhHaV
        fJnJXFvBbW9TYzA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lygXR-00BhAF-9K; Wed, 30 Jun 2021 22:10:25 +0200
Date:   Wed, 30 Jun 2021 22:10:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net 6/6] net: dsa: mv88e6xxx: enable SerDes PCS register
 dump via ethtool -d on Topaz
Message-ID: <YNzPsaqy7CbtBjwF@lunn.ch>
References: <20210630174308.31831-1-kabel@kernel.org>
 <20210630174308.31831-7-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210630174308.31831-7-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 07:43:08PM +0200, Marek Behún wrote:
> Commit bf3504cea7d7e ("net: dsa: mv88e6xxx: Add 6390 family PCS
> registers to ethtool -d") added support for dumping SerDes PCS registers
> via ethtool -d for Peridot.
> 
> The same implementation is also valid for Topaz, but was not
> enabled at the time.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Fixes: bf3504cea7d7e ("net: dsa: mv88e6xxx: Add 6390 family PCS registers to ethtool -d")

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

I actually think devlink regions will be better for this. But the
ethtool code exists.

    Andrew
