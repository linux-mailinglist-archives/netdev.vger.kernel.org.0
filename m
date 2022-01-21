Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D745A4959AA
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 07:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378604AbiAUGAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 01:00:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56008 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378595AbiAUGAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 01:00:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1139B81F45
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 06:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 975BFC340E7;
        Fri, 21 Jan 2022 06:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642744813;
        bh=Gu2S6kBT+by/CDjmWlPI95FRHe+OdnUNW7MzvG8+tx0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vIBpbyscfoNGi1UxjPH55upXgKuZ6rr0LM81reiMzbjLLofyC2ECqyAHPIS9kgjJv
         x9nlNfESyA5ZrPg43blm19tvBMTnkKzBdshphnoDuWuEME9YDgtdjTBO9hWV1dy/ue
         gFMKpb+h1KmPr4/w4VsOinGxEgg538LVN+RK+T/liiYajL7AKHNxNXdXHptdEHU3tj
         5t9elpsXQkYO/CQBETXY9JPs/W+z70Nu/vS/bzOGEUli36LbgyiXNmxpRsauK0DWPk
         kXS6C45lae5OE4f/Tsv8K4mf7qHNqJnmb8rIZwXAAYQVJwbPkJBa5/zELaYhUkzJ1y
         oF/LJTQ41IkAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B601F6079D;
        Fri, 21 Jan 2022 06:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: annotate accesses to fn->fn_sernum
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164274481350.1814.14213842157659170868.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Jan 2022 06:00:13 +0000
References: <20220120174112.1126644-1-eric.dumazet@gmail.com>
In-Reply-To: <20220120174112.1126644-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Jan 2022 09:41:12 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> struct fib6_node's fn_sernum field can be
> read while other threads change it.
> 
> Add READ_ONCE()/WRITE_ONCE() annotations.
> 
> [...]

Here is the summary with links:
  - [net] ipv6: annotate accesses to fn->fn_sernum
    https://git.kernel.org/netdev/net/c/aafc2e3285c2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


