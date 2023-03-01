Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3976F6A7217
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 18:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjCARaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 12:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjCARaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 12:30:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBF13CE2E;
        Wed,  1 Mar 2023 09:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA59161449;
        Wed,  1 Mar 2023 17:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3CA86C433A7;
        Wed,  1 Mar 2023 17:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677691818;
        bh=Jw73JyhRTaAxmMJmju+h5m6m+JBFOoE+5eLfCBl//2E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uolrFRx1CrYRuKJdrVXTH3+G7JDNW/G2otkVf9J7yl4oWF5YRNp9gmoDFysqPSqRI
         w8rsen+hOeedhEwl7i6KMcFka/BK37nhA1Zxbxm0gWmSqqCOvfIrfzGmq9EmKzYcnx
         lVqwG5NipfsNNcaeJYy0ZArmOJY1Gizs8nW2qOcOrJ5a4gvX6SL/Ipau9cYQ7jQt+u
         TNViV2Jlv68Rwgoxmnk7tqyxN58GJMJa5o5toJ/P7iWH9v1Uk77iWwMCFVm6maX+6/
         UVsrVtpCck+vgc4P7aFxQ+xTmlLX+oD/+eSTlHCHqstmdBOFcDqq6VB3qOaR3M+3Mf
         R1H4zqkdOmyng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 13078E450A7;
        Wed,  1 Mar 2023 17:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: lan966x: Fix port police support using tc-matchall
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167769181807.25108.2018314094074685958.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Mar 2023 17:30:18 +0000
References: <20230228204742.2599151-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230228204742.2599151-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 28 Feb 2023 21:47:42 +0100 you wrote:
> When the police was removed from the port, then it was trying to
> remove the police from the police id and not from the actual
> police index.
> The police id represents the id of the police and police index
> represents the position in HW where the police is situated.
> The port police id can be any number while the port police index
> is a number based on the port chip port.
> Fix this by deleting the police from HW that is situated at the
> police index and not police id.
> 
> [...]

Here is the summary with links:
  - [net] net: lan966x: Fix port police support using tc-matchall
    https://git.kernel.org/netdev/net/c/81563d8548b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


