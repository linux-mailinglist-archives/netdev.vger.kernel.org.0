Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E511E4A6AE5
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 05:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244356AbiBBEaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 23:30:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60088 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244141AbiBBEaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 23:30:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19758616E8
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 04:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 782FCC340F1;
        Wed,  2 Feb 2022 04:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643776211;
        bh=OZTcqrg0ATkEl86SnxxqwN3L0dTfuaRe3S8F4qwJKdI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rMQfdRvXGc/rCpUqHQWO28Kz/hye3HjjKG4Jmi/sHUn0h2iTySg3lsINolaUL5gI0
         wRNFgwqZNjoM0ZvIp25BL5XkcpbvQmQ+p5ws67Nfhlhh3bo6/HoAG0JohcITkR2ZiV
         5IDhdtIaqvkfuL/1HlSCNDqaEPmkGlVK21AyvyRp1ubjdNcP8jvXz0mAY0W/ctJh1K
         RoLVVcq1A1yYvHl7B62UyooojksUB+buxta4R5uaV/nL40jO2D5RgnQQkGvaEOWoMH
         612fQ9jZ4GtAUA40yQLQX4H3ZCrhS896WycUz9LGvSbDS188eH57gn6wU0wE6IUIen
         rgdgEuB++v1tw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 612E1E6BBCA;
        Wed,  2 Feb 2022 04:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] af_packet: fix data-race in packet_setsockopt /
 packet_setsockopt
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164377621139.13473.14445506764802571752.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Feb 2022 04:30:11 +0000
References: <20220201022358.330621-1-eric.dumazet@gmail.com>
In-Reply-To: <20220201022358.330621-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, willemb@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 31 Jan 2022 18:23:58 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> When packet_setsockopt( PACKET_FANOUT_DATA ) reads po->fanout,
> no lock is held, meaning that another thread can change po->fanout.
> 
> Given that po->fanout can only be set once during the socket lifetime
> (it is only cleared from fanout_release()), we can use
> READ_ONCE()/WRITE_ONCE() to document the race.
> 
> [...]

Here is the summary with links:
  - [net] af_packet: fix data-race in packet_setsockopt / packet_setsockopt
    https://git.kernel.org/netdev/net/c/e42e70ad6ae2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


