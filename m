Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21119417571
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 15:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345513AbhIXNXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 09:23:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346457AbhIXNVl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 09:21:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A751361269;
        Fri, 24 Sep 2021 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632489608;
        bh=B7Hp3DH9IA+8vb6RHWlanVpTye/C7yxBj6Vx+ioMTJw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UqdyuKUvQioIeLdo9HGKwbGZp+AruGuwjGeKfMs8j8UBjQN0gEzNAeAiQBLY7MFpt
         d/X6vfWWO2akJaUwT5dRllnHkSljHb63LX5RVwNd0YKh0widXhbG7PENy3DWBzKgWQ
         D78UQQXlMCbv3GNmAZcIow6JKqJGK+6a49xrlNbHRu9N/FRV9HplD4oMP2/KVVfnGF
         +8i4tJJm0VMwEhPzONKXBeZVb39BlVrPPAb34yKc9VqIBDp7s9z12YnJcHrJ9fj40g
         Anh9E1GERBT76Us5t86q+42Qz8RM9CQ+Ulq4BTT2asmcC4fCPdMcFmMHAdN+aF6eIp
         bE6OI8uNOEdrg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9BEA960BC9;
        Fri, 24 Sep 2021 13:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mlx4: Add support for XDP_REDIRECT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163248960863.28971.6919778213392766348.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Sep 2021 13:20:08 +0000
References: <20210923161034.18975-1-roysjosh@gmail.com>
In-Reply-To: <20210923161034.18975-1-roysjosh@gmail.com>
To:     Joshua Roys <roysjosh@gmail.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 23 Sep 2021 12:10:34 -0400 you wrote:
> Signed-off-by: Joshua Roys <roysjosh@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> This is a pattern-match commit, based off of the mlx4 XDP_TX and other
> drivers' XDP_REDIRECT enablement patches. The goal was to get AF_XDP
> working in VPP and this was successful. Tested with a CX3.

Here is the summary with links:
  - [net-next] net: mlx4: Add support for XDP_REDIRECT
    https://git.kernel.org/netdev/net-next/c/a8551c9b755e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


