Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238755A8B87
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 04:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbiIACkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 22:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIACkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 22:40:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA96474E2
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 19:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A24B0B823C9
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 02:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3779AC433B5;
        Thu,  1 Sep 2022 02:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662000015;
        bh=x7rkrBqXURQfnZoA0AayxqPWkVuGJ/nxwvdgElpjhoI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bIbmQhrTCJTOo3IXR50HbHuhRtetj10lmo2n1Agv54y2KMKvq+s8nzcTZKDaPNL9J
         vVy2nugImsgb4yKj2/wYyqluL5n/F9YCj0Pt2oBQJip6hgvqdOFBKASG9wq+FGZiYg
         TkPtTyOyPJmmEJ1N8bsqQ83PRdtf+8OtcCDhVWkmsvXjJENPMHRRfoDVaenOH4H2tc
         6Jc/5GxnNRGmaKErAaUKB5z7k1ZIwYy8IL9bmBL8Xg4DHfMoCgL+/nUd7c8YQCBs9Q
         DTaB++Hv55jPYUVxo62JK/iV+FmCyEHWoh6pzUqQ9afyP7UpgGXMDSEC1h8W1+m73s
         8IHpOWUFohaSg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 16E41C4166F;
        Thu,  1 Sep 2022 02:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch iproute2-next 0/2] devlink: allow parallel commands
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166200001508.20120.648796075645214084.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Sep 2022 02:40:15 +0000
References: <20220825080420.1282569-1-jiri@resnulli.us>
In-Reply-To: <20220825080420.1282569-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, dsahern@gmail.com,
        vikas.gupta@broadcom.com, jacob.e.keller@intel.com,
        kuba@kernel.org, moshe@nvidia.com, saeedm@nvidia.com
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

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Thu, 25 Aug 2022 10:04:18 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This patchset contains couple of small patches that allow user to run
> devlink commands in parallel, if kernel is capable of doing so.
> 
> Jiri Pirko (2):
>   devlink: load port-ifname map on demand
>   devlink: fix parallel flash notifications processing
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/2] devlink: load port-ifname map on demand
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=5cddbb274eab
  - [iproute2-next,2/2] devlink: fix parallel flash notifications processing
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=2b392dac5be3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


