Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5BD596D24
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 13:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239119AbiHQLAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 07:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239174AbiHQLAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 07:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC585FF70
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 04:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68D0CB81C94
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 11:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3D68C433D7;
        Wed, 17 Aug 2022 11:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660734016;
        bh=FIrsTzCMGTy2EJKi0DPTshsWavb3xt+EnZbkAHNxCVM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u+x0P4oH7F1mSYGt1n9H5TZ+KJOMSIiqAQsl8L+q2W/fQQ+RS5Zt7uHNqrlhPuqn2
         S6Ma9kVe0aCw4jJb5Nq9MNIr2FbRyD9AgeoCH8T+1m1YPqSkbEyDEWHMakQhWFa+PL
         C0RUbcZld5jUyERTbJGW/Q65EVipjHvPKUuEne0b/2NnvLVD8l80tCYb6z6b7N42fX
         ph+WZWpjyvNKQKsESNr8W5kNLrdvuc2Do9kzVF329y3rfwzKcJhvrZhekYcdtNCzXz
         vcj2meiKYEXm7c0Y5VjrHJWIu9JdRSGMSV/9aYaeAeJfJjjSbH6+ucao572DrQ5C4J
         qU4W9AVlCStzw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D55E6C43142;
        Wed, 17 Aug 2022 11:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] net: wwan: t7xx: fw flashing & coredump support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166073401586.15107.16369865126594704077.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Aug 2022 11:00:15 +0000
References: <20220816042301.2416911-1-m.chetan.kumar@intel.com>
In-Reply-To: <20220816042301.2416911-1-m.chetan.kumar@intel.com>
To:     Kumar@ci.codeaurora.org, M Chetan <m.chetan.kumar@intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
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
by David S. Miller <davem@davemloft.net>:

On Tue, 16 Aug 2022 09:53:01 +0530 you wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> This patch series brings-in the support for FM350 wwan device firmware
> flashing & coredump collection using devlink interface.
> 
> Below is the high level description of individual patches.
> Refer to individual patch commit message for details.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: wwan: t7xx: Add AP CLDMA
    https://git.kernel.org/netdev/net-next/c/d20ef656f994
  - [net-next,2/5] net: wwan: t7xx: Infrastructure for early port configuration
    https://git.kernel.org/netdev/net-next/c/007f26f0d68e
  - [net-next,3/5] net: wwan: t7xx: PCIe reset rescan
    https://git.kernel.org/netdev/net-next/c/140424d90165
  - [net-next,4/5] net: wwan: t7xx: Enable devlink based fw flashing and coredump collection
    https://git.kernel.org/netdev/net-next/c/87dae9e70bf7
  - [net-next,5/5] net: wwan: t7xx: Devlink documentation
    https://git.kernel.org/netdev/net-next/c/b0bc1709b768

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


