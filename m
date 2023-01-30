Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5EC68069D
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 08:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbjA3HkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 02:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235361AbjA3HkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 02:40:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C97A28D3F
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 23:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26EE460EDC
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 07:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 803B9C433D2;
        Mon, 30 Jan 2023 07:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675064418;
        bh=nSEjeldxldT/Tw4Jdo7TKldjMfhn6B7LCjpXjTkze+0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fduDIw3yW9QehxqhCgDcjkokAopUrbyDr7tkY8lYUUndPiPfS5Fkj0SIBI3FfuiJA
         GS1uTDVlT6/coCa6l2DpF77IlKb/XQ2yOynicBBC1Eld4xRezPzOw5aApNUIkRU5tF
         VNn4JYcY+YhHMMS5lrQE3RU2BDpdO8++7bhTfFqo7KwTgFGaIYuw/uH9QZ9V+azQCr
         keQiD5PP1S3BjUtmFIVjqIPom72nZyPBOQjQYmxpYItzpxRMppIASLABgC50LAFefH
         ZsyTqnr9nJcCHjhkm+Z6nKyIuS+WqIdzj03qdoVHoiypno+GfDHIFzNvXw83oDW5B/
         6XiNTAbaBrguw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 69AD5E4522A;
        Mon, 30 Jan 2023 07:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/5] batman-adv: Start new development cycle
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167506441843.19672.4070886774468126901.git-patchwork-notify@kernel.org>
Date:   Mon, 30 Jan 2023 07:40:18 +0000
References: <20230127102133.700173-2-sw@simonwunderlich.de>
In-Reply-To: <20230127102133.700173-2-sw@simonwunderlich.de>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Simon Wunderlich <sw@simonwunderlich.de>:

On Fri, 27 Jan 2023 11:21:29 +0100 you wrote:
> This version will contain all the (major or even only minor) changes for
> Linux 6.3.
> 
> The version number isn't a semantic version number with major and minor
> information. It is just encoding the year of the expected publishing as
> Linux -rc1 and the number of published versions this year (starting at 0).
> 
> [...]

Here is the summary with links:
  - [1/5] batman-adv: Start new development cycle
    https://git.kernel.org/netdev/net-next/c/55307f51f48e
  - [2/5] batman-adv: Drop prandom.h includes
    https://git.kernel.org/netdev/net-next/c/c4b40f80585c
  - [3/5] batman-adv: Fix mailing list address
    https://git.kernel.org/netdev/net-next/c/8f6bc4583713
  - [4/5] batman-adv: mcast: remove now redundant single ucast forwarding
    https://git.kernel.org/netdev/net-next/c/e7d6127b89a9
  - [5/5] batman-adv: tvlv: prepare for tvlv enabled multicast packet type
    https://git.kernel.org/netdev/net-next/c/0c4061c0d0e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


