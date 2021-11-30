Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE63463A99
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240001AbhK3P4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:56:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59684 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240281AbhK3Pyo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 10:54:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pN4EA5seKoqxjQ2Bt6gErRj/xnZqQ/ncrNhlWgQfBBo=; b=vCxuOhZ6YV7Ru0y+syqkJcsLsd
        d8uoAlC5NvLzf0kMXt77FNUug/terCMapmRwIw4rGFGgTy02l77X3uY8Ray9ZK/VOt0H5XZQzV57v
        rClGeKIQvSopw4YqCnO1V2fLTTMZrSsX9+qoss6t8kNvv4bQxI7ORYVl1oZUsKRtn4kI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ms5PI-00F7Iw-Jw; Tue, 30 Nov 2021 16:51:00 +0100
Date:   Tue, 30 Nov 2021 16:51:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phylink: tidy up disable bit clearing
Message-ID: <YaZIZOaSkp50PcHj@lunn.ch>
References: <E1ms4Rx-00EKEc-En@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ms4Rx-00EKEc-En@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 02:49:41PM +0000, Russell King wrote:
> Tidy up the disable bit clearing where we clear a bit and the run the
> link resolver.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
