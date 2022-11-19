Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 177FB630B92
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 04:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbiKSDyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 22:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiKSDx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 22:53:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2C3C7211
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 19:50:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 701726284F
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 03:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E7C9C4314E;
        Sat, 19 Nov 2022 03:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668829818;
        bh=KXNFyfUa21aI0QJG0G6KjM+fJtt9eKZxFkfikBSZDv8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HtnGjIbX0cVBIiA+KNZkKfQuIRJ+nt5rpe5AE7d95ccvC+Enkp+fLfX+WTbifpY7g
         pAI1sEfhFM910a6OXnVisq7pLaoqipenQhWLWnWbrj4YhjxMNbn5qpFtp8Q63+Ot2N
         2xpEdKVR+QURcZUme2Cz9KWVgD4TM07IMtmhVNFVlAFuAAw7s9SoOzOZMNH9CPmeZR
         cCuRdoqBAKWNrpOtq027GkfqB+lXZDAm8rlAZzctrSdS0EnXBFD864Jjr8cbdxPpj7
         PgfRfRM9pNFmiSFZhs892RpIgOVciF1w80hgE+56Rqrme/zRN9UFz5p/pwVWCSCOJF
         zkdOJTZXLAIdg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47A34E524E6;
        Sat, 19 Nov 2022 03:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net/mlx4: Check retval of mlx4_bitmap_init
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166882981828.27279.5298856833217818007.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Nov 2022 03:50:18 +0000
References: <20221117152806.278072-1-pkosyh@yandex.ru>
In-Reply-To: <20221117152806.278072-1-pkosyh@yandex.ru>
To:     Peter Kosyh <pkosyh@yandex.ru>
Cc:     tariqt@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        lvc-project@linuxtesting.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 17 Nov 2022 18:28:06 +0300 you wrote:
> If mlx4_bitmap_init fails, mlx4_bitmap_alloc_range will dereference
> the NULL pointer (bitmap->table).
> 
> Make sure, that mlx4_bitmap_alloc_range called in no error case.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> [...]

Here is the summary with links:
  - [net,v3] net/mlx4: Check retval of mlx4_bitmap_init
    https://git.kernel.org/netdev/net/c/594c61ffc77d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


