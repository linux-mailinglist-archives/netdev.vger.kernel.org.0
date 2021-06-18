Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D10D3AD224
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 20:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbhFRScQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 14:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231553AbhFRScP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 14:32:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8BC9B613F3;
        Fri, 18 Jun 2021 18:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624041005;
        bh=guf8kqFOHewgiez6tyVEKwVw06CLOr6wrVb3FAInSGw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BYaQl836pelcb2VSOJtj08JZ0Xm5LMNDV2UQ704xtruKfM2WVXTgGe1pf7wjqnsJn
         7vaN+W8k3uiSbxBeNkJYczBy7sUZ98Myq6DKEbZ6lOTbc6k2bqqAEWq0d7aMk0ovuq
         P7JIYXJ+smox2gYV9BO85HyrqBSfAe3+qRWixvR6rEegjiULZkU1yKy9N8WHFNxPpJ
         8BwiCjTNSV4F0GYl9EyroJ1vf9svoFuf/nCA6Iq47icMASgRyO+GxLxVy4DQHbVMGq
         AN7n+/vWZqe+OUF5pfHjrpztNt0URrQp89uIUTbyHQrEPp6vODZV9CpLLm6QB/AXQJ
         fI9z1NtBbal+Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 85ECD60A17;
        Fri, 18 Jun 2021 18:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] drivers: net: netdevsim: fix devlink_trap
 selftests failing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404100554.18542.3041947228503755195.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 18:30:05 +0000
References: <20210617113632.21665-1-oleksandr.mazur@plvision.eu>
In-Reply-To: <20210617113632.21665-1-oleksandr.mazur@plvision.eu>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     jiri@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vadym.kochan@plvision.eu, idosch@idosch.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 17 Jun 2021 14:36:32 +0300 you wrote:
> devlink_trap tests for the netdevsim fail due to misspelled
> debugfs file name. Change this name, as well as name of callback
> function, to match the naming as in the devlink itself - 'trap_drop_counter'.
> 
> Test-results:
> selftests: drivers/net/netdevsim: devlink_trap.sh
> TEST: Initialization                                                [ OK ]
> TEST: Trap action                                                   [ OK ]
> TEST: Trap metadata                                                 [ OK ]
> TEST: Non-existing trap                                             [ OK ]
> TEST: Non-existing trap action                                      [ OK ]
> TEST: Trap statistics                                               [ OK ]
> TEST: Trap group action                                             [ OK ]
> TEST: Non-existing trap group                                       [ OK ]
> TEST: Trap group statistics                                         [ OK ]
> TEST: Trap policer                                                  [ OK ]
> TEST: Trap policer binding                                          [ OK ]
> TEST: Port delete                                                   [ OK ]
> TEST: Device delete                                                 [ OK ]
> 
> [...]

Here is the summary with links:
  - [net-next,v2] drivers: net: netdevsim: fix devlink_trap selftests failing
    https://git.kernel.org/netdev/net-next/c/275b51c27cc3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


