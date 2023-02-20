Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4DC69C8F9
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 11:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbjBTKuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 05:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjBTKuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 05:50:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4200D13522;
        Mon, 20 Feb 2023 02:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D23D060DCE;
        Mon, 20 Feb 2023 10:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38A2AC433A8;
        Mon, 20 Feb 2023 10:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676890217;
        bh=gwFo9Hg00bQqTzT8sZEh658DqP/8C0QbZFvJL7Pah/w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VqNPD0gaZTjzwe0yGkzqJG87iCH1jBoju9yHRVSkEu6ZkAlvZLnPir/64OS14A52O
         AspuM+lShY0UnL+/IZJBrdSH4qtf/QiOkCaFetphoFWvOpALMVvBoAvIvpNg7cRoL4
         jpF6VhIZ4W8XE6370h7afkQPj1OEs4lfbemKbRy5k3fPHv2osZYmw7uK9lkr5LGlNP
         pvR1RBErwSHM63sd/qNp1GUDTdmHke338kAakkKcJ+NbBlSx3txeBSfDart6Qc1aN7
         9TV05ZmpJHCcGkxKzSglh7uFlPLQXnzLk1uF3MalzXN50F0lQg+Ijatp+Mt7avcYLg
         lcPAQwwyqBVjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 08FF5C691DE;
        Mon, 20 Feb 2023 10:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] octeontx2-af: Add NIX Errata workaround on CN10K
 silicon
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167689021703.13054.16188471204013171476.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 10:50:17 +0000
References: <20230217055112.1248842-1-saikrishnag@marvell.com>
In-Reply-To: <20230217055112.1248842-1-saikrishnag@marvell.com>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        gakula@marvell.com
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

On Fri, 17 Feb 2023 11:21:12 +0530 you wrote:
> From: Geetha sowjanya <gakula@marvell.com>
> 
> This patch adds workaround for below 2 HW erratas
> 
> 1. Due to improper clock gating, NIXRX may free the same
> NPA buffer multiple times.. to avoid this, always enable
> NIX RX conditional clock.
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-af: Add NIX Errata workaround on CN10K silicon
    https://git.kernel.org/netdev/net-next/c/933a01ad5997

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


