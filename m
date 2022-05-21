Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82DE52F745
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 03:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352920AbiEUBKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 21:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243528AbiEUBKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 21:10:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2FE1B12DD
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 18:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82D51B82EDF
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 01:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41B2DC34100;
        Sat, 21 May 2022 01:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653095412;
        bh=RM5kaOIp9kLh379FA8HUDdt8nzPfXqnWuBquTUDeXuM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UL1gIm7ZP5nbrSilQx+hOGn8m5DQI58gzLSAmR0nsVuGCpekxFqudl4zSb+2Ss64z
         uqSXYSP6JoHohqBFJhEd7pHSjPdbeyWE7V4TKeVaDiYIORzP8OSaM2zh9KupYz9rGy
         rIPw7o2nUCyWVIDp8yfNEE3jQeh6iHCvOi8u2gHxOqVfCUnu7XyG1bGg4kB6nEqLHW
         J+nsP90SofUGegCQc5e0+sP5LKlaNXrvhyUSKAmzFlhdfFHRqzdQHZiGhm2mq2NA/M
         L97uLyAPMjX7kDG2YQ5Azr6FzBRqP+XdI7B22RIjSGGens0SO6SjX6QRi/xy4fHmDV
         J6wR7zUYALLxg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 224AFF03935;
        Sat, 21 May 2022 01:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] wwan: iosm: use a flexible array rather than
 allocate short objects
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165309541213.9944.10663249636403145940.git-patchwork-notify@kernel.org>
Date:   Sat, 21 May 2022 01:10:12 +0000
References: <20220520060013.2309497-1-kuba@kernel.org>
In-Reply-To: <20220520060013.2309497-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, m.chetan.kumar@intel.com, linuxwwan@intel.com,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 19 May 2022 23:00:13 -0700 you wrote:
> GCC array-bounds warns that ipc_coredump_get_list() under-allocates
> the size of struct iosm_cd_table *cd_table.
> 
> This is avoidable - we just need a flexible array. Nothing calls
> sizeof() on struct iosm_cd_list or anything that contains it.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] wwan: iosm: use a flexible array rather than allocate short objects
    https://git.kernel.org/netdev/net-next/c/eac67d83bf25

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


