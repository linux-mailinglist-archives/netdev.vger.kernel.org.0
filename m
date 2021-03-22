Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3B23450A1
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhCVUUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230520AbhCVUUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 25B8261993;
        Mon, 22 Mar 2021 20:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616444408;
        bh=4xkEVn/A3SIRrwVBluZpT/FcfIxmEl0+kTjDynHe/kc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CMc983jq8dASo6gqKog4RyHMNVG9gsKqoUjT228bWp/9df89fQbcpo5EJ2ADvMkPO
         CjfO5itZHpl5krpUzfb8Kvhbw9pKhDoqh0vJFBuzuBVhvwdYEE1wx+mS1XpWdyibow
         H8oDcAQasvyn31716tB7hPHdXM6gaUJB2l211FbHsX7NtXHmFlSEAoKd6H+N2gfBPJ
         h9UTfejwmfiB8LJibd7CdMOYshcljJOjJ/tFJwPwS5kGoVdOovWUD9I6sHVFscU/Vw
         FAh6N43M/8mhLFh+NhK7IKlbFLgbWdJO/XgBOMtvD/RGwdQpLPAODEwLwjbrw8y8gS
         GB7Rlv1adDeaw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 15CF560074;
        Mon, 22 Mar 2021 20:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] cxgb4: Remove redundant NULL check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161644440808.26518.243238574763309295.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Mar 2021 20:20:08 +0000
References: <1616406794-105194-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1616406794-105194-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 22 Mar 2021 17:53:14 +0800 you wrote:
> Fix the following coccicheck warnings:
> 
> ./drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c:3540:2-8: WARNING: NULL
> check before some freeing functions is not needed.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - cxgb4: Remove redundant NULL check
    https://git.kernel.org/netdev/net-next/c/c3c3791ce31e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


