Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F40A4AA9AC
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 16:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347374AbiBEPaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 10:30:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41696 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbiBEPaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 10:30:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BDC060F6E
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 15:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86E71C340EC;
        Sat,  5 Feb 2022 15:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644075008;
        bh=Y6E3hXVThqhQ3t3HhRVwbkHn6wD+JKzF605aKKFA+bI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G3eAE1ntN0amQ5m9O8kbweSYnPLtdcX2E+UZQd7w29JrarimX+nLc7UkgI2QKUsJ9
         /9hXRLORsB3wHdyuVXYU7pT/4+vnlpCcuZWHGT1qRBP0H4PyM3bsHzBsG9KOKvTV6P
         JU9qSpuvRPXFOF9sF2anliGTtAXcBZrG4z12w29UPKJLXR1KoJfzwvPJ6D55bPTatL
         78xc4iG/z7Y7UqB72346OV1EaxpeIL/Tbbws6qYKdV/BM/i4iK787xJ/tHcYS1k/Ll
         T0sfXPtzusNmjthMeO/BPc1a7bn11D0YIKCTObWXKr25nUKrwtoDVZ0g0ShQeeOG5m
         B9PTi48FE/uNQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 70757E6D3DD;
        Sat,  5 Feb 2022 15:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mscc: ocelot: fix all IP traffic getting trapped to
 CPU with PTP over IP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164407500845.24838.2078251443580915520.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Feb 2022 15:30:08 +0000
References: <20220204230321.3779706-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220204230321.3779706-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  5 Feb 2022 01:03:21 +0200 you wrote:
> The filters for the PTP trap keys are incorrectly configured, in the
> sense that is2_entry_set() only looks at trap->key.ipv4.dport or
> trap->key.ipv6.dport if trap->key.ipv4.proto or trap->key.ipv6.proto is
> set to IPPROTO_TCP or IPPROTO_UDP.
> 
> But we don't do that, so is2_entry_set() goes through the "else" branch
> of the IP protocol check, and ends up installing a rule for "Any IP
> protocol match" (because msk is also 0). The UDP port is ignored.
> 
> [...]

Here is the summary with links:
  - [net] net: mscc: ocelot: fix all IP traffic getting trapped to CPU with PTP over IP
    https://git.kernel.org/netdev/net/c/59085208e4a2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


