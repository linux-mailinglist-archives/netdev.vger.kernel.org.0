Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0172E487866
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 14:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347637AbiAGNnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 08:43:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55946 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232401AbiAGNnN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 08:43:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=e/jSliqOAlavjyYTujY1gInGj0BgjAPJQsETI9dwpJ8=; b=QbqKBskiNCGfJzhUQN0B9QFoRI
        3TXppxC9Xfe5tgpd1A7Fr0ox5/BmOGNndCe1XN3tZLrMZRayieXBLWaoFJ2m4O+CXKiRMZu0QkEVg
        BJIKv1vc1wQbBswoIFXg2DW2NTb1tO3AMipMdGh8sPav76KxAWAyQzhdF0QzzwMyIMU8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n5pWJ-000lGZ-Av; Fri, 07 Jan 2022 14:43:03 +0100
Date:   Fri, 7 Jan 2022 14:43:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        stephen@networkplumber.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 5/6] net: marvell: prestera: Register
 inetaddr stub notifiers
Message-ID: <YdhDZ9Fkkx/moJH5@lunn.ch>
References: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
 <20211227215233.31220-6-yevhen.orlov@plvision.eu>
 <Yc3DgqvTqHANUQcp@shredder>
 <YdeaoJpSuIzPB/EP@yorlov.ow.s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdeaoJpSuIzPB/EP@yorlov.ow.s>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 07, 2022 at 03:42:56AM +0200, Yevhen Orlov wrote:
> On Thu, Dec 30, 2021 at 04:34:42PM +0200, Ido Schimmel wrote:
> >
> > What happens to that RIF when the port is linked to a bridge or unlinked
> > from one?
> >
> 
> We doesn't support any "RIF with bridge" scenario for now.
> This restriction mentioned in cover latter.

I did not look at the code. Does it return -EOPNOTSUPP? And then
bridging is performed by the host in software?

	 Andrew

     
