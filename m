Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1E92F5715
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbhANB6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:58:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:54084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729542AbhAMXkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 18:40:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B39772339D;
        Wed, 13 Jan 2021 23:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610580529;
        bh=/EZwYISxGNRvhIju1ByI/D1UP+uy/O49FGZOPOUzmtE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JXs675/Qn17FdCSFNLTX/mkhUaEBEwHY0DWBc/w3kZe3KCnG+PPfEGO2qNBshti4L
         GtW0C4g42+/YBy/BJ5G8afSqdf4b5UW7DKULxaKfF0QXBh3rFq2tYO8AiSW6mKLtOP
         qGZ4bF5EG6sBIo/Ug040cOzY2qNw/sTLktZ6u2ns0WyrBP/EEWpt1oqy9gUH1iBGZi
         1ynSwogd1ZCoNc2w8vYmntesCfq8t4MSWX3wXMmGVLqbnHGeWAq8kmK5RZBbhevc2h
         C+kn3QK2ORO/z8vrgXQdG79Gj6oH5EIniTBdet9vQyJm0h0NuDEeOFDGT7Dlw7aeor
         se9FEnBtMUjPA==
Date:   Wed, 13 Jan 2021 15:28:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: phy: micrel: reconfigure the phy on resume
Message-ID: <20210113152847.3dc4f59e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com>
References: <1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Jan 2021 17:45:54 +0200 Claudiu Beznea wrote:
> KSZ9131 is used in setups with SAMA7G5. SAMA7G5 supports a special
> power saving mode (backup mode) that cuts the power for almost all
> parts of the SoC. The rail powering the ethernet PHY is also cut off.
> When resuming, in case the PHY has been configured on probe with
> slew rate or DLL settings these needs to be restored thus call
> driver's config_init() on resume.
> 
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>

I think Heiner rises an interesting point, and we can't have this patch
hanging in patchwork for much longer. We'll be expecting a fresh posting
once the discussion settles, regardless of the decision. 

Thanks!
