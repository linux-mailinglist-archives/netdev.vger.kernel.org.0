Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F5E4EEDDD
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 15:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346196AbiDANMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 09:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346201AbiDANMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 09:12:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BDC506C6
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 06:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC57261ACE
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 13:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 136FFC34110;
        Fri,  1 Apr 2022 13:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648818612;
        bh=sN1w/GQNLmFGvPKPXkXFw8Xk3fdfRhRfAHv6J4Qi1VI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lZgI2KthgAj7wvvjkWeqITu66cBgiv93NZPwq75xNvQcN/fY/THOr6/ttJm1485pf
         gliTjJ4Ivzzledc6fhczsOjyMMrSqy7E9brK5aZOfvH+EDfV++3T0N6D2hbc6I8E/p
         JiryUmPp9CdzFNHDdUptZ1CRDWrC+Xh1OYCXTL5abYGh4/xZrZJRayt8O2CH30GHoX
         fzzoSxTGanjkZMl4AxLUzSK3Rm1m37vUU74CyGPc5LKXMAbl4GWRpc6l7SibBIcv1v
         p7P7ZyoLp7VWLG59Ok9yNlocxk+Hn8Y1riEBDS11/pSZNSZ2seNgPVLpaL4g4HTbL3
         fr3kF8PP6Zzhw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EBB90F0384A;
        Fri,  1 Apr 2022 13:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] net: ipv4: fix nexthop route delete warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164881861196.15190.6495658877952415587.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Apr 2022 13:10:11 +0000
References: <20220401073343.277047-1-razor@blackwall.org>
In-Reply-To: <20220401073343.277047-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org,
        donaldsharp72@gmail.com, philippe.guibert@outlook.com,
        kuba@kernel.org, davem@davemloft.net, idosch@idosch.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri,  1 Apr 2022 10:33:41 +0300 you wrote:
> Hi,
> The first patch fixes a warning that can be triggered by deleting a
> nexthop route and specifying a device (more info in its commit msg).
> And the second patch adds a selftest for that case.
> 
> Chose this way to fix it because we should match when deleting without
> nh spec and should fail when deleting a nexthop route with old-style nh
> spec because nexthop objects are managed separately, e.g.:
> $ ip r show 1.2.3.4/32
> 1.2.3.4 nhid 12 via 192.168.11.2 dev dummy0
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net: ipv4: fix route with nexthop object delete warning
    https://git.kernel.org/netdev/net/c/6bf92d70e690
  - [net,v2,2/2] selftests: net: add delete nexthop route warning test
    https://git.kernel.org/netdev/net/c/392baa339c6a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


