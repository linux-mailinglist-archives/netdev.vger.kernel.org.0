Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBAF75006CE
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 09:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240382AbiDNHWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 03:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240342AbiDNHWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 03:22:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CA4193DF
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 00:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36EB5B8289C
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 07:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E5A79C385A9;
        Thu, 14 Apr 2022 07:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649920811;
        bh=CMNgk7BXxfi3cZYwBqZaO7XmiL1R7HnVFbpl5aQ6lbw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b/Mu/hqcpnki6nqH2U6dGNHJRKFXcrQpVMsY2umzFv+uwUYXASWPmW+W78MgszVVX
         GA2sQcOHuQj/Lampm30JwMAQKahWkD6byDLMBRFUHn1c36NYyyrREr3k8/drTBT0lS
         Mp0krcy/ppRJB8UhMwFoy2hBFPJr8Aq9FWBpObD874ES0gJhC5SxqRwgULYvBle4Kr
         /Hh4nn4SzmxEzRTMZy3H72OVbxKXKIsxDW488bhKlC13e3JNEZP1tOMcPca2d7zmgh
         xP6LWpyQ77xD/HnuupK4JxTMEP8Bwzw96hkp4dfQjoheGr2cIAU4XPggOiKopP/9FN
         b9G1r6VFqiy4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CDF91E8DBD4;
        Thu, 14 Apr 2022 07:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rtnetlink: Fix handling of disabled L3 stats in
 RTM_GETSTATS replies
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164992081083.17585.16175913708091527817.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Apr 2022 07:20:10 +0000
References: <591b58e7623edc3eb66dd1fcfa8c8f133d090974.1649794741.git.petrm@nvidia.com>
In-Reply-To: <591b58e7623edc3eb66dd1fcfa8c8f133d090974.1649794741.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        idosch@nvidia.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 12 Apr 2022 22:25:06 +0200 you wrote:
> When L3 stats are disabled, rtnl_offload_xstats_get_size_stats() returns
> size of 0, which is supposed to be an indication that the corresponding
> attribute should not be emitted. However, instead, the current code
> reserves a 0-byte attribute.
> 
> The reason this does not show up as a citation on a kasan kernel is that
> netdev_offload_xstats_get(), which is supposed to fill in the data, never
> ends up getting called, because rtnl_offload_xstats_get_stats() notices
> that the stats are not actually used and skips the call.
> 
> [...]

Here is the summary with links:
  - [net] rtnetlink: Fix handling of disabled L3 stats in RTM_GETSTATS replies
    https://git.kernel.org/netdev/net/c/23cfe941b52e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


