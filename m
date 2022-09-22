Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF285E5802
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiIVBaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiIVBaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4F99E693;
        Wed, 21 Sep 2022 18:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D1C362811;
        Thu, 22 Sep 2022 01:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE434C433D7;
        Thu, 22 Sep 2022 01:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663810214;
        bh=PKiHL+1DqQCkB+ys4KLzzlaAz9w9/lU1MRTDk1sC9fY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RIfuOY5jmlVsL7apquAmm7W9DeEH6g6RZqfdvQgTMrH90PIqN7DqPN0Hq13T+3eGh
         qFmh4oIqzWlxhqVg/O04c63WBX8/zAfwN5WOxbRbCG9hOMPpnftUgzdHRwAD/m/0Ns
         aKx/3woY3NMCHwLrkGeud7WxHbgNof5ytDqvqBNweVzBDeMquR5Z4VA3WhUv6axOjo
         DmqQ0IdLAM8kWDDwYoyDuhiSl9W2I9BNeOOVtlz9ajK4EQZVF7oBP+HQKguBzeBxH7
         ouGYgXVBBu+jQx7BOk4xLFTyoWeup0mvBzeCZJaviIAdE1Mx/v2KJP2KdVGzvuWyaa
         SgBztqRwGYdPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A9E27E4D03C;
        Thu, 22 Sep 2022 01:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ice: Fix ice_xdp_xmit() when XDP TX queue number is not
 sufficient
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166381021469.720.2209811827600029157.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 01:30:14 +0000
References: <20220919134346.25030-1-larysa.zaremba@intel.com>
In-Reply-To: <20220919134346.25030-1-larysa.zaremba@intel.com>
To:     Larysa Zaremba <larysa.zaremba@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, maciej.fijalkowski@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, alexandr.lobakin@intel.com
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

On Mon, 19 Sep 2022 15:43:46 +0200 you wrote:
> The original patch added the static branch to handle the situation,
> when assigning an XDP TX queue to every CPU is not possible,
> so they have to be shared.
> 
> However, in the XDP transmit handler ice_xdp_xmit(), an error was
> returned in such cases even before static condition was checked,
> thus making queue sharing still impossible.
> 
> [...]

Here is the summary with links:
  - [net] ice: Fix ice_xdp_xmit() when XDP TX queue number is not sufficient
    https://git.kernel.org/netdev/net/c/114f398d48c5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


