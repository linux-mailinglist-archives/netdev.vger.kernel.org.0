Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C73E647522
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 18:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiLHRuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 12:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiLHRuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 12:50:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2279934EA
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 09:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78C50B825B2
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 17:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 074D3C43396;
        Thu,  8 Dec 2022 17:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670521816;
        bh=RsJIk9qC18tdBIlq/DktstajvjZ5PjWRfu7BGuowcDI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UBfb2YJH+Qn9ob90jbOvIf4aNRLiA5/NtGW42a3VDptACrRI9tCAYdwB1BqL5ALss
         9g2zmgnBjpFeKbOrHNa6WQRCjASS4+sZUrEn1pHCNaFl2jN3cigl9Wvi8J+BvdwArW
         gvbSQGJVqX/P5FOoSBCmserxl8P55J6MFVqsi7oSmNdneDGxz94QTwOIWTjDiqS/Zo
         PeqvW05ux7pH+YtfUiaHb1KqViWivPESUWIGC+GH0B0YU9CC85r+a/Nb7OLIBf/+8O
         y7J0X9gTpxRWuVr6L+b+x+Hw2qdRukA09OCQnkLcNOw7lS3IzY3rx7hsN+MavLZb6E
         RYxC+/EezeARw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E64A8E1B4D8;
        Thu,  8 Dec 2022 17:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch iproute2/net-next 0/4] devlink: optimize ifname handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167052181593.971.7294231283020849398.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 17:50:15 +0000
References: <20221205122158.437522-1-jiri@resnulli.us>
In-Reply-To: <20221205122158.437522-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com, kuba@kernel.org, moshe@nvidia.com,
        saeedm@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon,  5 Dec 2022 13:21:54 +0100 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This patchset enhances devlink tool to benefit from two recently
> introduces netlink changes in kernel:
> 
> patch #2:
> Benefits from RT netlink extension by IFLA_DEVLINK_PORT attribute.
> Kernel sends devlink port handle info for every netdev.
> Use this attribute to directly obtain devlink port handle for ifname
> passed by user as a command line option.
> 
> [...]

Here is the summary with links:
  - [iproute2/net-next,1/4] devlink: add ifname_map_add/del() helpers
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=f04f5e1d08d9
  - [iproute2/net-next,2/4] devlink: get devlink port for ifname using RTNL get link command
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=d5ae4c3fdba8
  - [iproute2/net-next,3/4] devlink: push common code to __pr_out_port_handle_start_tb()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=18ff3ccbc853
  - [iproute2/net-next,4/4] devlink: update ifname map when message contains DEVLINK_ATTR_PORT_NETDEV_NAME
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=42b27dfc6e72

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


