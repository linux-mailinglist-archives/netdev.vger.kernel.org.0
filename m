Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C758E3141DC
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 22:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbhBHVdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 16:33:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236435AbhBHVar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 16:30:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 20F9064E82;
        Mon,  8 Feb 2021 21:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612819807;
        bh=8xIc9+eRTA2pwgoXuNZTCRpm5QvH00mkbn877cIxlZI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eVZVBK3hYJkb2FUR770GmzNhiFyu8x6s/kbmTJ8YJ3OKPW8GkLdsFQUqjvEQBTQ+8
         ixqclPIvDfCRk858+9ifDQ4m0b09VJScwL7uHTHO3jaNIS3uy7bdealxl5LT6vXqjz
         E0dl1DVz2lpiUUifdQ0pXHYKtEDr+VeD2Eft1EzHTlgFvwKplgGWORbpecPhfc3iwl
         vzrJgbOi6NdFM0NZ23fHRTEKmtgm+PHoaSmo3whHjncWcL1JiMUu2uKM71vcFcc8Ph
         Dsrmcr5oIciARKuB+dv+sDqOPJh5gVSksfT4fQQbJyRQe2gm+GpIr6C6hlBEqHqp79
         NeD9VX/cq2H2g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 16995609D4;
        Mon,  8 Feb 2021 21:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] seg6: fool-proof the processing of SRv6 behavior
 attributes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161281980708.9441.7211081316793679754.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Feb 2021 21:30:07 +0000
References: <20210206170934.5982-1-andrea.mayer@uniroma2.it>
In-Reply-To: <20210206170934.5982-1-andrea.mayer@uniroma2.it>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, colin.king@canonical.com,
        stefano.salsano@uniroma2.it, paolo.lungaroni@cnit.it,
        ahabdels.dev@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat,  6 Feb 2021 18:09:34 +0100 you wrote:
> The set of required attributes for a given SRv6 behavior is identified
> using a bitmap stored in an unsigned long, since the initial design of SRv6
> networking in Linux. Recently the same approach has been used for
> identifying the optional attributes.
> 
> However, the number of attributes supported by SRv6 behaviors depends on
> the size of the unsigned long type which changes with the architecture.
> Indeed, on a 64-bit architecture, an SRv6 behavior can support up to 64
> attributes while on a 32-bit architecture it can support at most 32
> attributes.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] seg6: fool-proof the processing of SRv6 behavior attributes
    https://git.kernel.org/netdev/net-next/c/300a0fd8afb1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


