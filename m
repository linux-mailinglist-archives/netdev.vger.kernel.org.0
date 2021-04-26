Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5691C36BA5C
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 21:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241730AbhDZTzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 15:55:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242197AbhDZTy3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 15:54:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 25C7D613AB;
        Mon, 26 Apr 2021 19:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619466827;
        bh=BuuDPSZxLzXj95dQYHdbYsashZp/rgS3Wl/ecpDeREE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IjOoI6GlNgxg4PsD+PUU8X+NQy2XEV5U1+kuHOcTAUl2hZtbYDkR0na/VJFjC3FT9
         HGdgvcrTYM4YMwgvgUxpbaN4mqvJbAUS8AU6XcCKnFZyBqWUh82CBxdDrhvJtbsZYK
         JNnFUySw1ipsWzkOSFEpI8L447UcQxhhIqWEeVkYvnxYleNstolkTMAaI/y/obeM4c
         LgACKTJnG6W2lGxhjvGA/VzXfv1RZ29MGjVOmUu1C7RVJFvJ9tYJlm7XWYYC+QqGb5
         7nQg4gdUiBxdWEBVf4WhpkSG2oZc15H1yABgx3PWd8Fxtt4O0BOFZB48bYKYMjg2e1
         F+EZXPWCSV3fw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 15FB3609D6;
        Mon, 26 Apr 2021 19:53:47 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: davicom: Remove redundant assignment to ret
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161946682708.17823.1588898263426511226.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Apr 2021 19:53:47 +0000
References: <1619347376-56140-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1619347376-56140-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 25 Apr 2021 18:42:56 +0800 you wrote:
> Variable ret is set to zero but this value is never read as it is
> overwritten with a new value later on, hence it is a redundant
> assignment and can be removed.
> 
> Cleans up the following clang-analyzer warning:
> 
> drivers/net/ethernet/davicom/dm9000.c:1527:5: warning: Value stored to
> 'ret' is never read [clang-analyzer-deadcode.DeadStores].
> 
> [...]

Here is the summary with links:
  - net: davicom: Remove redundant assignment to ret
    https://git.kernel.org/netdev/net-next/c/9176e3802719

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


