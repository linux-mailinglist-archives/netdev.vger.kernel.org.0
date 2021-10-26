Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEB343B26B
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbhJZMce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:32:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235947AbhJZMcd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 08:32:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2430B60EFF;
        Tue, 26 Oct 2021 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635251410;
        bh=SnqNFSP5+VU+b68u/KalevXJYYfsYkIBQSYK4fTHDHY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eIfsSaDy9yQmrIpYsZQp6AP6+xjWCOG1EbZ8ri5lLwm3hSGjtpDh8QA569HrtgU43
         DwqHVoo0K4VZF9vnBvTpd2XQgD6LqAjvMGn8JFfqI7ha2FUxwjPSQdkfYHgwtHhzVL
         AntSspK4yqHfxClKMtBPuNUwW/nxf4YWhhZHw7outBIW+2g6HKYLOwyXbldvCJecgj
         O4u2LS6P9CVHUYEhgw0BXgFNIigm0Dief3aYlFANLIPLOIgkSLCF4lkKpmhjrqQzCJ
         5ztkQvR8vI/S5GH5hD4Wh47EMK6TSgTYmhJOBMdq8XmJ7PDJ13c1tCDeO0JSd1PuPC
         MQo5T4fKd41oQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 19D19600DF;
        Tue, 26 Oct 2021 12:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/2] vrf: rework interaction with
 netfilter/conntrack
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163525141010.31388.2177083204352859727.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 12:30:10 +0000
References: <20211025141400.13698-1-fw@strlen.de>
In-Reply-To: <20211025141400.13698-1-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        lschlesinger@drivenets.com, dsahern@kernel.org,
        pablo@netfilter.org, crosser@average.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 25 Oct 2021 16:13:58 +0200 you wrote:
> V2:
> - fix 'plain integer as null pointer' warning
> - reword commit message in patch 2 to clarify loss of 'ct set untracked'
> 
> This patch series aims to solve the to-be-reverted change 09e856d54bda5f288e
> ("vrf: Reset skb conntrack connection on VRF rcv") in a different way.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] netfilter: conntrack: skip confirmation and nat hooks in postrouting for vrf
    https://git.kernel.org/netdev/net-next/c/8e0538d8ee06
  - [v2,net-next,2/2] vrf: run conntrack only in context of lower/physdev for locally generated packets
    https://git.kernel.org/netdev/net-next/c/8c9c296adfae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


