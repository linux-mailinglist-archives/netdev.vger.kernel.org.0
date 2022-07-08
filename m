Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C171956C3D6
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238205AbiGHXAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 19:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236471AbiGHXA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 19:00:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CB9371B4;
        Fri,  8 Jul 2022 16:00:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A22FB82A11;
        Fri,  8 Jul 2022 23:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 013C3C341CB;
        Fri,  8 Jul 2022 23:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657321226;
        bh=cfgz11hbDz6Yz0qnEPQRJ2nlz33mqPZwQvepHGJGv20=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VdpQ60CYIYawwiQrtwGy0xCwxBMZr7rv4xRgMyXP6jT7pAa21kSM4NizGlZTAdZtk
         xfv/lFZB5RdgxODHFUiR3f4Dw3WEOr+UL+k1jPEXMmi+Vw+g624zJjHmaky+gH56hU
         8YxW4TSiCmYZRbf0WliEW4GojFRt6zW4SL/aH/n0JhtcUJq4Bda0n+vbX3S9qPIp5p
         dc/3rz1UWsc4KLCeji+6QjDxZdihrZuC4pmtAlr0PfhB1XkkbS0gQRRxMmLwVP4k25
         i0zJ7+jzBeG8AHeg4ieZtqabBSA5l6u/Z0eT1iu7bBw2L30LEhdoUwI0MQ3DhSkUkF
         9bb3qQIQx7CJQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D8369E45BDB;
        Fri,  8 Jul 2022 23:00:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2022-07-08
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165732122588.21326.6932743257091611309.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jul 2022 23:00:25 +0000
References: <20220708213418.19626-1-daniel@iogearbox.net>
In-Reply-To: <20220708213418.19626-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  8 Jul 2022 23:34:18 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 3 non-merge commits during the last 2 day(s) which contain
> a total of 7 files changed, 40 insertions(+), 24 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2022-07-08
    https://git.kernel.org/netdev/net/c/7c895ef88403

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


