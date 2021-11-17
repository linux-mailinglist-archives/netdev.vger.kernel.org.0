Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67CF454C92
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 18:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239760AbhKQR5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 12:57:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38728 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239719AbhKQR5O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 12:57:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=clmMrSB02nk/FV3l3fqdX4PgU/ZeXCQX3UPfQqM4ZAM=; b=tHGQRFmfIhKXbJFCMdNlD7jno2
        Xjq5LD8Jl4oGZyIEhCNQ1XuNgH1UEuGpUlfovN2QXzMLcGRg5QIz8L1JB1Zf3p6GzR6Aa+Mz47EqR
        DXdfKphpghWwLbJ0ZENv59FJUuFjCZXJxUp3LZTUvzYhT0/i/689m/TSzSLtDhZG+/vI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mnP8K-00Dsth-Bv; Wed, 17 Nov 2021 18:54:08 +0100
Date:   Wed, 17 Nov 2021 18:54:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: mdio: Replaced BUG_ON() with WARN()
Message-ID: <YZVBwJEHLwpUl3ur@lunn.ch>
References: <20211117173629.2734752-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117173629.2734752-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 09:36:29AM -0800, Florian Fainelli wrote:
> Killing the kernel because a certain MDIO bus object is not in the
> desired state at various points in the registration or unregistration
> paths is excessive and is not helping in troubleshooting or fixing
> issues. Replace the BUG_ON() with WARN() and print out the MDIO bus name
> to facilitate debugging.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
