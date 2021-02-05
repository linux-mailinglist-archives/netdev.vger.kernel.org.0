Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9499C31030C
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 04:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhBEDAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 22:00:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229484AbhBEDAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 22:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6A3B664FB3;
        Fri,  5 Feb 2021 03:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612494008;
        bh=uXj29V54eVUZUJo85aZcDOyHDEYWjJaEViPEVtpx+5o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A8IFbT9lrWkAICBpqejYNG+WEL8uYsSrUJdxysxVDNKqK3wWm1+W6mK/fcSr43N56
         vYzjcgvAPHYezPFFvuLbxe4iMfbYMjXyRPVPUFQn1W38Zc2Vt3lkQdq3493PyU9f7N
         U9bvqXIkcSWePnZdRsjtGAxOdeO2YM40CSYNVE8hwNSeF+dQmBHwiK2SkrLy+pOrLr
         rC8VtNSk+TrCWjBnWND6bQb5EuN/FkP5LAVOA640/9VE7lLiVSUNa77cmbgKrmG9s/
         zoURIOGmULnphGwEqztNw9r9/P+zQF1gOuW+TxN/SwFlcivYOuRBCTkINHDjV2ituK
         Btiik/K4t99uw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4C61C609CE;
        Fri,  5 Feb 2021 03:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net-loopback: set lo dev initial state to UP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161249400830.18283.17954804241614751474.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 03:00:08 +0000
References: <20210201233445.2044327-1-jianyang.kernel@gmail.com>
In-Reply-To: <20210201233445.2044327-1-jianyang.kernel@gmail.com>
To:     Jian Yang <jianyang.kernel@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        maheshb@google.com, jianyang@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon,  1 Feb 2021 15:34:45 -0800 you wrote:
> From: Jian Yang <jianyang@google.com>
> 
> Traditionally loopback devices come up with initial state as DOWN for
> any new network-namespace. This would mean that anyone needing this
> device would have to bring this UP by issuing something like 'ip link
> set lo up'. This can be avoided if the initial state is set as UP.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net-loopback: set lo dev initial state to UP
    https://git.kernel.org/netdev/net-next/c/c9dca822c729

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


