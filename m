Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DFC30122C
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 03:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbhAWCIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 21:08:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:60786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbhAWCIc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 21:08:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E436323B26;
        Sat, 23 Jan 2021 02:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611367666;
        bh=XRQqG+aR57tpcyn6xO7vucieDJ01bwdumKjopVYalgg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SZ3QrbWRXnStrJg7Hm6ucve61R9zQWCPGMLTdHi7k8HxrbVCExyaXBgs5jlz84lMu
         ONESFHwUQUXOXba7NkWCC+lBky7spTVpUDatrfzR/ewORXUzf5Lq6G3fi2d6TkCoSq
         jG/SrVb5F5XiyPhnpVy72e+NGMIq5HOg2aLZ3NHlUoXAb53jy6VspRk5i8TKZu/iSZ
         b274n5iymLHfAxuAuyzt4GoXguTKUCQFv/JBx+bvYcl1h2ZRw3xSuSP15S2tDzOyrd
         S5o08FvNwkyTdO5Wu1Yvm4V1Uv4DG9YAuLZxhoZdG3xS7Cfe5WWGK/icNWjNVh9eQe
         jaO+K+GHLsqkg==
Date:   Fri, 22 Jan 2021 18:07:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        netdev@vger.kernel.org, torii.ken1@fujitsu.com
Subject: Re: [PATCH v3] net: phy: realtek: Add support for RTL9000AA/AN
Message-ID: <20210122180745.43353f75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YAng+Gf4pmviSuff@lunn.ch>
References: <20210121080254.21286-1-ashiduka@fujitsu.com>
        <YAng+Gf4pmviSuff@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 21:15:52 +0100 Andrew Lunn wrote:
> On Thu, Jan 21, 2021 at 05:02:54PM +0900, Yuusuke Ashizuka wrote:
> > RTL9000AA/AN as 100BASE-T1 is following:
> > - 100 Mbps
> > - Full duplex
> > - Link Status Change Interrupt
> > - Master/Slave configuration
> > 
> > Signed-off-by: Yuusuke Ashizuka <ashiduka@fujitsu.com>
> > Signed-off-by: Torii Kenichi <torii.ken1@fujitsu.com>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
