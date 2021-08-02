Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7013DDAA3
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238673AbhHBOR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:17:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236536AbhHBOPn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:15:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA9F560555;
        Mon,  2 Aug 2021 14:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627913731;
        bh=oXmp2YxkwyfmyIthIzrS1T0ojqznGMIJnaKDB8CNJUM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EUY5bWaMUNMHlJhecnoIZYUhlKur1QDTsV46Ez0f5Y2JQ0o9da3TIvNqt7ws6B3Zt
         lOl2hUKI0uf6LAfH/9S2PujprxGIqBGWlwv+yeyQ/bk1R7vIpe/V1nNsL7XWe+ZUcN
         mS4RBdxAd8bU1x0oz//OXY1KzwDfVnV/eQWsphaMKvfZ7Bhvskz/abaHKOYtyetPRc
         Wp8Df2AWB9YlPS7WpfSH94bfX3WMuCe/hm90e029O2QgemJa8bAl+lbGQCGSl9Xy4Y
         7oL31t9/z+a1jK1tUdu0bur1OQjSY9xYf7H1lXnCyzTQZBkTozdU3vtD6adngdVZTK
         gftQPXiSFojfw==
Date:   Mon, 2 Aug 2021 07:15:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] ethtool: runtime-resume netdev parent
 before ethtool ops
Message-ID: <20210802071531.34a66e68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8bcca610-601d-86d0-4d74-0e5055431738@gmail.com>
References: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
        <8bcca610-601d-86d0-4d74-0e5055431738@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 1 Aug 2021 18:25:52 +0200 Heiner Kallweit wrote:
> Patchwork is showing the following warning for all patches in the series.
> 
> netdev/cc_maintainers	warning	7 maintainers not CCed: ecree@solarflare.com andrew@lunn.ch magnus.karlsson@intel.com danieller@nvidia.com arnd@arndb.de irusskikh@marvell.com alexanderduyck@fb.com
> 
> This seems to be a false positive, e.g. address ecree@solarflare.com
> doesn't exist at all in MAINTAINERS file.

It gets the list from the get_maintainers script. It's one of the less
reliable tests, but I feel like efforts should be made primarily
towards improving get_maintainers rather than improving the test itself.
