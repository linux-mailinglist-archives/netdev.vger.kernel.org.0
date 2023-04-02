Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877FE6D37E3
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjDBMkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjDBMkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC2D93D1
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F333611DE
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 12:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B828C433EF;
        Sun,  2 Apr 2023 12:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680439217;
        bh=OczZutMfnv1AcNrO9PmcMvjgdnhAvuBwWoqxIe1jGTc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ze9H1cjM0sa3BKnL0r8wgE2kzuvNRMZ0et5ecVWTQoJk1kYWYWrJLpYZN2mGTY35e
         qmzavjvCJzozv7Ee6i4a1+rrF9s8G04vkV6TpTIP7RbkydBOTFqlD2c9izGHc9Kq0S
         Hshmz01jtW2JrKpUpcUEQtDj3TfgAPbPDa3D/E5crK8ip1FFd23NdaJV6JSXo/nFFz
         zipSi4dR85oBK0UHFMo0ecwCVouXhf7LxB5c5vSsXe4iO4us/p5ILeJWvOs0Lb60Co
         VdCURjvXroS7INKcVEZHFxE9TfL1Wd1VwK7kUFrxKfvmou8v0R/i5Wu0t7uTyBzW1D
         +b9VP4sBVFROA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 56A95C73FE2;
        Sun,  2 Apr 2023 12:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix remaining throughput
 regression
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168043921735.11869.4838397079593791979.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Apr 2023 12:40:17 +0000
References: <20230331124959.40468-1-nbd@nbd.name>
In-Reply-To: <20230331124959.40468-1-nbd@nbd.name>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, frank-w@public-files.de
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 31 Mar 2023 14:49:59 +0200 you wrote:
> Based on further tests, it seems that the QDMA shaper is not able to
> perform shaping close to the MAC link rate without throughput loss.
> This cannot be compensated by increasing the shaping rate, so it seems
> to be an internal limit.
> 
> Fix the remaining throughput regression by detecting that condition and
> limiting shaping to ports with lower link speed.
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: mtk_eth_soc: fix remaining throughput regression
    https://git.kernel.org/netdev/net/c/e669ce46740a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


