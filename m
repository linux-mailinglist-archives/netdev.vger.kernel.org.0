Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A3A6C8A35
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 03:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbjCYCUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 22:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbjCYCUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 22:20:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C13768A;
        Fri, 24 Mar 2023 19:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF1EDB826E3;
        Sat, 25 Mar 2023 02:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 75E34C4339B;
        Sat, 25 Mar 2023 02:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679710818;
        bh=7oGymZwtLVwzbqSYONJHlD0YnohvJxQQmc9evf8lDRs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nIsQbLTEX8bk/t3wb1m/0mobflH5+3GW8rGaMi1+3S3lpAk9ucvt8+LQ3E5f3/vLi
         ToOyAzrRIO6/YO3bLZQGcHF/0W5HE9yGe9BmpdhiOVmYJNpbSNDHAddmBSFvxJSQx7
         B+Xb3zivLZFAI6I5nIF1sKC5o0gBzpD4iCqR57EWHSTA2vGn8XtmK63LIj2dJnZbi5
         05Wg357fVEgBG0jr4fG450L8UiCWXfXEU18zgMPBeTplE0qng3CBKV2kgd1AHmB/J1
         5hLosP5w3emuw3oNn8oLM2wmTpupr/ACmZ/v9akA+jy9sx0P+F7sphrIJBIH6T6Jch
         MI23sNPITAHtw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4DB17E4D021;
        Sat, 25 Mar 2023 02:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ptp_qoriq: fix memory leak in probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167971081831.20950.12097733993259593696.git-patchwork-notify@kernel.org>
Date:   Sat, 25 Mar 2023 02:20:18 +0000
References: <20230324031406.1895159-1-u201912584@hust.edu.cn>
In-Reply-To: <20230324031406.1895159-1-u201912584@hust.edu.cn>
To:     SongJingyi <u201912584@hust.edu.cn>
Cc:     yangbo.lu@nxp.com, richardcochran@gmail.com, davem@davemloft.net,
        claudiu.manoil@nxp.com, hust-os-kernel-patches@googlegroups.com,
        error27@gmail.com, dzm91@hust.edu.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 24 Mar 2023 11:14:06 +0800 you wrote:
> Smatch complains that:
> drivers/ptp/ptp_qoriq.c ptp_qoriq_probe()
> warn: 'base' from ioremap() not released.
> 
> Fix this by revising the parameter from 'ptp_qoriq->base' to 'base'.
> This is only a bug if ptp_qoriq_init() returns on the
> first -ENODEV error path.
> For other error paths ptp_qoriq->base and base are the same.
> And this change makes the code more readable.
> 
> [...]

Here is the summary with links:
  - ptp_qoriq: fix memory leak in probe()
    https://git.kernel.org/netdev/net/c/f33642224e38

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


