Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A493CFC04
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239246AbhGTNo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:44:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239965AbhGTNj0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:39:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4534461164;
        Tue, 20 Jul 2021 14:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626790804;
        bh=iLQ2bAbb9FAmnF83PcXjhr6i9h3GD8KMIdQ2kzDnkjE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cBzS01GFNmTli6X58/L/X+sn/p+2/KlLvH2+g8yR9HIio4kJqbZbtg0kgVQPg+PX7
         9v1e7BB7ReCnu/C5fRTwi/yu7IwqdLjkvTD/y2BD8i6mhNJID/LVEaKFi6XDLGqw8f
         hUj9Vkf6dOneynsPJJ8d59O5Bm/SlhBVFVaMLfT83QfEsoO2/uC3jH6jCWH3XKh2PO
         d7R6Ek5b4B/uIQWbLypwZQTnIKpgfj0QIZkxu7mlwNuWsliVZMvpyu6HZMQBbOOpgA
         xvC40AwW/KnDQuWE3TsUWgiCG9EFO4pQ30yhD3NCaHlo9bHMsbSYbgH6Wq93/cV4Xw
         tjsP0TsrJG65g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3831660A0B;
        Tue, 20 Jul 2021 14:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: act_skbmod: Skip non-Ethernet packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162679080422.18101.4733184768253484722.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 14:20:04 +0000
References: <20210719234124.18383-1-yepeilin.cs@gmail.com>
In-Reply-To: <20210719234124.18383-1-yepeilin.cs@gmail.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        peilin.ye@bytedance.com, davem@davemloft.net, kuba@kernel.org,
        cong.wang@bytedance.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 19 Jul 2021 16:41:24 -0700 you wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> Currently tcf_skbmod_act() assumes that packets use Ethernet as their L2
> protocol, which is not always the case.  As an example, for CAN devices:
> 
> 	$ ip link add dev vcan0 type vcan
> 	$ ip link set up vcan0
> 	$ tc qdisc add dev vcan0 root handle 1: htb
> 	$ tc filter add dev vcan0 parent 1: protocol ip prio 10 \
> 		matchall action skbmod swap mac
> 
> [...]

Here is the summary with links:
  - [net] net/sched: act_skbmod: Skip non-Ethernet packets
    https://git.kernel.org/netdev/net/c/727d6a8b7ef3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


