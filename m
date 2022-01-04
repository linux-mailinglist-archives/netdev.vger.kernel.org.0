Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AF8483B33
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 05:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbiADEAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 23:00:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44042 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbiADEAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 23:00:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78C2661267
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 04:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7BE7C36AEF;
        Tue,  4 Jan 2022 04:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641268811;
        bh=6LKcbLDBAWDxgGS1n/i55l5BNGoGk778boBlco/391w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T5wwpWpDJgyc/axSvP4MoN3kP8v3lwPNwy2R3h5x+5z3EFX5SY9DsF2+6NIuMd6It
         lPKXf00j0Nhcd6kfidpxWTwvXMwENTwxIjQdVxD+hHTuqC7jfty5bt3s8nysUaLloO
         RJXJqnAnUdzKsxV6RKmj8oOdRe8jjfIMD2Qt8G0XKV23KolwI5KT/KrEkSgaQCW38s
         Yq6MbbWm5soEwP8n68ctk5jViYEy9nOt8hlYaKKjZYJsoXRasu8CyagMUHMt/9SlH0
         nE1XD2eQqgQ7ey/LEjdvpj+c+nvHeKOMsyPiu3Zte6LIDj22S50dzM46btQO231B16
         fspAKzTg4o++A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BA90FF79400;
        Tue,  4 Jan 2022 04:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] batman-adv: mcast: don't send link-local multicast to
 mcast routers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164126881175.32247.1012598310655037825.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Jan 2022 04:00:11 +0000
References: <20220103171203.1124980-2-sw@simonwunderlich.de>
In-Reply-To: <20220103171203.1124980-2-sw@simonwunderlich.de>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, linus.luessing@c0d3.blue,
        sven@narfation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Simon Wunderlich <sw@simonwunderlich.de>:

On Mon,  3 Jan 2022 18:12:03 +0100 you wrote:
> From: Linus Lüssing <linus.luessing@c0d3.blue>
> 
> The addition of routable multicast TX handling introduced a
> bug/regression for packets with a link-local multicast destination:
> These packets would be sent to all batman-adv nodes with a multicast
> router and to all batman-adv nodes with an old version without multicast
> router detection.
> 
> [...]

Here is the summary with links:
  - [1/1] batman-adv: mcast: don't send link-local multicast to mcast routers
    https://git.kernel.org/netdev/net/c/938f2e0b57ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


