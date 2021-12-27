Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11FDB47FC90
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 13:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236654AbhL0MUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 07:20:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60196 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236646AbhL0MUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 07:20:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F18CE60FE6
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 12:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 53590C36AEB;
        Mon, 27 Dec 2021 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640607610;
        bh=8laaHzaNsLlW1hzFvP3s7PFjwak717yN9XHS8XE07d4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=atncnpvSHnru71Fv/gpdMyO7yb6zFm4QW57OKv0WlNY1JVbp1AoJZhaP0ArE0Fg8D
         /frIMbas5SAFN8MuVwraHssynJm0f+HxGg6nN2z0AaTzCvr5ImZ5Zv8neA2ntk8k8Q
         d8y4pRdG7SV6m4YQykQfEqdU64pm2nlIe7IonaiUASZS5jo9YjIObZC/xk8OHTHlz2
         VfXb+Fe4o3+MvI2LTJZhcpAAvRhDD4x2tLPsNmSPYp1OB9Ej5p3AMX0qUb5jTt6FEW
         Rd/c4xbyP78bvr7U50ypTt6WNOVWEgI+0Nt3UEPAP2NsP9+6xpYFus+fHzUbnGy9Sy
         A5GtC3+PZzx5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 36794C395E0;
        Mon, 27 Dec 2021 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] bnxt_en: Update for net-next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164060761021.26361.17265867327012151969.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Dec 2021 12:20:10 +0000
References: <1640592032-8927-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1640592032-8927-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 27 Dec 2021 03:00:25 -0500 you wrote:
> This series includes some added error logging for firmware error reports,
> DIM interrupt sampling for the latest 5750X chips, CQE interrupt
> coalescing mode support, and to use RX page frag buffers for better
> software GRO performance.
> 
> Andy Gospodarek (1):
>   bnxt_en: enable interrupt sampling on 5750X for DIM
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] bnxt_en: Add event handler for PAUSE Storm event
    https://git.kernel.org/netdev/net-next/c/5a717f4a8e00
  - [net-next,2/7] bnxt_en: Log error report for dropped doorbell
    https://git.kernel.org/netdev/net-next/c/0fb8582ae5b9
  - [net-next,3/7] bnxt_en: enable interrupt sampling on 5750X for DIM
    https://git.kernel.org/netdev/net-next/c/dc1f5d1ebc5c
  - [net-next,4/7] bnxt_en: Support configurable CQE coalescing mode
    https://git.kernel.org/netdev/net-next/c/df78ea22460b
  - [net-next,5/7] bnxt_en: Support CQE coalescing mode in ethtool
    https://git.kernel.org/netdev/net-next/c/3fcbdbd5d8d5
  - [net-next,6/7] bnxt_en: convert to xdp_do_flush
    https://git.kernel.org/netdev/net-next/c/b976969bed83
  - [net-next,7/7] bnxt_en: Use page frag RX buffers for better software GRO performance
    https://git.kernel.org/netdev/net-next/c/720908e5f816

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


