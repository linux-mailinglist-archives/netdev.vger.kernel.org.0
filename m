Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3426A5B07CB
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiIGPAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiIGPAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:00:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522D57671
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 85ACBCE1C69
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 15:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDABAC4347C;
        Wed,  7 Sep 2022 15:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662562818;
        bh=7jeJEjwql3EEohaZJAOSWd5SKm8C6mgXQtWepI34pDI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S2HWqr7rKRMhjHPBT6cOYnBvkscOpgZiL63Ed92b8qVKSGeZNvCoZIJgm41vIO1nd
         tcoYKCzcSkBsBFENNLZQX8UohGvwD43EOWA7dJ4DcxXAk+pE+UT7GAJkaUeIsmMblZ
         d+OsjY5RxkDmcp5rHK090HTRh79H7G18VF2Obd4Imiv7EN3b69lmu8xCmfLytY/U5j
         DquStpmodWczaP5KyoFrvbofJVkWuXhK6R/kIfXWM3zpcJTVzaopZIRN6T2KA/ULWw
         DXMv2jh0iLMBJFR7pafutJlJ2ah5r+gqbqPKJfQjuqa47La5wyO5C2tklKeoAMjNoY
         2Z7vVXYzDJ7ug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C7173E1CABE;
        Wed,  7 Sep 2022 15:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5][pull request] Intel Wired LAN Driver Updates
 2022-09-06 (ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166256281881.26447.10260309099428658851.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Sep 2022 15:00:18 +0000
References: <20220906211302.3501186-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220906211302.3501186-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue,  6 Sep 2022 14:12:57 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Tony reduces device MSI-X request/usage when entire request can't be fulfilled.
> 
> Michal adds check for reset when waiting for PTP offsets.
> 
> Paul refactors firmware version checks to use a common helper.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] ice: Allow operation with reduced device MSI-X
    https://git.kernel.org/netdev/net-next/c/ce4626131112
  - [net-next,2/5] ice: Check if reset in progress while waiting for offsets
    https://git.kernel.org/netdev/net-next/c/0b57e0d44299
  - [net-next,3/5] ice: add helper function to check FW API version
    https://git.kernel.org/netdev/net-next/c/1bd50f2deb19
  - [net-next,4/5] ice: switch: Simplify memory allocation
    https://git.kernel.org/netdev/net-next/c/1b9e740dd733
  - [net-next,5/5] ice: Simplify memory allocation in ice_sched_init_port()
    https://git.kernel.org/netdev/net-next/c/04cbaa6c08e3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


