Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131424BC5EF
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 07:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236816AbiBSFuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 00:50:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236043AbiBSFub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 00:50:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26A3BDE4E
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 21:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99FD5B827CD
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 05:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FF87C340EC;
        Sat, 19 Feb 2022 05:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645249810;
        bh=quGDOzADQoXJGfMI3xcw2JZCEjr0m37B0WRThdIu4Xs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EOIVM2H4p5LtqOt1XNZn3eU88xR8Mp/bkj/S3mlMkLMOQyS1sqOkGHgc319/eCTFi
         MwHY2rE5oD42ef8/Jz7hhEug5wpk1rsfrTYmgZontQwB/NLYerJoHCTqRs9LaHUFpj
         vJvqSyDZvWrPjkD97eVK5Os1zYAjXP0xTtCt/7b3MXo1PX3uM3p7u0TTFOWkZdrdsE
         06n6jj7R4CJCwwLLKZztEa0ijQj3y2MiNiOs5/U8rx0EBsvbUfpi/uQTqyyvJ0RWPs
         xNSAo9N09Ze3JS1kIcjWKxJLGBFVyg9Krw9Yxe8jUExjAmfjFuHH+jl9vnx7lOQ5Ul
         JeD0jLWYuRRIg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 261E4E7BB08;
        Sat, 19 Feb 2022 05:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Add checks for incoming packet addresses
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164524981015.32402.14631434649717750190.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Feb 2022 05:50:10 +0000
References: <20220218042554.564787-1-jk@codeconstruct.com.au>
In-Reply-To: <20220218042554.564787-1-jk@codeconstruct.com.au>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matt@codeconstruct.com.au
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 18 Feb 2022 12:25:52 +0800 you wrote:
> This series adds a couple of checks for valid addresses on incoming MCTP
> packets. We introduce a couple of helpers in 1/2, and use them in the
> ingress path in 2/2.
> 
> Cheers,
> 
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] mctp: replace mctp_address_ok with more fine-grained helpers
    https://git.kernel.org/netdev/net-next/c/cb196b725936
  - [net-next,2/2] mctp: add address validity checking for packet receive
    https://git.kernel.org/netdev/net-next/c/86cdfd63f25d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


