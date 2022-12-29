Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24875658F3C
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 17:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbiL2Qu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 11:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiL2QuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 11:50:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66630F4B
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 08:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0717DB819FE
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 16:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 91C08C433F1;
        Thu, 29 Dec 2022 16:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672332615;
        bh=/XhPsBiHlOdXuRsA2/JETl7Kygk+kcmhJHjBtBN3pKQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O40l5Z00ATeTTAwa2QVzDj/peiivuzM1CU+GeEv7n3MuXHzZJL89UPN32uyRNihBB
         YHbmZdh9Yx095/965E1HdwWBFv1iZvHAf6FJFLUDYZH0r5RrosiPn/dZLAy0j3Vit3
         2p1NmboNG688i+qjz8Ek81EgX0oq6HcsgI1R44vDmSyujkT2yZgexflNM4Uwvbc/x5
         Txz49uHp9XXNoII+FjJvz4T4mneMcYFAmAHtQ84bciR3pCMRWPh+4YWQneyKwbe7hy
         3DCzJbzWq1QRzPHjlQ8+JKOUZecFYNkCrvhcA02HTBpal11izFLciQq/Zsn/qSQNHl
         sZSl0IOrsrsLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79D18C43159;
        Thu, 29 Dec 2022 16:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2 v2] configure: Remove include <sys/stat.h>
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167233261549.30800.12464946939084546492.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Dec 2022 16:50:15 +0000
References: <20221223170345.3785809-1-hauke@hauke-m.de>
In-Reply-To: <20221223170345.3785809-1-hauke@hauke-m.de>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     netdev@vger.kernel.org, heiko.thiery@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Fri, 23 Dec 2022 18:03:45 +0100 you wrote:
> The check_name_to_handle_at() function in the configure script is
> including sys/stat.h. This include fails with glibc 2.36 like this:
> ````
> In file included from /linux-5.15.84/include/uapi/linux/stat.h:5,
>                  from /toolchain-x86_64_gcc-12.2.0_glibc/include/bits/statx.h:31,
>                  from /toolchain-x86_64_gcc-12.2.0_glibc/include/sys/stat.h:465,
>                  from config.YExfMc/name_to_handle_at_test.c:3:
> /linux-5.15.84/include/uapi/linux/types.h:10:2: warning: #warning "Attempt to use kernel headers from user space, see https://kernelnewbies.org/KernelHeaders" [-Wcpp]
>    10 | #warning "Attempt to use kernel headers from user space, see https://kernelnewbies.org/KernelHeaders"
>       |  ^~~~~~~
> In file included from /linux-5.15.84/include/uapi/linux/posix_types.h:5,
>                  from /linux-5.15.84/include/uapi/linux/types.h:14:
> /linux-5.15.84/include/uapi/linux/stddef.h:5:10: fatal error: linux/compiler_types.h: No such file or directory
>     5 | #include <linux/compiler_types.h>
>       |          ^~~~~~~~~~~~~~~~~~~~~~~~
> compilation terminated.
> ````
> 
> [...]

Here is the summary with links:
  - [iproute2,v2] configure: Remove include <sys/stat.h>
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=22c877d93eed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


