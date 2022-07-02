Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75E9563DF7
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 05:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbiGBDUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 23:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbiGBDUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 23:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C7631939;
        Fri,  1 Jul 2022 20:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8138B832BF;
        Sat,  2 Jul 2022 03:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80DB4C341D6;
        Sat,  2 Jul 2022 03:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656732015;
        bh=sZex7/SjQQe2qnhQaW5VF9AycATS82nOa6WP1tjzs8M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sZMJ8Jb2nhK4Df8A6bB9kDtbu8d5gswOCY/qkC2YKvlM58hzCfsXHaquNWSX2x1x/
         qL7IjoOlRp/4FfU1AkvaEB7n97NeWI2Q+z1+RuIjmwzkEC/AK1VuUquSLBeKXm9GHP
         eMfo4lGBBKFqQMgfA0XViq5UMtLrLqPw+P9SHk22vMAqD8ae05Oq5xNdgLYEno1mgn
         55dn1d/QQH44NajzQ06ZfkzoV+8wW74LSYKAVOXiL4diV6MmlUtdjcPGMMGQVv4RTg
         ThTSTzoQ1T2cJCzw3AC4yZ8Tj+nuRdyWt5MXKSPUulPXMRV/ysJLPzUqB6ER6qVU0Y
         /HlTfks56fAFw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 67A24E49FA0;
        Sat,  2 Jul 2022 03:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet/sun: fix repeated words in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165673201542.6297.15118487367936857534.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Jul 2022 03:20:15 +0000
References: <20220630130916.21074-1-yuanjilin@cdjrlc.com>
In-Reply-To: <20220630130916.21074-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 30 Jun 2022 21:09:16 +0800 you wrote:
> Delete the redundant word 'the'.
> Delete the redundant word 'is'.
> Delete the redundant word 'start'.
> Delete the redundant word 'checking'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> 
> [...]

Here is the summary with links:
  - ethernet/sun: fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/c31788832f87

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


