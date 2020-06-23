Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300EA2065CE
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388896AbgFWVdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:33:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390399AbgFWVd3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 17:33:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A02A20707;
        Tue, 23 Jun 2020 21:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592948008;
        bh=9NLg7n4Vm8YuhO5SLAOq3ATmcJRnYMPf7/udDDBSDBI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oDugkRISYUgLWN+1xRK+0FTsRkEAV0LvwNxhHM9AYpGCR+lJfNksI8qQxuWyhM7XC
         GiLIYevffhXhHLX3TaI9BSUOCrIbxh/URf2ZjsCJJbWukrjjLz5YUj6qcBIp3G1Wka
         LpYyVxsA1X+hBPa6DTVv9XoEi+uZMZU4OX6i3gPs=
Date:   Tue, 23 Jun 2020 14:33:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Roi Dayan <roid@mellanox.com>, Maor Dickman <maord@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [net-next 07/10] net/mlx5e: Move TC-specific function
 definitions into MLX5_CLS_ACT
Message-ID: <20200623143327.473a1d88@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3e259566a57c6ce50843c1fadd80530e3307bc62.camel@mellanox.com>
References: <20200623195229.26411-1-saeedm@mellanox.com>
        <20200623195229.26411-8-saeedm@mellanox.com>
        <20200623140357.6412f74f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3e259566a57c6ce50843c1fadd80530e3307bc62.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 21:26:02 +0000 Saeed Mahameed wrote:
> On Tue, 2020-06-23 at 14:03 -0700, Jakub Kicinski wrote:
> > On Tue, 23 Jun 2020 12:52:26 -0700 Saeed Mahameed wrote:  
> > > From: Vlad Buslov <vladbu@mellanox.com>
> > > 
> > > en_tc.h header file declares several TC-specific functions in
> > > CONFIG_MLX5_ESWITCH block even though those functions are only
> > > compiled
> > > when CONFIG_MLX5_CLS_ACT is set, which is a recent change. Move
> > > them to
> > > proper block.
> > > 
> > > Fixes: d956873f908c ("net/mlx5e: Introduce kconfig var for TC
> > > support")  
> > 
> > and here... do those break build or something?  
> 
> No, just redundant exposure and leftovers.
> Do you want me to remove the Fixes Tags ?
> Personally I don't mind fixes tags for something this basic,
> but your call.. 

If you don't mind - please remove them, IMHO frivolous use of Fixes
tags removes half of their value.
