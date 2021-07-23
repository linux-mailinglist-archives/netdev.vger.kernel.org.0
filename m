Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8383D418B
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 22:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhGWTtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 15:49:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231168AbhGWTtc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 15:49:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4572D60F25;
        Fri, 23 Jul 2021 20:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627072205;
        bh=Y3vOXmTZ6FMX35K2oO4l/v3gslI8iJttyNT+ssTw8Xc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BHp9PCHxDx5aGV3q2+iEjflXtHlCrAwDIWCptQNYEfZnOxZMnTL85v/U6YH1Qdioz
         A39GQd+yK739PBtN/zVDnTvfXvGfbWCiSsNeuXVyjj0kxhHOuVHzyDq/JWgNsO0Chc
         uF6Rh/2l+l0tIngK+wwZsxtmmvG5yhSNLMyO/ObK1Mn+ou3x0xOgswUIRxLhqkZZHO
         TKac393tqzOVXnj21rB7nrs17mAgHeL1PKBOYxfLyNTTWX8W7CPBxEHJjQHQCpojMX
         sXONNBwTzl9J48x2bG/fIPu6h+/+3hh0BAockmHQEv5yDRZiAljEBc2afN2uEtS5YK
         8f3qbupoD20uA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 379036096D;
        Fri, 23 Jul 2021 20:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3][pull request] 1GbE Intel Wired LAN Driver
 Updates 2021-07-23
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162707220522.29548.10333536015615861177.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Jul 2021 20:30:05 +0000
References: <20210723170910.296843-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210723170910.296843-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 23 Jul 2021 10:09:07 -0700 you wrote:
> This series contains updates to igb and e100 drivers.
> 
> Grzegorz adds a timeout check to prevent possible infinite loop for igb.
> 
> Kees Cook adjusts memcpy() argument to represent the entire structure
> to allow for appropriate bounds checking for igb and e100.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] igb: Add counter to i21x doublecheck
    https://git.kernel.org/netdev/net-next/c/07be39e32d0a
  - [net-next,2/3] igb: Avoid memcpy() over-reading of ETH_SS_STATS
    https://git.kernel.org/netdev/net-next/c/c9183f45e4ac
  - [net-next,3/3] e100: Avoid memcpy() over-reading of ETH_SS_STATS
    https://git.kernel.org/netdev/net-next/c/cd74f25b28ce

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


