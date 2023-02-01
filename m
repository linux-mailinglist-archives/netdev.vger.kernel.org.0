Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16257686EAB
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 20:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbjBATKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 14:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjBATKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 14:10:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AB86279C
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 11:10:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A65A6B8227B
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 19:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 549ECC433D2;
        Wed,  1 Feb 2023 19:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675278620;
        bh=vqzqrgMMaWK7l55RVxcAeLnevFADyAm4z4FeqEcvXtE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aTu9ixjjXuEguD2dSWmTUdQgkWyXAqIFddg2FLBvXVbPqcQmsk5HYNfowWtqz1vvy
         /5kD7tIF53XGye57daqDKmcEJPHGHzZEcyEm7LFIMCfPhk3aMv4vVMegjqGm0B/9ub
         RP74TQoLJJq5Fcr1PwEmHIwYPnIqb6pTkB1WAE/owds2YGUggnVxvzUVCM3Zw/0uST
         s1SGzHtWkJ0jqfyELjCXX1RmTdOujJtDPy+wpTOc77OZZCuCg8xzWZfL7udONcw9OE
         PAoOv0o5Brr7mtsj6hEe7KLNYTCC9pElpjF/z0zJjnKRxJdJMN+nErk/I7w08XJxuo
         syl8m7g4NhEBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39288E21ED4;
        Wed,  1 Feb 2023 19:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next 0/3] devlink: trivial names cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167527862022.14526.14310512928671088131.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Feb 2023 19:10:20 +0000
References: <20230131090613.2131740-1-jiri@resnulli.us>
In-Reply-To: <20230131090613.2131740-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jacob.e.keller@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 31 Jan 2023 10:06:10 +0100 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This is a follow-up to Jakub's devlink code split and dump iteration
> helper patchset. No functional changes, just couple of renames to makes
> things consistent and perhaps easier to follow.
> 
> Jiri Pirko (3):
>   devlink: rename devlink_nl_instance_iter_dump() to "dumpit"
>   devlink: remove "gen" from struct devlink_gen_cmd name
>   devlink: rename and reorder instances of struct devlink_cmd
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] devlink: rename devlink_nl_instance_iter_dump() to "dumpit"
    https://git.kernel.org/netdev/net-next/c/c3a4fd5718ea
  - [net-next,2/3] devlink: remove "gen" from struct devlink_gen_cmd name
    https://git.kernel.org/netdev/net-next/c/f87445953d4c
  - [net-next,3/3] devlink: rename and reorder instances of struct devlink_cmd
    https://git.kernel.org/netdev/net-next/c/8589ba4e642a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


