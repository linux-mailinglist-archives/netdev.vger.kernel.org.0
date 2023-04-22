Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6EC06EB739
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 05:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjDVDui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 23:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjDVDub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 23:50:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3ADE1FC3;
        Fri, 21 Apr 2023 20:50:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 591C063BC3;
        Sat, 22 Apr 2023 03:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7D30C433D2;
        Sat, 22 Apr 2023 03:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682135429;
        bh=iVkHaE8eCMl3ljbEGwhZ7UfOkU1P4VOuz5eSyh6hsJs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mm2l/pDjZHyavhmyxdHLapgBUbzYpEkbcAX5E/yAmuNKBneoRZp4EFNOmsATE6UqO
         hTUzhTvxyXTF52SMaA9QjHRTEjHx6vF+w/A0MxMH4e6nbUiY2cBiPv2mvoRloTGkzk
         d+372hcZZ9mIHfgG0kaLAjQjkz/KXoXJOz0gS9HWUwHvOUKzCF46R4D+ZEZGSqXbZv
         YPnKJ2K69VQM0WdDDtEL+vXVcfKoYkDDXHdBW8Yv3wY29S4kT5jGY353zhjf8acS2X
         QWh2tkeMYOThZTkiqAUxutamR238P3m5ahBypt5CNxEO4VTitSiP+FCnDoh0iis1tW
         nn5fhqrgy0Y8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A543AE270DA;
        Sat, 22 Apr 2023 03:50:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2023-04-21
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168213542967.31717.12562943743588428880.git-patchwork-notify@kernel.org>
Date:   Sat, 22 Apr 2023 03:50:29 +0000
References: <20230421211035.9111-1-daniel@iogearbox.net>
In-Reply-To: <20230421211035.9111-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 21 Apr 2023 23:10:35 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 71 non-merge commits during the last 8 day(s) which contain
> a total of 116 files changed, 13397 insertions(+), 8896 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2023-04-21
    https://git.kernel.org/netdev/net-next/c/9a82cdc28f47

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


