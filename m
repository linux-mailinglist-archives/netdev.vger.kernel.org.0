Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C9C463444
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241611AbhK3Mdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:33:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60818 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241582AbhK3Mdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:33:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 404C5B819A4;
        Tue, 30 Nov 2021 12:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF691C53FD4;
        Tue, 30 Nov 2021 12:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638275412;
        bh=j0fZU0DsHTDZ1BpvG8o08wQhKZB15D83eO0A+8gQwV0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SVwpKPTodKaeBVTOd1Z4c2zOVBu0D3L3O5SUBCkoKr8bl0cXxvBb2Xh5iqqB764L6
         VSRsTQ+Q9ECuLVxIVSZErNMFIvQNfqAooFJsDGxPeaDl6MlkLqLouLVcNXfPcpRSbW
         T7FkpDZcBSX0LFjzSEqxtBk7J517NpbbKd+zbqKD1X6B2OTTrQNOwbjqwmxJxly9s0
         rL8W6q2mR3eAWsDzYMaAzN8nLNSo9jk8e0OWiicilpLBNQolh28gRrOWtl/vooc/z4
         t86aFS7T6L1SHGFZNWFYbNDRlIp9VX03BaqfxJSmOfzEYRh9HvuSbSgDUq1l/vaQsi
         C6c2AiKUFcmlQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DB2C460A17;
        Tue, 30 Nov 2021 12:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] net: prestera: acl: migrate to new
 vTcam/counter api
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163827541189.1181.4381809397284707099.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 12:30:11 +0000
References: <1638268383-8498-1-git-send-email-volodymyr.mytnyk@plvision.eu>
In-Reply-To: <1638268383-8498-1-git-send-email-volodymyr.mytnyk@plvision.eu>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, taras.chornyi@plvision.eu,
        mickeyr@marvell.com, serhiy.pshyk@plvision.eu, vmytnyk@marvell.com,
        tchornyi@marvell.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 30 Nov 2021 12:32:57 +0200 you wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> 
> This patch series aims to use new vTcam and Counter API
> provided by latest fw version. The advantage of using
> this API is the following:
> 
> - provides a way to have a rule with desired Tcam size (improves
>   Tcam memory utilization).
> - batch support for acl counters gathering (improves performance)
> - gives more control over HW ACL engine (actions/matches/bindings)
>   to be able to support more features in the future driver
>   versions
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] net: prestera: acl: migrate to new vTCAM api
    https://git.kernel.org/netdev/net-next/c/47327e198d42
  - [net-next,v2,2/3] net: prestera: add counter HW API
    https://git.kernel.org/netdev/net-next/c/6e36c7bcb461
  - [net-next,v2,3/3] net: prestera: acl: add rule stats support
    https://git.kernel.org/netdev/net-next/c/adefefe5289c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


