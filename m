Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C37742B2CA
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 04:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236389AbhJMCmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 22:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233316AbhJMCmN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 22:42:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8CAAB61040;
        Wed, 13 Oct 2021 02:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634092810;
        bh=FM4OZoJEd+Rm6Opfou6pfoWmAWCe6TixGTniwtVN2nw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pgQyuGifmmqhYK+s9Ffrz9SeKLYbS1HNjGTeHa+EDD3/5iL7zNhzL32JNpfExOvDl
         gGKQK90cqro7llN5Am05lOdwGfyVWeVbpIkL7OzQM43n9TOKDUq4Bsn7YM/3ILg5uu
         TzrkjCuq/qMrsiecJUCN79HS+kT56jC1Q6wZg/5BeMvbDCMOrvyPP80ZFvP1kQwviW
         /YBKocIKXDpmODtL3XxMKfhQ+CUlqC6UuXo+VOW3QMcgSjl10p/THvdh7vvThLhOM3
         dU5O0OB2AfSrwsGjoLD+LSFCDwCoAUQGDM1poZ3jnBKQEz1frvfF8rk93FjCZWG4pm
         S6IKlYDcigBjQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 86EB2609CC;
        Wed, 13 Oct 2021 02:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ionic: no devlink_unregister if not registered
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163409281054.3651.17969042289726348581.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Oct 2021 02:40:10 +0000
References: <20211012231520.72582-1-snelson@pensando.io>
In-Reply-To: <20211012231520.72582-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io, leonro@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 Oct 2021 16:15:20 -0700 you wrote:
> Don't try to unregister the devlink if it hasn't been registered
> yet.  This bit of error cleanup code got missed in the recent
> devlink registration changes.
> 
> Fixes: 7911c8bd546f ("ionic: Move devlink registration to be last devlink command")
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> 
> [...]

Here is the summary with links:
  - [net-next] ionic: no devlink_unregister if not registered
    https://git.kernel.org/netdev/net-next/c/d1f24712a86a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


