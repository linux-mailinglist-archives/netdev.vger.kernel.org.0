Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACDC485532
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbiAEPAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:00:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53102 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233942AbiAEPAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 10:00:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=x6gK5yY1yxb0eY2ySqbL451Layn3bnny98jgg9LwDck=; b=CzFBW3i8yFUwT0ZPrhoF0HPrJJ
        DIzqU4PaR/vTT8ZJqozBOGXrcfpFTT9juCsY9C7WUd9EahJ4YmLajGW5ZJOzsNx+GZc7zGkxwlB1r
        UISFYo+hgpKMtjKBzVPTMD+kAzmf4P8P1tHCRETK330x7HPh8mRYYRlw3LJxS2GejEyk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n57lk-000ZN7-8W; Wed, 05 Jan 2022 16:00:04 +0100
Date:   Wed, 5 Jan 2022 16:00:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     trix@redhat.com
Cc:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        arnd@arndb.de, danieller@nvidia.com, gustavoars@kernel.org,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethtool: use phydev variable
Message-ID: <YdWydCivOs6yE8fj@lunn.ch>
References: <20220105141020.3793409-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105141020.3793409-1-trix@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 06:10:20AM -0800, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> In ethtool_get_phy_stats(), the phydev varaible is set to
> dev->phydev but dev->phydev is still used.  Replace
> dev->phydev uses with phydev.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
