Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805A74841B8
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 13:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbiADMkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 07:40:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38050 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiADMkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 07:40:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50FD36126E
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 12:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B58F5C36AF5;
        Tue,  4 Jan 2022 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641300010;
        bh=EvfYXys03IY4QrgYGE9KsTWBvbrxVkLZmMs8qPHWnRI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bl0SJYjt96GlMAW6fnf0iPw44oI1ayKts0qUGDBdF55Tdim2WloSBrlBXSlktEA1t
         h6+qZsE5j/zM05ASF5Fe1S8apk7xUrbW1T/mLGpM/NuQgVpHxFISNMj3XG2a1PfGwz
         Nu+nPwOLhHjr6Iiop+Q/WkBcXgMuU9HZOTQc20w1NfNhZtBQ3VnX4oRg04CowWtL6k
         9vHS7xxeB5knJX4j3XDlLBv1kYyq90h3tljUWzH0qxMoLZclUaMlBQTvRYQIUjHKnO
         FgxP5NAGmIr1mrjXwQaSxv94gJFWDMUIQY28aKwQIyGeWPXxHP6OPzl6H/csWTyra/
         y7Tco3J2/sp4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9AC5FF79408;
        Tue,  4 Jan 2022 12:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sch_qfq: prevent shift-out-of-bounds in qfq_init_qdisc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164130001062.24992.4043817752363633197.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Jan 2022 12:40:10 +0000
References: <20220104094508.3312096-1-eric.dumazet@gmail.com>
In-Reply-To: <20220104094508.3312096-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  4 Jan 2022 01:45:08 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> tx_queue_len can be set to ~0U, we need to be more
> careful about overflows.
> 
> __fls(0) is undefined, as this report shows:
> 
> [...]

Here is the summary with links:
  - [net] sch_qfq: prevent shift-out-of-bounds in qfq_init_qdisc
    https://git.kernel.org/netdev/net/c/7d18a07897d0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


