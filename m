Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E0630926B
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 07:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhA3GFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 01:05:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230355AbhA3GD6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 01:03:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 74BF964E18;
        Sat, 30 Jan 2021 02:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611973808;
        bh=KRsECL0CY8vrmNohnQdX/oDh0SnoLw4AGId9AWLrICE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FqMcmHqp/oqVs7iwm7USlDGLneuNJ29nGKDSkkE9tcv6aIZvrCmUtpAv26bQNSOFk
         KnVpmc/lqHJ0RSCWsJBUZb6YeqWMlwMFGsE3PC0+blMBesr06nheP5OfuW1J96m23t
         ie73eJirgP2hiTEJNroZlc0QA8dECQwVARNRKVch3z490octJiGXJDETBb8knBHXXm
         NyIgWRJaSaVcq77v8nX553v08l9klm2DKmXfw0ApRBM4JXTqvHTZciyblywOdHaYbU
         v3dLdoMwzDq/qRxX9YCnjU0vTjqqRVdodJcqi5wLkWaX06bElEGFcCx/Mhy4TkTkPN
         MRjNm7bZ+rr2w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6B61F6095C;
        Sat, 30 Jan 2021 02:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net/sched: cls_flower: Add support for matching
 on ct_state reply flag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161197380843.28728.7197592752143377200.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jan 2021 02:30:08 +0000
References: <1611757967-18236-1-git-send-email-paulb@nvidia.com>
In-Reply-To: <1611757967-18236-1-git-send-email-paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, davem@davemloft.net,
        kuba@kernel.org, xiyou.wangcong@gmail.com, vladbu@nvidia.com,
        ozsh@nvidia.com, roid@nvidia.com, jiri@nvidia.com,
        saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 27 Jan 2021 16:32:44 +0200 you wrote:
> This patchset adds software match support and offload of flower
> match ct_state reply flag (+/-rpl).
> 
> The first patch adds the definition for the flag and match to flower.
> 
> Second patch gives the direction of the connection to the offloading drivers via
> ct_metadata flow offload action.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net/sched: cls_flower: Add match on the ct_state reply flag
    https://git.kernel.org/netdev/net-next/c/8c85d18ce647
  - [net-next,2/3] net: flow_offload: Add original direction flag to ct_metadata
    https://git.kernel.org/netdev/net-next/c/941eff5aea5d
  - [net-next,3/3] net/mlx5: CT: Add support for matching on ct_state reply flag
    https://git.kernel.org/netdev/net-next/c/6895cb3a95c9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


