Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01FD368A7F8
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 04:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbjBDDaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 22:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBDDaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 22:30:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43813CA0E;
        Fri,  3 Feb 2023 19:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CD2F62054;
        Sat,  4 Feb 2023 03:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 01D90C4339B;
        Sat,  4 Feb 2023 03:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675481418;
        bh=o0yfzoFpD9DIW8/TWpFlHrxS3YLbeDbsVYdfnFZAHo4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=buBMdvylEeoOlfQpWhwcdtL8xyY1jRaHwgQThu0hoLNF6V5YwjdMj7oi4NMl7q96W
         qxO/iVatsqKdqNuT3awPSiJJHgwCMjZv86UWo8aibbfJdOpo9NBl+8plx6JMcP8OtM
         lzysFRAefVGfrkWAERaRHVEJ/FxRaKg/lXQqAaIr0iIEKAw6RR5llXCuidd1YwscU1
         McIlqZWktsDKiUc1xpqOaWqCiyG/1f+AZp9wILT9NGoQgzZPHM4RNvnELSsTwy4v7g
         nShQ0JDJa1lB8Pd+pP+aXWewLZPcNm3ErMcEttXSgDB9MNpnAR3aE5/nx9etR1uRjT
         bS+T1sW/nbGqg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D53A4E270C4;
        Sat,  4 Feb 2023 03:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/3] some minor fixes of error checking about debugfs_rename()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167548141786.31101.12461204128706467220.git-patchwork-notify@kernel.org>
Date:   Sat, 04 Feb 2023 03:30:17 +0000
References: <20230202093256.32458-1-zhengqi.arch@bytedance.com>
In-Reply-To: <20230202093256.32458-1-zhengqi.arch@bytedance.com>
To:     Qi Zheng <zhengqi.arch@bytedance.com>
Cc:     gregkh@linuxfoundation.org, rafael@kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        vireshk@kernel.org, nm@ti.com, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  2 Feb 2023 17:32:53 +0800 you wrote:
> Since commit ff9fb72bc077 ("debugfs: return error values, not NULL") changed
> return value of debugfs_rename() in error cases from %NULL to %ERR_PTR(-ERROR).
> The comments and checks corresponding to debugfs_rename() should also be updated
> and fixed.
> 
> Qi Zheng (3):
>   debugfs: update comment of debugfs_rename()
>   bonding: fix error checking in bond_debug_reregister()
>   PM/OPP: fix error checking in opp_migrate_dentry()
> 
> [...]

Here is the summary with links:
  - [1/3] debugfs: update comment of debugfs_rename()
    (no matching commit)
  - [2/3] bonding: fix error checking in bond_debug_reregister()
    https://git.kernel.org/netdev/net/c/cbe83191d40d
  - [3/3] PM/OPP: fix error checking in opp_migrate_dentry()
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


