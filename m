Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B3357917B
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 05:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbiGSDuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 23:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235065AbiGSDuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 23:50:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE74A1BC
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 20:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 42C2FCE1A36
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 03:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59CB5C341CA;
        Tue, 19 Jul 2022 03:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658202614;
        bh=Mf27sS3apVdYyKWUBigasLYZVmCHEIhbB5lfLDooq5Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gaTV7dnX61SjYKtp0cBaBsH7vJgN1jBCpQBk6OAsMkwOSOTHt+qJYlPlOssZKHuCd
         c4kto1uyGt+aLBA4JVzDCPS/ZU5Nw4kASjO7XZFW1pnh2AGiDms9ztumvoz8e5HYnU
         OnwW0jNaAVs6zkZgexm7KsRVN/dGQyqtHOaMSscWYODxSUQCnblpaehCg8hKv3+UgQ
         aTnIIPBz9T+JNCBqXPa2+9EONUG3RUBK58xyPbn3zDosUIuQxKtXeJBlymnWiXrXUu
         UJpj1pkl1sWF2h1jqO4rnvqZpgd+CTbFMnVN3cOQ7Hs5CNNmj7UZ5f3JSfCTGAUhF6
         71AavpRZKmI5A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F115E451B8;
        Tue, 19 Jul 2022 03:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2][pull request] 100GbE Intel Wired LAN Driver
 Updates 2022-07-15
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165820261425.2183.10609708273189132183.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jul 2022 03:50:14 +0000
References: <20220715214642.2968799-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220715214642.2968799-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Fri, 15 Jul 2022 14:46:40 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Ani updates feature restriction for devices that don't support external
> time stamping.
> 
> Zhuo Chen removes unnecessary call to pci_aer_clear_nonfatal_status().
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] ice: Add EXTTS feature to the feature bitmap
    https://git.kernel.org/netdev/net-next/c/896a55aa5232
  - [net-next,v2,2/2] ice: Remove pci_aer_clear_nonfatal_status() call
    https://git.kernel.org/netdev/net-next/c/ca415ea1f03a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


