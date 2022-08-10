Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071AA58E6AE
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 07:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbiHJFUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 01:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbiHJFUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 01:20:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2899E11827;
        Tue,  9 Aug 2022 22:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA1EBB818E3;
        Wed, 10 Aug 2022 05:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C704C433D7;
        Wed, 10 Aug 2022 05:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660108814;
        bh=gBo3B78RHSQNX+YsYhLUDdk13eMy2af1OHnfA8ITw0M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UlpWvUSkaJI2EFAel2UeJJahuXRAvPWBbAF/mPfNgi9qD27JNxQ47SRI9cRPkHuPn
         bBs6zQf0Tm2KD+hArVH6lQsMyqj8A15iVER5AEP11NwXQTUD+BgCBXUS3osOuMjcEz
         apcsliIATyM0O29luzs18DqmDwKaguFohmDInyTeIttqQrCaCAXaFaoWNG4T/wCWlo
         PnT/d0QINy+ZheyHQEEdn4VH6sn+dEFUvDorUsCL4hhFWLhV7QYc5TGXp+JdnWKrU6
         DLgMGNcaPbqneOG7uJ06qjEMGqexpVQf4MqgwN00m+1hP1/OUEHJ2J0j9QQ1A5vnyM
         g1Z83VQ3Qy3FA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58455C43144;
        Wed, 10 Aug 2022 05:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ax88796: Fix some typo in a comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166010881435.23810.582475083264301054.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Aug 2022 05:20:14 +0000
References: <7db4b622d2c3e5af58c1d1f32b81836f4af71f18.1659801746.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <7db4b622d2c3e5af58c1d1f32b81836f4af71f18.1659801746.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  6 Aug 2022 18:02:36 +0200 you wrote:
> s/by caused/be caused/
> s/ax88786/ax88796/
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> s/ax88786/ax88796/ is a guess based on the surrounding comments and the
> name of the file.
> 
> [...]

Here is the summary with links:
  - ax88796: Fix some typo in a comment
    https://git.kernel.org/netdev/net/c/84b709d31063

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


