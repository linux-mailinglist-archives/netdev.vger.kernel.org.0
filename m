Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 419235ABE3B
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 11:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiICJkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 05:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiICJkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 05:40:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9448D5AA33;
        Sat,  3 Sep 2022 02:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0ED2AB81186;
        Sat,  3 Sep 2022 09:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6D19C433B5;
        Sat,  3 Sep 2022 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662198015;
        bh=IYEXZN1OgM9Il3jW57SEzDvi57oPin8juPDN3I1wetQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fc5/g7b3SXC2L4Y/1Gu7wlRDUzh93g+rLOD+J3/xQhJD5UrvVjT/zSIJAwk5+QnUe
         whhXgXofqecXhWAahanZ40Tq+i6d2QbsZTIhLfJzojWf+PU29Xoc9qD+j6wfhaTy4a
         ZiJe8SnL8TOqFYCESZaCIWAM4uYimc2LITNzENaLsNT55mWYfbPcqmd786QAHlEX+M
         Etl9RJTfNsmXz78pzMSW3+27OTGcyfT0xot06ZTKZe5silz92/sou8D7HzGooTLygf
         nuspgk4grb62yBNPJzr2h0QDwUfawggp7k4fZMfe8LmUVgFByJFbnHZYr0UENWbRxy
         PLY/CX0DSCD8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A692AE924D9;
        Sat,  3 Sep 2022 09:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next] net: fec: add stop mode support for imx8 platform
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166219801567.23737.14676977489194014593.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Sep 2022 09:40:15 +0000
References: <20220902023001.2258165-1-wei.fang@nxp.com>
In-Reply-To: <20220902023001.2258165-1-wei.fang@nxp.com>
To:     Wei Fang <wei.fang@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri,  2 Sep 2022 10:30:01 +0800 you wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> The current driver support stop mode by calling machine api.
> The patch add dts support to set GPR register for stop request.
> 
> imx8mq enter stop/exit stop mode by setting GPR bit, which can
> be accessed by A core.
> imx8qm enter stop/exit stop mode by calling IMX_SC ipc APIs that
> communicate with M core ipc service, and the M core set the related
> GPR bit at last.
> 
> [...]

Here is the summary with links:
  - [V2,net-next] net: fec: add stop mode support for imx8 platform
    https://git.kernel.org/netdev/net-next/c/40c79ce13b03

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


