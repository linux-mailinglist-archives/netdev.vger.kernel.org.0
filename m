Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32CF852536F
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 19:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356967AbiELRUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 13:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356968AbiELRUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 13:20:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF4C26ADA7
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 10:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D633AB82A77
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 17:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98A77C34100;
        Thu, 12 May 2022 17:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652376015;
        bh=6LhL7KZNIaS4rxxO5MgAJK76FV17a/Q2w5I5O2lWps4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P0DCwMGqG38UU7GHYVNaUlCYJsVXl+dvIjtdqfPZbYqxtTPeYLp8ct+NmPK72gQxX
         5IKfEOw5NltPJ+62ex9HM8OezbMcuztJvSfLIVeO4bo2o3z8eSpC6ptCcrdP0ft6G9
         gwCb83QhaTo7AsUutaikEW0rsdI6PMcseHpHR2JYKjROwimjcn49zZJQvqjoZEbM8b
         6OeYFy9Fztzxt/52+kec5X+20epB1l69IroVv0+YQRutQdNL9CkJvhWl1yCDS8Txb+
         bN7JPopBFhbc1oJtDlqArzbCzplR/tmgD4Y2YWCespA0XN8d6fU/MfBcXnNHjDc7Jy
         1ZjMIVO23DQpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7842DF03937;
        Thu, 12 May 2022 17:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 00/10] ip stats: Support for xstats and afstats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165237601548.19682.8195185427370630562.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 17:20:15 +0000
References: <cover.1652104101.git.petrm@nvidia.com>
In-Reply-To: <cover.1652104101.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, idosch@nvidia.com
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

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Mon, 9 May 2022 15:59:53 +0200 you wrote:
> The RTM_GETSTATS response attributes IFLA_STATS_LINK_XSTATS and
> IFLA_STATS_LINK_XSTATS_SLAVE are used to carry statistics related to,
> respectively, netdevices of a certain type, and netdevices enslaved to
> netdevices of a certain type. IFLA_STATS_AF_SPEC are similarly used to
> carry statistics specific to a certain address family.
> 
> In this patch set, add support for three new stats groups that cover the
> above attributes: xstats, xstats_slave and afstats. Add bridge and bond
> subgroups to the former two groups, and mpls subgroup to the latter one.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,01/10] iplink: Fix formatting of MPLS stats
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=72623b73c4ea
  - [iproute2-next,02/10] iplink: Publish a function to format MPLS stats
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=dff392fd86ee
  - [iproute2-next,03/10] ipstats: Add a group "afstats", subgroup "mpls"
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=5ed8fd9d5144
  - [iproute2-next,04/10] iplink: Add JSON support to MPLS stats formatter
    (no matching commit)
  - [iproute2-next,05/10] ipstats: Add a third level of stats hierarchy, a "suite"
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=c6900b79b13d
  - [iproute2-next,06/10] ipstats: Add groups "xstats", "xstats_slave"
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=1247ed51e924
  - [iproute2-next,07/10] iplink_bridge: Split bridge_print_stats_attr()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=79f5ad95c17c
  - [iproute2-next,08/10] ipstats: Expose bridge stats in ipstats
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=36e10429dafc
  - [iproute2-next,09/10] ipstats: Expose bond stats in ipstats
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=d9976d671c37
  - [iproute2-next,10/10] man: ip-stats.8: Describe groups xstats, xstats_slave and afstats
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=5a1ad9f8c1e6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


