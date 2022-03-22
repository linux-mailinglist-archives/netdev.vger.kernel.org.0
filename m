Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9C74E3516
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 01:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbiCVAC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 20:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233451AbiCVACw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 20:02:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90561208A;
        Mon, 21 Mar 2022 17:00:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79EAC61585;
        Tue, 22 Mar 2022 00:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE100C36AE2;
        Tue, 22 Mar 2022 00:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647907210;
        bh=KrtzWFX8G5X8RCKL2ptm/LBZ0E8LGfJCrspQfTG+yag=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TN8q2QGeQyMuq6NWGzGQOc/NGdzSy82ATWXPoO5/r5I8Gushv7oYrCo6brj9ztyVV
         KDhhO1WvVbAglzErEr5lunuLdI2svJ9Ocu+R3GzymOmQ+UOqNJvqOj5Euq9fOvCxYl
         3trIjkFAyXy8JoDr/QiC+/qlthQ96Ryd0kWL6f0InoM+et0KHQ6pUlYj8rnATguyo8
         N8qThXbZS4YvXJ4Yft1xmPxzMb1T3B1ok3EO59auDxQ/GDMjR+K2aRJlzZEi4loOCj
         GqEZzOQfgqzvwFdFSkxf0/KP+jryTQrfFiZPBQJ0EbCl+3QR8PHLuqfbMR741dJ1Yv
         EKl/SfAiq5s/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ADEF6E7BB0B;
        Tue, 22 Mar 2022 00:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH linux-next v3] selftests: net: change fprintf format
 specifiers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164790721070.15202.9703241191384577497.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Mar 2022 00:00:10 +0000
References: <20220319073730.5235-1-guozhengkui@vivo.com>
In-Reply-To: <20220319073730.5235-1-guozhengkui@vivo.com>
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhengkui_guo@outlook.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 19 Mar 2022 15:37:30 +0800 you wrote:
> `cur64`, `start64` and `ts_delta` are int64_t. Change format
> specifiers in fprintf from `"%lu"` to `"%" PRId64` to adapt
> to 32-bit and 64-bit systems.
> 
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> ---
>  tools/testing/selftests/net/txtimestamp.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [linux-next,v3] selftests: net: change fprintf format specifiers
    https://git.kernel.org/netdev/net-next/c/94f19e1ec38f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


