Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7BC25047BC
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 14:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbiDQMct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 08:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbiDQMcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 08:32:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF716DEA9;
        Sun, 17 Apr 2022 05:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EB1BB80B83;
        Sun, 17 Apr 2022 12:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18519C385A4;
        Sun, 17 Apr 2022 12:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650198611;
        bh=o/0z0cSTiJx0WM+KrWfPxlkZPrjpZ7Llch6HOsEHINE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JHlVdbmVdxZqotMNLILNbbl3JU+akKt6x8XxYjDdzB2Vf4XfOkSlc/tT3vPqKDzDM
         gnMfLsHhCeb8ZSyxQ92grUeP2tBYvygQAKEL7T5n7NxibdskcX4/k0T9Ldk5WJmwzz
         DFzStLf5pW0XEASkCKFPQnvejtxex+hOgQluf0rN4OtMOZdgFlpKz9br/3yLHammHe
         zhwLA6xf9e8AHpZbeW+tn8XUTLn4A1guPAL10r61PxXkASkzhtGCggLUZ5G/GyQ5Xa
         W9CzjQ3X4SY0+MgAGP2U0ITj11QZ1B+GRndls572QYWjXoJuE3PsQtSRq64G0nS6hb
         +82QOvPoLHjtA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E98F9E8DD6A;
        Sun, 17 Apr 2022 12:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6] net/ipv6: Introduce accept_unsolicited_na knob to
 implement router-side changes for RFC9131
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165019861094.3969.10708842046305944701.git-patchwork-notify@kernel.org>
Date:   Sun, 17 Apr 2022 12:30:10 +0000
References: <20220415083402.39080-1-aajith@arista.com>
In-Reply-To: <20220415083402.39080-1-aajith@arista.com>
To:     Arun Ajith S <aajith@arista.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        dsahern@kernel.org, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, prestwoj@gmail.com,
        gilligan@arista.com, noureddine@arista.com, gk@arista.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 15 Apr 2022 08:34:02 +0000 you wrote:
> Add a new neighbour cache entry in STALE state for routers on receiving
> an unsolicited (gratuitous) neighbour advertisement with
> target link-layer-address option specified.
> This is similar to the arp_accept configuration for IPv4.
> A new sysctl endpoint is created to turn on this behaviour:
> /proc/sys/net/ipv6/conf/interface/accept_unsolicited_na.
> 
> [...]

Here is the summary with links:
  - [net-next,v6] net/ipv6: Introduce accept_unsolicited_na knob to implement router-side changes for RFC9131
    https://git.kernel.org/netdev/net-next/c/f9a2fb73318e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


