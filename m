Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDFC06C87E9
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbjCXWAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbjCXWAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:00:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E05C15CB8
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 15:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B77FDB8263B
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 22:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 69845C4339B;
        Fri, 24 Mar 2023 22:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679695218;
        bh=sdrtEXgc3lZXQXod7fYJcM2w0pbvV1AfeTWmzAQP4Vk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ViqcB12gDRBZipvMp47akpt8F14UwxdoX7UbT4TPL24Quh757wS9VP9vWYM6C2rCp
         oNUVhgmElfaAUnMrhSTPZUcXNGxIMctwAIwmJ/5iuzobeuxHm0H1sEC6mIdqbijN4i
         tzqaR5TxFxSYs4nNwG6FQgzld54C0YzJg2ouejMREF3rntJ6Kp6wHg8n9Xnv8uWP93
         M7wMMCAAP9SNk+cUarbP/mb8DNfG7EEqSd50kMfsE9Y9f3vwB3BIn/mEY0N+jLNMk2
         nFIpFX5439Djq2KCfhW5NmkBfbYlNJzkvtGzSq5hpvX35kECrdqejqvWibyjqyJW45
         f7PYxsloe11ng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 50CD7C41612;
        Fri, 24 Mar 2023 22:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: dp83869: fix default value for
 tx-/rx-internal-delay
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167969521832.9897.18401059606197192566.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Mar 2023 22:00:18 +0000
References: <20230323102536.31988-1-josua@solid-run.com>
In-Reply-To: <20230323102536.31988-1-josua@solid-run.com>
To:     Josua Mayer <josua@solid-run.com>
Cc:     netdev@vger.kernel.org, yazan.shhady@solid-run.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Mar 2023 12:25:36 +0200 you wrote:
> dp83869 internally uses a look-up table for mapping supported delays in
> nanoseconds to register values.
> When specific delays are defined in device-tree, phy_get_internal_delay
> does the lookup automatically returning an index.
> 
> The default case wrongly assigns the nanoseconds value from the lookup
> table, resulting in numeric value 2000 applied to delay configuration
> register, rather than the expected index values 0-7 (7 for 2000).
> Ultimately this issue broke RX for 1Gbps links.
> 
> [...]

Here is the summary with links:
  - net: phy: dp83869: fix default value for tx-/rx-internal-delay
    https://git.kernel.org/netdev/net/c/82e2c39f9ef7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


