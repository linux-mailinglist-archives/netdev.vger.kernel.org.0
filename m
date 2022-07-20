Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63B657AB2F
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 02:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238959AbiGTAuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 20:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiGTAuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 20:50:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FCE334
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 17:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01F20B81DDD
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BBB2DC341CB;
        Wed, 20 Jul 2022 00:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658278218;
        bh=wKQmKqRicl5I5JvUqeCBqKjUkaANXVd7aI5QABPmGpQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NVbJk/FnxqXwGPxqT0hGD2p3pbtf5x++hB461c+wZsZufEjUGZXkvxIbN8aU67p+2
         AbVhtzA02BPVCj8JVTYxCOhtcIb7sTqihWFYXpB74X3dr1PbfELB0U0TXBbSnQEgzI
         8goE4AZcbzgIwJTbcu3J4kxF8RF7ve0ZN0p2yYNdjTHoe8szv1vKi8VgqGF7NxK2/s
         9GCQwTao36ygJnGy3RK2QZ8Nks0ZPa4Wb6Iv7SSS066uJQHeXUtZwXjDJpxYb8R1KV
         +1sRNhJmX9HYxwb634D8Pq2L5BOgdkErI+WAnMbG+VRXnII1ogMDO1KlvOewRkJZJN
         94K6jwVdWpsTA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9F9CCE451BC;
        Wed, 20 Jul 2022 00:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/4][pull request] Intel Wired LAN Driver Updates
 2022-07-18
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165827821865.16777.10137902398154618750.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jul 2022 00:50:18 +0000
References: <20220718174807.4113582-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220718174807.4113582-1-anthony.l.nguyen@intel.com>
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

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon, 18 Jul 2022 10:48:03 -0700 you wrote:
> This series contains updates to iavf driver only.
> 
> Przemyslaw fixes handling of multiple VLAN requests to account for
> individual errors instead of rejecting them all. He removes incorrect
> implementations of ETHTOOL_COALESCE_MAX_FRAMES and
> ETHTOOL_COALESCE_MAX_FRAMES_IRQ.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/4] iavf: Fix VLAN_V2 addition/rejection
    https://git.kernel.org/netdev/net/c/968996c070ef
  - [net,v2,2/4] iavf: Disallow changing rx/tx-frames and rx/tx-frames-irq
    https://git.kernel.org/netdev/net/c/4635fd3a9d77
  - [net,v2,3/4] iavf: Fix handling of dummy receive descriptors
    https://git.kernel.org/netdev/net/c/a9f49e006030
  - [net,v2,4/4] iavf: Fix missing state logs
    https://git.kernel.org/netdev/net/c/d8fa2fd791a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


