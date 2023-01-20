Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2132B6755CC
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 14:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjATNaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 08:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjATNaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 08:30:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FCFC41C4
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 05:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE269B8281D
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 13:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 70E18C4339E;
        Fri, 20 Jan 2023 13:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674221416;
        bh=7MtCaRC3Q2VCoBvXevtDNtTBgmGap/RtzDKcb5JvYIc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uai/xZ6ivVPI8XP2SoqYI931JoHKxS/LtfjO7DELmqpJNbAjcJy8/HB8pDRGvtizC
         PgJmWnlbRnxisCq38lscOf6uBRA6bV9VQvEtjQ9C5aEqncUw9nLLd/ANKW4FAyvT5Q
         VsjwPqxiiAaDzanoGHZkefH9OsuwvuG6gRmshM3gQdRrDVlHde/O0SlTwl2j/VTJp3
         jjmimLnoxgk70dFFCqeJf/qPHNJhYf5MTRo44oGnbrHYdNciKCil6S/hqFqd84CiUc
         pFFXT4DmlhiGF8w+nVvPPp1wuaP70nlqf+QWgsw1TaZlBk1fEKCmrEtzubTteGq58w
         SWNmul9L6PYMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 54560C04E34;
        Fri, 20 Jan 2023 13:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: fix rate_app_limited to default to 1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167422141634.18652.14652739419092170811.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Jan 2023 13:30:16 +0000
References: <20230119190028.1098755-1-morleyd.kernel@gmail.com>
In-Reply-To: <20230119190028.1098755-1-morleyd.kernel@gmail.com>
To:     David Morley <morleyd.kernel@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, morleyd@google.com, ycheng@google.com,
        ncardwell@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 19 Jan 2023 19:00:28 +0000 you wrote:
> From: David Morley <morleyd@google.com>
> 
> The initial default value of 0 for tp->rate_app_limited was incorrect,
> since a flow is indeed application-limited until it first sends
> data. Fixing the default to be 1 is generally correct but also
> specifically will help user-space applications avoid using the initial
> tcpi_delivery_rate value of 0 that persists until the connection has
> some non-zero bandwidth sample.
> 
> [...]

Here is the summary with links:
  - [net] tcp: fix rate_app_limited to default to 1
    https://git.kernel.org/netdev/net/c/300b655db1b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


