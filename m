Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C2F49BFAC
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 00:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbiAYXkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 18:40:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45756 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234941AbiAYXkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 18:40:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCAF1B81B84
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 23:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9A351C340E5;
        Tue, 25 Jan 2022 23:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643154009;
        bh=czDhqrh/CRw9weHgbBA1yXkErrzTy6UWUgKUoQHtGRA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KFtD7xi4Fbs3n8VWi6o/qupYBeNP+/K5APonj/FfJDeRWC8qpc8jv4Qrm/dr7Ayev
         6gclwdWJLOyAHn62iUfPi3NDbcAMXM5C+oIaSu9q2e8pVe+yABY81TGGw9DW+v32OB
         X00V8DbZ3Grsm3jXyzzJde13wp7j3XgK3o5E43MkSdcqg+3Mi4X6Vy8x62fEQx8BQc
         x4n+BSerbw0g0NmjXAhhz7TsIdY9Uafmjk+pkQTEES4Ipuxd0yrHi+boZwQP2OLeYI
         r4px85JRrE7sK94BVGsyzMBs5XBO54B3CBDVGS1BiBhLQhJxGxQ/Qx/LFCBNYthtlq
         b8wM7DFcIhXZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 82B30E5D07D;
        Tue, 25 Jan 2022 23:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: Adjust sk_gso_max_size once when set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164315400953.24146.6826771602579742703.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Jan 2022 23:40:09 +0000
References: <20220125024511.27480-1-dsahern@kernel.org>
In-Reply-To: <20220125024511.27480-1-dsahern@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 24 Jan 2022 19:45:11 -0700 you wrote:
> sk_gso_max_size is set based on the dst dev. Both users of it
> adjust the value by the same offset - (MAX_TCP_HEADER + 1). Rather
> than compute the same adjusted value on each call do the adjustment
> once when set.
> 
> Signed-off-by: David Ahern <dsahern@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: Adjust sk_gso_max_size once when set
    https://git.kernel.org/netdev/net-next/c/ab14f1802cfb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


