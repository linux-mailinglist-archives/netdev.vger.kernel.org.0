Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C04558F97
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 06:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiFXEUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 00:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiFXEUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 00:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDE951331
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 21:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 360F8620B8
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 04:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59973C341CD;
        Fri, 24 Jun 2022 04:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656044413;
        bh=ToDuEgoriWaVvInkyPnFz6wuEw+tO1Tgp5LmPzmiors=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kg38gpAQujVu401yWnMryD7WE60oBwfI5e154aYMyLlTo6SJAT+yuXoauCWNtPfJN
         7m2MAIMmaaTC8graGBoqx7rra/kgrXZ6HKrG3SedDUk5SJICpyU9yrQyPZ6yR6IT5p
         gxyt9Enah/vpO3NRCoZ5oyTnYMf16+2ZcLSPNADD2ROaBuWgrTQj4fpLi9m6qzEVJW
         cRn6KyvRBHZdrwsM9hGRWJ54axwYyBT4F67nkUr0wtvQiwLoDDQv69DZMmXyZQpEvG
         mMx9XwW4jURvOV66mtKQ9o4mCCaQxoODVmXXDPpbWzd8BlLw894gX0hZP8D0FX3NPv
         FXO8A319WvHYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3EAC5E574DA;
        Fri, 24 Jun 2022 04:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: clear msg_get_inq in __sys_recvfrom() and
 __copy_msghdr_from_user()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165604441325.4225.13959139452095084994.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 04:20:13 +0000
References: <20220622150220.1091182-1-edumazet@google.com>
In-Reply-To: <20220622150220.1091182-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, axboe@kernel.dk
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Jun 2022 15:02:20 +0000 you wrote:
> syzbot reported uninit-value in tcp_recvmsg() [1]
> 
> Issue here is that msg->msg_get_inq should have been cleared,
> otherwise tcp_recvmsg() might read garbage and perform
> more work than needed, or have undefined behavior.
> 
> Given CONFIG_INIT_STACK_ALL_ZERO=y is probably going to be
> the default soon, I chose to change __sys_recvfrom() to clear
> all fields but msghdr.addr which might be not NULL.
> 
> [...]

Here is the summary with links:
  - [net] net: clear msg_get_inq in __sys_recvfrom() and __copy_msghdr_from_user()
    https://git.kernel.org/netdev/net/c/1228b34c8d0e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


