Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C80D5925D4
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 19:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiHNRkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 13:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiHNRkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 13:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7166CB8B
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 10:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BEEEB80B77
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 17:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8805C433D7;
        Sun, 14 Aug 2022 17:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660498814;
        bh=r50sUsuaDUhQaGuvEdXStBynfTtsnxiHSaBL1i64xiI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=orBvlbMeZ72qgdWLE2m7OH74x6RF5kLaSdEGgHSX2R+Y15yY92SeSlGNLJ7SElCLw
         l6ytNJ0gunn400kiC2JFTCpV+CBM/a0NT0v3rdNswgiAHjf94C3bDy0fe03e3HIZ15
         04gZdHT8kOD8jIcq9PcW9CM+dQ/+QvE9+/BVPt1trMmhz6PIQC9JUjpWeoAYQRIedZ
         07Ga0vkE93YX303DRqpCtz0Wnb4qAm4dHeju0/OjRMnaz93vkCeXENYxjfBt773r62
         Te6sBepeG5ZUPoxi9Yo4sZvwM8C1RzWIZNjzant1G+hMH6OPjg6IxZx3hRSkJZb+v8
         c3NGEMsyDqWKw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF2A1C43143;
        Sun, 14 Aug 2022 17:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch iproute2-next] devlink: expose nested devlink for a line card
 object
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166049881471.1582.5255122421776267161.git-patchwork-notify@kernel.org>
Date:   Sun, 14 Aug 2022 17:40:14 +0000
References: <20220809131730.2677759-1-jiri@resnulli.us>
In-Reply-To: <20220809131730.2677759-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, dsahern@gmail.com,
        mlxsw@nvidia.com, idosch@nvidia.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Tue,  9 Aug 2022 15:17:30 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> If line card object contains a nested devlink, expose it.
> 
> Example:
> 
> $ devlink lc show pci/0000:01:00.0 lc 1
> pci/0000:01:00.0:
>   lc 1 state active type 16x100G nested_devlink auxiliary/mlxsw_core.lc.0
>     supported_types:
>       16x100G
> $ devlink dev show auxiliary/mlxsw_core.lc.0
> auxiliary/mlxsw_core.lc.0
> 
> [...]

Here is the summary with links:
  - [iproute2-next] devlink: expose nested devlink for a line card object
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=700a8991f05e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


