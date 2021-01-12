Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A382F2438
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 01:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391713AbhALAZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:40060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404264AbhALAT5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 19:19:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF3D422D08;
        Tue, 12 Jan 2021 00:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610410757;
        bh=+jHd3FBR/xS82IUsdnfb3oZQaHCBiPM5qtKqQnRLvZY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nttW76Vo1u7Kp8u032LBwCj/Dm4Lh7g9v5pATzedjtmQUKJ9jTipOyGTmsfi62evM
         oAB1H59cAP1yc6ccZW02eS21MmSQdBcDLXQVkEHIeW4PsHp3VZDIdtPb1hdkc458tD
         bNQN6FAajXPejRhnrp+2Uj1Vnc+wXIdu2t5pcl4BNycu3AGE0ZU3J61b2wxUu+b4uX
         4rgpsqqAYMHi4RmYs7aDqX+chcRIPWSuH9ycVt5K3sMkoaY5AwRh31Q1pV+4Ydf3ae
         sUFDA2g+oPAO7qFIg1nzdLXT68u350YhY8c/HLF43k3Pbj6C8kochmVQHPn01rK3XX
         mS3sjQmtQ7D1w==
Date:   Mon, 11 Jan 2021 16:19:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: sfp: extend bitrate-derived mode for
 2500BASE-X
Message-ID: <20210111161916.19646eca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <X/swMh8TcD/l176c@lunn.ch>
References: <E1kyYQf-0004iY-Gh@rmk-PC.armlinux.org.uk>
        <X/swMh8TcD/l176c@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Jan 2021 17:49:54 +0100 Andrew Lunn wrote:
> On Sun, Jan 10, 2021 at 10:58:37AM +0000, Russell King wrote:
> > Extend the bitrate-derived support to include 2500BASE-X for modules
> > that report a bitrate of 2500Mbaud.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
