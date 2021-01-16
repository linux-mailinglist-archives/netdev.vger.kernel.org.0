Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166312F89B7
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 01:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbhAPAAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 19:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbhAPAAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 19:00:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6C5F723A5E;
        Sat, 16 Jan 2021 00:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610755208;
        bh=KZeCc6R56vZJhc/fk3Kh/NyMLXaLdCg4gYA4YPGtMFo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KuRkCkc/ndl6XWeNAm4N0B+oilnBv5x6qu8zfkL9nLlKaLM5ddZfs7FjLHIUwqeX3
         kTxW4LKih0SFx3k3/JNlzuvtnpjA0FMQyNQZyiiK01hkJe5GQ55FKWSQ9D+82Vc+oY
         CJrBOwOrmrrVJN6PeNjoZZIZWMHDvhP8XlzFae07IXLfAk8UbE/LwOw9L2pFraClq5
         AMYPS7/Tw/X0qhvie/VoPNscIwigcD7p4VPbYnKLdRpEVZ1Xex4SRio0Ov1l/eyi16
         q3n0aGGsBEr0NEvXWdDQXgCoQaj+4vYIOcrawnmtCZ9+OP3C+1GcvJZGt0pR6fJIYQ
         GK+Oe49ZAh0wg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 5E77C605AB;
        Sat, 16 Jan 2021 00:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net v4] cls_flower: call nla_ok() before nla_next()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161075520838.15612.8489720419574863467.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Jan 2021 00:00:08 +0000
References: <20210115185024.72298-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210115185024.72298-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com,
        jhs@mojatatu.com, lucien.xin@gmail.com, jiri@resnulli.us,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 15 Jan 2021 10:50:24 -0800 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> fl_set_enc_opt() simply checks if there are still bytes left to parse,
> but this is not sufficent as syzbot seems to be able to generate
> malformatted netlink messages. nla_ok() is more strict so should be
> used to validate the next nlattr here.
> 
> [...]

Here is the summary with links:
  - [net,v4] cls_flower: call nla_ok() before nla_next()
    https://git.kernel.org/netdev/net/c/c96adff95619

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


