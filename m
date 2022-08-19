Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB605993DC
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 06:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244502AbiHSEBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 00:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239642AbiHSEBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 00:01:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DEBCC315;
        Thu, 18 Aug 2022 21:00:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31784B82555;
        Fri, 19 Aug 2022 04:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4CA9C433B5;
        Fri, 19 Aug 2022 04:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660881656;
        bh=H/aB3f86wWIgzIaNyEoppKOzVVAMHECaZ6JzFFKAxHo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AGsLjgh16WHmBRtiDpAbOQFrqH0icaimRK1z+n6ok3kywYPNkg0e9WRwRAFFPJUWd
         23frqd4TZTVjHEqRf9dzDw3F1eV/sd8Xe5j3/NKRSHhvf9gSjsykOEUKau+uzpB6rp
         w0z28elNkny9x+kPlqWdeFiXiwjRhf5D1RCaxcGaSl+qWosfBmajJMMxmy3y1aSe+E
         ytje/6MX9MTUiQhdI8RaoMT4FxhwhrFaz4n3ZyTzQg4oT0OAI6leAzdy0OalN6DQYR
         1pyEJQISKJHBS2c0pVs107gLzxpfy5KXEq5uHUCkO52GjI0I5iJXuE7dIFhF9MsVuV
         xvnzPAjw0qGBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 93418C004EF;
        Fri, 19 Aug 2022 04:00:56 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 1/1] net: macsec: Expose MACSEC_SALT_LEN
 definition to user space
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166088165659.14408.6075514173179516789.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Aug 2022 04:00:56 +0000
References: <20220818153229.4721-1-ehakim@nvidia.com>
In-Reply-To: <20220818153229.4721-1-ehakim@nvidia.com>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     edumazet@google.com, mayflowerera@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, raeds@nvidia.com, sd@queasysnail.net
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 18 Aug 2022 18:32:30 +0300 you wrote:
> Expose MACSEC_SALT_LEN definition to user space to be
> used in various user space applications such as iproute.
> Iproute will use this as part of adding macsec extended
> packet number support.
> 
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/1] net: macsec: Expose MACSEC_SALT_LEN definition to user space
    https://git.kernel.org/netdev/net-next/c/5d8175783585

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


