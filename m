Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8802AA7EA
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 21:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgKGUlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 15:41:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgKGUlV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 15:41:21 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE094206C1;
        Sat,  7 Nov 2020 20:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604781680;
        bh=kxAn7e29If4/y5W6eMUCHK+YlR9sw920UlCWMtSpp5I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NP0hkjOMF3PLKd6n7mTInYYj2JdLYjvUjPTqknemYKJtBNCY2Ps/OnOzNi09K570C
         y81fKVC4iQe3RAXoRBBBb0SGl/i3uMmuHn1h4BL5c341FMYtGjl4euyCbHnoJQ8hq6
         2PEGEhtsLOg7sYkPzEwZWFq5mXBIKcYhy6fYI02k=
Date:   Sat, 7 Nov 2020 12:41:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [pull request][net v2 0/7] mlx5 fixes 2020-11-03
Message-ID: <20201107124120.38305b0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201105202129.23644-1-saeedm@nvidia.com>
References: <20201105202129.23644-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 12:21:22 -0800 Saeed Mahameed wrote:
> This series introduces some fixes to mlx5 driver.
> 
> v1->v2:
>  - Fix fixes line tag in patch #1
>  - Toss ktls refcount leak fix, Maxim will look further into the root
>    cause.
>  - Toss eswitch chain 0 prio patch, until we determine if it is needed
>    for -rc and net.
> 
> Please pull and let me know if there is any problem.
> 
> For -stable v5.1
>  ('net/mlx5: Fix deletion of duplicate rules')
> 
> For -stable v5.4
>  ('net/mlx5e: Fix modify header actions memory leak')
> 
> For -stable v5.8
>  ('net/mlx5e: Protect encap route dev from concurrent release')
> 
> For -stable v5.9
>  ('net/mlx5e: Fix VXLAN synchronization after function reload')
>  ('net/mlx5e: Use spin_lock_bh for async_icosq_lock')
>  ('net/mlx5e: Fix incorrect access of RCU-protected xdp_prog')
>  ('net/mlx5: E-switch, Avoid extack error log for disabled vport')

Pulled, thanks!
