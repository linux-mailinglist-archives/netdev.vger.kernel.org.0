Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A22951296D
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 04:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237776AbiD1CX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 22:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbiD1CX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 22:23:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D50671D87
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 19:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E5DF60EA6
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 02:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62542C385AD;
        Thu, 28 Apr 2022 02:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651112413;
        bh=ww7HQG2Tn34K9m84UmJ6Jass8zBmCqamk6sw1AiuRQc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iwBnbYpNkUR4I/ixtl8R/ahj7q0dngqczg6lkXCoFOGMbOyS3eJsBajw4WcOp0xuj
         kST5LVtIw+fr2FDciWUhckgRjkdqihdYWRXhdz2lIrpqTUvbTRQWY/592vdZ6nVnTP
         nizfY7q5GOTL5QOazG3xL1kCjPXprJhDP6VeXeLfj4tn2AAczN5yD+Ag0lVngwNT5+
         i7LvkGm6eRkInPytZ5dbDa76d4trWoNDUp9/hoJ1R28fa+lNF5wpu++DBQGCxLxKz0
         wLL32JZMNpfyZSTxR/SJfIGgyifs5VloMZhwOq1yZi2fbhVs7zQM1ZrRgJ+miTR/65
         uYxh4E6oLD3Dw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 40F46E8DD67;
        Thu, 28 Apr 2022 02:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 00/11] ip stats: A new front-end for
 RTM_GETSTATS / RTM_SETSTATS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165111241325.28424.6132629051800661870.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Apr 2022 02:20:13 +0000
References: <cover.1650615982.git.petrm@nvidia.com>
In-Reply-To: <cover.1650615982.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, idosch@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Fri, 22 Apr 2022 10:30:49 +0200 you wrote:
> A new rtnetlink message, RTM_SETSTATS, has been added recently in kernel
> commit ca0a53dcec94 ("Merge branch 'net-hw-counters-for-soft-devices'").
> 
> At the same time, RTM_GETSTATS has been around for a while. The users of
> this API are spread in a couple different places: "ip link xstats" reads
> stats from the IFLA_STATS_LINK_XSTATS and _XSTATS_SLAVE subgroups, "ip
> link afstats" then reads IFLA_STATS_AF_SPEC.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,01/11] libnetlink: Add filtering to rtnl_statsdump_req_filter()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=a463d6b19107
  - [iproute2-next,02/11] ip: Publish functions for stats formatting
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=5520cf1603ba
  - [iproute2-next,03/11] ip: Add a new family of commands, "stats"
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=54d82b0699a0
  - [iproute2-next,04/11] ipstats: Add a "set" command
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=82f6444f83c7
  - [iproute2-next,05/11] ipstats: Add a shell of "show" command
    (no matching commit)
  - [iproute2-next,06/11] ipstats: Add a group "link"
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=0517a2fd66ae
  - [iproute2-next,07/11] ipstats: Add a group "offload", subgroup "cpu_hit"
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=af5e7955273e
  - [iproute2-next,08/11] ipstats: Add offload subgroup "hw_stats_info"
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=179030fa6bc7
  - [iproute2-next,09/11] ipstats: Add offload subgroup "l3_stats"
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=0f1fd40cc9e8
  - [iproute2-next,10/11] ipmonitor: Add monitoring support for stats events
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=a05a27c07cbf
  - [iproute2-next,11/11] man: Add man pages for the "stats" functions
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=b28eb051b321

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


