Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C1B5F0BBF
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 14:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiI3MaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 08:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiI3MaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 08:30:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680593FA25;
        Fri, 30 Sep 2022 05:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 275F0B8289E;
        Fri, 30 Sep 2022 12:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3EA5C433D7;
        Fri, 30 Sep 2022 12:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664541015;
        bh=dJ9p2JTbNabN3KhCp1FSybnMuG4EFrKPIhohldhul2o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qtml5r1d4pV8fgixeNcDhW2QWQQcAywERJwnVNJAPfdsgYv84TyaVaCbrCYAhnYYk
         oV0oMrpvzsBrgsy7auLdiDZuYWcF5ne/saM0Y14kto1kpNvJ8c4/u2LH+jr3RkpUm8
         apZzihRXKlhV91SfAyWW9O7a4jBH7PbTcoeltqrsysynNuUZg+abnvhSuQyCUcwskA
         ZxQZ0EmRDV0Kj21KRGEdNlOEforGaedC8S4Gp8FKl5twjD/OlcJ7OaCTyZT6buLqDu
         yL5vPgPo/B7YiW0ziyGURywFP4AdKSPWMCZzlZAk9DohmIY+7xM9dKPJJGbCI+FwmG
         pdquRNDmCUfWQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 94BE4C395DA;
        Fri, 30 Sep 2022 12:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ip6_vti:Remove the space before the comma
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166454101560.1800.13264286320041280640.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 12:30:15 +0000
References: <20220929061205.2690864-1-wh_bin@126.com>
In-Reply-To: <20220929061205.2690864-1-wh_bin@126.com>
To:     Hongbin Wang <wh_bin@126.com>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 29 Sep 2022 02:12:05 -0400 you wrote:
> There should be no space before the comma
> 
> Signed-off-by: Hongbin Wang <wh_bin@126.com>
> ---
>  net/ipv6/ip6_vti.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - ip6_vti:Remove the space before the comma
    https://git.kernel.org/netdev/net-next/c/0f5ef005310d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


