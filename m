Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D8F3938A9
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 00:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236306AbhE0WVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 18:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236141AbhE0WVh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 18:21:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C103B60FE3;
        Thu, 27 May 2021 22:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622154003;
        bh=15gavqVpmrkTzK7qxiXx5eKR7o4eATUPo08BBMbpMLY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Aw7VtNkCVScgEUcoD81AAMqIFdK1EG0IBeX/Rzq5ZtGyCs/tP5EyMZxsdmdGs0zFa
         TsSPaixVlY6GSlxRiIBBDYDutEHj8xlRj6fJxkJhh885kcpHCPxaT5tl6CZsqjLi8P
         l94tQ22b++AvREMZxBcBMz2LGtdVQ7VIlxmrH9L0FXRdo7gYi01KR0yDcALQNLvAYD
         y1AkaG129fyINg7efloVGRZvamYSPgzKMJ8u7yBQXtoA9fPMfBn4tM1b8i7d8gxMhQ
         sN3Su4gWrnQxewDdm5TUIzAfCPO1bJPxycBAAVTQsmkodrEH8m8aPHig4rKX/cuw04
         7/F8FMjkaXlYw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B53AB60BD8;
        Thu, 27 May 2021 22:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: act_ct: Fix ct template allocation for zone 0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162215400373.3007.7103318975203350675.git-patchwork-notify@kernel.org>
Date:   Thu, 27 May 2021 22:20:03 +0000
References: <20210526170110.54864-1-lariel@nvidia.com>
In-Reply-To: <20210526170110.54864-1-lariel@nvidia.com>
To:     Ariel Levkovich <lariel@nvidia.com>
Cc:     netdev@vger.kernel.org, marcelo.leitner@gmail.com,
        paulb@nvidia.com, jiri@resnulli.us
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 26 May 2021 20:01:10 +0300 you wrote:
> Fix current behavior of skipping template allocation in case the
> ct action is in zone 0.
> 
> Skipping the allocation may cause the datapath ct code to ignore the
> entire ct action with all its attributes (commit, nat) in case the ct
> action in zone 0 was preceded by a ct clear action.
> 
> [...]

Here is the summary with links:
  - [net] net/sched: act_ct: Fix ct template allocation for zone 0
    https://git.kernel.org/netdev/net/c/fb91702b743d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


