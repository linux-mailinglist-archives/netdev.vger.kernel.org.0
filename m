Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BC935D211
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 22:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343506AbhDLUab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 16:30:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241611AbhDLUa2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 16:30:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6BC85611C9;
        Mon, 12 Apr 2021 20:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618259410;
        bh=mnRCNpbeHJD3BiBcIGORGDnkUD3eGIEq1qqVv7uXx3s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mJNG8D1oB1rNrMiLMzTnYpKk/43ajH/+d0wTy7Qarwtx7+J8WcNhNzG92ZJYwcrrB
         cd0SUlMbTO9EXReAqGWnW5audcC4uQlhtJbtQ1H1LexXogmVCxfHcadlqGRPTwaXc+
         Gnv38dUzsI75INMKgd5V3j1uG7aUkOCQDDfPbiySt8n4KS79KxzGHJ4HH1dIG+e4gu
         SZ0cNXRerR0K+P8ZqA6Kzr3lOaTWKlj7wSgVz6M5KDb2H/MZdBbNiLYcUz4ka1CJvo
         rQ7ckK9gq+EPg0Q1R5lcJ8ZUwY1XiLJWQNQtdM6cyR5NgkL8ckYsCovTvlQ0mPKKL4
         H0S1CnN7Yzzcw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6361B60BD8;
        Mon, 12 Apr 2021 20:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ibmvnic: clean up the remaining debugfs data
 structures
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161825941040.5277.5205825536817156760.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Apr 2021 20:30:10 +0000
References: <20210412074059.9251-1-lijunp213@gmail.com>
In-Reply-To: <20210412074059.9251-1-lijunp213@gmail.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 12 Apr 2021 02:40:59 -0500 you wrote:
> Commit e704f0434ea6 ("ibmvnic: Remove debugfs support") did not
> clean up everything. Remove the remaining code.
> 
> Signed-off-by: Lijun Pan <lijunp213@gmail.com>
> ---
>  drivers/net/ethernet/ibm/ibmvnic.h | 94 ------------------------------
>  1 file changed, 94 deletions(-)

Here is the summary with links:
  - [net-next] ibmvnic: clean up the remaining debugfs data structures
    https://git.kernel.org/netdev/net-next/c/c82eaa4064f3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


