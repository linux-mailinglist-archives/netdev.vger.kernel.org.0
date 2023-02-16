Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDCB698B32
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 04:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjBPDaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 22:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBPDaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 22:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD32A28865;
        Wed, 15 Feb 2023 19:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 516B361E65;
        Thu, 16 Feb 2023 03:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A259BC4339B;
        Thu, 16 Feb 2023 03:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676518217;
        bh=pyW4QRwa1hsXtoJuVx5+c0+hAhw5agc7JlAYOOA34ME=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LZQEC1h+Onz8wjY8PFmy/WfTkvsAz4qnaeIvtetk58NBxbkqeFuKc2CMaE0MzdAYT
         3aS6TsjGzOzYEGxdyyzeuZQgSZ4MW0NOtNgVAdIW7ppfr23LjxaC7CpFKV/bwstTDF
         y6aAwz/zmKjT373g4XYM6O5n2ClcwK7hK7knfdezgF44NgyXA+ZN0ExfcsQX9pg7CA
         zWpXgzS7EWYbdVzzgpw9fJPVpCTaeclZ2MdBThZneVXAF+jYqVxBXoEjxrmO/7+uTo
         ZXXg1t8Nsza7QgT8sMjVHs3IolRRgoeYVZpPWru0JU5xDmt7UkijG/NVMu5Qqa8vus
         3/F6x4oeDc8wg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 892D2E68D39;
        Thu, 16 Feb 2023 03:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates
 2023-02-14 (ixgbe, i40e)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167651821755.29240.3397242945456192101.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 03:30:17 +0000
References: <20230214185146.1305819-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230214185146.1305819-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org, bjorn@kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 14 Feb 2023 10:51:43 -0800 you wrote:
> This series contains updates to ixgbe and i40e drivers.
> 
> Jason Xing corrects comparison of frame sizes for setting MTU with XDP on
> ixgbe and adjusts frame size to account for a second VLAN header on ixgbe
> and i40e.
> 
> The following are changes since commit 05d7623a892a9da62da0e714428e38f09e4a64d8:
>   net: stmmac: Restrict warning on disabling DMA store and fwd mode
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 10GbE
> 
> [...]

Here is the summary with links:
  - [net,1/3] ixgbe: allow to increase MTU to 3K with XDP enabled
    https://git.kernel.org/netdev/net/c/f9cd6a4418ba
  - [net,2/3] i40e: add double of VLAN header when computing the max MTU
    https://git.kernel.org/netdev/net/c/ce45ffb815e8
  - [net,3/3] ixgbe: add double of VLAN header when computing the max MTU
    https://git.kernel.org/netdev/net/c/0967bf837784

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


