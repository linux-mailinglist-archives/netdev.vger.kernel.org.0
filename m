Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178C754A975
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 08:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351799AbiFNGaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 02:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351345AbiFNGaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 02:30:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE6A1A83C;
        Mon, 13 Jun 2022 23:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D6ECB817AB;
        Tue, 14 Jun 2022 06:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B119DC385A2;
        Tue, 14 Jun 2022 06:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655188213;
        bh=AYPq/VQJE5vgPEluHYU3gzWiUXIPxC1klZ+49PaNbgI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hmw3Oo7Z4E9aVzQoy+BmbanNGkLFS9ids1j15rZr2vXdGSGyFDaJcgwzMlTUwaC+u
         t8SjyEq23qsN4it/j9kWkaRdx023Qfl57rM1yVyan8BpIoiNPfEWRLbGvXKo6e+OHn
         75hizgBV0IlTR4Ae9iqOzS+iAdD9jvRHh7ZzPFddSLRwm1p+VLON0ECPXgL4mwn/3B
         CCK2GNNyYG0lR/EYWUs7B/vT4R5ZWtT4+oLmjxMbgGcnWVRYhv31UJKKCGQ/sAXCq3
         zEWlLF4TttrHSURyo9qFl/zOvxq4spS3i5x4BDCkeUD444Z9AfN5f0vEWTw/VzzRWS
         3zIdnlAfeDtEg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 937A7E6D466;
        Tue, 14 Jun 2022 06:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethtool: Fix and simplify
 ethtool_convert_link_mode_to_legacy_u32()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165518821360.28798.10787116939755170787.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Jun 2022 06:30:13 +0000
References: <20220609134900.11201-1-marco@mebeim.net>
In-Reply-To: <20220609134900.11201-1-marco@mebeim.net>
To:     Marco Bonelli <marco@mebeim.net>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Jun 2022 15:49:01 +0200 you wrote:
> Fix the implementation of ethtool_convert_link_mode_to_legacy_u32(), which
> is supposed to return false if src has bits higher than 31 set. The current
> implementation uses the complement of bitmap_fill(ext, 32) to test high
> bits of src, which is wrong as bitmap_fill() fills _with long granularity_,
> and sizeof(long) can be > 4. No users of this function currently check the
> return value, so the bug was dormant.
> 
> [...]

Here is the summary with links:
  - ethtool: Fix and simplify ethtool_convert_link_mode_to_legacy_u32()
    https://git.kernel.org/netdev/net-next/c/19d62f5eeaa0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


