Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96F7444078
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 12:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhKCLWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 07:22:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231511AbhKCLWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 07:22:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2C44B6113B;
        Wed,  3 Nov 2021 11:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635938409;
        bh=ID1ZZoTZpOftO8QfPEHySSS6IismbdSO9n1xdkZFSk4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ek2WZ4se33hZRWN0BUSTIX2cZoL8+K2BUS0OeOjgNSVnQwKS79w/k0bn+ud14etQF
         VOuob51a6eQcjMDbWCdTVbV6hdUu5PYTcM4mM3unKnClc3hv+FJd2Q6QWMP+PpALB5
         9n2w8Ue0P6F0DtVH1pcQOAxk/xHrDTdhksv1NanxQiOxWNlmQdTpwL7gMxdHPJs+p9
         yE8s5MtIqx+MlnRbyt0jrYJ2QHZJRDLjgLB79enXgAs+xkbV/fn8hgna5CvnJO9Yja
         uqYtJKZpwJMLXE+qKuMXJN9JfF0qqK1nstdbvSX94tg94ybyZkPOWfxv1kEBuo+pS1
         ZUq6gcEdLHq2w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1CF0A60A39;
        Wed,  3 Nov 2021 11:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] amt: Remove duplicate include
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163593840911.17756.11126112016952297201.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Nov 2021 11:20:09 +0000
References: <1635911107-63759-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1635911107-63759-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     ap420073@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  3 Nov 2021 11:45:07 +0800 you wrote:
> Clean up the following includecheck warning:
> 
> ./drivers/net/amt.c: net/protocol.h is included more than once.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - amt: Remove duplicate include
    https://git.kernel.org/netdev/net/c/a4414341b583

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


