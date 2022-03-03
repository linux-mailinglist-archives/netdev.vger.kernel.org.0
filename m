Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8707A4CC302
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 17:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbiCCQk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 11:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiCCQk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 11:40:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6969F131944;
        Thu,  3 Mar 2022 08:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06F9861610;
        Thu,  3 Mar 2022 16:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59EDCC340F0;
        Thu,  3 Mar 2022 16:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646325610;
        bh=kZnSuby+vzunhy440Jporuuea3nDNjFamYv1mhfxRi0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=knJCxkKBmCtQ6X7GzKDS3Qzzkt4SxyykDhbYQ5KoQ3Yyb5xIxVY1ixl0AfCXv+/kL
         hzmz37zeNR8Lx0/gHAQKxkzxou1XzDuR0XoTGyqdRBDQNGqLNy9iaPYz8TVmEK9FJR
         RPZ1NhWkaZk0ednlRMpTj7BfQXNVqRYKVrBPxBYa8NJ6d1jBKGRRyfizbxvvj7cAz+
         AyVufJ2mx1ihVFy4w5BuGKveHLYKMgNqKlT90Gir+Q/NTPof4eU3zDsqyKu/cQOCtG
         rFH8O5tkogBbjFmNRQFcYM340unF9SSuRYsjWeWqsVDvr58unWhta3oYRG0ypjBSQZ
         WcX3MDqaihzgQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3FBC5EAC096;
        Thu,  3 Mar 2022 16:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2022-03-02
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164632561025.26136.11953927125941699105.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 16:40:10 +0000
References: <20220302175928.4129098-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220302175928.4129098-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org, andrii@kernel.org,
        kpsingh@kernel.org, kafai@fb.com, yhs@fb.com, songliubraving@fb.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  2 Mar 2022 09:59:26 -0800 you wrote:
> This series contains updates to ixgbe and ice drivers.
> 
> Maciej fixes an issue that occurs when carrier is not ok and xsk_pool
> is present that will cause ksoftirqd to consume 100% CPU by changing
> the value returned when the carrier state is not ok for ixgbe. He also
> removes checks against ice_ring_is_xdp() that can't occur for ice.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ixgbe: xsk: change !netif_carrier_ok() handling in ixgbe_xmit_zc()
    https://git.kernel.org/netdev/net/c/6c7273a26675
  - [net,2/2] ice: avoid XDP checks in ice_clean_tx_irq()
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


