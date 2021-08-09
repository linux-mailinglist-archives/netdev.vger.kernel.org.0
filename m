Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06ABD3E4379
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbhHIKAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233842AbhHIKA1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 06:00:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9874260FE3;
        Mon,  9 Aug 2021 10:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628503206;
        bh=VFvsdbydQBG0qtbhj3oEsYfEHuzb02KLHgOHJ8SGFvE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m/43W8GNUfX24m5UQTabMTltOa2aI+kqeuxd0WvjJWaYrleQODALDBEgr6wHfyin/
         zvwJhRGqIUbxQr6bgMEV+AXlZErem4O1DoVud7EBCF6w6GvLkrvYZbgDfW4Ld9CywG
         xo6xXrb0b//FWM5/8vgLlkXuBrTBcnFq0Z5VURN0ePKTT8ztrmtzEhvzlilfd+FYU7
         quHVTMlBgVEr/wk/pChpL0RdxBGtQjoMrdJdBUUC1eREl+CSrFIOdcslNyKQbirIhr
         x/Yia5mmznaMkvYrtnMhjcL/HB2TNzbGGoWpdMEtPbiULjGgdRHGZg2R5lMFMrROPD
         O2ZSVS2OU93KQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 88B6D60A9C;
        Mon,  9 Aug 2021 10:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sched: act_mirred: Reset ct info when
 mirror/redirect skb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162850320655.31628.17692584840907169170.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Aug 2021 10:00:06 +0000
References: <20210809070455.21051-1-liuhangbin@gmail.com>
In-Reply-To: <20210809070455.21051-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, kuba@kernel.org,
        mleitner@redhat.com, ahleihel@redhat.com, dcaratti@redhat.com,
        aconole@redhat.com, roid@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  9 Aug 2021 15:04:55 +0800 you wrote:
> When mirror/redirect a skb to a different port, the ct info should be reset
> for reclassification. Or the pkts will match unexpected rules. For example,
> with following topology and commands:
> 
>     -----------
>               |
>        veth0 -+-------
>               |
>        veth1 -+-------
>               |
> 
> [...]

Here is the summary with links:
  - [net] net: sched: act_mirred: Reset ct info when mirror/redirect skb
    https://git.kernel.org/netdev/net/c/d09c548dbf3b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


