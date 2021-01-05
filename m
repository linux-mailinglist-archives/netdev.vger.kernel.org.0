Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAA22EB4A4
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 22:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbhAEVEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 16:04:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728938AbhAEVEy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 16:04:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16AAC22D5A;
        Tue,  5 Jan 2021 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609880654;
        bh=Mex4he2eeuSZXX28QgBED6uPOLb/WpJ6zWS5NGBDB8s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PHGW+0ZaKGYs9uEYPMbydBXYmLVqVcvASF/VgbKIFye6pmSHhOGAO+5PumV6uLeUD
         OGMhQ22cTqMMwp1rLub7zZMl7P8TeLHHamQeXGvBm1lgnLulrY5oOhuY1DEYYzov5G
         x4gmT7F3j85jiMlvZEbaGUV3swj1SLeqBCR56Cmjrx2Is4IG7hg++t9jZt6SstNIfz
         HZU4PaKnhwq9+sgAKhCePrGH0dLCJHSBc1/Kj60z2aM9RuM+hxne5xTC1DLpSAM8Bv
         O6tDMfYcFI3ISvJMFEfKYddek08dvGqKJ//P5PYsED52F9rvNp5dQUwB4h2NAGsUKM
         qrtQ3jgSMpoew==
Message-ID: <0f5be5508fd3110e01823d03b3188f5ceef3a5d1.camel@kernel.org>
Subject: Re: [PATCH] net/mlx5e: Fix memleak in mlx5e_create_l2_table_groups
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 05 Jan 2021 13:04:10 -0800
In-Reply-To: <20201227083302.GD4457@unreal>
References: <20201221112731.32545-1-dinghao.liu@zju.edu.cn>
         <20201227083302.GD4457@unreal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-12-27 at 10:33 +0200, Leon Romanovsky wrote:
> On Mon, Dec 21, 2020 at 07:27:31PM +0800, Dinghao Liu wrote:
> > When mlx5_create_flow_group() fails, ft->g should be
> > freed just like when kvzalloc() fails. The caller of
> > mlx5e_create_l2_table_groups() does not catch this
> > issue on failure, which leads to memleak.
> > 
> > Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> 
> Fixes: 33cfaaa8f36f ("net/mlx5e: Split the main flow steering table")
> 
Added

> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

Applied to net-mlx5
Thanks


