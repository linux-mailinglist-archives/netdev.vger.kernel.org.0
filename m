Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C47F40F89F
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239959AbhIQNB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:01:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239274AbhIQNB3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 09:01:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 10F5361241;
        Fri, 17 Sep 2021 13:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631883607;
        bh=lMFIfXUt2ys7f5DsSWgrGzn/XxspjTVWlL8eOei3y2I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MgGoSAZtwwhMtXxyIUSc7wBduGfRWbweAKI7ies5GdkMk8NjBhyrLs1j/MAQQI2ur
         xswsOqG17FPaja4rjoufENeaRGdGLNRAkRJr+8X4zmXVF+6hqw7d6eilQHp3YJ44aM
         DN7tWERLi0HPpI8T1YyV69nX+oFZhawJPuxKlyrKjDkmvkBro//K+7rte36fDW+FjA
         XwNucb6R+HnPv9pocDJpKGOMpdKxvPbF1vBTobVsXQa3TXg+z/+MCU/2zYrLWKIUzZ
         bFrKQBeV1DeT8RGrqoNl4Pdb2b2peX6IHabTD8bkwBk9qw6JOWY6Fs1szieJHyBm4f
         WIUhj5SQWiHmg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 010BA609AD;
        Fri, 17 Sep 2021 13:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: update NXP copyright text
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163188360699.21192.12229674909894768610.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Sep 2021 13:00:06 +0000
References: <20210917111735.475830-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210917111735.475830-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 17 Sep 2021 14:17:35 +0300 you wrote:
> NXP Legal insists that the following are not fine:
> 
> - Saying "NXP Semiconductors" instead of "NXP", since the company's
>   registered name is "NXP"
> 
> - Putting a "(c)" sign in the copyright string
> 
> [...]

Here is the summary with links:
  - [net-next] net: update NXP copyright text
    https://git.kernel.org/netdev/net/c/3c9cfb5269f7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


