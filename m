Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3BDB68067B
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 08:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235883AbjA3Ha1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 02:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbjA3HaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 02:30:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4D219F0C;
        Sun, 29 Jan 2023 23:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D5C1B80E73;
        Mon, 30 Jan 2023 07:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08060C433A8;
        Mon, 30 Jan 2023 07:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675063817;
        bh=wG98rm1zkePmL4nUVE2va7AHeKBwUEWbwgrieb24Ulw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=btwm5yFUpQNHYuAbqIA9KqDzDjDrc45NNZvN9Z3PulsFLmQcs6cJClvBE0mp/fstb
         MoJ953+eqYwpYnO67o2T/8yWOr/wBbObjMdTrk3Edcgd9g4D7pDCJ6zaH36So7m46X
         sgUh1KN1shvRQ0PJEnGfIxKfPsjLOFs0sHWsYQoQEF5QDpyebV6f40RgvGFz9HPAY9
         RDk7BsEr+iB/A9jQhnJajXV710fvrH8ttBwQm5duPmKt7F9+0k3lh6lOD9gDX+QJ2/
         JWgDFyIMkPDfTam6RALOQ/QJgvmktw8tXL5q8zolYMT4EYaEnqkyL6xNRd6H8u1iVt
         Lf7iANkkoY6KA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DFC1EE21ED7;
        Mon, 30 Jan 2023 07:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bcmgenet: Add a check for oversized packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167506381691.14069.10311016244498367096.git-patchwork-notify@kernel.org>
Date:   Mon, 30 Jan 2023 07:30:16 +0000
References: <20230127000819.3934-1-f.fainelli@gmail.com>
In-Reply-To: <20230127000819.3934-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, maxime@cerno.tech, opendmb@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 26 Jan 2023 16:08:19 -0800 you wrote:
> Occasionnaly we may get oversized packets from the hardware which
> exceed the nomimal 2KiB buffer size we allocate SKBs with. Add an early
> check which drops the packet to avoid invoking skb_over_panic() and move
> on to processing the next packet.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: bcmgenet: Add a check for oversized packets
    https://git.kernel.org/netdev/net-next/c/5c0862c2c962

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


