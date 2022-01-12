Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0848A48BDFA
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 05:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350779AbiALEuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 23:50:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58796 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349155AbiALEuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 23:50:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A39DF6183C
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 04:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 01C0AC36AE5;
        Wed, 12 Jan 2022 04:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641963011;
        bh=eaknNAuAJhybR3Xp3NhyC0vXVK64nC32zh32lacrQJ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bk0Li0b8OtD22o175OjC/oV/21UMIZVgpBRyPQpvgpAoZlj0SGTrYK3sCuKq9czu8
         Oaz7vRAULfqXomCs1BoLX291ODbPijMCy9g7Q69XMjj1ufRQT2uxp+caRThEb/QDkU
         r4GzuvGTBpxfu2imhuJigyPr+BgC+6Hw1i10l1k5JFUyBbY202dII2wQ1LTCAcd1eg
         go98ZlZ4YMSrzfi5PY0IdOEdJSREmLEQ7vVbp0vkwjWb8tZ7MyIjtAExGUihO7SlUk
         em/5S8RZw/VwHqOr0Vvsws333l6smfzTRBhIWNP3qnTmBzvWpV9jFsK6xkYPxjXSeS
         1J/BG70CmAFrw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DD826F60796;
        Wed, 12 Jan 2022 04:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sched: do not allocate a tracker in
 tcf_exts_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164196301089.21433.5938069973239132647.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Jan 2022 04:50:10 +0000
References: <20220110094750.236478-1-eric.dumazet@gmail.com>
In-Reply-To: <20220110094750.236478-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 10 Jan 2022 01:47:50 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> While struct tcf_exts has a net pointer, it is not refcounted
> until tcf_exts_get_net() is called.
> 
> Fixes: dbdcda634ce3 ("net: sched: add netns refcount tracker to struct tcf_exts")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: sched: do not allocate a tracker in tcf_exts_init()
    https://git.kernel.org/netdev/net/c/cb963a19d99f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


