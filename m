Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B284CC286
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 17:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbiCCQVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 11:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234184AbiCCQU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 11:20:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD1D199D63
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 08:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52A1CB82661
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 16:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02DC0C340F2;
        Thu,  3 Mar 2022 16:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646324411;
        bh=GbTcoRkUzNfgi8QB8HcS6LQdnotjlfMJyDbSepeVMTQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ga+5RhCiC6vAgi4q/hLhxoGrXimKaxCayjoV4g4A2BMYdculMh0b7aj7cvxOuhpNm
         xhPZdRfSPKg1ISeyW+trFzvNPNSrEy/dSLCXNz3KUt3FWRPga8w6EEdCRBPHKCjcaa
         GfVmsNQpWy45gxEekL6ZeE3UA/1xtf7Om9zQ8LkO3hACSTyy6nUGzbQbZlCQaZXJ7k
         uFxq8YjGP6NgcqlBfF2rcZIYUK2Eb9I7zkhuoEaK32eDZpbdTeahVYbrhEn4BizQHQ
         FVf4N6IUqYKxrp6lDvgvNHIciw9H9UsBsrWyr9ILgDWdCKHW90QakmsAZ3MPEKahxA
         LcnRE9c+TvXqg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DC206E5D087;
        Thu,  3 Mar 2022 16:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] selftests: mlxsw: A couple of fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164632441089.16147.15733066447122951076.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 16:20:10 +0000
References: <20220302161447.217447-1-idosch@nvidia.com>
In-Reply-To: <20220302161447.217447-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, amcohen@nvidia.com, danieller@nvidia.com,
        mlxsw@nvidia.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  2 Mar 2022 18:14:45 +0200 you wrote:
> Patch #1 fixes a breakage due to a change in iproute2 output. The real
> problem is not iproute2, but the fact that the check was not strict
> enough. Fixed by using JSON output instead. Targeting at net so that the
> test will pass as part of old and new kernels regardless of iproute2
> version.
> 
> Patch #2 fixes an issue uncovered by the first one.
> 
> [...]

Here is the summary with links:
  - [net,1/2] selftests: mlxsw: tc_police_scale: Make test more robust
    https://git.kernel.org/netdev/net/c/dc9752075341
  - [net,2/2] selftests: mlxsw: resource_scale: Fix return value
    https://git.kernel.org/netdev/net/c/196f9bc050cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


