Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFAE3443B60
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 03:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhKCCcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 22:32:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229650AbhKCCco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 22:32:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5DECA61108;
        Wed,  3 Nov 2021 02:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635906607;
        bh=8WG7w2PRplZ8YT95QyIK4fJmFOW6w6F/ityaoQAJf7g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GYHeXokLLDqfjr/I9IC1dvHFfjRgbBH4NMLrAY/X609Rdg0jmrhW48vJdfr84tYTL
         rWJFBDsU5udgZ9yiiNHCOc4oqKU2xbTk3Q8PAE3PxlSgu94XDeioib9MwC05SgeX0r
         uAGDVtUzAta9Z3YasqfGzu0wyO66swFQKmeuKVQrwxrRCnOKHiLT38L4jyP4/xj2cA
         D0Lg4AJGk9JWvjIj7nReOCM7lKqXASzvLhK53ngcjAz6BSaqgfQFTZcugzuUS0dcI4
         FZDV6UDbFvFxX9RM7aM5DxN+kwHCEo0jOpUTVM7vgkYHH3nuE2wyiZa8NHzNIJqStw
         NZ/uE1L6ilrfQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4F5AE60AA2;
        Wed,  3 Nov 2021 02:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch v1 net-next] MAINTAINERS: Update ENA maintainers information
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163590660731.25427.10212145042833089150.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Nov 2021 02:30:07 +0000
References: <20211102110358.193920-1-shayagr@amazon.com>
In-Reply-To: <20211102110358.193920-1-shayagr@amazon.com>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dwmw@amazon.com, zorik@amazon.com, matua@amazon.com,
        saeedb@amazon.com, msw@amazon.com, aliguori@amazon.com,
        nafea@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com, akiyano@amazon.com, ndagan@amazon.com,
        darinzon@amazon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 2 Nov 2021 13:04:00 +0200 you wrote:
> The ENA driver is no longer maintained by Netanel and Guy
> 
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
> ---
>  MAINTAINERS | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [v1,net-next] MAINTAINERS: Update ENA maintainers information
    https://git.kernel.org/netdev/net/c/18635d524870

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


