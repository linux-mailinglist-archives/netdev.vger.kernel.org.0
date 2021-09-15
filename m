Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7549B40C824
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 17:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238024AbhIOPV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 11:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234024AbhIOPV2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 11:21:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 85AC361186;
        Wed, 15 Sep 2021 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631719209;
        bh=bBE0UhKQlL1hvTx6lTt8ND6CSWazbOEHl36BlaBVxpI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q9hSMCml2fXQdVpQXCatN8cg8L7/NH5bImxp/jjtyfsYk6ht3G6hOujffn3K1IW3H
         xYr7egjhQC9UUbsxjBYscziVy4FeniohubcKH6idHUXN23kIFq2tQVBVtbU7qV8fzL
         7TbkhKSoDoOC617q2GzSlMKXK/alsLCk5evVEq7qMfvBIDH/h9ff3wSz4bcHehPwgI
         wwqGyRriEwTixPmZcpbI4/xYfHvzbBN6PbiC5MrX3I8I6/Oqbs1jCg/gLgoqB5WbPp
         piNO7hxWOD5PHdbPUt/aS7HjRZZxOQHUz6Jc6VU9VOCF5iuvRKj5OFK/UjjXtzDa9p
         bJVlKFQB5boTg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 73BEC60A9C;
        Wed, 15 Sep 2021 15:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Delete publish of single parameter API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163171920946.21180.12853132498476309022.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Sep 2021 15:20:09 +0000
References: <cover.1631623748.git.leonro@nvidia.com>
In-Reply-To: <cover.1631623748.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        ayal@nvidia.com, jiri@nvidia.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        saeedm@nvidia.com, tariqt@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 14 Sep 2021 15:58:27 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Hi,
> 
> This short series removes the single parameter publish/unpublish API
> that does nothing expect mimics already existing
> devlink_paramss_*publish calls.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net/mlx5: Publish and unpublish all devlink parameters at once
    https://git.kernel.org/netdev/net-next/c/e9310aed8e6a
  - [net-next,2/2] devlink: Delete not-used single parameter notification APIs
    https://git.kernel.org/netdev/net-next/c/c2d2f9885066

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


