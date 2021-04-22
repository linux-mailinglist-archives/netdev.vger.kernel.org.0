Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D1E3688E4
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 00:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239765AbhDVWKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 18:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236896AbhDVWKq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 18:10:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8683361421;
        Thu, 22 Apr 2021 22:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619129410;
        bh=TMQelfQjGHs/ILNy2Fy5Kvi6GIUQdq9gJxzgk3Lm918=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jIAVdG7C6dgdk08B8p9RABFCjMOCsahpQDk5Jb+q7KL6kH4gxNjD0ZMMnBC9pUoTK
         XqrOWUyaZp8eML2eFifF4zNilUM+dNvhf40FzJMRo0nQdDggiekrJGq+mf1xDhBxDA
         M/SWtrFpb8DYShyIvb3kHX5Zq3q5nlBjt1hsRGQ0P7T4lOQL8yDWCAIXIeqS+OWrZw
         oqdF1uB2Lrmbs3LW+ss6m/cOjj68UdFfvZ0vlFRqDlimahXVn3robhJRmT7g8J9sz5
         qjd1JXuf0c19FZDTYq5kDGN5MF1qQPSHZaiRdb1RkyIYHu0/pXvdorMkZG9627Ov7D
         49W/MWTnaNYiQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7D91660A52;
        Thu, 22 Apr 2021 22:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net/mlx4: Treat VFs fair when handling
 comm_channel_events
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161912941050.2979.11454821964984651039.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Apr 2021 22:10:10 +0000
References: <1619072500-13789-1-git-send-email-hans.westgaard.ry@oracle.com>
In-Reply-To: <1619072500-13789-1-git-send-email-hans.westgaard.ry@oracle.com>
To:     Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Cc:     tariqt@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Apr 2021 08:21:40 +0200 you wrote:
> Handling comm_channel_event in mlx4_master_comm_channel uses a double
> loop to determine which slaves have requested work. The search is
> always started at lowest slave. This leads to unfairness; lower VFs
> tends to be prioritized over higher VFs.
> 
> The patch uses find_next_bit to determine which slaves to handle.
> Fairness is implemented by always starting at the next to the last
> start.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net/mlx4: Treat VFs fair when handling comm_channel_events
    https://git.kernel.org/netdev/net-next/c/79ebfb11fe08

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


