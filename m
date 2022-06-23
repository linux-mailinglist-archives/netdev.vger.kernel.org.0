Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7605571CD
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbiFWEjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbiFWDKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 23:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903AE29C9B
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 20:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EEFE61D9D
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 03:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F42AC3411B;
        Thu, 23 Jun 2022 03:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655953813;
        bh=PT2JF5Vnxz6zuFVlSB1trxdgQlp4uBCzOOuMGuEbjHk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AwG+qFc5GNgke/P5BTtnIc9QEPjDojQDLrFqllkW5YmlW9zSSvc2Pd19hPT3oklUH
         rFqww3N5DpSaUdCCwDc2G1jymP7Dzb0m/5jeukBD6qdP8fkz69aBP8hqJjDzOPSf6m
         zdfIQ8on2xaA8Jj6JIOeU7jhJiiqkMSFwgyjhy5wHpJPs0/XYdvIGg6UeLeVdHyEaH
         5Gy9ruDmR0PN9YDq41zuiK3MAewyEVm5CrpJDVY5Pgjq7Aev0t5jjHJT1f5iJEkkNq
         sP49S0s3eziko30kzep6UjMbC431uwtlFU1NGayVeaoB1O3WMAps3ZfVn711DfR3XZ
         x7fQx+yar7N0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7321EE7387A;
        Thu, 23 Jun 2022 03:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3][pull request] 40GbE Intel Wired LAN Driver
 Updates 2022-06-21
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165595381345.32590.17806640082143432315.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Jun 2022 03:10:13 +0000
References: <20220621225930.632741-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220621225930.632741-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, sassmann@redhat.com
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
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 21 Jun 2022 15:59:27 -0700 you wrote:
> This series contains updates to i40e driver only.
> 
> Mateusz adds support for using the speed option in ethtool.
> 
> Minghao Chi removes unneeded synchronize_irq() calls.
> 
> Bernard Zhao removes unneeded NULL check.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] i40e: Add support for ethtool -s <interface> speed <speed in Mb>
    https://git.kernel.org/netdev/net-next/c/7f72d923149c
  - [net-next,2/3] i40e: Remove unnecessary synchronize_irq() before free_irq()
    https://git.kernel.org/netdev/net-next/c/3e0fcb782a9f
  - [net-next,3/3] intel/i40e: delete if NULL check before dev_kfree_skb
    https://git.kernel.org/netdev/net-next/c/56878d49cc26

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


