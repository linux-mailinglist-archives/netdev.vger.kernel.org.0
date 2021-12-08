Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D2946CF9E
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 09:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhLHJDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 04:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhLHJDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 04:03:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C899C061746;
        Wed,  8 Dec 2021 00:59:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D4EFB81FED;
        Wed,  8 Dec 2021 08:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E56C00446;
        Wed,  8 Dec 2021 08:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638953989;
        bh=T5PVij8+enQFZqVYqZGpoSAkYiH/mApNNKIaagOIjgM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TAlyMsgA9MGyQf9Lf/ptrXiwcCcvcT6wkNZd2+LK8w8di/nyyqtcPOPH20RwOB1Vy
         1mOF0pBoNzpFXaR6d5AMGXzVpxSsNX5+xMC46bgKot9G+nOY7orP1Q+51SCa6Y5Ue6
         Nzgp1BWiulHoik9ooZYlne2nZ2b261WXg0sElaqMwS+aAtksDlfYKuMyOPZxTPl/Ly
         GQpczoQnhKOHLugu7iz3gt2JqzWqI+d0GS70vqtUBg7tjyFuv369WSUrcSTTv/yPLX
         ymcaEE8Aemzu8jPbmZo8TX/7rq+pBKelMEaVKn3mZ3s4t91ogInNFNNiNeKWkFE24W
         E+werwVJGYktA==
Date:   Wed, 8 Dec 2021 10:59:45 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net/mlx5: Remove the repeated declaration
Message-ID: <YbB0AUPzeEjkb8bQ@unreal>
References: <20211207123515.61295-1-zhangshaokun@hisilicon.com>
 <Ya9WMysibKB7e5CF@unreal>
 <83cb3b17-09a7-fefe-6310-8ec5b992a6a7@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83cb3b17-09a7-fefe-6310-8ec5b992a6a7@hisilicon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 09:27:37AM +0800, Shaokun Zhang wrote:
> Hi Leon,
> 
> On 2021/12/7 20:40, Leon Romanovsky wrote:
> > On Tue, Dec 07, 2021 at 08:35:15PM +0800, Shaokun Zhang wrote:
> >> Function 'mlx5_esw_vport_match_metadata_supported' and
> >> 'mlx5_esw_offloads_vport_metadata_set' are declared twice, so remove
> >> the repeated declaration and blank line.
> >>
> >> Cc: Saeed Mahameed <saeedm@nvidia.com>
> >> Cc: Leon Romanovsky <leon@kernel.org>
> >> Cc: "David S. Miller" <davem@davemloft.net>
> >> Cc: Jakub Kicinski <kuba@kernel.org>
> >> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> >> ---
> >>  drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 3 ---
> >>  1 file changed, 3 deletions(-)
> >>
> > 
> > Fixes: 4f4edcc2b84f ("net/mlx5: E-Switch, Add ovs internal port mapping to metadata support")
> > 
> 
> Shall we need this tag since it is trivial cleanup patch?

I don't know about netdev policy about Fixes line.

IMHO, it should be always when the bug is fixed.

Thansk

> 
> > Thanks,
> > Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> 
> Thanks your reply.
> 
> > .
> > 
