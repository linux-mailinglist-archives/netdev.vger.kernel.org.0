Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59CD525884
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359563AbiELXkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359559AbiELXkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:40:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B73286FF5
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 16:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B306B82BBB
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 23:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4308BC36AE2;
        Thu, 12 May 2022 23:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652398813;
        bh=ELBSu+MT+NX3Lxaqm2tTxJ/mkx2O/IIxJwFwIcPrG5Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fMBxjwGxmmTffYOR3rPwairxB7GSLNxGEdWpq1XTdtHCeFFGkrNi71RzsMJCycE/a
         +Xt7oKI7UU5qpnnrC1gvtc0uFrNyH7cN+vCnehCEjX2o6wdl5r3xoWvDG+QCzzfn5K
         T/7Lto81LTyfCqmxtkOZlfSx5qVzFzug1z6zoILUJa9VM70/vhJe6R+WNDogtgIkpJ
         vlmRNbl5WK1vaK+e6t1mK6vNeBby2juBhY7TLrjsFvvppMHkr8doo3PU7IPZB6vkuo
         6DLt50zSlje9RxezwtMv8nSqVrenYEORvZ1bTv+qVQ0KLqit7z08POkp5Eh7vdAauJ
         g4zbrmV2yer0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 219DCF03936;
        Thu, 12 May 2022 23:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] mlxbf_gige: remove driver-managed interrupt
 counts
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165239881313.13563.15669889348912472831.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 23:40:13 +0000
References: <20220511135251.2989-1-davthompson@nvidia.com>
In-Reply-To: <20220511135251.2989-1-davthompson@nvidia.com>
To:     David Thompson <davthompson@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, limings@nvidia.com,
        brgl@bgdev.pl, chenhao288@hisilicon.com, cai.huoqing@linux.dev,
        asmaa@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 11 May 2022 09:52:51 -0400 you wrote:
> The driver currently has three interrupt counters,
> which are incremented every time each interrupt handler
> executes.  These driver-managed counters are not
> necessary as the kernel already has logic that manages
> interrupt counts and exposes them via /proc/interrupts.
> This patch removes the driver-managed counters.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] mlxbf_gige: remove driver-managed interrupt counts
    https://git.kernel.org/netdev/net-next/c/f4826443f4d6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


