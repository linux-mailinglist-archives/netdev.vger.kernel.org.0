Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD7D423F6D
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 15:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238274AbhJFNhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 09:37:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230023AbhJFNhw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 09:37:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1BDB61076;
        Wed,  6 Oct 2021 13:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633527360;
        bh=a0QQ3BdKFzREAG4YgeXQxom6x0nBUGn5ofM28WH6ccg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wjx6J/vP4Otob/UYgwjFKW/sJsmRTZftLGR07UXTSyuNmnCdrce8IcccWTBb28Mta
         Q+z5I7t1xm8Jnerq3+kVI7i4H/82JHrGTbJUmsy3JMLnycYPnFlC5YLXn2GEiWCJHc
         oQZKB+yFKkeve4aidu0yMTtX1B7usMQ2X2ivmik4VtEZ5dEQoFp9Rr8BGxP4BMzrQF
         4l4o8GjHZjAzC8vFKRuIhlX8UW0BGoOvMxD4dnz+/TqFi14tLYzqrJuJffljPPc/T+
         wp7esuL1Ftnb5HLwW5bsLjqhhdzD6QSRWFWS9ZN5ZZ9a/X74jc9cdQvbi3zkSLcTi4
         FSyMuHAfryZQQ==
Date:   Wed, 6 Oct 2021 06:35:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        mlxsw@nvidia.com, Moshe Shemesh <moshe@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shay Drory <shayd@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next v2 3/5] devlink: Allow set specific ops
 callbacks dynamically
Message-ID: <20211006063558.6f4ee82d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YV0aCADY4WkLySv4@unreal>
References: <cover.1633284302.git.leonro@nvidia.com>
        <92971648bcad41d095d12f5296246fc44ab8f5c7.1633284302.git.leonro@nvidia.com>
        <20211004164413.60e9ce80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YVv/nUe63nO8o8wz@unreal>
        <20211005113213.0ee61358@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YVykXLY7mX4K1ScW@unreal>
        <20211005173940.35bc7bfa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YV0aCADY4WkLySv4@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Oct 2021 06:37:44 +0300 Leon Romanovsky wrote:
> Let's chose random kernel version (v5.11)
> https://elixir.bootlin.com/linux/v5.11/source/net/core/devlink.c#L10245
> as you can see, it doesn't hold ANY driver core locks,

Nope, that is not what I see.

> so it can be called in any time during driver .probe() or .remove(). 

Having a callback invoked after registering to a subsystem (which used
to be the case for devlink before the changes) is _normal_.

You keep talking about .probe() like it's some magic period of complete
quiescence.

> Drivers that have implemented ops.flash_update() have no idea about that.

I bet.

I don't think this discussion is going anywhere, count me out.
