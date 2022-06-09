Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDFE154426C
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 06:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236795AbiFIEUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 00:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiFIEUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 00:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EEEE3DD3
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 21:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D566761C58
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 04:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 331E7C34115;
        Thu,  9 Jun 2022 04:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654748412;
        bh=Znk74DM1zfgHPUuJcwHIjG0bsB7BH9Y+FWZ/aPhr8cg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=stBClGCuZawDw7XyoqyM2eEQGnHInM81hdf4VgAt3uTxLQshPiJMagGw7zTz0tVAr
         cpzbkBtWjv6Jc7OXYG889wKPG+u8alHH1uNs5qpjhNFAM95DpurWwzqxbvTT1U0vva
         bSRy/OGJxGw7l+lOcew0TSfZn4zTNXC1gCgLJeVt/4T4AKNoWy+gE7W1s/IMHjbKcu
         BVxNXOeC/X/ge2/YYkP5f3vaODL+K8OHFqCDnLItwKg7LMlWX4uFY5wKUr/ShX3gmO
         P8zanKIARECKPQC+dO5+LvDtY6rNXEo2dTWy6+gihXDl7+ykISyG81+8CIZnOAoh1t
         vyEWSlB9YUxIg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 18EDEE737ED;
        Thu,  9 Jun 2022 04:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: amd-xgbe: fix clang -Wformat warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165474841209.6883.1108959402027978072.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Jun 2022 04:20:12 +0000
References: <20220607191119.20686-1-jstitt007@gmail.com>
In-Reply-To: <20220607191119.20686-1-jstitt007@gmail.com>
To:     Justin Stitt <jstitt007@gmail.com>
Cc:     thomas.lendacky@amd.com, llvm@lists.linux.dev,
        ndesaulniers@google.com, nathan@kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  7 Jun 2022 12:11:19 -0700 you wrote:
> see warning:
> | drivers/net/ethernet/amd/xgbe/xgbe-drv.c:2787:43: warning: format specifies
> | type 'unsigned short' but the argument has type 'int' [-Wformat]
> |        netdev_dbg(netdev, "Protocol: %#06hx\n", ntohs(eth->h_proto));
> |                                      ~~~~~~     ^~~~~~~~~~~~~~~~~~~
> 
> Variadic functions (printf-like) undergo default argument promotion.
> Documentation/core-api/printk-formats.rst specifically recommends
> using the promoted-to-type's format flag.
> 
> [...]

Here is the summary with links:
  - net: amd-xgbe: fix clang -Wformat warning
    https://git.kernel.org/netdev/net/c/647df0d41b6b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


