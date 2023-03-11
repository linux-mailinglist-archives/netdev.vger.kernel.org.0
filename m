Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1081C6B5721
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 01:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbjCKAxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 19:53:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbjCKAx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 19:53:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB118142DF1
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 16:51:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 055B5B82498
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 00:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6183C4339E;
        Sat, 11 Mar 2023 00:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678495820;
        bh=0E3gmCYT+i4jDh60DrFQcrcCuu0LkDVRrpwm0cwK/60=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L16egvlmy1Ovegz1nqmkAc+phAhwpp0zge+v/I6pYka0URw5ANg9cNrYW/bsD2q9p
         26F2AB6I02Q14Q6j82mT2aj5IGpl8QPoYisa4AUvJdK7ZPqbnWgblxxu5MCDACVYVE
         SuEvLpjsr2LhHLOac8t26st8BliQyfnNgJRJtcl4o+30VcvHeOEvS2vcqXxqdOIUvS
         zLFQ0NgZhe3HzZzulRYEh6BNeSr+wVzaDeWqPZ69fPpjlZfrLsQqyQ8XPfQE/0ISe+
         cFTQMP0Q6aLA2j/pqIaTpH2DP5+862BLcX71e6J9CEl5scGtgdsHynks3xlDc995ox
         LdWyYISOl0rpA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9C178E270C7;
        Sat, 11 Mar 2023 00:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tap: add support for IOCB_NOWAIT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167849582063.26321.5041602132237824015.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 00:50:20 +0000
References: <8f859870-e6e2-09ca-9c0f-a2aa7c984fb2@kernel.dk>
In-Reply-To: <8f859870-e6e2-09ca-9c0f-a2aa7c984fb2@kernel.dk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     netdev@vger.kernel.org, edumazet@google.com, kuba@kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 7 Mar 2023 21:18:21 -0700 you wrote:
> The tap driver already supports passing in nonblocking state based
> on O_NONBLOCK, add support for checking IOCB_NOWAIT as well. With that
> done, we can flag it with FMODE_NOWAIT as well.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> 
> [...]

Here is the summary with links:
  - tap: add support for IOCB_NOWAIT
    https://git.kernel.org/netdev/net-next/c/f758bfec377a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


