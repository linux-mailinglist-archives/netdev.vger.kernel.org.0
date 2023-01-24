Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB2E679085
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 06:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbjAXF4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 00:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjAXF4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 00:56:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4F63CE10
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 21:55:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57E55B81076
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 05:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0323AC4339C;
        Tue, 24 Jan 2023 05:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674539418;
        bh=rFplY8wVoaP6NnJmu31njf396jT+MmzMtEyKOa68tNs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KGdgs0PxCxSEab94NKps09IhXLGdXIf0smvm8PSAVWnQCVgzgoxUKnf6vmtn3UVJO
         67criK49EJGrchfiS/LqOn7UAOObzcbQXr9uUUWId2zgl1dtaoED+trcRwC/SPsMES
         L53Mr5dnnSPmQML2XoUlwIAHsxacQ0lIM1SqznSvBYnV5u+GS6k+xyNJCWXe0lRVZg
         8vIsIGpL4i19Q10GaX2TgckiE6xjgw8uwpfwW1Xk7Jx2a6mNxvZAjLOgkEMA1o9QOn
         SgNKS7MUk1Y0GrTjBZApAvxuOBfngxTlj+IXcqyYkNlGEB/l/5a+2I6ydalobocHj6
         ooZeazPU6IYag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D819EF83ECD;
        Tue, 24 Jan 2023 05:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: Update MPTCP maintainer list and CREDITS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167453941788.4419.9662628324991224049.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 05:50:17 +0000
References: <20230120231121.36121-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20230120231121.36121-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 20 Jan 2023 15:11:21 -0800 you wrote:
> My responsibilities at Intel have changed, so I'm handing off exclusive
> MPTCP subsystem maintainer duties to Matthieu. It has been a privilege
> to see MPTCP through its initial upstreaming and first few years in the
> upstream kernel!
> 
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [net] MAINTAINERS: Update MPTCP maintainer list and CREDITS
    https://git.kernel.org/netdev/net/c/bce4affe30b2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


