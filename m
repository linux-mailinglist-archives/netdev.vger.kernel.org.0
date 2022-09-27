Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B163E5EC716
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 17:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbiI0PA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 11:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbiI0PAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 11:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019EA73904
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 08:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D28761A25
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 15:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E19FDC433D7;
        Tue, 27 Sep 2022 15:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664290816;
        bh=fJkaHa6tyfSYRsUFTzs71+amRH+zSqcPVmZI6j7fRU4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=axmgwCU8E14lAh3HRmk3FmUiLEsR9QoNz7RQ6u0i2sb8CiiwXuqJtVjWwup28vseN
         vGLGZXVGZTG85oCJu6rEJAfQQdauL+p99ybUPrsBiI+SDC5RtArUpKp8in8g+pReR4
         tqDC0LT2yQoHXl6h8uDD+xJRESqcOxOjqUrLjVmouiIP6n/ENKXZRMPXlYnXVH/pJg
         bt/d2H2adp4igP4lCK24B4AQ/PbNER0b4g0zGIbhZSbOlSMJ1/2ea4yZPxj3+U7Dee
         qO43XO6FZ5UIFw8nClCG1Yf2EIt7/pPK1PXEah68H6vCWRRNHSoYuzt96YgllCdqZK
         F4JD06sKUd2Bw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C2A51E21EC1;
        Tue, 27 Sep 2022 15:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next 0/3] devlink: fix order of port and netdev register
 in drivers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166429081579.27886.11728976920673888757.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Sep 2022 15:00:15 +0000
References: <20220926110938.2800005-1-jiri@resnulli.us>
In-Reply-To: <20220926110938.2800005-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        snelson@pensando.io, drivers@pensando.io, f.fainelli@gmail.com,
        yangyingliang@huawei.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 26 Sep 2022 13:09:35 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Some of the drivers use wrong order in registering devlink port and
> netdev, registering netdev first. That was not intended as the devlink
> port is some sort of parent for the netdev. Fix the ordering.
> 
> Note that the follow-up patchset is going to make this ordering
> mandatory.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] funeth: unregister devlink port after netdevice unregister
    https://git.kernel.org/netdev/net-next/c/dfe609491476
  - [net-next,2/3] ice: reorder PF/representor devlink port register/unregister flows
    https://git.kernel.org/netdev/net-next/c/a286ba738714
  - [net-next,3/3] ionic: change order of devlink port register and netdev register
    https://git.kernel.org/netdev/net-next/c/1fd7c08286ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


