Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDE750A2D2
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 16:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389534AbiDUOnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 10:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389528AbiDUOnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 10:43:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E213F31A;
        Thu, 21 Apr 2022 07:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13A34B82534;
        Thu, 21 Apr 2022 14:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CBF6BC385AC;
        Thu, 21 Apr 2022 14:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650552012;
        bh=DKsEv/LABW12r4OSRC7mw/gVT+7RoHLCGvohkLfka04=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tSVjYOMG6TfkiXUdj81QmLrZItY6c9ofpaEsd5GD5JxwwgXRWIiG5IUok0NBohEKJ
         jmCaQu2ycBSrgP9Xi1gBIQBPxnoJun70uX0ZJQnSkwCHMFX+qxCsalHeiCCKpFBgZx
         veeKdawODISyqa4/m81fJVJ0go64nWAeb00uwoUweGbTBjpzAu1MBcy9Y8pNYOfLJb
         ipQXzaXhPeNGBj0ZlCoon860tdN3g4E7R2BXBoXK8/uBH2djCTo/8EU/v+s2wNWmMG
         S6at1N6Xm4EAnynHKndmMvVIyOzTabdehN9NHvdn0TrW4nh/ePvjsSytvIUXKOnHdi
         w4p/YhtShQzKA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AC52FE8DD85;
        Thu, 21 Apr 2022 14:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/2] xsk: remove reduntant 'falltrough' attributes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165055201268.27677.12493601547484216703.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Apr 2022 14:40:12 +0000
References: <20220421132126.471515-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20220421132126.471515-1-maciej.fijalkowski@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        sfr@canb.auug.org.au, andrii@kernel.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, linux-next@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 21 Apr 2022 15:21:24 +0200 you wrote:
> This is a follow-up to recently applied set [0] to fix the build
> warnings:
> 
> error: attribute 'fallthrough' not preceding a case label or default
> label [-Werror]
> 
> that Stephen has stumbled upon when merging bpf-next to linux-next.
> Apologies for these leftovers.
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/2] ixgbe: xsk: get rid of redundant 'fallthrough'
    https://git.kernel.org/bpf/bpf-next/c/e130e8d5434b
  - [bpf-next,2/2] i40e: xsk: get rid of redundant 'fallthrough'
    https://git.kernel.org/bpf/bpf-next/c/9d87e41a6d64

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


