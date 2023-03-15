Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 285046BAA9F
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbjCOIUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjCOIUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:20:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B8B29E14;
        Wed, 15 Mar 2023 01:20:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4AE461C0A;
        Wed, 15 Mar 2023 08:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0BF20C433A4;
        Wed, 15 Mar 2023 08:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678868421;
        bh=QvXlvQ8wOAS+kZD2A5LfgiKypG9UgBD2KXGRG9H7Ltg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ILUoLQ0AKWk/ucMOHrKqPIprbiOP4JCppp6i4t8xWqWTkODV6EY8GDOqJLv/Q06O6
         3mwEozt9G1z/jwGs4/ri5JU8OD1vD9pDGayJZT42S/Gy0gy/1rYU1WiLN/t6y6RrBI
         QbZyT+QHW2iorSSaROe+YJr3VPUu5oLhaCBAq2TLXmoviJWzAUyPHq6XxOgMn6V8cI
         +CUdwiA7ZtVFob0ag6l5gq7zIzVO/eqQ8VT67uPLS7JVhhOUUak4owGUJ2vNlY+7Dh
         DxKbHIVslRwomDA34JybxlCjdyT305Gom/YwHMdtpYev4VwRciVKv04576G17hsuPN
         /NhZRRTwLvjOA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E2A17E66CBC;
        Wed, 15 Mar 2023 08:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: geneve: set IFF_POINTOPOINT with
 IFLA_GENEVE_INNER_PROTO_INHERIT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167886842092.29094.2330914608273020554.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Mar 2023 08:20:20 +0000
References: <20230312164557.55354-1-josef@miegl.cz>
In-Reply-To: <20230312164557.55354-1-josef@miegl.cz>
To:     Josef Miegl <josef@miegl.cz>
Cc:     eyal.birger@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Sun, 12 Mar 2023 17:45:57 +0100 you wrote:
> The GENEVE tunnel used with IFLA_GENEVE_INNER_PROTO_INHERIT is
> point-to-point, so set IFF_POINTOPOINT to reflect that.
> 
> Signed-off-by: Josef Miegl <josef@miegl.cz>
> ---
>  drivers/net/geneve.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: geneve: set IFF_POINTOPOINT with IFLA_GENEVE_INNER_PROTO_INHERIT
    https://git.kernel.org/netdev/net-next/c/45ef71d108e6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


