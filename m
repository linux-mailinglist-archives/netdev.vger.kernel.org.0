Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD6742406B
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239152AbhJFOus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:50:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239140AbhJFOur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 10:50:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8403760F4C;
        Wed,  6 Oct 2021 14:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633531735;
        bh=NzdvoVd7vwsMXLmG484eEW7YZuuVevuhIB8FQKYnEC8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HKDmPSZ3x9VHDxbUuJoJut1zfY7qi8iUqRFlOb2vxcwgdjCuGK+rE6UbW0sJw3B3y
         h2pvw05Pq781w1rbsiJMtkWvLJad3eub/2pjzFH4dmdrI4/GphYb05tVL0EoCQ/Ad/
         x1unN83tc6CkHZDOwS5Y+P9529mGYUaClp1I9JTwdMSeLdqmi1623s3Iasx8VUeu6b
         6hSCBSceQrCNooCVM3YU46SCEgxBuho0M/OCJbNzvDGp2g4WJAw9Mw9MkGsAq1vMRt
         5VZaZmF/FIkqwAzclFwt6aBIsfXBSfz2CVwwru9dsmC5z0FKpe+WoEvNWK0xpN/b/S
         txRQMm7X+1HDQ==
Date:   Wed, 6 Oct 2021 17:48:51 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
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
Message-ID: <YV23U2gyRfgrT8EU@unreal>
References: <cover.1633284302.git.leonro@nvidia.com>
 <92971648bcad41d095d12f5296246fc44ab8f5c7.1633284302.git.leonro@nvidia.com>
 <20211004164413.60e9ce80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YVv/nUe63nO8o8wz@unreal>
 <20211005113213.0ee61358@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YVykXLY7mX4K1ScW@unreal>
 <20211005173940.35bc7bfa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YV0aCADY4WkLySv4@unreal>
 <20211006063558.6f4ee82d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006063558.6f4ee82d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 06, 2021 at 06:35:58AM -0700, Jakub Kicinski wrote:
> On Wed, 6 Oct 2021 06:37:44 +0300 Leon Romanovsky wrote:

<...>

> I don't think this discussion is going anywhere, count me out.

At least here, we agree on something.
