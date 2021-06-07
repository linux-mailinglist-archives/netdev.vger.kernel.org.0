Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8EA39E842
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 22:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhFGUV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 16:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231553AbhFGUVz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 16:21:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 236F1611AD;
        Mon,  7 Jun 2021 20:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623097204;
        bh=YdeDKy8F6mirt7OLSlruTUjX1Z85Ptgb3xCCLRBNqGI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LGdDNwwTfB9DUQjzePWpyzCqWVQKoNmb3orsiGUTrGWAyx6UeBMulO2ejInR8W8f4
         1nzZuraiQyEdZs85KTUIR1PggA0/bGxXPd9W/hpdid9pH9cXSqYMDi+PgE4YeskRfo
         /F4msZJw1AikCNr+RC6po0/6HRLopSvzesisBtjkb239YZvptUTIuHdbl9DI7mIT7d
         IzUsTOqEtpgtnpM/Qy2I+vCSULwj2WAkY0WSMCt9DURywLGZIP+qhdLdWqDYyqcSss
         /BdEAyLwNmsBA8+THc08bzk1z+QuFks2KcpEFQ9vBIA2hZO2yyOTS8K+EkrAEGfmmD
         eIPTVZnf5aY4w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1E950609F1;
        Mon,  7 Jun 2021 20:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] atm: [br2864] fix spelling mistakes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162309720412.9512.5228590021806034561.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 20:20:04 +0000
References: <20210607063307.376988-1-13145886936@163.com>
In-Reply-To: <20210607063307.376988-1-13145886936@163.com>
To:     None <13145886936@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  6 Jun 2021 23:33:07 -0700 you wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> interrupt should be changed to interrupting.
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
>  net/atm/br2684.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - atm: [br2864] fix spelling mistakes
    https://git.kernel.org/netdev/net-next/c/4fb473fe7325

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


