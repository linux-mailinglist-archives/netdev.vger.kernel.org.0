Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701744A45C5
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359729AbiAaLqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:46:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52212 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377978AbiAaLkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 06:40:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75E01B82A90
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 11:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06F60C340EE;
        Mon, 31 Jan 2022 11:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643629211;
        bh=byE8nTKDH1fhZSddNVLjpDfE9HShezslU7YAiDX0eOk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TYcaScYjNzkBftnRkN0rnxnoTGA/XQBquw9yVfI5C0YBHeoSwSNkK5Yge/AbLPOXy
         TLdjftlBqe6RuMY3BSO4Nwl1A9XLnxb2KEH4LIvL78IWSnTSkTE3sb8uo22DORaGI7
         VHt2f+8l7k2GcsPQxaOhj9cyps2S2yBJM0ZwXITv2X4vFVsIPRcTs1VRIuYUsU4jh1
         ezBiz8YMvHneJkC2Kpy87y9RSlEwiYUGABYrcmuTQJQc2NyC7mKCcGp/3fSYfzQi4j
         PCMaT9A5WsbcSJDVLiwzPnQv5TC1po0VOFaV6vyjjqyjkvzO+m/8N9ZHRZMkIukkIe
         PruB4AtsBV6GA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DF6AEE5D08C;
        Mon, 31 Jan 2022 11:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] r8169: add rtl_disable_exit_l1()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164362921091.6327.10501956176630696702.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Jan 2022 11:40:10 +0000
References: <c92aeff4-e887-06e9-ecef-f458a9903ee8@gmail.com>
In-Reply-To: <c92aeff4-e887-06e9-ecef-f458a9903ee8@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org, hau@realtek.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Jan 2022 21:41:42 +0100 you wrote:
> Add rtl_disable_exit_l1() for ensuring that the chip doesn't
> inadvertently exit ASPM L1 when being in a low-power mode.
> The new function is called from rtl_prepare_power_down() which
> has to be moved in the code to avoid a forward declaration.
> 
> According to Realtek OCP register 0xc0ac shadows ERI register 0xd4
> on RTL8168 versions from RTL8168g. This allows to simplify the
> code a little.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] r8169: add rtl_disable_exit_l1()
    https://git.kernel.org/netdev/net-next/c/d192181c2ccb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


