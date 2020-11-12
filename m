Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597FB2B1182
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgKLW2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:28:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:60530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgKLW2G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 17:28:06 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8400622201;
        Thu, 12 Nov 2020 22:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605220086;
        bh=hqzOEE9slJHruPm1S91dR08YcGHz3IXTTJKdDrMbBnM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UTj1RnCC9I1G1KeM9CqGcuIegTsZ8oAcS4EHi/fVpM0ezOFn5VXo9edfiyl7QmOwW
         vEoy8wyaB2fVvwL6cRy6y3BK2roXnyrr5j4WGahFSTan0/ZhX+6ze0P1B7PRcjvZn0
         WORN4jEvrpJzudgIUv3BGwVJ/bHIFTLtjc7UaIdw=
Date:   Thu, 12 Nov 2020 14:28:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <atenart@kernel.org>,
        Bryan Whitehead <Bryan.Whitehead@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        John Haechten <John.Haechten@microchip.com>,
        Netdev List <netdev@vger.kernel.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: phy: mscc: remove non-MACSec compatible phy
Message-ID: <20201112142804.3787760c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112090429.906000-1-steen.hegelund@microchip.com>
References: <20201112090429.906000-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 10:04:29 +0100 Steen Hegelund wrote:
> Selecting VSC8575 as a MACSec PHY was not correct
> 
> The relevant datasheet can be found here:
>   - VSC8575: https://www.microchip.com/wwwproducts/en/VSC8575
> 
> Fixes: 0a504e9e97886 ("net: phy: mscc: macsec initialization")
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>

Fixes tag: Fixes: 0a504e9e97886 ("net: phy: mscc: macsec initialization")
Has these problem(s):
	- Subject does not match target commit subject
	  Just use
		git log -1 --format='Fixes: %h ("%s")'
