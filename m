Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA47E6BF822
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 06:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjCRFuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 01:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjCRFuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 01:50:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FE5AD021;
        Fri, 17 Mar 2023 22:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A88CB81E8A;
        Sat, 18 Mar 2023 05:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2269FC4339C;
        Sat, 18 Mar 2023 05:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679118619;
        bh=DWNryxgL9EWSaLOCwHlmbuKpdAAwje4ksen4MhfUktc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D9HEHIfdD7CiMo+mDUBtLxlTba8XoKDhp/1O/AifPszFEj6rF2FbyRgYfqCG5BQne
         kDQkJdSfJWbgwZ7E0bwP0op8CS9JBcbXgOdrv1bXeiBGmWgtYji2xGSKMT9T5+BFHQ
         fYXi9nrVjzvI+Ol+oljzgRv+A11d4IKMmtCuOjmLxCeF6hf7Em/Yl1H9avPurcXaOL
         6AEmwYl/xet94i0VgacwPXeMHnR7RgsDJdoijiXzkB6YTJ8VTORD5pF+J5ErEnKj+Q
         Ft0sddqu0SKmA79LVzhlX2zEeC8OH4KitZhmGvidshRyZnPIa1FkctMw5czcHNDRP8
         gNerlE4C6NqWw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0BBDDE2A03A;
        Sat, 18 Mar 2023 05:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: ti: am65-cpts: reset pps genf adj
 settings on enable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167911861904.13068.18427380496415263771.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Mar 2023 05:50:19 +0000
References: <20230316095232.2002680-1-s-vadapalli@ti.com>
In-Reply-To: <20230316095232.2002680-1-s-vadapalli@ti.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rogerq@kernel.org, jacob.e.keller@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srk@ti.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Mar 2023 15:22:32 +0530 you wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> The CPTS PPS GENf adjustment settings are invalid after it has been
> disabled for a while, so reset them.
> 
> Fixes: eb9233ce6751 ("net: ethernet: ti: am65-cpts: adjust pps following ptp changes")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: ti: am65-cpts: reset pps genf adj settings on enable
    https://git.kernel.org/netdev/net/c/3dacc5bb8147

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


