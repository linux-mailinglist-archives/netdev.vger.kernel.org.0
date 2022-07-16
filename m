Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E683576B18
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 02:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiGPAUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 20:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiGPAUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 20:20:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763E24F6A7
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 17:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ED135CE3249
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 00:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 382CAC341C0;
        Sat, 16 Jul 2022 00:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657930813;
        bh=Lk6yieVeY87TA4onqdHzQwRYIJS0Nr2+t97MSlqSOp4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AiAnSJu5Oep0QaOboM9X6weeLJgisHoiGjUHev6qPMolxcSiXjBfOwdtYKWtgeuKY
         IIf1Vzj4iw6orB91YGizEh7tA1zX14py93I7HnHx/VbYWKsE1mayBXw+P+UGXyVcS7
         X+BaLmCQXVHMQYbxLOen7ehZ9fSZ6NcMu/BaOgcQk7tgZVLkDKWyZpOXq2EihvY9AS
         UyhDbewzW+43Rld8c8t0WEcZCIdd/RbutDamYX1EfRSxUlElOflbALcG9XKQndyb7Z
         Yv0yjNf5seg9MKJP01cyYvAdwKBpnP9fL1PXIrZw4lU6gD0o90MEA73p2aSys2z8jz
         k4nAGPhz2gkRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 15F39E4521F;
        Sat, 16 Jul 2022 00:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates
 2022-07-14
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165793081308.25022.13008346588703133397.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Jul 2022 00:20:13 +0000
References: <20220714175857.933537-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220714175857.933537-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, sasha.neftin@intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 14 Jul 2022 10:58:54 -0700 you wrote:
> This series contains updates to e1000e and igc drivers.
> 
> Sasha re-enables GPT clock when exiting s0ix to prevent hardware unit
> hang and reverts a workaround for this issue on e1000e.
> 
> Lennert Buytenhek restores checks for removed device while accessing
> registers to prevent NULL pointer dereferences for igc.
> 
> [...]

Here is the summary with links:
  - [net,1/3] e1000e: Enable GPT clock before sending message to CSME
    https://git.kernel.org/netdev/net/c/b49feacbeffc
  - [net,2/3] Revert "e1000e: Fix possible HW unit hang after an s0ix exit"
    https://git.kernel.org/netdev/net/c/6cfa45361d3e
  - [net,3/3] igc: Reinstate IGC_REMOVED logic and implement it properly
    https://git.kernel.org/netdev/net/c/7c1ddcee5311

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


