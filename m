Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE21E31046F
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 06:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhBEFRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 00:17:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:48646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229713AbhBEFR3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 00:17:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41E1D64FA1;
        Fri,  5 Feb 2021 05:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612502208;
        bh=GnvfanKHKRShnKCtLWeAXVkcdAE40M+rJL9Whas9zMk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hs4tbBGHM2dZqIPWpihZjCB4Ll+B3STfAlNWufg4XF+ZH6CqM2bYeLiaQXPmlHQwW
         Kd8X9h/xoCz7cf7Gi+x28zB1d5XuBl+kZE2Dg3nSIIwK/DB68JmtEN8K5A4qzTTWBZ
         UdRh1mPkeGpFtWuqIj1gVatZDUmb/R3lAa4uaaBwlkBQv6K6pGwT/jGatMOPArTTrM
         wBKwKsdb+eGl/Ckjl3HUMyjLYy380KhSzXsPnwAkW5hKprg8nruSaKw22PVZl6nir8
         N6vlSXGY3Zqvydzx42ivsdo/qmkWgKfLwusfzSi0gmA1po+Da3W3GNa7P3z9s1GI8R
         NGIy4KtKpJ0Jg==
Date:   Thu, 4 Feb 2021 21:16:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH net-next 5/7] net: marvell: prestera: add LAG support
Message-ID: <20210204211647.7b9a8ebf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210203165458.28717-6-vadym.kochan@plvision.eu>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
        <20210203165458.28717-6-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Feb 2021 18:54:56 +0200 Vadym Kochan wrote:
> From: Serhiy Boiko <serhiy.boiko@plvision.eu>
> 
> The following features are supported:
> 
>     - LAG basic operations
>         - create/delete LAG
>         - add/remove a member to LAG
>         - enable/disable member in LAG
>     - LAG Bridge support
>     - LAG VLAN support
>     - LAG FDB support
> 
> Limitations:
> 
>     - Only HASH lag tx type is supported
>     - The Hash parameters are not configurable. They are applied
>       during the LAG creation stage.
>     - Enslaving a port to the LAG device that already has an
>       upper device is not supported.

Tobias, Vladimir, you worked on LAG support recently, would you mind
taking a look at this one?
