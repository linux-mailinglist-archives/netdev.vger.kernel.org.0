Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96531472C6D
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 13:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbhLMMkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 07:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236838AbhLMMkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 07:40:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD99C061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 04:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 87C32CE0FE3
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 12:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABA2AC3460D;
        Mon, 13 Dec 2021 12:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639399209;
        bh=W3H2v8frN+JuV6BRmqCHVthHzfrYooqpXSNQ1Tis3Pw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=alMLA0KZUnu0UDDYrWFwuf1lQHP5k4QyTNpfXhQzGK33YhJkJ1FRVHQFxMYbB+Lpp
         9KxVEuImBRvKizyaL/febFab+r2aeZ2NiNbMrigdRgeaND56vnohJCtKjdK+Brd9/x
         SWfSj4hvABoIOGtAvsNWN1HLlUdD8tV+WE4FOoPuNXjVy8y+hVwWOkGnwLYUuT8dFf
         3KOnU/GejuH/ZYnJrnXnZGimAN5I9TnzdvY2HITZJpyr3eP+LNjmNNp0zCIzYrkIM/
         iqS7tUASKGOe3W3jva5NytHrEqIPkEnDrDxlcDd6WBasmLlH8uncVMcJbDopfwlfi6
         y5QeyszBfsW9w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 983156098C;
        Mon, 13 Dec 2021 12:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tipc: discard MSG_CRYPTO msgs when
 key_exchange_enabled is not set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163939920961.24922.13443527652248929517.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 12:40:09 +0000
References: <30b1e3d5fb5d00c4200837107d26f445fd3a958f.1639162240.git.lucien.xin@gmail.com>
In-Reply-To: <30b1e3d5fb5d00c4200837107d26f445fd3a958f.1639162240.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        jmaloy@redhat.com, ying.xue@windriver.com,
        hoang.h.le@dektech.com.au, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Dec 2021 13:50:40 -0500 you wrote:
> When key_exchange is disabled, there is no reason to accept MSG_CRYPTO
> msgs if it doesn't send MSG_CRYPTO msgs.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> ---
>  net/tipc/link.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] tipc: discard MSG_CRYPTO msgs when key_exchange_enabled is not set
    https://git.kernel.org/netdev/net-next/c/6180c780e64c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


