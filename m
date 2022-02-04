Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 228BF4A92B4
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 04:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354021AbiBDDUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 22:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356786AbiBDDUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 22:20:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6A0C061714;
        Thu,  3 Feb 2022 19:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9114B83656;
        Fri,  4 Feb 2022 03:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A3901C340F7;
        Fri,  4 Feb 2022 03:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643944810;
        bh=pE6YpV7FpsnzgBxvUPWZDQMobC/RZ2p2EU/TpNvk24I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JLfSFp/+7BIjgNtNkkVdu27VsCBG0Ah9VkIEQXacvaICKM8LGRV9e14dPgc/mSoxm
         CglhicFesbW6iTYZZtPNqO8L5NvRMjSrMMgCS4eLJ1l57KPV0d8xDGws1MHnognm9F
         EZBNo9NYzAlqOOCwJ7SHT/vMVL9nnITc1peuHE+wZviGCYE5wvnVnKaGphZa8ROuDY
         dlJAsdwWSlA0LTVZbrrhAQ7rifdEpowgXgb1zfoDqcl3R6Rcjmgu+x538hQjAk3RO8
         lMbMiXn+uzUqtHbhj7PNd9AQACg+boAqsL8nx5ydB0GFJcqy2BQo07jkXQlQnI9TnH
         tMonkaGg0Hauw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 878A6E5D08C;
        Fri,  4 Feb 2022 03:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: fib offload: use sensible tos values
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164394481054.31803.1317546149481406185.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Feb 2022 03:20:10 +0000
References: <5e43b343720360a1c0e4f5947d9e917b26f30fbf.1643826556.git.gnault@redhat.com>
In-Reply-To: <5e43b343720360a1c0e4f5947d9e917b26f30fbf.1643826556.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        idosch@mellanox.com, jiri@mellanox.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 2 Feb 2022 19:30:28 +0100 you wrote:
> Although both iproute2 and the kernel accept 1 and 2 as tos values for
> new routes, those are invalid. These values only set ECN bits, which
> are ignored during IPv4 fib lookups. Therefore, no packet can actually
> match such routes. This selftest therefore only succeeds because it
> doesn't verify that the new routes do actually work in practice (it
> just checks if the routes are offloaded or not).
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: fib offload: use sensible tos values
    https://git.kernel.org/netdev/net-next/c/bafe517af299

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


