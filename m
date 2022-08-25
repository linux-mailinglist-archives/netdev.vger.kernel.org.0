Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964905A1AA9
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243133AbiHYVAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiHYVAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CF12C124
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 14:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA235B82B6A
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 21:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F215C433D6;
        Thu, 25 Aug 2022 21:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661461217;
        bh=R4HHE55RlTJjjUqV+t2tcZ97Ixseny3DohIghI6UgeI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O5GNEMxYi3ZMF4hKzTedkARd0pqNACg4u/xI7VuL577fqJgJrzgK45sYmVyCyewcJ
         ZRUD3nMW1FB9h5Vm0A53Ycc3pg1d4i6xOv2N9xX+pn31+QeBFkcxUXfPr71k26Arug
         j5MuiWjCaUYIBfilhRuzZbm/QK2IDn9yb2iApA5pkQx/icHqTKPCJitl3A0B72bDmu
         Z4+4V6h626nfagdwbPrC9X9oJx0VXJ1aZrP/wcgE0UtUwEyjRQb2py9d081Vreltpq
         GC9nU0Bn5Suj01p4Mi3WrCpdwA4oJZVwasHIbHIvHxyU5OjycquL86+EQX/Naut2Er
         OzYvFIbf5rkbA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 76737C004EF;
        Thu, 25 Aug 2022 21:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next v3 0/3] net: devlink: sync flash and dev info
 commands
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166146121748.1643.16706733424704106127.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 21:00:17 +0000
References: <20220824122011.1204330-1-jiri@resnulli.us>
In-Reply-To: <20220824122011.1204330-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        idosch@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        saeedm@nvidia.com, jacob.e.keller@intel.com,
        vikas.gupta@broadcom.com, gospo@broadcom.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Aug 2022 14:20:08 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Purpose of this patchset is to introduce consistency between two devlink
> commands:
>   devlink dev info
>     Shows versions of running default flash target and components.
>   devlink dev flash
>     Flashes default flash target or component name (if specified
>     on cmdline).
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] net: devlink: extend info_get() version put to indicate a flash component
    https://git.kernel.org/netdev/net-next/c/bb67012331f7
  - [net-next,v3,2/3] netdevsim: add version fw.mgmt info info_get() and mark as a component
    https://git.kernel.org/netdev/net-next/c/0c1989754f76
  - [net-next,v3,3/3] net: devlink: limit flash component name to match version returned by info_get()
    https://git.kernel.org/netdev/net-next/c/f94b606325c1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


