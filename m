Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C025F8D9D
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 21:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiJITAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 15:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiJITAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 15:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925981A836
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 12:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 205AFB80D8E
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 19:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B8954C433D6;
        Sun,  9 Oct 2022 19:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665342014;
        bh=EeM0NvFYt9987G0JmuVI1VOSy1Nwi5UiFs2uC7oy9Po=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JcD27jy5Pg8WH+qvYTqtA3ewPeVaaivtNvDP+CMDeuh5Ch+kKA8+9mCd1IBqjR47/
         q2VyjCaYedZ6ByEjvJIHeVoFcixDFqfMwnED7L+kgPVIba3vERvtAebCEEFE/sf5d1
         oJtftUkSSMIGdRPZmQp3m/azd9n5RFM736C+2hONqZ4NPEOEH9oxvcpqt3nNCpLTG0
         Ips3yyOfRW+97KSLmtVJjLlGzozorrsWE5qhhtmrx4wgsz6JOsraKDdgq3BFV/PY4A
         aZLn4328HmSAfLFr6gBblp+XcCpOpYshrlIpYyot5YbnuQS2cnlGxwgNQmWfjGtwgZ
         WvES/6WMmH6Zg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 94D53E43EFE;
        Sun,  9 Oct 2022 19:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] macvlan: enforce a consistent minimal mtu
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166534201460.6058.15297627699542349899.git-patchwork-notify@kernel.org>
Date:   Sun, 09 Oct 2022 19:00:14 +0000
References: <20221007225743.1633333-1-eric.dumazet@gmail.com>
In-Reply-To: <20221007225743.1633333-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com,
        syzkaller@googlegroups.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  7 Oct 2022 15:57:43 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> macvlan should enforce a minimal mtu of 68, even at link creation.
> 
> This patch avoids the current behavior (which could lead to crashes
> in ipv6 stack if the link is brought up)
> 
> [...]

Here is the summary with links:
  - [net] macvlan: enforce a consistent minimal mtu
    https://git.kernel.org/netdev/net/c/b64085b00044

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


