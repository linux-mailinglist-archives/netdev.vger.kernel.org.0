Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6486525886
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359557AbiELXkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358909AbiELXkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69675286FF9
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 16:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 022CF6206F
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 23:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D538C34119;
        Thu, 12 May 2022 23:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652398813;
        bh=stRYI9ZXHlnqaavjq3IC24bTwcTHmLYI+P+S/KCALM4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DYVQZMol7ylSX6uKxWlgR66B7U/4dN65Cx5cWFc0d7bHAPSX2MVoNcidj9ZQk4GT5
         FmiAnGmo/bxQPNz5TLHaIGiaji884CJGHoARnaEJlKnkJ+op2kkeQ4B/iegMaVvbfk
         aM+0Szjhop8fXt/HniX4guCwryN9FNWK+CyOJwButdL0ilknag9NZiJp0YlI+KIuJv
         IZBJtve+bE5CYNU6y2u4tIQMTijLj/HhPp43E4e1ZsmyBdFj6fug9LMUkMtfEZwC2z
         6V64oxdFqJYLYXzsKgSi1TEQ/jjFlT9k+S1V2SSOAfhQxk5aIynPCUv/pAeUuYKiX1
         NGZgqXrs9lbrA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3D676F0393E;
        Thu, 12 May 2022 23:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: update the register_netdevice() kdoc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165239881324.13563.9956924202729954918.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 23:40:13 +0000
References: <20220511190720.1401356-1-kuba@kernel.org>
In-Reply-To: <20220511190720.1401356-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 11 May 2022 12:07:20 -0700 you wrote:
> The BUGS section looks quite dated, the registration
> is under rtnl lock. Remove some obvious information
> while at it.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/core/dev.c | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)

Here is the summary with links:
  - [net-next] net: update the register_netdevice() kdoc
    https://git.kernel.org/netdev/net-next/c/fa926bb3e491

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


