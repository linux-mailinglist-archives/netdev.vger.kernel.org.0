Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2904AA70E
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 07:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237797AbiBEGKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 01:10:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35206 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351460AbiBEGKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 01:10:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0E796149E
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 06:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 17482C340F1;
        Sat,  5 Feb 2022 06:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644041412;
        bh=hMNHnqW8kQy0cH+OIuWrY53Xq0cBBvg5tHuyD3tXLm8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MiQbun7yRqv+zc/Qritk2Ru69xlilkC8XcKJTWMHf4Uxn/1hkEM1y++gQxy1iVPPE
         MXU+oiodf5TbI6ATMfULVWy9WP9ABZR/GQlSfJhwuiSxXPVD26invT3Rns9fJyyvZ3
         t2RPMMV8nUHgglkFYgjyxWL7RVZpw/WVR4uv8uCpINod4yxpvw+/CYLb+lgimKkr8U
         Dr6HQqKQ3LheJj/0za6iNRJWXa90Lj9cRm2zRCK0xlqrpxrUDXdaskQ/v54oNDoOGm
         4l8NeGPo5WuPv/qUdaOLAGjQzt0uzjR5Nswu63FQW3BjCIt+ih81u6arzxK1CdTf9t
         lfjFEpBGfedHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E85DCE6BBD2;
        Sat,  5 Feb 2022 06:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] Support for the IOAM insertion frequency
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164404141194.19196.11294891057831741120.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Feb 2022 06:10:11 +0000
References: <20220202142554.9691-1-justin.iurman@uliege.be>
In-Reply-To: <20220202142554.9691-1-justin.iurman@uliege.be>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  2 Feb 2022 15:25:52 +0100 you wrote:
> v2:
>  - signed -> unsigned (for "k" and "n")
>  - keep binary compatibility by moving "k" and "n" at the end of uapi
> 
> The insertion frequency is represented as "k/n", meaning IOAM will be
> added to {k} packets over {n} packets, with 0 < k <= n and 1 <= {k,n} <=
> 1000000. Therefore, it provides the following percentages of insertion
> frequency: [0.0001% (min) ... 100% (max)].
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] uapi: ioam: Insertion frequency
    https://git.kernel.org/netdev/net-next/c/be847673cfff
  - [net-next,v2,2/2] ipv6: ioam: Insertion frequency in lwtunnel output
    https://git.kernel.org/netdev/net-next/c/08731d30e78e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


