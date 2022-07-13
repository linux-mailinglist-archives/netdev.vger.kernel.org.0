Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33660572C05
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 05:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiGMDuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 23:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiGMDuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 23:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B92D8630;
        Tue, 12 Jul 2022 20:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0532AB81D04;
        Wed, 13 Jul 2022 03:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 971C1C341C6;
        Wed, 13 Jul 2022 03:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657684213;
        bh=qiPoG7Jg2ZK8XLZzWI0T5Ch1pvGJVm45/AHHC01wVj8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fsvGACoKafuWPo/6GsT6Lwi1pi+9jjdLCSaAAgsu8Y/HNqg2y8gE4mAu8uffR0mY9
         0ijETSgyBxMiTQo02uZpP88Sy+B8vGLONTAYN7DqNLbjjU1baNInvgOQ/z3UvG2plF
         W79GOByaHslMV/YnDLH4TRPV3tw/o7HDLg9Nuhd1KOLxTvGS0qa1GurQJwXezbR+Lo
         /KiF2aIKOXcUNFy4/AXqFgjn+Hn6wCorNfC1DNZ3LQBQc3RD3gvP+OHPtbZvQMMqAI
         j9cblOMKR2M1GESS6t3fV0GkL6LWdNBhrxMR86XxrfV2eAqDosxlxvZ/ZYvOh3Cbib
         T3hK8e8MDz63w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A703E45223;
        Wed, 13 Jul 2022 03:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] igb: add xdp frags support to ndo_xdp_xmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165768421349.12868.5124518960518905657.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 03:50:13 +0000
References: <20220711230751.3124415-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220711230751.3124415-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        lorenzo@kernel.org, netdev@vger.kernel.org, chandanx.rout@intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 11 Jul 2022 16:07:51 -0700 you wrote:
> From: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> Add the capability to map non-linear xdp frames in XDP_TX and
> ndo_xdp_xmit callback.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] igb: add xdp frags support to ndo_xdp_xmit
    https://git.kernel.org/netdev/net-next/c/1aea9d87334d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


