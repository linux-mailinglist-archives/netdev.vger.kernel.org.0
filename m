Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 746FD5BD925
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiITBKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiITBK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:10:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43499193F5
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 18:10:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5573EB822B5
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 01:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE1DEC43140;
        Tue, 20 Sep 2022 01:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663636220;
        bh=gkJ7ZVcaz8IXbnDg5q6yn7ldIyp76BwHAyOtlN1CNBA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fg2GmjMYlJ4zgOS6S03eqPyalQZxLAwBxRMaxkKKRF+Oa+SSPf7cTwpI7qnc9ztyi
         Lp3WmtJRWn51I/Qy0NLMHT7TSIfY/XIEyYgytoxoXxP/1JoTyBJTRR25B89f80wR2A
         /mEl8d+blY10PdmTcxQUvNmhkRfRHmuYRRE9vjJ2JQAsG1YTGpZ76KrrJQz5NNSOK9
         FJa9y2k5cmVC+kEY+W+Lu5rxGedDupqKXdr1m/5LWASSbZdRcE0ZrIvGTeR7RQFmjg
         GEGeMiX1OqYqmsJMmScSevYF5mpMIzlh57yFW/u7NHiLuUNAw+tuV5QraysSbGfuDs
         ued+4vVqgx1Mg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C72C9E52538;
        Tue, 20 Sep 2022 01:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] mlxsw: Adjust QOS tests for Spectrum-4 testing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363622081.23429.13803304871211598999.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:10:20 +0000
References: <cover.1663152826.git.petrm@nvidia.com>
In-Reply-To: <cover.1663152826.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, idosch@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com
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

On Wed, 14 Sep 2022 13:21:47 +0200 you wrote:
> Amit writes:
> 
> Quality Of Service tests create congestion and verify the switch behavior.
> To create congestion, they need to have more traffic than the port can
> handle, so some of them force 1Gbps speed.
> 
> The tests assume that 1Gbps speed is supported. Spectrum-4 ASIC will not
> support this speed in all ports, so to be able to run QOS tests there,
> some adjustments are required.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] selftests: mlxsw: Use shapers in QOS tests instead of forcing speed
    https://git.kernel.org/netdev/net-next/c/9e7aaa7c65f1
  - [net-next,2/5] selftests: mlxsw: Use shapers in QOS RED tests instead of forcing speed
    https://git.kernel.org/netdev/net-next/c/61a00b196aaf
  - [net-next,3/5] selftests: devlink_lib: Add function for querying maximum pool size
    https://git.kernel.org/netdev/net-next/c/bd3f7850720c
  - [net-next,4/5] selftests: mlxsw: Add QOS test for maximum use of descriptors
    https://git.kernel.org/netdev/net-next/c/5ab0cf142bb7
  - [net-next,5/5] selftests: mlxsw: Remove qos_burst test
    https://git.kernel.org/netdev/net-next/c/72981ef2d196

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


