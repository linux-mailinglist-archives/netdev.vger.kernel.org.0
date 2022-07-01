Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAB7562969
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 05:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbiGADK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 23:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbiGADKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 23:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC50252A4;
        Thu, 30 Jun 2022 20:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23D9CB82E03;
        Fri,  1 Jul 2022 03:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9272DC341CD;
        Fri,  1 Jul 2022 03:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656645016;
        bh=m/SVEi7NnB9+2bxqBz6ueU2oubylQLnsS39o+oyQ8hs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=esDHWtytuoO2zsj4ZsT61HlPlj6cMM5d27HGoNlQ0pOJ7IGfX8PdAY8vyrlEvrCOd
         8gZPuflEkZG9AlHGjCkcxe0DHBQU8IQiZnADlr2lL3DugoJQ5tQUo5ZjawzwhzEw91
         7IioqMhUDK8HRzsG+BYLF7NztapzuINXJWADorG9Olii0Om0hU6I6u+McXiMMe3bO0
         /4U8VcwrjSs1T6b7r6FPemz5B47N2mZIcyzdkqYA/Ld77KzoEIKwMga/WPTbRgvWWH
         +vy7SZF2J3VpLj5tiQwpqU9lSA/uAEdSLZTBz0lfA5XZAdVhFyafiRz2LmXrUPV3mM
         X9VO8czwNRKxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6BCC6E49FA3;
        Fri,  1 Jul 2022 03:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] google/gve:fix repeated words in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165664501643.21670.14437832391080131082.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Jul 2022 03:10:16 +0000
References: <20220629130013.3273-1-yuanjilin@cdjrlc.com>
In-Reply-To: <20220629130013.3273-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jeroendb@google.com, csully@google.com,
        awogbemila@google.com, netdev@vger.kernel.org,
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

On Wed, 29 Jun 2022 21:00:13 +0800 you wrote:
> Delete the redundant word 'a'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>  drivers/net/ethernet/google/gve/gve_tx_dqo.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - google/gve:fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/577d7685d591

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


