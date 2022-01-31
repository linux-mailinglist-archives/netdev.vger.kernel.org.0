Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428C94A4650
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378152AbiAaLwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:52:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50120 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378116AbiAaLuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 06:50:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F8AB60E9B
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 11:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85FA9C36AE3;
        Mon, 31 Jan 2022 11:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643629809;
        bh=/sf2q8jS6kvecwbtAtmw51Gl3Vp7cjnDdc9k05rtHCw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JmtWl0LuIt+iKx767bHFxDhD+N8Yuqk4dhSmZlYZC+WpeFHLRkpkC67uebIo5gQx9
         /BIPdHevexAYYHvunNoSXKCfp/owhK5kDZwiCbMes+0e7Vnpq0xsjOP4ei9LaIp1Ps
         L4PKtFreuX7DTf19sgOT5ueVhr1UE54fGFc2AUlYhSY51o5Iiioznp7nQnMOQp+aOM
         xen+youOmMDAhyIUK/BWScDfsZ7kH6WF3jwvmRRL5zMtBhDjpA+LsjrY63esFn/Cro
         4zdBl1vy67yr+/OGtmMqhu+xuZLGC42UN1fQUefRYw/uNYG1i6H9FfgofogKY8T6FK
         CTGbYqp2aPoQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E8D1E5D098;
        Mon, 31 Jan 2022 11:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests/net: timestamping: Fix bind_phc check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164362980944.13015.4576395639127430444.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Jan 2022 11:50:09 +0000
References: <20220130095422.7432-1-gerhard@engleder-embedded.com>
In-Reply-To: <20220130095422.7432-1-gerhard@engleder-embedded.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 30 Jan 2022 10:54:22 +0100 you wrote:
> From: Gerhard Engleder <gerhard@engleder-embedded.com>
> 
> timestamping checks socket options during initialisation. For the field
> bind_phc of the socket option SO_TIMESTAMPING it expects the value -1 if
> PHC is not bound. Actually the value of bind_phc is 0 if PHC is not
> bound. This results in the following output:
> 
> [...]

Here is the summary with links:
  - [net-next] selftests/net: timestamping: Fix bind_phc check
    https://git.kernel.org/netdev/net-next/c/678dfd528034

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


