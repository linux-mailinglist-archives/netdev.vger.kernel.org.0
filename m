Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9021061F81C
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 17:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbiKGQAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 11:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbiKGQAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 11:00:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9C512A88
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 08:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 298146100C
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 16:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B0B6C433D6;
        Mon,  7 Nov 2022 16:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667836815;
        bh=3+hZ0VzuEouDRXRWFNePW5vGwUECiCDinzmmzNdjRN0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nfwOqvhzMOYfTeiQFncCvLIyRNnRyi/q/s8x+gPqj5VI1hFFrUXWYgdSpqv3ZAFjU
         HVAQ6B/JUqYWbzsKa83H3t/oWa9JfVeEH6ywM1EHrHtTyU3OgguGepDOneDUvgQQow
         Ck+4jmRjp0IbmgULkFoqRJ5WTSEpmSsrkaqpHlQS2T4y2UwWf3sTckktnWwBTSpHk9
         UIMFbOL7YyZprJWwilx5clJ2KMm7ORWHRmmp/gLzZZ05VK3tWIWPHJ0gvAblQrDHjH
         T55/IENbVS4B6F2MNni1WbokqMRr7XvtTb8EBxDznWVnfAN7MzTueSdhx+UYG+ITEb
         XNQuwNjk6dAuQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6F0F7E270D0;
        Mon,  7 Nov 2022 16:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 0/4] bridge: Add MAC Authentication Bypass (MAB)
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166783681545.12669.9505644614573438514.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Nov 2022 16:00:15 +0000
References: <20221106113957.2725173-1-idosch@nvidia.com>
In-Reply-To: <20221106113957.2725173-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com
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

On Sun,  6 Nov 2022 13:39:53 +0200 you wrote:
> Add MAB support in iproute2, allowing it to enable / disable MAB on a
> bridge port and display the "locked" FDB flag.
> 
> Patch #1 syncs the kernel headers.
> 
> Patch #2 extends iproute2 to display the "locked" FDB flag when it is
> set.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/4] Sync kernel headers
    (no matching commit)
  - [iproute2-next,2/4] bridge: fdb: Add support for locked FDB entries
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=fa24597472f3
  - [iproute2-next,3/4] bridge: link: Add MAC Authentication Bypass (MAB) support
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=05f1164fe811
  - [iproute2-next,4/4] man: bridge: Reword description of "locked" bridge port option
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=34c4cb13a059

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


