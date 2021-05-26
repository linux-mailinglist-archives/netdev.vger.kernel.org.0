Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B95F391FBD
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 20:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbhEZSzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 14:55:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58826 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234284AbhEZSzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 14:55:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zE041151kypdWo4gMk21qCJXHbuc8D4xGmUwPwBbqog=; b=JhKf0JRuW4swZd7iPJM/Pz+p+L
        +0rCz+sGacn+X/7MFQEALrJ9Tk6nP7pAO5evy/CWh1gEK0EOHkqbap+ViI5rDKsZRnZoqxx13TFYL
        MKj+r12KcE8ckOwuhpZ8f7NGMuNKa11BtvSwN8BJ7iwXiuF9l7xpQaERuehywOqWB06I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1llyez-006Nh8-W7; Wed, 26 May 2021 20:53:41 +0200
Date:   Wed, 26 May 2021 20:53:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: phy: Document phydev::dev_flags bits allocation
Message-ID: <YK6ZNbClPNCMl0Vx@lunn.ch>
References: <20210526184617.3105012-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526184617.3105012-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 11:46:17AM -0700, Florian Fainelli wrote:
> Document the phydev::dev_flags bit allocation to allow bits 15:0 to
> define PHY driver specific behavior, bits 23:16 to be reserved for now,
> and bits 31:24 to hold generic PHY driver flags.

Hi Florian

This is good as far as it goes. But do we want to give a hint that if
the MAC driver sets bits in [15:0] it should first verify the PHY has
the ID which is expected?

    Andrew
