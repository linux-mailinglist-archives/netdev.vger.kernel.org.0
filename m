Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8073BA43B
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 21:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhGBTMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 15:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230172AbhGBTMf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 15:12:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 80FFA61416;
        Fri,  2 Jul 2021 19:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625253003;
        bh=cdItp4amKNvRA+IJpbZ0uTB0KCPYxSfZgwS/ygkhMus=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RvUDiPF2s7r3eoESfX4ALe4AOdHLMy82lc1PJXhmNviJXoCCA1mMnzRtO2tnL+rjX
         h6uKO/wgJcQkZYpCdaRs1Mk70ugqLWHS5OgKiH150Gj/Qb8v+fgt5zvn3kMIj7BVQ/
         BtAXYbA/wBrS1x5Cc7nvJ1dXQy4e/ejIL7tsoQidKKTIix9STjfA5bxK2Ejcv6DQ50
         uCpZrTEG4VssPqtpkcuicV3x7eeMe/2PMaWfLMO2E40Xcng+VfqBlkXxgS3xn/yVHy
         NEE56TzrlVrYtoy2/XrzsSYnwALQ+ZwKEtXvZ7hJLer5AUinUzQKlF16Zcu8ANuj60
         ThVkY1oCsq36w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7477A60A4D;
        Fri,  2 Jul 2021 19:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] gve: DQO: Remove incorrect prefetch
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162525300347.7668.4532189818837115605.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Jul 2021 19:10:03 +0000
References: <20210702031336.3517086-1-bcf@google.com>
In-Reply-To: <20210702031336.3517086-1-bcf@google.com>
To:     Bailey Forrest <bcf@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  1 Jul 2021 20:13:36 -0700 you wrote:
> The prefetch is incorrectly using the dma address instead of the virtual
> address.
> 
> It's supposed to be:
> prefetch((char *)buf_state->page_info.page_address +
> 	 buf_state->page_info.page_offset)
> 
> [...]

Here is the summary with links:
  - [net] gve: DQO: Remove incorrect prefetch
    https://git.kernel.org/netdev/net/c/1bfa4d0cb5ad

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


