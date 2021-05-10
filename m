Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B43437995B
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 23:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbhEJVlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 17:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232845AbhEJVlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 17:41:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A5E536161F;
        Mon, 10 May 2021 21:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620682810;
        bh=NMRQx/FUQeQ2QxPze5XjDo/lkXMG7k8LGb0/uBUljLI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Abo2RHPnG1WZYzUHYXiCxg3Oxddi8ZPNqdR6uJQSj0kQiRmLbLWDkpVK2CbMktQLa
         4YKIuq0aGZ2Y/qWf6nwE2DWjHr8sYYnbmcFuVUCxf0Iza7sZDsotZsJVIvHLnP78tQ
         yAo1TJuiYOaew1P/iNb7M9p2IXm1nBCqHSB9t8r8GYO2BXLb/Oxa0qANG7zz2NefgE
         YAvtkO2iytRsgMbYjjXC/q3bHw6G0dIcfq3wexo5eZJf2AeCn+XVr2ZzVt7HpDE5cC
         6OQBvPRCl++puEO1CIWAAzVqioDiK7kXVfeKOgMY/Swah8FcMrhRMp8SZzZugLc9Oy
         wuVviUlfxDWbQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9F4E7609AC;
        Mon, 10 May 2021 21:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net v2] rtnetlink: avoid RCU read lock when holding RTNL
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162068281064.31911.18118695417131026218.git-patchwork-notify@kernel.org>
Date:   Mon, 10 May 2021 21:40:10 +0000
References: <20210508180033.44455-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210508180033.44455-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        syzbot+7d941e89dd48bcf42573@syzkaller.appspotmail.com,
        ap420073@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat,  8 May 2021 11:00:33 -0700 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> When we call af_ops->set_link_af() we hold a RCU read lock
> as we retrieve af_ops from the RCU protected list, but this
> is unnecessary because we already hold RTNL lock, which is
> the writer lock for protecting rtnl_af_ops, so it is safer
> than RCU read lock. Similar for af_ops->validate_link_af().
> 
> [...]

Here is the summary with links:
  - [net,v2] rtnetlink: avoid RCU read lock when holding RTNL
    https://git.kernel.org/netdev/net-next/c/a100243d95a6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


