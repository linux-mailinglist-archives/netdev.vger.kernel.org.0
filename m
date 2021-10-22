Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FC04380A3
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhJVXc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:32:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230086AbhJVXc0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 19:32:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C51FA61037;
        Fri, 22 Oct 2021 23:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634945407;
        bh=wCzLRSne1yFxq/2gRBYVkpE3tJsoqmF0PS7wnKEJiNU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K7lS71kx9cfrQHFI/TqzS5SD6Ls+ejxqBoHbKSUkHNZ0OMO6jtVbvV68XAfxDb7db
         Zxxo0zN3DwPmUnsM6AMn+53UfTOO0p5i14rRQyGibeDacuYLTsSBT2uI0QaBUIG3R1
         tbVWeOv556/VD3P46niIuzdgHNbGH2glkxtPmZr8JjkS+7ooEyRboBD12btG4fS9If
         +t19vu1ahZ8hm0h05GT7kBKNiEN6wRjjF3bnI8mAuGifIdqG1w1Yl6WoBnu/i6+JmU
         6lwMC0up8Hve6olifqQkfMvuyVfBnk6tjfXY9pVqTG3baWjVgCvcBmxIqG/fBuiZRB
         zuG7Fbc8San7w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B7AF560A47;
        Fri, 22 Oct 2021 23:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] Delete impossible devlink notifications
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163494540774.28829.5859060207065094181.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Oct 2021 23:30:07 +0000
References: <cover.1634825474.git.leonro@nvidia.com>
In-Reply-To: <cover.1634825474.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        jiri@nvidia.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 21 Oct 2021 17:16:12 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> This series is a followup to the delayed devlink notification scheme.
> 
> I removed the impossible notifications together with attempt to annotate
> various calls in order to mark them as pre/post devlink)register().
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] devlink: Delete obsolete parameters publish API
    https://git.kernel.org/netdev/net-next/c/99ad92eff764
  - [net-next,2/4] devlink: Remove not-executed trap policer notifications
    https://git.kernel.org/netdev/net-next/c/22849b5ea595
  - [net-next,3/4] devlink: Remove not-executed trap group notifications
    https://git.kernel.org/netdev/net-next/c/8bbeed485823
  - [net-next,4/4] devlink: Clean not-executed param notifications
    https://git.kernel.org/netdev/net-next/c/7a690ad499e7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


