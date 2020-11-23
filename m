Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4242C18D1
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732807AbgKWWtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:49:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731277AbgKWWtH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 17:49:07 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA28520717;
        Mon, 23 Nov 2020 22:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606171746;
        bh=+hKfuSHtqGsRaUlQQNwPdgKj27lIN/ygWLqzb1ZJ66Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HMAZyDQeQSAs0W/bPxyPtzCxLRZ7s1hQvX1mNyHpGtFuOECj+L0yEo5YVevuFWeGh
         Z8peswtZ2QfhlPvauJAwl+Op6VMKOgsvxotsve8pH/sbISHmSMXs8Rpv+J3ioOt8Sf
         /1yTBx5QByhZiNZYtZ5DqRBzEzAC+0mVbirGmHSE=
Date:   Mon, 23 Nov 2020 16:49:20 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 044/141] net/mlx4: Fix fall-through warnings for Clang
Message-ID: <20201123224920.GL21644@embeddedor>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <84cd69bc9b9768cf3bc032c0205ffe485b80ba03.1605896059.git.gustavoars@kernel.org>
 <0ba92238-2e31-b7d8-5664-72933dc76a7b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ba92238-2e31-b7d8-5664-72933dc76a7b@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 22, 2020 at 10:36:01AM +0200, Tariq Toukan wrote:
> 
> 
> On 11/20/2020 8:31 PM, Gustavo A. R. Silva wrote:
> > In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> > by explicitly adding a break statement instead of just letting the code
> > fall through to the next case.
> > 
> > Link: https://github.com/KSPP/linux/issues/115
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > ---
> >   drivers/net/ethernet/mellanox/mlx4/resource_tracker.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
> > index 1187ef1375e2..e6b8b8dc7894 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
> > @@ -2660,6 +2660,7 @@ int mlx4_FREE_RES_wrapper(struct mlx4_dev *dev, int slave,
> >   	case RES_XRCD:
> >   		err = xrcdn_free_res(dev, slave, vhcr->op_modifier, alop,
> >   				     vhcr->in_param, &vhcr->out_param);
> > +		break;
> >   	default:
> >   		break;
> > 
> 
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> 
> Thanks for your patch.

Thanks, Tariq.
--
Gustavo
