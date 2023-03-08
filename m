Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E696B1608
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 00:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjCHXBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 18:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjCHXAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 18:00:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2347FB78A6;
        Wed,  8 Mar 2023 15:00:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8A55B81DDC;
        Wed,  8 Mar 2023 23:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6187EC4339E;
        Wed,  8 Mar 2023 23:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678316423;
        bh=1UzxDS4PPdxCROB4gW4rEA9CaqNj9tFtJR1/TgUc0dM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ig3jOg9yOywYUaPzcm2XUiO9h439re4E3U5gKKfe4n7ecEl+FydNuxjA+7Ktza2UF
         70b4R5pddAgbHxy4qmSd7DEzWCHBSDMtOEbzsoXa1g4klelF4i9SooknwbIc/bbrG2
         2RGrWzwCNWa4/EuzDS2l1q/0Bq7KWYlB3PEcsuHFPOnDB/mNQ/Xsjk1xVT/BaOqPmO
         GAtRDQAo0n8hCQ8MPYSIkpavdMtMMKw44RIRmZneVclRF48FiLJbEG5KBD+oIHrZuh
         zd1iMNaM23DcX1A9tKwSQDhq0GtgrY3SnbtENHLev6YdKKOAu88yl/HVe3aT2zljJN
         RzlDVWk1rpFSQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47B52E61B64;
        Wed,  8 Mar 2023 23:00:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2023-03-08
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167831642329.18063.12143926239944854028.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Mar 2023 23:00:23 +0000
References: <20230308193533.1671597-1-andrii@kernel.org>
In-Reply-To: <20230308193533.1671597-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, daniel@iogearbox.net, ast@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 8 Mar 2023 11:35:33 -0800 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 23 non-merge commits during the last 2 day(s) which contain
> a total of 28 files changed, 414 insertions(+), 104 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2023-03-08
    https://git.kernel.org/netdev/net-next/c/ed69e0667db5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


