Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64C32F6F04
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 00:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731050AbhANXiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 18:38:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:35792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbhANXiJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 18:38:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46A5023107;
        Thu, 14 Jan 2021 23:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610667449;
        bh=noG3xvDHyLnrzxqxjZ1wzIFafAuIIPgwVDdLQPRWPxM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DjQdqlKHOn7b3+qLfV+i63mxSwyu3PZPVqEsW8YMtZoSoXuOuB+/kAn4/GSTRaNyR
         3PnsCKkbG40pC/1Nml/1YmFth7p22Z0foU85GAU1/4qQSeRF0zJ4GOGAthC1OLwhvd
         WS0lg6KF+hj5iUP5B6bpOUxqhniLdBPrc4t/cvsahJBnULzCgyF4j7xvWzeFNVGUf9
         b8jdfAjreBaj6nuAJK2yKdOTbwCVMoaP/cf55fMFRt+oW0/gp04/ZYw1ilXJecfeND
         KbPGo9oQqB0kia3O555gjIjYJ5gtp96FPmnV645R6C/GKHpZ1d9YyXjDjhS36rkYbH
         rJ0qZPFzy85/g==
Date:   Thu, 14 Jan 2021 15:37:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: ar803x: disable extended next page
 bit
Message-ID: <20210114153728.68749dcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YADKXlEvv632wKlQ@lunn.ch>
References: <E1kzSdb-000417-FJ@rmk-PC.armlinux.org.uk>
        <YADKXlEvv632wKlQ@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 23:49:02 +0100 Andrew Lunn wrote:
> On Tue, Jan 12, 2021 at 10:59:43PM +0000, Russell King wrote:
> > This bit is enabled by default and advertises support for extended
> > next page support.  XNP is only needed for 10GBase-T and MultiGig
> > support which is not supported. Additionally, Cisco MultiGig switches
> > will read this bit and attempt 10Gb negotiation even though Next Page
> > support is disabled. This will cause timeouts when the interface is
> > forced to 100Mbps and auto-negotiation will fail. The interfaces are
> > only 1000Base-T and supporting auto-negotiation for this only requires
> > the Next Page bit to be set.
> > 
> > Taken from:
> > https://github.com/SolidRun/linux-stable/commit/7406c5244b7ea6bc17a2afe8568277a8c4b126a9
> > and adapted to mainline kernels by rmk.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Added missing 'm' to accommodate and applied, thanks!
