Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5CAA4ABF55
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 14:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447832AbiBGNB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 08:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442567AbiBGMVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 07:21:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF425C03FED7
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 04:10:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6859D61124
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 12:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C7732C340F1;
        Mon,  7 Feb 2022 12:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644235808;
        bh=efKwV7QV7zJUHKDpjsY9I5/UflgRUk3ovWu7FUxvLEg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oUVgFFXX3cw6nNaSgCfmv8HQsHaxxGdmHluHytB1q/m2zAFfM7s4pyLhou28S7VxJ
         aimvuZJdTNFOba0ty9UFrn6e5GjR4ypP70XNU48HQTwA1JgtAPcLNwKczid3u8AYm/
         cuH09FR3UEOCizImSzErIHXxBLYr4fSARWir69Rj5osrfOEuYnS7Jwu4ZGQ3jZYgZ+
         i0Y5Vx6wMonsf7MzDFbFrZqAx8r64btrLSql/a3nBM3+hAIs7c5Ikl6MRBu5xwSD3G
         RP5jSZoqYZy7DI1vWxyUQQVCLJMXUm9Q/kPeryBjcUrWwh0VzUu/uGDGuDGT8z3IAf
         AafAyhSzwYQfg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A657DE5CF96;
        Mon,  7 Feb 2022 12:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: use GFP_ATOMIC allocation in smc_pnet_add_eth()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164423580867.24406.11128037843401074365.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Feb 2022 12:10:08 +0000
References: <20220206143348.350693-1-eric.dumazet@gmail.com>
In-Reply-To: <20220206143348.350693-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Sun,  6 Feb 2022 06:33:48 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> My last patch moved the netdev_tracker_alloc() call to a section
> protected by a write_lock().
> 
> I should have replaced GFP_KERNEL with GFP_ATOMIC to avoid the infamous:
> 
> [...]

Here is the summary with links:
  - [net] net/smc: use GFP_ATOMIC allocation in smc_pnet_add_eth()
    https://git.kernel.org/netdev/net/c/94fdd7c02a56

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


