Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDFB3E0083
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 13:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237907AbhHDLuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 07:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237816AbhHDLuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 07:50:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C5E6760F6F;
        Wed,  4 Aug 2021 11:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628077805;
        bh=c5vcBbLoBY0IYaLVW0ew0lzBwPYLhU69YvcxFfsB4Vc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eaqyexShsI+Nfp0R5ctZSYMJzzDdYimWvQsXUSIGPFGfkG2EZO4Z0Xkx/zK71GBb9
         ULsF0G1NkYdkD6iDM7YX3RlmEyrDagdptzQG1oaFdyvh6uVaABWn/f+jin0WVFZpwW
         8yfwCaY0JqnXFbeINnt53ajGRc1BA6yQCKEQHpQXtuxoUnS4bKDparRCT+yr3MU8hB
         MIKg8I2ypNKWrW9BEzOAY/epN9/8/TY28x3eYnc/HF9UmeMK/XX2Z50icuLxXy+Qak
         vhm1lET2EUzu/8ootUfGYYde16pgqixGLPUR58vGwYXd3L53qZmr8w98zUPxyG6iKI
         r4GwLZAOhzNYg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B9C8860A6A;
        Wed,  4 Aug 2021 11:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] docs: networking: netdevsim rules
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162807780575.28477.13089376303981403810.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Aug 2021 11:50:05 +0000
References: <20210803231415.3067296-1-kuba@kernel.org>
In-Reply-To: <20210803231415.3067296-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, corbet@lwn.net, linux-doc@vger.kernel.org,
        xiyou.wangcong@gmail.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  3 Aug 2021 16:14:15 -0700 you wrote:
> There are aspects of netdevsim which are commonly
> misunderstood and pointed out in review. Cong
> suggest we document them.
> 
> Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] docs: networking: netdevsim rules
    https://git.kernel.org/netdev/net/c/396492b4c5f2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


