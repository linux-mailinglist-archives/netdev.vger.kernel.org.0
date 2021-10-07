Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4696C425541
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 16:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242055AbhJGOXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 10:23:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54358 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241042AbhJGOXm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 10:23:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gytudVVpq8SCrMKAKvcKmqBixUZdzXLUudXgXA2mOUM=; b=lEqh9R2YOfEiz08X/G5FBY7XpQ
        AF8u8Usb1OL53Lp8NBYpUnkMggwH40x0VXxcoANCmKoJrq6UzNt6dmLyFDZ6cTN0ijPsd5oAzmRfc
        HZEaM+WPQUGskhL2Q2XHD661O0WEdAT3rAogX4zTYIKj6ah1g1KFx8ZI9gzlUlzq+LLU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYUHJ-009xPk-Dp; Thu, 07 Oct 2021 16:21:45 +0200
Date:   Thu, 7 Oct 2021 16:21:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, michael@walle.cc
Subject: Re: [PATCH net-next 3/3] ethernet: use platform_get_ethdev_address()
Message-ID: <YV8CedxWOaC22Gkt@lunn.ch>
References: <20211007132511.3462291-1-kuba@kernel.org>
 <20211007132511.3462291-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007132511.3462291-4-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 06:25:11AM -0700, Jakub Kicinski wrote:
> Use the new platform_get_ethdev_address() helper for the cases
> where dev->dev_addr is passed in directly as the destination.
> 
>   @@
>   expression dev, net;
>   @@
>   - eth_platform_get_mac_address(dev, net->dev_addr)
>   + platform_get_ethdev_address(dev, net)
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
