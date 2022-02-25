Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5424C42C0
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 11:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239815AbiBYKup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 05:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233863AbiBYKuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 05:50:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E7323533C
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 02:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9DF760DCE
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 10:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 40C6FC340F1;
        Fri, 25 Feb 2022 10:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645786211;
        bh=QLqcwFOvwKDeQ7d897UwLNiwPmNo3jKiXei+qI2+8wY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JE0lGcWVN/31iyJ9Tuyaj7RHGqpT7BvRizTX3UppU+p1LAG+AAhnudAnByCIXgTpE
         bpXWKKBCKPouaQACsmWc8RZiZbLHNl6TgfdTet2AFRLQ6U1Pi+Xit4jOA8E4Z3YyMp
         2neBPtfLzGZcIDkXV5yq3H0jXsl3pOSZFAH2aSDDUgXg13AXYI7FOcYvgoMqOJn4EC
         yzwZM4eZzRrbGFz6rON8d1VWnllAzwbz/ANJlODNrHntZRXzbMsd2RhsCzVMk7fP3R
         XIz1IESdgDJAkS8RZq/b/y23+pYHpO7is4z6lTttQ3syynK72h7CwBqwSfvPbIg2/H
         rm96fTbDmyOaA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1EEF4E6D453;
        Fri, 25 Feb 2022 10:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dcb: flush lingering app table entries for
 unregistered devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164578621112.20500.4215266898167946595.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 10:50:11 +0000
References: <20220224160154.160783-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220224160154.160783-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        john.fastabend@gmail.com, petrm@nvidia.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 24 Feb 2022 18:01:54 +0200 you wrote:
> If I'm not mistaken (and I don't think I am), the way in which the
> dcbnl_ops work is that drivers call dcb_ieee_setapp() and this populates
> the application table with dynamically allocated struct dcb_app_type
> entries that are kept in the module-global dcb_app_list.
> 
> However, nobody keeps exact track of these entries, and although
> dcb_ieee_delapp() is supposed to remove them, nobody does so when the
> interface goes away (example: driver unbinds from device). So the
> dcb_app_list will contain lingering entries with an ifindex that no
> longer matches any device in dcb_app_lookup().
> 
> [...]

Here is the summary with links:
  - [net] net: dcb: flush lingering app table entries for unregistered devices
    https://git.kernel.org/netdev/net/c/91b0383fef06

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


