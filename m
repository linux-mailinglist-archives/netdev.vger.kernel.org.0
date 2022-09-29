Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E68F5EF834
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 17:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234943AbiI2PA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 11:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiI2PAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 11:00:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD75910238B
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 299EDCE21FE
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 15:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84CF2C433B5;
        Thu, 29 Sep 2022 15:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664463616;
        bh=snBk/TJ9eTRKBACp9t/8Q7qhtd52MIM4yCtQ3eOc+8k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O11Zy1qH/Zs8fknzPDvA9rDcArwbilG+JjlkdP3A6w+TPONuYjh0nVR9DXHUHr+8j
         LfrECjuxmmZwfbWC83OJNwa12xh83KZ7JDDMydgWn6eYFMp4p9AJLVGH6NQFMxW+KE
         PU531Q6XGgtSOmPBzWI0Rzdplxoe4KRmyDKOGfNn4Zr84Q/+v/wdnKET44UobIcgwP
         hI/w9belGzjyujcdSEje08FRsueo24Y2IXscPDCfRtKQYtu03h0D11SYtO03oYgP7S
         Gf2HgO6UV2lEV5X435TiyzKmchOMWAxCKSGm3fCxeJMTnXq0iFNz9FTyMH529LurYR
         iR1Nwq4L9TKPw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 689A3E4D018;
        Thu, 29 Sep 2022 15:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch iproute2-next 0/2] devlink: fix couple of cosmetic issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166446361642.22433.2425220805651992484.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 15:00:16 +0000
References: <20220929102436.3047138-1-jiri@resnulli.us>
In-Reply-To: <20220929102436.3047138-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, dsahern@gmail.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Thu, 29 Sep 2022 12:24:34 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Just cosmetics, more or less.
> 
> Jiri Pirko (2):
>   devlink: move use_iec into struct dl
>   devlink: fix typo in variable name in ifname_map_cb()
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/2] devlink: move use_iec into struct dl
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=16d2732a5283
  - [iproute2-next,2/2] devlink: fix typo in variable name in ifname_map_cb()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=d8d3aadf347c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


