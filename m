Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69539515D2A
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 15:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380990AbiD3NDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 09:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358940AbiD3NDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 09:03:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFDDDFFD
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 06:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB49660C15
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 13:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02806C385B3;
        Sat, 30 Apr 2022 13:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651323612;
        bh=QmKRrzCFzMfjbrGf1djsnAltggg48AKsTxAb2i4NqGM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MxHfr3B4XPxpuIlviUlH2lZ8CQD6pvfOcjRL3CmbPldKhHEBAvieBiWmtfzkzlc/r
         nXhYulR50J4tmiicGlIVpzYSockxHr5V+QU/vFTVSmCp6B39XRZ2zSGf7StZuzB5H+
         d1dWKzvIJWuN/Zgj4+Slr+O4e/a+GyysynAyAGZ0GiFm+3Gx6JQqfjE8IuRjJq0EvG
         itmEh//h6Rr0fHdaQJmOnFz/PFs+qnveF+Qc+Tub5Mdg8ziKOZ3lJcd1v5e49QGhfS
         aoxRE4z5REVl0cQPkWHgcYbuuIIxBZisefRZuz5DuCA76IevgtQ+Sy0OatnM4FgjWm
         397tp082cu4RQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CB196F03848;
        Sat, 30 Apr 2022 13:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next][v2] qede: Reduce verbosity of ptp tx timestamp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165132361182.2405.7173184252075735029.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 13:00:11 +0000
References: <20220430010513.20655-1-pkushwaha@marvell.com>
In-Reply-To: <20220430010513.20655-1-pkushwaha@marvell.com>
To:     Prabhakar Kushwaha <pkushwaha@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        palok@marvell.com, aelior@marvell.com, prabhakar.pkin@gmail.com,
        manishc@marvell.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 30 Apr 2022 04:05:13 +0300 you wrote:
> Reduce verbosity of ptp tx timestamp error to reduce excessive log
> messages.
> 
> Signed-off-by: Manish Chopra <manishc@marvell.com>
> Signed-off-by: Alok Prasad <palok@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] qede: Reduce verbosity of ptp tx timestamp
    https://git.kernel.org/netdev/net-next/c/059d9f413efe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


