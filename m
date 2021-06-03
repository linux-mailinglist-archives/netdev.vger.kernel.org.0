Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DB939AE2A
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhFCWlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhFCWlv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 18:41:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1087361402;
        Thu,  3 Jun 2021 22:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622760006;
        bh=4r+KaXf9HhPfPuJ3L0A6ucBPg67H8QvheAAx7CS+HS0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tJqr86vh3Q3ZL/yQkDKIIVUuXi0nnWG/CMD7GIg8k4YQXl0RCXGUgB3Lb9KrA6WVn
         mYvTFZ7qiewnTrZNsGRd9JlMCC5nctShVFq8EZKHcIc25ZgCfA1i8tveWc0LDaeKnv
         Y7ziWe0hV358zYkif8B5csGj7pznhIlzPkgs34FDfuHRwQS8v7auIftpqXTLFpyI3B
         3bYVYjDQY7/qMY+xqURwc5V7lBVpTN2iCtMWosKU0axxH008KhSlPAIT/zDL4MY9IP
         Gwlw+oycaYPOI9GLiMvqYiAoo5BFE90Kr9Uxj0jOsh9ILnjP1LYLIWWXMcJIijpBYJ
         MHClJ0aZhQDWg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 030DA60A6F;
        Thu,  3 Jun 2021 22:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] netdevsim: Fix unsigned being compared to less than
 zero
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162276000600.13062.15630996018975105780.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 22:40:06 +0000
References: <20210603215657.154776-1-colin.king@canonical.com>
In-Reply-To: <20210603215657.154776-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     kuba@kernel.org, davem@davemloft.net, dlinkin@nvidia.com,
        yuvalav@nvidia.com, jiri@nvidia.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  3 Jun 2021 22:56:57 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The comparison of len < 0 is always false because len is a size_t. Fix
> this by making len a ssize_t instead.
> 
> Addresses-Coverity: ("Unsigned compared against 0")
> Fixes: d395381909a3 ("netdevsim: Add max_vfs to bus_dev")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - [next] netdevsim: Fix unsigned being compared to less than zero
    https://git.kernel.org/netdev/net-next/c/ebbf5fcb94a7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


