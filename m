Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C1349D669
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 00:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiAZXzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 18:55:45 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56572 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229823AbiAZXzp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 18:55:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=N6c5KT5/hYZ+Gy+SZubGi76SOB2giRyb/x7wsZ1gL9E=; b=xLwZk0+r1ds11wrE0UQNjirIom
        VqAKThgkE4/07+UKwq8vdL0YSVW+bk1VCtbaEZ+80+3C/k+TH4ygRSsfV+JwlYQFQPzciztS4TBaK
        oLwT963Bfiea6gSBe+LgktnzsSaOeFA8BvCVX1rOTGqHv3fiAQsiRwlFx4R6S6X1hd+0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nCs8b-002sU0-Mx; Thu, 27 Jan 2022 00:55:41 +0100
Date:   Thu, 27 Jan 2022 00:55:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, hkallweit1@gmail.com,
        inux@armlinux.org.uk
Subject: Re: [PATCH net] MAINTAINERS: add more files to eth PHY
Message-ID: <YfHffTn5pC1mDSlM@lunn.ch>
References: <20220126202424.2982084-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126202424.2982084-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 12:24:24PM -0800, Jakub Kicinski wrote:
> include/linux/linkmode.h and include/linux/mii.h
> do not match anything in MAINTAINERS. Looks like
> they should be under Ethernet PHY.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
