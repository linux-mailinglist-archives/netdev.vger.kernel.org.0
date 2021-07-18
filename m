Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432C23CC9F0
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 18:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhGRQxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 12:53:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhGRQxD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 12:53:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0743E61184;
        Sun, 18 Jul 2021 16:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626627005;
        bh=IPDW8GOsBua4YTnf75L7530GqftR90icqXiwYN/4dos=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CemA7e5DbtEy16P0IwlFcIBA2J/agWYCkek0aOYoNQHXxW7c7atNKd5lVZqBrT5pD
         fNf7EkGsB5NUMPQAugliYc8ff+rk4KvlU3Mx4y2ZkqKgl8l6EK8QuJHM+i/yLqQTlW
         vxmRDYYYZAb5M+kBPO+D5tpI9xHOk7r5hvTF/Wr+AV8IXYNrs5iFv3YkkdiPbWRDNe
         6vIipHCoCD+x5tw9k4uA2Mf/5Ds0Um2qCuXkBOUunnDjQ/eJ0V2rtwKb7G4BQIdqz7
         /ZufBwnjeg9UYywZhN+4yj2NIdoVsLeKK6Kd4O07fgD9muT4/AWfxbdrPcDJi5geDY
         t6c2SCGHf/AQw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F15F9609DA;
        Sun, 18 Jul 2021 16:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sched: fix memory leak in tcindex_partial_destroy_work
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162662700498.19662.15454403088763553589.git-patchwork-notify@kernel.org>
Date:   Sun, 18 Jul 2021 16:50:04 +0000
References: <20210717112933.12670-1-paskripkin@gmail.com>
In-Reply-To: <20210717112933.12670-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f0bbb2287b8993d4fa74@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 17 Jul 2021 14:29:33 +0300 you wrote:
> Syzbot reported memory leak in tcindex_set_parms(). The problem was in
> non-freed perfect hash in tcindex_partial_destroy_work().
> 
> In tcindex_set_parms() new tcindex_data is allocated and some fields from
> old one are copied to new one, but not the perfect hash. Since
> tcindex_partial_destroy_work() is the destroy function for old
> tcindex_data, we need to free perfect hash to avoid memory leak.
> 
> [...]

Here is the summary with links:
  - net: sched: fix memory leak in tcindex_partial_destroy_work
    https://git.kernel.org/netdev/net/c/f5051bcece50

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


