Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D464666A21
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 05:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjALEU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 23:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235789AbjALEUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 23:20:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6C82E1
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 20:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2AEAB81D75
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 04:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4AD42C433F0;
        Thu, 12 Jan 2023 04:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673497216;
        bh=liI3qzC5NrDFJwyqYVMvNdTA63MllbFf4HhWo1P+JDQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YGUab/OqpTxYQwCNHfUhBgaU+mp3DH2KnxTadVs7ZAePtJpk9vlttnNPCfLpxKOT9
         Wfo1MKxcand8/hvIZlSmF73TpPhP5FMCu7/smKUQDSvjSlhuAkvg9eQqCwaFQs5GIX
         u3/1OQltXHHMu0eoypHLHmCFdNWTSs6k2XQWIPfpgG6L3hwIeIYOOZLHMXYxvaKLx5
         ylTPb9A7nIl/tpXwHxsUmFedd/qivIRm8kTS45z9J4pJNOE3/hDNvnBWzLHJFyM9Ib
         484ZUvoW9rLJucBRdexw/0iU/LM5EeZz6OVWE26q6Z0NS68q6Qo1U839LRQ6mr9u9t
         jZfTJxjzvEaVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30289C395D8;
        Thu, 12 Jan 2023 04:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next resubmit v2] r8169: disable ASPM in case of tx
 timeout
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167349721618.28794.16528632793566012861.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Jan 2023 04:20:16 +0000
References: <92369a92-dc32-4529-0509-11459ba0e391@gmail.com>
In-Reply-To: <92369a92-dc32-4529-0509-11459ba0e391@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        stephen@networkplumber.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 10 Jan 2023 23:03:18 +0100 you wrote:
> There are still single reports of systems where ASPM incompatibilities
> cause tx timeouts. It's not clear whom to blame, so let's disable
> ASPM in case of a tx timeout.
> 
> v2:
> - add one-time warning for informing the user
> 
> [...]

Here is the summary with links:
  - [net-next,resubmit,v2] r8169: disable ASPM in case of tx timeout
    https://git.kernel.org/netdev/net-next/c/80c0576ef179

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


