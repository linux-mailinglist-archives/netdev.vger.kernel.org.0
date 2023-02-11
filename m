Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECA1692E28
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 05:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjBKEAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 23:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBKEAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 23:00:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1D21ABE0;
        Fri, 10 Feb 2023 20:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BA5361F18;
        Sat, 11 Feb 2023 04:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0A9EC4339C;
        Sat, 11 Feb 2023 04:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676088019;
        bh=kBp1uteC19i6bkOE0j5LqAmzuVCE7BS7DDOYVZTtvww=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DHTtPD/8xDVyMgACd9O4l5g7UajA5NhwKN6IQsDkhmz7k2L21BBRVIGz0G9BKhYEt
         s471IYXp9eCBmz+lMeHkxSm0mdr357/z3mIniHNI92ATPkr0ekibA6ZBVdkLxD7ue2
         ztqhX9d7ynwXxd5A6pXBXl7gwD4RukiiN+tjVXFq/feC5yFNxp+/itQ7YyQI1wrtFX
         eiaWyqgI/55jHaASPnqS6YhlrXTGDJj8TCW8wOhsOw0cSAOWZs768+pb0I1wYGzZ9V
         KOvEkmFnUXEIGaFh0D4+8MIWC45rDeJiqa042aLDFuNik9/oMnlU2fbDySUbOMsCP6
         Qsns1KOcLqzRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C3AB8E55EFD;
        Sat, 11 Feb 2023 04:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ice: xsk: Fix cleaning of XDP_TX frames
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167608801979.32607.6812685908820179983.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Feb 2023 04:00:19 +0000
References: <20230209160130.1779890-1-larysa.zaremba@intel.com>
In-Reply-To: <20230209160130.1779890-1-larysa.zaremba@intel.com>
To:     Larysa Zaremba <larysa.zaremba@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, intel-wired-lan@osuosl.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        alexandr.lobakin@intel.com, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Feb 2023 17:01:30 +0100 you wrote:
> Incrementation of xsk_frames inside the for-loop produces
> infinite loop, if we have both normal AF_XDP-TX and XDP_TXed
> buffers to complete.
> 
> Split xsk_frames into 2 variables (xsk_frames and completed_frames)
> to eliminate this bug.
> 
> [...]

Here is the summary with links:
  - [net] ice: xsk: Fix cleaning of XDP_TX frames
    https://git.kernel.org/netdev/net/c/1f090494170e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


