Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85870456084
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbhKRQeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:34:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40890 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232841AbhKRQeK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 11:34:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=u9DHdSwC6kM/XXgGIze7GoPBJLaS72VY8WJLlQ1X+0Y=; b=Gb
        u/S4To55rvC4JhcYaSO+7r1YxjVWifhdbqFy1aVpvV7sACBbpcqCAGPtdwS+s9YJawsSLRfevDOJu
        RF39n7R8nL/3pGE/09z0+FKk7OP8aNH6PSjG+oOAorvWTJ0cG2siU3Hav69tCiTf9VsPoCjTL9HcG
        fNhCgQp9O01/ie4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mnkJX-00E0AS-Bg; Thu, 18 Nov 2021 17:31:07 +0100
Date:   Thu, 18 Nov 2021 17:31:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/8] device property: add helper function for
 getting phy mode bitmap
Message-ID: <YZZ/y9qXKL8zhTfu@lunn.ch>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-4-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211117225050.18395-4-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 11:50:45PM +0100, Marek Behún wrote:
> Now that the 'phy-mode' property can be a string array containing more
> PHY modes, add helper function fwnode_get_phy_modes() that reads this
> property and fills in PHY interfaces bitmap.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
