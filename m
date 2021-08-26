Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF1C3F8624
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 13:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242004AbhHZLK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 07:10:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241924AbhHZLKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 07:10:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 75A28610A4;
        Thu, 26 Aug 2021 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629976206;
        bh=SS6cCz9oaI/DDIT+Uf4ZMUbBpdAcO3LvxDNZbPilPN4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pUjBp4Af5gHxubfq5xMkk9USmrBFCKSURFgxbHyY49otEv+c9G0mkwsIurLFvakxP
         1CqSonZXBQyCQWhYy2oj0Y7Pko7VdhbP0iu1vLhhDkst3So9v33bEOak8KOCCg7uRQ
         Pzctc8gFrhWwfJ5v9f0wKK2jEvRPAgcqUYWHppQg1v4fzVoUiK/MNwwCIC6j4OmNZH
         Lyu7B9Vpw40x46lEahut8V5X0pW+MdGGhWpAsbTyk4rF+TZdYK9kjgFklxMweG5xI5
         LUr+Ckoc4ay1LtDrC5GRudqGo0NLlSZjHC6HtGmn5tmU79bR3pYaoSHtpMbvEGlBnt
         QZXy3e0x+AghQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6E68F60A14;
        Thu, 26 Aug 2021 11:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ptp: ocp: Simplify Kconfig.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162997620644.12775.14603065021004466765.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Aug 2021 11:10:06 +0000
References: <20210825211733.264844-1-jonathan.lemon@gmail.com>
In-Reply-To: <20210825211733.264844-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        arnd@kernel.org, rdunlap@infradead.org, richardcochran@gmail.com,
        kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 25 Aug 2021 14:17:33 -0700 you wrote:
> Remove the 'imply' statements, these apparently are not doing
> what I expected.  Platform modules which are used by the driver
> still need to be enabled in the overall config for them to be
> used, but there isn't a hard dependency on them.
> 
> Use 'depend' for selectable modules which provide functions
> used directly by the driver.
> 
> [...]

Here is the summary with links:
  - [net-next] ptp: ocp: Simplify Kconfig.
    https://git.kernel.org/netdev/net-next/c/bc8e05d6b965

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


