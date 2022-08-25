Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3CA5A0768
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbiHYCkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbiHYCkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:40:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30B97FE74
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 19:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E45B6174B
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B0DBC4347C;
        Thu, 25 Aug 2022 02:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661395219;
        bh=rUh6g3igDEl7STbpNgZ9HXSkWkxWqocYMq9ZEy1Mh7E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MbrD0tfrzrU2N8XWZTOWUrh6B3jJPC1QS17BA8z940afI+cDi94YZu3r6STaJM4qy
         VZfl+4fxGF9bHj/2CdGGnDevJigkO3yoGW8RObL7Aybh1HRceBBnmIWyrbMqvBluvB
         L3cZ10e0Z4b8uya4eZBX8zmtDRWlBk5LA5alFLc7mibdQUgMXsSqnTE9DW4eyhYejI
         jcyuJ/xOAjiNygl8DCx38tQZZuJ3Zr2Yc6e78KL6KEft3czu7pORYkOT/tkhi98ZZF
         1beSHUctUisLHgXldQHGE9Lp3ANtkbIvXog2UHHQZW180KaKWi41b3JdHZZTP0nuOH
         NRRv4fjNquVJA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 59196E2A03D;
        Thu, 25 Aug 2022 02:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next] Documentation: devlink: fix the locking section
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166139521936.434.16339590930408268647.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 02:40:19 +0000
References: <20220823070213.1008956-1-jiri@resnulli.us>
In-Reply-To: <20220823070213.1008956-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 23 Aug 2022 09:02:13 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> As all callbacks are converted now, fix the text reflecting that change.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] Documentation: devlink: fix the locking section
    https://git.kernel.org/netdev/net-next/c/77a70f9c5b86

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


