Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C77634F2E
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235623AbiKWEwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235565AbiKWEwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:52:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4890BD905B;
        Tue, 22 Nov 2022 20:52:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D627561A4D;
        Wed, 23 Nov 2022 04:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 392F1C43147;
        Wed, 23 Nov 2022 04:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669179129;
        bh=4NvP/O2VteahETjm4hYBDUujrvlEG1cNk7a8AEiiDTU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Urtl/iRwobjO4H24k2SgU7AmyTuqdzO0GMA4XRLsK+e0pjOULhqKL9Y8L6fYqmac1
         9hrE75ceQDbp93BMRstqMofDdbjfuWOg253I2LyVTz7iAiPr5WALZDAuINuDloj2t7
         YGRKDGFca7t+/MepWGEj1mnz1x+rLedVkAOQ5uE0+D1WkaoBiamakUftTM2oskf8d4
         oBAa7Qt2Tn9fAPBawewJUJ5T7EGm/q0gVObnojrbC48AUy1YzMR4OLd9ZI3DdHiQ/s
         fCJVjP2yqeiD1M7dI80FieK8Ffx7WIGcmxLn62WeRMKq+bvmCKm6cFJgOvgbzO+gDp
         pfG3jkQPGTMug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 18919E4D039;
        Wed, 23 Nov 2022 04:52:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] Revert "veth: Avoid drop packets when xdp_redirect
 performs" and its fix
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166917912909.11566.7056255757396820424.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 04:52:09 +0000
References: <20221122035015.19296-1-hengqi@linux.alibaba.com>
In-Reply-To: <20221122035015.19296-1-hengqi@linux.alibaba.com>
To:     Heng Qi <hengqi@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, pabeni@redhat.com,
        kuba@kernel.org, xuanzhuo@linux.alibaba.com,
        john.fastabend@gmail.com, toke@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 22 Nov 2022 11:50:13 +0800 you wrote:
> This patch 2e0de6366ac16 enables napi of the peer veth automatically when the
> veth loads the xdp, but it breaks down as reported by Paolo and John. So reverting
> it and its fix, we will rework the patch and make it more robust based on comments.
> 
> Heng Qi (2):
>   Revert "bpf: veth driver panics when xdp prog attached before
>     veth_open"
>   Revert "veth: Avoid drop packets when xdp_redirect performs"
> 
> [...]

Here is the summary with links:
  - [1/2] Revert "bpf: veth driver panics when xdp prog attached before veth_open"
    https://git.kernel.org/netdev/net-next/c/b535d681adda
  - [2/2] Revert "veth: Avoid drop packets when xdp_redirect performs"
    https://git.kernel.org/netdev/net-next/c/5e8d3dc73e80

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


