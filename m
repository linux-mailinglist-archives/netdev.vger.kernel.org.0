Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA4A515CE5
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 14:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348152AbiD3Mdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 08:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238776AbiD3Mdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 08:33:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B581160D5
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 05:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 507F860B1D
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 12:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6051C385AE;
        Sat, 30 Apr 2022 12:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651321811;
        bh=Dsz98gUk7X0GSmSSrCHTKUHChzUg5nB8TCAOrSCX+Gk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sV19KQC9ab+gKeOrYkbPTU/Pll09TQx/T9xJvnj6/u5TBawCZPPElzSrvg2MhEg92
         52FQcH8l5aGXG8T+f2cGW8jp2mz0vV4bnBlYZuY2daXj9B/rWDwZUe4L3+x6kmwdHB
         rEsUC1PqW+BmRd2n3mrrJQF09ARCvgVxeK6XzJB+K2XxH78j38H1S1V6+V6U2MIa3N
         OIuog+GOLwyyAU8M9RKfTAItzM62SYMviXJ9sFjjb4r5W+0alt0yvfwyykHChb5hLU
         AxT1DEQXRintWb4QWmlUfrnawSYodqugPSVKykZih+ZkIkPICaZBBAGpkucfQRQ0jY
         BX+8Oo5KMdLaA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 85B8BE8DD85;
        Sat, 30 Apr 2022 12:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: drop skb dst in tcp_rcv_established()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165132181154.22225.7295368933525782341.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 12:30:11 +0000
References: <20220430011523.3004693-1-eric.dumazet@gmail.com>
In-Reply-To: <20220430011523.3004693-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, soheil@google.com, ncardwell@google.com,
        edumazet@google.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 29 Apr 2022 18:15:23 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> In commit f84af32cbca7 ("net: ip_queue_rcv_skb() helper")
> I dropped the skb dst in tcp_data_queue().
> 
> This only dealt with so-called TCP input slow path.
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: drop skb dst in tcp_rcv_established()
    https://git.kernel.org/netdev/net-next/c/783d108dd71d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


