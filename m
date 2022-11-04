Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68719618FC1
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 06:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbiKDFAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 01:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiKDFAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 01:00:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC1D165BA
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 22:00:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAFD8B82BFD
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 05:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32A2CC43470;
        Fri,  4 Nov 2022 05:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667538027;
        bh=oLwVDnbcmZK0KN8F1o/Rwn4ASO25KFQL/iUxwvszajM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Silwmez6Wer1ZG+SYYPsGpFNX/nBU46kKI2EOYdmel2dVOuiYhoansIkto8vrxRlM
         1QChUqjcSTQPvGcF1buogGNdKPBfR85x5OjQqj+dgHv+84xPeEu5Oomc1d0R6r3NDI
         82mv2e2oDtXwxjRfMwvKrwmlhoBwzH0N5RkgWG4sXnPd3TazrlyoN4lTW7eVs/vpUS
         IZsXeqzBcS8d3AWZpzugFE40mTkXHr61bywmdqNFJDdTcPwKgW0zZJ7SQS8qXoiu/j
         Ld44jHce+byJhCF6YbPJB9oZY1lYDet4Xc2VqFw+sNE7A42xtwJy4oYDLHmHltrC7o
         ke+2RU988Sd8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E703EE29F31;
        Fri,  4 Nov 2022 05:00:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6][pull request] Intel Wired LAN Driver Updates
 2022-11-02 (e1000e, e1000, igc)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166753802694.27738.10764597053691364875.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 05:00:26 +0000
References: <20221102203957.2944396-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20221102203957.2944396-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, sasha.neftin@intel.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  2 Nov 2022 13:39:51 -0700 you wrote:
> This series contains updates to e1000e, e1000, and igc drivers.
> 
> For e1000e, Sasha adds a new board type to help distinguish platforms and
> adds device id support for upcoming platforms. He also adds trace points
> for CSME flows to aid in debugging.
> 
> Ani removes unnecessary kmap_atomic call for e1000 and e1000e.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] e1000e: Separate MTP board type from ADP
    https://git.kernel.org/netdev/net-next/c/db2d737d63c5
  - [net-next,2/6] e1000e: Add support for the next LOM generation
    https://git.kernel.org/netdev/net-next/c/0c9183ce61bc
  - [net-next,3/6] e1000e: Add e1000e trace module
    https://git.kernel.org/netdev/net-next/c/7bab8828e1ec
  - [net-next,4/6] e1000e: Remove unnecessary use of kmap_atomic()
    https://git.kernel.org/netdev/net-next/c/ab400b0dd4ec
  - [net-next,5/6] e1000: Remove unnecessary use of kmap_atomic()
    https://git.kernel.org/netdev/net-next/c/3e7b52e0eb9e
  - [net-next,6/6] igc: Correct the launchtime offset
    https://git.kernel.org/netdev/net-next/c/790835fcc0cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


