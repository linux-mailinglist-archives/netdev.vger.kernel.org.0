Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D9366D9A6
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236549AbjAQJRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236554AbjAQJQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:16:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA0F30293;
        Tue, 17 Jan 2023 01:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47115B81250;
        Tue, 17 Jan 2023 09:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB718C433F0;
        Tue, 17 Jan 2023 09:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673946615;
        bh=xZpznIQ09R4nUtwSDKcglfRLI5LKxCh4f6CTxDsf3JU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mJbhoZ6Nfl1pnPwjGi4AgiE4ZEb1fK1fAaYVOK5Pbr9ksfC94FIajxLeenbYibcm+
         aQ5YgVFqAQ6rt1MZ/jogndVSrPxqLQruIw/jM56J39c2TziBGBeOj2QNrsvEAVXnHo
         B5M8hbcqZwMaRc+fctkDOIK1KN/nACLfQyfeB+GtNMhw5IpiwmtixTFsJHo5y/3O0N
         sCOX5z4s51OAo1wX/vaVry8WM/VmC0JtjlFC9YucZju6u838LYkD7T4zA/0gAFGc9R
         JesPUXbiSJDqkWwyJHZw5om1b4Cat/WI3ZtyBVO0W/cTTfHT2Vf5qQUE26KfCkRfc0
         3KYI9evh4UUvw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C1AA8C43147;
        Tue, 17 Jan 2023 09:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: remove some unnecessary code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167394661579.18505.5359254062812323564.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Jan 2023 09:10:15 +0000
References: <Y8EJz8oxpMhfiPUb@kili>
In-Reply-To: <Y8EJz8oxpMhfiPUb@kili>
To:     Dan Carpenter <error27@gmail.com>
Cc:     idosch@nvidia.com, jiri@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 13 Jan 2023 10:35:43 +0300 you wrote:
> This code checks if (attrs[DEVLINK_ATTR_TRAP_POLICER_ID]) twice.  Once
> at the start of the function and then a couple lines later.  Delete the
> second check since that one must be true.
> 
> Because the second condition is always true, it means the:
> 
> 	policer_item = group_item->policer_item;
> 
> [...]

Here is the summary with links:
  - [net-next] devlink: remove some unnecessary code
    https://git.kernel.org/netdev/net-next/c/501543b4fff0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


