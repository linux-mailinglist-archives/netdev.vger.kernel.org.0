Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B593E2CDE15
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgLCSxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:53:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:33852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbgLCSxV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 13:53:21 -0500
Date:   Thu, 3 Dec 2020 10:52:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607021560;
        bh=sTJV0OxLyl4uNHY7jKwbl2YQkT5lptVy38snDdPmp60=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=TtjqfE/NJAu7EVc9sG3+6Fyu4+RyDIp3afPwG1Xg80Q7BYYtcIVlesOodjbgJxOOo
         G5fxMGy0ZugGupz2nR3b9LY7derWSntTXdGsfJo8az7+nWiWNxAPdlOokoTONz46hR
         dRwaLK5mwTYN/cEN9Tnbh51AMC8c6yLKDmrf05xnRnDJjLpxBpjzozuNyZtrJ3CR0y
         +VC2eILrHy82Fg4Ps7dcDRvgOYjc/vbeU2SCT6rHQg8c06jihMjQC7ADs2rcdlelkJ
         Y70yhNjtKWceJEpgFd4aE0lp3jLP85VfqE0acdKkkeLmwZs2QMNeUn49+G6FP5QIxl
         wdd5PL1aD1sEw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [pull request][net 0/4] mlx5 fixes 2020-12-01
Message-ID: <20201203105239.3e189565@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203043946.235385-1-saeedm@nvidia.com>
References: <20201203043946.235385-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Dec 2020 20:39:42 -0800 Saeed Mahameed wrote:
> Hi Jakub,
> 
> This series introduces some fixes to mlx5 driver.
> Please pull and let me know if there is any problem.
> 
> For the DR steering patch I will need it in net-next as well, I would
> appreciate it if you will take this small series before your pr to linus.
> 
> For -stable v5.4:
>  ('net/mlx5: DR, Proper handling of unsupported Connect-X6DX SW steering')
> 
> For -stable v5.8
>  ('net/mlx5: Fix wrong address reclaim when command interface is down')
> 
> For -stable v5.9
>  ('net: mlx5e: fix fs_tcp.c build when IPV6 is not enabled')

Your tree is missing your signoff on:

Commit 3041429da89b ("net/mlx5e: kTLS, Enforce HW TX csum offload with kTLS")
	committer Signed-off-by missing
	author email:    tariqt@nvidia.com
	committer email: saeedm@nvidia.com
	Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

You can fix it or I'll just apply the patches from the ML.
