Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B616CCFF7
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 04:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjC2CaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 22:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjC2CaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 22:30:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DAA2D4F;
        Tue, 28 Mar 2023 19:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE28CB81FAD;
        Wed, 29 Mar 2023 02:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5CA6EC4339C;
        Wed, 29 Mar 2023 02:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680057019;
        bh=+QwrRmOXbnQhTisk8GmcCJmFMKhT3fmPAg7Gw0Ms5l8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dc8/Z1fpLRipEtdfMpu0iRxHEddMycyhUPJhhIaTPJpOLz8Rs1qzeySGI48OkhNOi
         zkAGB3zdNgiWYZnlCB/fL2vaUqT5Jw6AhRueqm5NEXFXT96+vsse10VKF/EHQsiMAE
         Ke4B5xCBnr9LvMzlzBapeUtrvCjrClL1ZXo5gy9DrrDqBRNfecjSIzSzXZBbeaTeai
         IW5aoQWnOnLnvDXly4UHXYfRuCW6v0qQPFWsXEF1GyM95F26y2fJ/h/NuU67SSiVWm
         IzNj62FKxDPbCMImnoC4yDEnrTuV8CvLzDLaUrqHNDqQqLMzxaHuiIFeGYHCpbfegj
         B9K7mpzrRjCBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 365F2E55B21;
        Wed, 29 Mar 2023 02:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] Revert "sh_eth: remove open coded
 netif_running()"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168005701921.27658.2565049250607185005.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Mar 2023 02:30:19 +0000
References: <20230327152112.15635-1-wsa+renesas@sang-engineering.com>
In-Reply-To: <20230327152112.15635-1-wsa+renesas@sang-engineering.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 27 Mar 2023 17:21:12 +0200 you wrote:
> This reverts commit ce1fdb065695f49ef6f126d35c1abbfe645d62d5. It turned
> out this actually introduces a race condition. netif_running() is not a
> suitable check for get_stats.
> 
> Reported-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] Revert "sh_eth: remove open coded netif_running()"
    https://git.kernel.org/netdev/net-next/c/cdeccd13a03f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


