Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D64210DE6E
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 18:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfK3RnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 12:43:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43592 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbfK3RnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 12:43:03 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1B7B314E09827;
        Sat, 30 Nov 2019 09:43:02 -0800 (PST)
Date:   Sat, 30 Nov 2019 09:42:59 -0800 (PST)
Message-Id: <20191130.094259.2137634376477573408.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     yuehaibing@huawei.com, linux-rdma@vger.kernel.org,
        kliteyn@mellanox.com, ozsh@mellanox.com, pablo@netfilter.org,
        eli@mellanox.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, elibr@mellanox.com, leon@kernel.org,
        roid@mellanox.com
Subject: Re: [PATCH] net/mlx5e: Fix build error without IPV6
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4da78750d80eb7b6099849ac8ffbae528b6d78e8.camel@mellanox.com>
References: <20191127132700.25872-1-yuehaibing@huawei.com>
        <20191127.112635.1621097212312385906.davem@davemloft.net>
        <4da78750d80eb7b6099849ac8ffbae528b6d78e8.camel@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 Nov 2019 09:43:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Sat, 30 Nov 2019 07:33:48 +0000

> On Wed, 2019-11-27 at 11:26 -0800, David Miller wrote:
>> From: YueHaibing <yuehaibing@huawei.com>
>> Date: Wed, 27 Nov 2019 21:27:00 +0800
>> 
>> > If IPV6 is not set and CONFIG_MLX5_ESWITCH is y,
>> > building fails:
>> > 
>> > drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:322:5: error:
>> redefinition of mlx5e_tc_tun_create_header_ipv6
>> >  int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
>> >      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> > In file included from
>> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:7:0:
>> > drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h:67:1: note:
>> previous definition of mlx5e_tc_tun_create_header_ipv6 was here
>> >  mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
>> >  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> > 
>> > Use #ifdef to guard this, also move mlx5e_route_lookup_ipv6
>> > to cleanup unused warning.
>> > 
>> > Reported-by: Hulk Robot <hulkci@huawei.com>
>> > Fixes: e689e998e102 ("net/mlx5e: TC, Stub out ipv6 tun create
>> header function")
>> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> 
>> Saeed et al., how do you want to handle this?
>> 
> 
> LGTM, I guess you can push this to net since this is dealing with a
> build error ?

Ok, I'll do that, thanks.
