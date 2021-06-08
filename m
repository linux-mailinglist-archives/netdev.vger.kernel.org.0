Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB053A03F7
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236866AbhFHTYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 15:24:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236356AbhFHTV7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 15:21:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C847261001;
        Tue,  8 Jun 2021 19:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623180005;
        bh=nw5MqRXnweT8FGg25O6okzeBS3+VNiSk5E9vXjzH/yY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CwA9WQGlzhIgeYifmOxj/+wWoFZiZxs224j0ZfP8BXphEj+73l7Xsf+Xq0FdDu5Hn
         Wmp6Co1OgEBezxq2Fv3nShyXIQvY8V3atLqhPopMQvoBzFTPjHYkaKR2yCRByU8LRg
         AWA0kUDbmwipqi2KMImxE1c/iIn+nY0bxSRsX4RhtptYUfeyxZYA0IjiHk1+eiksCv
         trRw7fS8Xz1VYCRFH8WaIV/8SSKrYwsl3snH9Ghx1z0+TzrO6YLFE0X9FAgib4Q73q
         y3qyLujxXHcOD/QTu3wvi0sOW/VXfGZEVPE2p5JT3f0Oqvvdt3/yxREgk6IRXrNTcS
         vN56gHXUAR+ZA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C299460A22;
        Tue,  8 Jun 2021 19:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 01/11] batman-adv: Start new development cycle
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162318000579.7737.13404086203664485668.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 19:20:05 +0000
References: <20210608152700.30315-2-sw@simonwunderlich.de>
In-Reply-To: <20210608152700.30315-2-sw@simonwunderlich.de>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue,  8 Jun 2021 17:26:50 +0200 you wrote:
> This version will contain all the (major or even only minor) changes for
> Linux 5.14.
> 
> The version number isn't a semantic version number with major and minor
> information. It is just encoding the year of the expected publishing as
> Linux -rc1 and the number of published versions this year (starting at 0).
> 
> [...]

Here is the summary with links:
  - [01/11] batman-adv: Start new development cycle
    https://git.kernel.org/netdev/net-next/c/9a959cab2219
  - [02/11] batman-adv: Always send iface index+name in genlmsg
    https://git.kernel.org/netdev/net-next/c/d295345abb3e
  - [03/11] batman-adv: bcast: queue per interface, if needed
    https://git.kernel.org/netdev/net-next/c/3f69339068f9
  - [04/11] batman-adv: bcast: avoid skb-copy for (re)queued broadcasts
    https://git.kernel.org/netdev/net-next/c/4cbf055002c5
  - [05/11] batman-adv: mcast: add MRD + routable IPv4 multicast with bridges support
    https://git.kernel.org/netdev/net-next/c/7a68cc16b82c
  - [06/11] batman-adv: Remove the repeated declaration
    https://git.kernel.org/netdev/net-next/c/1cf1ef60a1a6
  - [07/11] batman-adv: Fix spelling mistakes
    https://git.kernel.org/netdev/net-next/c/791ad7f5c17e
  - [08/11] batman-adv: Drop implicit creation of batadv net_devices
    https://git.kernel.org/netdev/net-next/c/bf6b260b8a96
  - [09/11] batman-adv: Avoid name based attaching of hard interfaces
    https://git.kernel.org/netdev/net-next/c/fa205602d46e
  - [10/11] batman-adv: Don't manually reattach hard-interface
    https://git.kernel.org/netdev/net-next/c/170258ce1c71
  - [11/11] batman-adv: Drop reduntant batadv interface check
    https://git.kernel.org/netdev/net-next/c/020577f879be

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


