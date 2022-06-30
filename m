Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEA5561707
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbiF3KAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233748AbiF3KAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA7D43EDC;
        Thu, 30 Jun 2022 03:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D5CE62195;
        Thu, 30 Jun 2022 10:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72E02C385A5;
        Thu, 30 Jun 2022 10:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656583214;
        bh=BWLfKsPSN4yajyxIhFyOTTZXdy8Ooyjrk8lujMp6r2c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f6DaFtzD5/f1u+5kOT5ozyzBVPm9bJRcngnEXaYSPfZfqSF2KpUI8y8MC9wppKFdy
         CLynIjl+WvcRfTy1QGWGU5KJoo8gmgCbaUZ5VIAkNv0DbaFHpjFX+pNPAzxjdegKK5
         4toWaQ9DmoQqycHfQz+Cfa81Eqw5zqih6sxMYfmtBTm/cAsfUT/HdfCxpl+VbMGJHn
         hPAWa5aA2mzhlbtE9fAOTRtwcnjXobdENzG8Gd+3lLA/3jA1Uwt8Ul6Wxr1HT70YBy
         Jda3W+FFvz7raA4JogWkAZCMXY1HlaaFSa2HtjvVKY4tHVzs5HP9q87hhjmrKJtatY
         PN1pk2nSZCdPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5252EE49FA0;
        Thu, 30 Jun 2022 10:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: sfp: fix memory leak in sfp_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165658321433.30282.12130648369067340647.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 10:00:14 +0000
References: <20220629075550.2152003-1-niejianglei2021@163.com>
In-Reply-To: <20220629075550.2152003-1-niejianglei2021@163.com>
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 29 Jun 2022 15:55:50 +0800 you wrote:
> sfp_probe() allocates a memory chunk from sfp with sfp_alloc(). When
> devm_add_action() fails, sfp is not freed, which leads to a memory leak.
> 
> We should use devm_add_action_or_reset() instead of devm_add_action().
> 
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
> 
> [...]

Here is the summary with links:
  - [net,v3] net: sfp: fix memory leak in sfp_probe()
    https://git.kernel.org/netdev/net/c/0a18d802d65c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


