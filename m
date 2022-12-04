Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A9664209A
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 00:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiLDXuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 18:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiLDXuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 18:50:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E626612775
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 15:50:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D47360F2C
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 23:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3B02C433D7;
        Sun,  4 Dec 2022 23:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670197814;
        bh=63xdwZ2OXMqXjO/8Zvjx5mlI8FbKSwJHDJ/XQW4gtDU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P4K7/4mIm2CjYYZQHCqmqkqbnRM2LrZOkR6Q5y3oBChVhvva1yAVK/qE5A7Bg/fg+
         gfpoThDrc4k5lQj2yU4/pILwv/MdKhJr+m87GycSQqugiXabUKu6ssWjAOqW/1xSCF
         ka+KC4sTce9ZdjzQ+u3zza6EUHzkmnw9mHOCMTHUJEZsutnsRxAHJgNr6/Z6vp79CW
         gcsb7IJrOQMHJCXU8GEreLqllD45HHDMt6DaBdkw3uBxFhh/Fnyn2/z2YG1+5ZtkK/
         UgIAwDwT0tPu9NQTwWOWwmPuWToMRUahpHwd46pzN/LWw5AtpIryEftUg0NW35roLu
         X+4Wgct+JgmkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B7ACDE270CF;
        Sun,  4 Dec 2022 23:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: correct desc type when header dma len is 4096
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167019781474.13667.6835006524449338517.git-patchwork-notify@kernel.org>
Date:   Sun, 04 Dec 2022 23:50:14 +0000
References: <20221202134646.311108-1-simon.horman@corigine.com>
In-Reply-To: <20221202134646.311108-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        yinjun.zhang@corigine.com, richard.donkin@corigine.com,
        niklas.soderlund@corigine.com
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

On Fri,  2 Dec 2022 14:46:46 +0100 you wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> When there's only one buffer to dma and its length is 4096, then
> only one data descriptor is needed to carry it according to current
> descriptor definition. So the descriptor type should be `simple`
> instead of `gather`, the latter requires more than one descriptor,
> otherwise it'll be dropped by application firmware.
> 
> [...]

Here is the summary with links:
  - [net] nfp: correct desc type when header dma len is 4096
    https://git.kernel.org/netdev/net/c/5c306de8f787

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


