Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8A5397D0C
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 01:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbhFAXbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 19:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234766AbhFAXbp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 19:31:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EFC0D613BC;
        Tue,  1 Jun 2021 23:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622590204;
        bh=9jBBGc5/tlEn3Q34kDZN1+/teHzhfZVd4bupvmg7+D4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GKLECLE4dEMV8InJBYItYwPSBsI14RzkochqCKAzwyq2d3BgqjBye/SpEsExDWli/
         9Xd+4hdLQ7NTfJCWLhaMqOiT9sTIpmB3POuLaWXDkppbZ4rFiqSRyGCg5HfvLBl/O7
         bagOUXarr8D+weW4ShtZakSStb/AC8oQruRkXn02VdJRU/TkUYgUrnkZo3WV1PQoA9
         9U2ggwOn6YbHd6clOCR1YHZTKWQ2Jbnd2GGIX/3bV3TGglLdGxRHdaBTFQGDeSUGwm
         oVeUBXzq+YaC7pYya09J+HHiLo7YewPpnQ/1g9NTGQJfBWUpbaPHlTYkR7cCQ9tL/Q
         MnKokiSUvwg4Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E33F9609F8;
        Tue,  1 Jun 2021 23:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] Fix use-after-free after the TLS device goes down
 and up
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162259020392.5946.15667853325648383667.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 23:30:03 +0000
References: <20210601120800.2177503-1-maximmi@nvidia.com>
In-Reply-To: <20210601120800.2177503-1-maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        kuba@kernel.org, davem@davemloft.net, aviadye@nvidia.com,
        tariqt@nvidia.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 1 Jun 2021 15:07:58 +0300 you wrote:
> This small series fixes a use-after-free bug in the TLS offload code.
> The first patch is a preparation for the second one, and the second is
> the fix itself.
> 
> v2 changes:
> 
> Remove unneeded EXPORT_SYMBOL_GPL.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net/tls: Replace TLS_RX_SYNC_RUNNING with RCU
    https://git.kernel.org/netdev/net/c/05fc8b6cbd4f
  - [net,v2,2/2] net/tls: Fix use-after-free after the TLS device goes down and up
    https://git.kernel.org/netdev/net/c/c55dcdd435aa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


