Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5182F4D6D24
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 08:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbiCLHBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 02:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbiCLHBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 02:01:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4593E1029F8
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 23:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2F8360C08
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 07:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 423F7C340EC;
        Sat, 12 Mar 2022 07:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647068410;
        bh=TNkdmxx/jCaHnO1kcPT6b/bvzqGDpsAYR2UguI4ErhE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jfS8fcZ/ih0Jwq7yU+BFjTk2uBf3l8YlCrAOHd3HwX2NMSe7dABNjVBqjPHy/XFrB
         KsdY8jLgK/5sz3G69jSKPslfvB6gJU2jz+wfOTgcXT5RWjD7U92zFg9bCrNKZZURFK
         k5IleErpxDYKHN0xxXMlm8PLAZxRWvmJriHziVYoSDIqM/OfqB3hXjlQ8howRWEEFk
         YyhiNb9JyYMgAyqZ+glP3AeD/eTV00ZLYjt/GRyV+0PFg4wk8VvNqGTS1n3zzKkS1S
         JFuA+czilxjDjGD6PlJDtsh1M7LC4oMfwSWQJcdTEezc5tAh41ukmGwoU7I2irSs8P
         +kfzrXXzHqhkw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 25071E73C2D;
        Sat, 12 Mar 2022 07:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] alx: acquire mutex for alx_reinit in alx_change_mtu
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164706841014.27256.1893088847103071015.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Mar 2022 07:00:10 +0000
References: <20220310232707.44251-1-dossche.niels@gmail.com>
In-Reply-To: <20220310232707.44251-1-dossche.niels@gmail.com>
To:     Niels Dossche <dossche.niels@gmail.com>
Cc:     netdev@vger.kernel.org, chris.snook@gmail.com, davem@davemloft.net,
        kuba@kernel.org, johannes@sipsolutions.net
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 11 Mar 2022 00:27:08 +0100 you wrote:
> alx_reinit has a lockdep assertion that the alx->mtx mutex must be held.
> alx_reinit is called from two places: alx_reset and alx_change_mtu.
> alx_reset does acquire alx->mtx before calling alx_reinit.
> alx_change_mtu does not acquire this mutex, nor do its callers or any
> path towards alx_change_mtu.
> Acquire the mutex in alx_change_mtu.
> 
> [...]

Here is the summary with links:
  - [v2] alx: acquire mutex for alx_reinit in alx_change_mtu
    https://git.kernel.org/netdev/net/c/46b348fd2d81

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


