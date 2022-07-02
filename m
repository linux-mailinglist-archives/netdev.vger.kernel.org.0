Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F70563DF3
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 05:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbiGBDUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 23:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiGBDUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 23:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E27E31934
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 20:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D614661D46
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 03:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3012FC341C6;
        Sat,  2 Jul 2022 03:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656732014;
        bh=VmwfkXxozm88Dk+i4mrDtq/TLhWxGoBDkgFy+6In46A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ll4rfeg6IGJKpGYC3F3cdCnquRiF2tRSAqIM4kyVqgPOg5XW1q+ITE5SH0AfSPJ4x
         1e5/QFQdIX0uVIX8Ew7CVLTuiLLTK2b6JuYbwIYEHWucn+3o1fnv7y1eZhfFsY+10m
         ixUYfN9EpJtdiakEtW4+IXlTcqvZ3Lg3cjF0upnqEWxe19ZDvovDQgQ/5K5YkXrWiQ
         YuSbJoMZC7KY4hWI8u7i3pwiBT6z0BvS/pDQifZRs+v2hh6nb+tiV7BJtEsFFLRkho
         R6wW1qe1xpt/rWSqGkMjMCxGle8y64843RyxIIsoVnfM8fCDEaKmrdNiswvQ2ZtisE
         5CPniDwD1b6iw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 16857E49BBC;
        Sat,  2 Jul 2022 03:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests/net: fix section name when using xdp_dummy.o
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165673201408.6297.2474028535787637780.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Jul 2022 03:20:14 +0000
References: <20220630062228.3453016-1-liuhangbin@gmail.com>
In-Reply-To: <20220630062228.3453016-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, andrii@kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 30 Jun 2022 14:22:28 +0800 you wrote:
> Since commit 8fffa0e3451a ("selftests/bpf: Normalize XDP section names in
> selftests") the xdp_dummy.o's section name has changed to xdp. But some
> tests are still using "section xdp_dummy", which make the tests failed.
> Fix them by updating to the new section name.
> 
> Fixes: 8fffa0e3451a ("selftests/bpf: Normalize XDP section names in selftests")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] selftests/net: fix section name when using xdp_dummy.o
    https://git.kernel.org/netdev/net/c/d28b25a62a47

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


