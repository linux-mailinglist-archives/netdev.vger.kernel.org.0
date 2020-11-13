Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180452B288A
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 23:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgKMWaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 17:30:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:33526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725986AbgKMWaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 17:30:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605306605;
        bh=jshkWJpO8ihEQgO0FBZn1eIT3Gk7dBfaAksna1ZpW5c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KOM0GuJmTF3yHtZKaXUML9mYKvRVVHSS6+/GuKOmQpya4iUbkxtS9ate4h2Q9bJmS
         ISQSZP0IOpgH/vkM5+tdsyfgRErVko5Ebzqx+K2RvXAmZw5dq+miTkEueK272MQ3Wc
         YEiQDcUIIf3YjBKTArVtZVW9tk/l3hlopcVf088k=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tipc: fix -Wstringop-truncation warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160530660536.10508.1390520498145841572.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Nov 2020 22:30:05 +0000
References: <20201112093442.8132-1-wenlin.kang@windriver.com>
In-Reply-To: <20201112093442.8132-1-wenlin.kang@windriver.com>
To:     Kang Wenlin <wenlin.kang@windriver.com>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 12 Nov 2020 17:34:42 +0800 you wrote:
> From: Wenlin Kang <wenlin.kang@windriver.com>
> 
> Replace strncpy() with strscpy(), fixes the following warning:
> 
> In function 'bearer_name_validate',
>     inlined from 'tipc_enable_bearer' at net/tipc/bearer.c:246:7:
> net/tipc/bearer.c:141:2: warning: 'strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
>   strncpy(name_copy, name, TIPC_MAX_BEARER_NAME);
>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - tipc: fix -Wstringop-truncation warnings
    https://git.kernel.org/netdev/net-next/c/2f51e5758d61

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


