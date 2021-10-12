Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4212E42A30D
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbhJLLWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236088AbhJLLWI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 07:22:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 883FD61078;
        Tue, 12 Oct 2021 11:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634037607;
        bh=k9WWsXgpCC0ME/AsALWQa5R2xfZqjiz0mSOc6HSXRMQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jUf0FY93IgeNyUHEcnVD9aybZMYrHB96YCD4VvvKZnvL/E6gUmS2u2swRdsVs2qj2
         ikQL4+u7hr+2Q3tK7yQ8Q5laX4DZlU1LwoyOiaibM3NqO/PJiuAYPsm9QC6sJdEBNO
         0L7nxda5iPWCj4NY+u4cQY0tyREIVFzyLy3gbAkcSHayporDzWFTpV8G79A1FfMQZH
         89DhgCXyRytQw0pPumURuMEbDA+6XeelVorYmolhjb9HZcJWvJ/ZdSo3OClY1auAYp
         qI3YeN/inLfzxitWBBuATKt1dUXSWvOz+Pn6K0VKHmXX+9m9TZPmurmSgUJewYk53E
         gR1IHcZlht4dQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 83290609EF;
        Tue, 12 Oct 2021 11:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethernet: tulip: avoid duplicate variable name on
 sparc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163403760753.11134.12240773427004629744.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Oct 2021 11:20:07 +0000
References: <20211012000016.4055478-1-kuba@kernel.org>
In-Reply-To: <20211012000016.4055478-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 11 Oct 2021 17:00:16 -0700 you wrote:
> I recently added a variable called addr to tulip_init_one()
> but for sparc there's already a variable called that half
> way thru the function. Rename it to fix build.
> 
> Fixes: ca8793175564 ("ethernet: tulip: remove direct netdev->dev_addr writes")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] ethernet: tulip: avoid duplicate variable name on sparc
    https://git.kernel.org/netdev/net-next/c/177c92353be9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


