Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494D951EEF0
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 18:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbiEHQYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 12:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235913AbiEHQYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 12:24:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE03EDF7A
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 09:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68F6B6124C
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 16:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA6ACC385AF;
        Sun,  8 May 2022 16:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652026811;
        bh=8rG+mcVAvIn0kPnX9bUskgyPc3GgqvMzqQU/AY9DJO8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IIgkbjwqjuzFrwb9f6ta40psb4uZkerwrIFDdenn55xV+5P5mb12VcmEldlXsQ6j0
         nIlpDJJfZblsXRjTaIGFFPc2WQVc8F8rwhYddjOOr+ySvftBm2R4W5rNWxzXz+b3hW
         eQwFqo7khR1oeLoE0idefdxjIG3W3YPew7TS93Jx0Hh1ApXfxDR6oW6wdYZoVuqhaA
         NuJCB7Kan1Ea6FdKanTwdJv59pNkWNWkEh4qGcCUAgs2iB3yeRWLk/1L2kFhQq8IEP
         T+L5pWvvaRROBwKcT6vrZfeWkIrwmDFtcoZ544lQwnqMEM2pD9LjeQ2TIg3PXFIMkM
         bLc4noOpUfE9Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AADDAE8DBDA;
        Sun,  8 May 2022 16:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] batman-adv: Start new development cycle
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165202681169.7776.6221908264196100235.git-patchwork-notify@kernel.org>
Date:   Sun, 08 May 2022 16:20:11 +0000
References: <20220508132616.21232-2-sw@simonwunderlich.de>
In-Reply-To: <20220508132616.21232-2-sw@simonwunderlich.de>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Simon Wunderlich <sw@simonwunderlich.de>:

On Sun,  8 May 2022 15:26:15 +0200 you wrote:
> This version will contain all the (major or even only minor) changes for
> Linux 5.19.
> 
> The version number isn't a semantic version number with major and minor
> information. It is just encoding the year of the expected publishing as
> Linux -rc1 and the number of published versions this year (starting at 0).
> 
> [...]

Here is the summary with links:
  - [1/2] batman-adv: Start new development cycle
    https://git.kernel.org/netdev/net-next/c/cfa4e7b1bcf8
  - [2/2] batman-adv: remove unnecessary type castings
    https://git.kernel.org/netdev/net-next/c/8864d2fcf043

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


