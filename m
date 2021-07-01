Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2773B8B97
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 03:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238364AbhGABEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 21:04:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238224AbhGABEY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 21:04:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7B7F961424;
        Thu,  1 Jul 2021 01:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625101314;
        bh=WToMXzI3yMhbnvlr8MlauCWZIVvK6RTokiij4CowMdU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TPUyyXUnMZl64xR9PhuG0r4b0QcihxmyICRvjt0codeaTNOTsEJvMHDPQvvdNomC6
         jRHC6sh5x5WgZFCvNQFKWnoInfHuw51jZ3MkRpEpu9e7BQm03cJHZQ7XG73FvmdHkD
         SOxzFZpLv4Pd/xf/EZDxqy8T8VmC3BTHlhTqm+/HASccUTNzIwja6ldpTH8seSY13b
         Z+G5sof2GES3ZmMC8XTslKZindXp0WWjNoCCozQfcswmjmacfwAk8d03XeAbiqx7AW
         4imtvgQ0BIPOfemvBJTp66onOli8sHvqgLC/5mCzjMO2PBYgaX3SnKLBxOMF5R5etm
         ta+ZFfZhTMB0Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6EAB3609B2;
        Thu,  1 Jul 2021 01:01:54 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking for v5.14
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162510131444.2235.12279590636797194102.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 01:01:54 +0000
References: <20210630051855.3380189-1-kuba@kernel.org>
In-Reply-To: <20210630051855.3380189-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Tue, 29 Jun 2021 22:18:55 -0700 you wrote:
> Hi Linus!
> 
> This is the networking PR for 5.14.
> 
> I see two conflicts right now.
> 
> In Documentation/networking/devlink/devlink-trap.rst between these two:
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking for v5.14
    https://git.kernel.org/netdev/net-next/c/dbe69e433722

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


