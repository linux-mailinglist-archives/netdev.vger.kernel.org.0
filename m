Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34E53D49FA
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 22:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbhGXUJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 16:09:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhGXUJd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Jul 2021 16:09:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 83E0760E8C;
        Sat, 24 Jul 2021 20:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627159804;
        bh=j6Ih0psRC49VSyGvCnlv4QrSO2iI9itjL7KoOjRaXow=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tdfXy095Ofbtkj2Y1ibUxPLX0KlguNo7asI4YJimJb2XezXUvJ1H8P0tgVuFpDYaN
         krwAf7mjy5J2TLeMN/TzId7LyrU7BabdYNKQK8pQZRj7s3oLWH4f/5lQbnms6c7Efa
         iilORXDYij43SvlUPhLeK35179djVBsZMXQ8477IZxbxAF//LUwtOokbHJtfO3magB
         Ez7/rsRNu+4cudaq3r0t+LHZXnuFN8J5lrUj3Q0fC2hnQCLLW42Fs3ZFl1cqk1QTXb
         8fBUybWL04hxwqM8jjdL0f8e7tU4FE8r05pZ7Ms/kWNdyh67DHc55hcrKTgWxT5dYQ
         psGzX+ZDiEQUA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 75AEB60A0C;
        Sat, 24 Jul 2021 20:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bridge: fix build when setting
 skb->offload_fwd_mark with CONFIG_NET_SWITCHDEV=n
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162715980447.18267.8661173843406406793.git-patchwork-notify@kernel.org>
Date:   Sat, 24 Jul 2021 20:50:04 +0000
References: <20210723204911.3884995-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210723204911.3884995-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, tobias@waldekranz.com, roopa@nvidia.com,
        nikolay@nvidia.com, stephen@networkplumber.org,
        bridge@lists.linux-foundation.org, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 23 Jul 2021 23:49:11 +0300 you wrote:
> Switchdev support can be disabled at compile time, and in that case,
> struct sk_buff will not contain the offload_fwd_mark field.
> 
> To make the code in br_forward.c work in both cases, we do what is done
> in other places and we create a helper function, with an empty shim
> definition, that is implemented by the br_switchdev.o translation module.
> This is always compiled if and only if CONFIG_NET_SWITCHDEV is y or m.
> 
> [...]

Here is the summary with links:
  - [net-next] net: bridge: fix build when setting skb->offload_fwd_mark with CONFIG_NET_SWITCHDEV=n
    https://git.kernel.org/netdev/net-next/c/c5381154393d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


