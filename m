Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4051D43FD22
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 15:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhJ2NMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 09:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231367AbhJ2NMf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 09:12:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F2F5F60FC4;
        Fri, 29 Oct 2021 13:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635513007;
        bh=LD+fzgjDS1B1Qw+gcqKUlfjGFEnPCJ810Xn8Xudj1CY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Wq00LN4KyzQ8xFX+41D+UkcsbVs2EVqnf1RoZfB9zNlMx4S2+KK8AXBMtzYrXPfFr
         hNQG89fQ9DtUWEYUvV6E+3iNPA4EI0nJ1VYmrqKEuILZ69IZcdXso6xkydymO6biqC
         6buFcCQLkyX7RbRaFgtLMsVun3l1mrzoIj0EipeRqrZDAr9dlYVOvM8mjH5P46HYri
         ld6INjEGRmnoqykw2xpYbV6h0ltLbrBtzVF296yloqmfEGMZE3ZJM3RRoS65VLti4z
         2HHUeEbeBGwB2rA6UtDSOkpiOG0tUznWQ7tFYYpCAv+KCh9jg+XEdYE12K711XFxpr
         E3LkVDG/aJy2w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DC3CB60A1B;
        Fri, 29 Oct 2021 13:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] cls_flower: Fix inability to match GRE/IPIP packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163551300689.9482.6803667652504679288.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 13:10:06 +0000
References: <20211029092141.6924-1-komachi.yoshiki@gmail.com>
In-Reply-To: <20211029092141.6924-1-komachi.yoshiki@gmail.com>
To:     Yoshiki Komachi <komachi.yoshiki@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, pshelar@ovn.org,
        netdev@vger.kernel.org, dev@openvswitch.org,
        toshiaki.makita1@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Oct 2021 09:21:41 +0000 you wrote:
> When a packet of a new flow arrives in openvswitch kernel module, it dissects
> the packet and passes the extracted flow key to ovs-vswtichd daemon. If hw-
> offload configuration is enabled, the daemon creates a new TC flower entry to
> bypass openvswitch kernel module for the flow (TC flower can also offload flows
> to NICs but this time that does not matter).
> 
> In this processing flow, I found the following issue in cases of GRE/IPIP
> packets.
> 
> [...]

Here is the summary with links:
  - [net] cls_flower: Fix inability to match GRE/IPIP packets
    https://git.kernel.org/netdev/net/c/6de6e46d27ef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


