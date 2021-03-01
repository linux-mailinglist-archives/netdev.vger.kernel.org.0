Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A2B3294E1
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 23:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242375AbhCAWYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 17:24:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235339AbhCAWU5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 17:20:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 86E8F60230;
        Mon,  1 Mar 2021 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614637207;
        bh=fAvLSvqpTEpF8L6VPRAzijM97phhPE8xSRVV06LZwVY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oML8aMIUMUG3hZfw5eBscTVLM91IUCxmp01rwzV/Rkh4e76JguG41LzOqm7V6JLcB
         v8cmDUY+1V8p58SYA/3nOr0LfiC4M8FMiGmdMWSmpi55FY4Up2715ykWknJrBM0GJo
         HegfLrZT5kGh2aHq0Zt18MQNaCqF7X088zhDsgGp6Sool3K0f2BjT/H8zmSSPeHLer
         5hCU6+HgTkn2KbA/++vUd24GVGEeLhXunAd6w1mEVKmnjkudog+rVR0JECiHdoBKAn
         J5/G4QpwGH4cNudFdKwhv/pWmjpZVswAAtyH3IrHZ8NcQZk2JRY7wOpTAbGETZ7t1C
         hGjg0JsmPwB3Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 77E8160C26;
        Mon,  1 Mar 2021 22:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] docs: networking: bonding.rst Fix a typo in bonding.rst
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161463720748.4566.6951106912840108619.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Mar 2021 22:20:07 +0000
References: <20210301122823.1447948-1-standby24x7@gmail.com>
In-Reply-To: <20210301122823.1447948-1-standby24x7@gmail.com>
To:     Masanari Iida <standby24x7@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  1 Mar 2021 21:28:23 +0900 you wrote:
> This patch fixes a spelling typo in bonding.rst.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  Documentation/networking/bonding.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - docs: networking: bonding.rst Fix a typo in bonding.rst
    https://git.kernel.org/netdev/net/c/2353db75c3db

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


