Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5594D6CFA5E
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 06:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjC3EuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 00:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjC3EuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 00:50:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0151E1995
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 21:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8674C61EF2
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 04:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C351DC433EF;
        Thu, 30 Mar 2023 04:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680151819;
        bh=mciNO0nEeQ/vq8aakO5L5Sn0WtmD3PiuAvmSYetcliI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o+MSySB6DaHe/5Ue4kYg0CI3/mDW5m/OrEmjBnd2jIYIr6fRJaKXSE/BA6ou7FzMV
         HlBCLH7izq8RUbtRU65eaMKTNhs21uN6s0yYXp0j2iF68+uEhRb48kWikVSW3VbqSx
         0yJV6t+lAnXNZzCooT+DVcwOnGSGtmoEv+hZMKQS5UHGpTfLQ68AODimJtav7H283o
         x3jT9c+j91+48yohE/EDFr8wapHZ7TdR2LYpMsHoSts53UnKApnmnUhAktg17fhK+Z
         FeWR8RAz+Glvdl2I6/dItw1d0z4J5p8XartDnD6knTQPOVsWRE6e/9qsmAaVT+vMTG
         6ndoAu6r6XqgA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B1E05E2A037;
        Thu, 30 Mar 2023 04:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates
 2023-03-28 (ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168015181972.11752.2795278731444663581.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Mar 2023 04:50:19 +0000
References: <20230328172035.3904953-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230328172035.3904953-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 28 Mar 2023 10:20:31 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Jesse fixes mismatched header documentation reported when building with
> W=1.
> 
> Brett restricts setting of VSI context to only applicable fields for the
> given ICE_AQ_VSI_PROP_Q_OPT_VALID bit.
> 
> [...]

Here is the summary with links:
  - [net,1/4] ice: fix W=1 headers mismatch
    https://git.kernel.org/netdev/net/c/66ceaa4c4507
  - [net,2/4] ice: Fix ice_cfg_rdma_fltr() to only update relevant fields
    https://git.kernel.org/netdev/net/c/d94dbdc4e020
  - [net,3/4] ice: add profile conflict check for AVF FDIR
    https://git.kernel.org/netdev/net/c/29486b6df3e6
  - [net,4/4] ice: fix invalid check for empty list in ice_sched_assoc_vsi_to_agg()
    https://git.kernel.org/netdev/net/c/e9a1cc2e4c4e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


