Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAF6626743
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 07:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbiKLGA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 01:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234548AbiKLGAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 01:00:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57433165A6
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 22:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3146B828B1
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 06:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44676C4347C;
        Sat, 12 Nov 2022 06:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668232818;
        bh=GEKv9FokRcaiEDaEwMPRK38n9n8GnCFECbCRomwVT8s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j/Rl8ccG+tqAwXBswhdjyai6PncKdGnIWY0fb7KbKZhUWKbKWTyg3Nf9NGnHbAv46
         sNilgF6oWwyWO5Lx7KzsU55bEAEImKZTA3jx8ig26k+Lo4iPjtDcfvJe1BFrWMfKce
         0jWFgYe98hztOM8wEym5Ae0oWGdEode+XPY9ykTLNlVB1dJSyxBAlLlV8hJBdjj2dF
         AQtdxfN3OaCwPi1sQrOQlKep3f+9ooAOrd60iZyOAuJ7GeN7GNFd/6rDDJFw3vUtN0
         kT2s+ExNPdPmjDPM2dsWYrAuuJ9RWFLxXWZt1WIJuVtB56AF/VuV30g3YOTsIg+Bhp
         C1MHd1YQLCnJw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 21F00E4D022;
        Sat, 12 Nov 2022 06:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] bridge: Add missing parentheses
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166823281813.10181.5447638832386414958.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Nov 2022 06:00:18 +0000
References: <20221110085422.521059-1-idosch@nvidia.com>
In-Reply-To: <20221110085422.521059-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 10 Nov 2022 10:54:22 +0200 you wrote:
> No changes in generated code.
> 
> Reported-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_input.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] bridge: Add missing parentheses
    https://git.kernel.org/netdev/net-next/c/3e35f26d3397

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


