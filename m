Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D5046E103
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 03:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbhLICxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 21:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbhLICxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 21:53:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB67CC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 18:50:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EBDFDCE2455
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 02:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F6D3C341C7;
        Thu,  9 Dec 2021 02:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639018210;
        bh=2iPRYLmthpb+wdru1fB+A7iaQpRYDmBtvxcZ9LOo9GU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fxm9O0a/wqSeTgnj1SFgFgVdOCM97at+yMa5linGkjibs0XmmrQOPuHC/RilkefAq
         ox6ak7DBpmVOUoI7e9UXrbEhLK7J+KHgvpZkeHmQ/+en94dT5pJde9vmgfEAmHPzvV
         bV2Y3wmn3tjFD7KyU2ozWQlPvc9YS48I7lk6W+/sZkeX41SI+5EOYdy5vk7ZblhRK0
         Jrx+W9BnHFEILW0fwkgd05ykRFZyvPaCFxiyLueBZflF9jsLb5UgRoGhnrRypYTG1L
         bTS+ciWP6M0D8bb+D18ZHr8agWUz5YKhD/cRC6/sGiXBDS3gvBieCc8ISMUu3aDXVv
         cuFJOeeEotUnw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 03B4860A88;
        Thu,  9 Dec 2021 02:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: track the queue count at unregistration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163901821001.6906.10367360858755360089.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 02:50:10 +0000
References: <20211207145725.352657-1-atenart@kernel.org>
In-Reply-To: <20211207145725.352657-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Dec 2021 15:57:23 +0100 you wrote:
> Hello,
> 
> Those two patches allow to track the Rx and Tx queue count at
> unregistration and help in detecting illegal addition of Tx queues after
> unregister (a warning is added).
> 
> This follows discussions on the following thread,
> https://lore.kernel.org/all/20211122162007.303623-1-atenart@kernel.org/T/
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net-sysfs: update the queue counts in the unregistration path
    https://git.kernel.org/netdev/net-next/c/d7dac083414e
  - [net-next,2/2] net-sysfs: warn if new queue objects are being created during device unregistration
    https://git.kernel.org/netdev/net-next/c/5f1c802ca69b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


