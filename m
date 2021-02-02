Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A06330CD4B
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 21:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbhBBUuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 15:50:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:41466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231193AbhBBUuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 15:50:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4D3C64F61;
        Tue,  2 Feb 2021 20:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612298976;
        bh=TxCiK9MFWxmE+ojs+vuVEd7RHvf0a7ydvFCMKQDzY4w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gvHI9GG2gYhFGStNFewc6yQADNDHMES2D9l+feHm/lpAZ+6lZ6cYnt/HZW5XK+pqL
         u+UaAzp+dC6s23XTl8Z5+yoAfPybddjxP59FEGKhg5g+vDaz9IBtSM0WeHu1GEOTYM
         ATLZZAkAeE52s39GG/rH04OaKCp5bGK3Tpfyz9DA2m5b+X4Z8AAPigVW2ZxqkBIhTE
         w0An+ydB4Zdkl4eleFz4aCuWPGDobIKuABPQ+eIQdFzTL+iV4Q7QmFCjqgnMX70Tbe
         byyJaA6fzUZZDd2sTEqciqOkBdTwc0Ozl/fk5HD6ZViNZ1Fa35NY9VTxp7rq9QDrfA
         yAvko/bpQWEog==
Date:   Tue, 2 Feb 2021 12:49:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>, <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next v2 0/4] bridge: mrp: Extend br_mrp_switchdev_*
Message-ID: <20210202124934.65c90df9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210202200649.mc7vpgltoqxf2oni@soft-dev3.localdomain>
References: <20210127205241.2864728-1-horatiu.vultur@microchip.com>
        <20210129190114.3f5b6b44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9143d15f-c41d-f0ab-7be0-32d797820384@prevas.dk>
        <20210202115032.6affffdc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210202200649.mc7vpgltoqxf2oni@soft-dev3.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Feb 2021 21:06:49 +0100 Horatiu Vultur wrote:
> The 02/02/2021 11:50, Jakub Kicinski wrote:
> > On Tue, 2 Feb 2021 08:40:02 +0100 Rasmus Villemoes wrote:  
> > > I am planning to test these, but it's unlikely I'll get around to it
> > > this week unfortunately.  
> > 
> > Horatiu are you okay with deferring the series until Rasmus validates?
> > Given none of this HW is upstream now (AFAIU) this is an awkward set
> > to handle. Having a confirmation from Rasmus would make us a little bit
> > more comfortable.  
> 
> It is perfectly fine for me to wait for Rasmus to validate this series.
> Also I have started to have a look how to implement the switchdev calls
> for Ocelot driver. I might have something by the end of the week, but
> lets see.

Great, thanks! Please repost once we got the confirmation.


