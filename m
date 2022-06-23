Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B2F556FFB
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 03:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356325AbiFWBkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 21:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347915AbiFWBkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 21:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E0643396;
        Wed, 22 Jun 2022 18:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC65AB82192;
        Thu, 23 Jun 2022 01:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6FC9DC341C6;
        Thu, 23 Jun 2022 01:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655948413;
        bh=8gPS3ZEbSfQhEFpb4GD8/pHWihq2qhd38yYpOCLsc2A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P/6mB0nehD+C5+PvHOg1Da3T9tTQJNMZJ7iOYBAcZYMa/TXcian9l8y/Q7EqtwvRz
         AFsrd3kY/M3fXQB7Ap7VrQTSiO9gNEUP7DD00oJpiGwyahPF0DSihIy2BKcppdfpkc
         Zlh+1hbUJs0fWffWKDUIG/Al7tdXBXAFoow9L4mYmBzt9Yu2axGggyEbb0yaESzvUb
         PWHvgFSNNsyMdFSvhw12ZT/IipF1tz3Qk65neG1e496Cyaqw1gZhzd2+bN+soEQzMA
         tQ3wzpzRDzv6j6wKYxWmI1YTizlCBkwqrPmIf6rEu88SBTd2fPlPWq5Zm3vYHVLz4J
         3DiptHE4u3mlQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 527C0E7387A;
        Thu, 23 Jun 2022 01:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: dsa: qca8k: reset cpu port on MTU change
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165594841333.25849.16798970262846753043.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Jun 2022 01:40:13 +0000
References: <20220621151122.10220-1-ansuelsmth@gmail.com>
In-Reply-To: <20220621151122.10220-1-ansuelsmth@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, noodles@earth.li,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
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

On Tue, 21 Jun 2022 17:11:22 +0200 you wrote:
> It was discovered that the Documentation lacks of a fundamental detail
> on how to correctly change the MAX_FRAME_SIZE of the switch.
> 
> In fact if the MAX_FRAME_SIZE is changed while the cpu port is on, the
> switch panics and cease to send any packet. This cause the mgmt ethernet
> system to not receive any packet (the slow fallback still works) and
> makes the device not reachable. To recover from this a switch reset is
> required.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: dsa: qca8k: reset cpu port on MTU change
    https://git.kernel.org/netdev/net/c/386228c694bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


