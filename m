Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE32345064
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhCVUAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230247AbhCVUAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C4CC061993;
        Mon, 22 Mar 2021 20:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616443208;
        bh=thJVPQpkALBugFUnwubpYNlwmdOppdAJCbE3bETQo8c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LlbkBQQtu1wruErc71XhAtiix2VUoo32iRdZqw0DBSDTomoT8GZQn0mifV2h7E+Pw
         0ogeeYcnZ8N1vr7QDghHtMMPucnmsL0hbDJGdIjHKFuqhMee946gqNlVOuLdAGgxmI
         sq5ndFchgEshoONckmAqnGpf1UH9Mc0pYfp7r+fmvAHkzuPWhL6c1S+U041j7cJgat
         U+a0nfRGQGOs9B/seIugx5KJxRI93MuAD4GPjyMzB5Wwyoyo4L+O4cYBXUDfTd0+YH
         jfgMHgR6ozpxd12hQtTV7ERAtj1pWBjveLsK89jtxqyF/B/qkwpVFAUxG9ncnVnMff
         U3ksiYrlrhD9w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B54D760A70;
        Mon, 22 Mar 2021 20:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] NFC: Fix a typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161644320873.18911.780914181416583866.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Mar 2021 20:00:08 +0000
References: <20210322005430.222748-1-unixbhaskar@gmail.com>
In-Reply-To: <20210322005430.222748-1-unixbhaskar@gmail.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     davem@davemloft.net, dan.carpenter@oracle.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 22 Mar 2021 06:24:30 +0530 you wrote:
> s/packaet/packet/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  drivers/nfc/fdp/fdp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> [...]

Here is the summary with links:
  - NFC: Fix a typo
    https://git.kernel.org/netdev/net-next/c/0853f5ab35e6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


