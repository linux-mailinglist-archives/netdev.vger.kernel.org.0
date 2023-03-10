Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFE86B3728
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjCJHLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjCJHLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:11:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD683107D4A;
        Thu,  9 Mar 2023 23:11:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2023860EBC;
        Fri, 10 Mar 2023 07:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D993C4339E;
        Fri, 10 Mar 2023 07:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678432264;
        bh=h40/Zux2k/DrUDrrmXSlT/UAMegOunLYFbe8FbJm+Hc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IRa8s5LkCJiHw6JI+NIgdbW9uH0TLsU0b4vONePExNn17RVlta/lb9COqPSRWE7AY
         8yi8QxSTHohEUMAvEZUEkYZ+mHxPPt2/pnlQAcBvSFR4Y7P+KaRwSmGlmCvqFCf1Pk
         K9tTKN6grvhthUEOydGZqOPiYFfrxzvpomroeUtTDPvLICBtomQx26amBCzBdpD7aH
         eshGX7l8N8l3/FJws1B56xuyk/75pBCWac7XDPNocJrGfwxdnVW2XeYTLkjuNI1CVP
         XR9Ou0lHcYkm4FFzDnjMzDGmvbqg5n4amStn3a17R8rxxTlna4sWWHblMXVLkhA528
         p9CTrlYMQnFaQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 64C04E61B66;
        Fri, 10 Mar 2023 07:11:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mctp: remove MODULE_LICENSE in non-modules
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167843226440.11704.9102499483871080842.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Mar 2023 07:11:04 +0000
References: <20230308121230.5354-2-nick.alcock@oracle.com>
In-Reply-To: <20230308121230.5354-2-nick.alcock@oracle.com>
To:     Nick Alcock <nick.alcock@oracle.com>
Cc:     netdev@vger.kernel.org, mcgrof@kernel.org,
        linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
        hasegawa-hitomi@fujitsu.com, jk@codeconstruct.com.au,
        matt@codeconstruct.com.au, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Mar 2023 12:12:30 +0000 you wrote:
> Since commit 8b41fc4454e ("kbuild: create modules.builtin without
> Makefile.modbuiltin or tristate.conf"), MODULE_LICENSE declarations
> are used to identify modules. As a consequence, uses of the macro
> in non-modules will cause modprobe to misidentify their containing
> object file as a module when it is not (false positives), and modprobe
> might succeed rather than failing with a suitable error message.
> 
> [...]

Here is the summary with links:
  - mctp: remove MODULE_LICENSE in non-modules
    https://git.kernel.org/netdev/net-next/c/14296c7d72ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


