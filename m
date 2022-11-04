Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F08B618F6D
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 05:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiKDEKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 00:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiKDEKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 00:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710351F2C0;
        Thu,  3 Nov 2022 21:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8420062091;
        Fri,  4 Nov 2022 04:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D56C0C433B5;
        Fri,  4 Nov 2022 04:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667535016;
        bh=WVmc/zT6xkjPYdilU0jlgr4Zxr1wW2/RoDbqoDEgp04=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MMXlzhtUkBKPsR9tIN1P8zMdYCCuTMweJbpmOMeIvPJlbgPm1/RmeEplXmDDsXKCp
         xgeZZBu6/07Pk1czA+z1QH32jn6pWRA2Wss7jrYc5Pr8Qn2dhhGk4Tno33w3cDvXyP
         ZgHX0NVz+b6WFEZ1gw9JDihrUqrd5Knxgcpq21h7seg+tSlmPCvdYWKoc6m/fkbJy9
         VEXUNegthsUuK6akmBSof5dlPs3lo53uehWCP+0I1uvwBVh3Qb0yPIORRKJ5JgdMrs
         8MZ/iadQJIevSKCI8atWNQoCEj/UyttIcQjmYkjUYW08Vg7Bl9ly+iLovunbT+L3GW
         Q0Pxy19WHZEXQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8635E270D2;
        Fri,  4 Nov 2022 04:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2022-11-04
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166753501675.4086.8840380962219739735.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 04:10:16 +0000
References: <20221104000445.30761-1-daniel@iogearbox.net>
In-Reply-To: <20221104000445.30761-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  4 Nov 2022 01:04:45 +0100 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 8 non-merge commits during the last 3 day(s) which contain
> a total of 10 files changed, 113 insertions(+), 16 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2022-11-04
    https://git.kernel.org/netdev/net/c/f2c24be55bb7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


