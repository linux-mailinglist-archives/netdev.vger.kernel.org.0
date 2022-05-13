Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14082526B18
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 22:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384087AbiEMUUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 16:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384046AbiEMUUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 16:20:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A424AE15
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 13:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69EC5B831C5
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 20:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A8ECC34117;
        Fri, 13 May 2022 20:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652473215;
        bh=YKHeEoSm6XImxF5Q8kSXIYfEHC+1IgUf6esVZWtrD6Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kby1GC+eKFrih8+SmkgKZNY45u2qxVUUzYM8TGf/qVSNsvLPW1fVCgft/+r907JkH
         lI6/yKsEobE32hMVetexgyEI6I1/r+yobwBTci+H9uuSREer2zmFRIVAfybzTBa/VD
         Bb0T4jJpTroaxOoKECpSBbZXN3f5JhLCUpYNVFNXv6h2waAPrsSBlFFxz25gJS8nMR
         Hu/p60obBGybQ7znk8VJemWMqmn4h7sw7TjQLBOMo9ec4bO/Ocv4CuCuEZe6VyzKFX
         gMaci5FHxMlBdy1QeD6ZxGj4xpEq4QQinHSreq4/qIu/piEr4MiB6SsGhICq/C9fM0
         HflqmzUmJDQSw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4B7AF03934;
        Fri, 13 May 2022 20:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/8] xfrm: free not used XFRM_ESP_NO_TRAILER flag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165247321493.3484.7185891880033859064.git-patchwork-notify@kernel.org>
Date:   Fri, 13 May 2022 20:20:14 +0000
References: <20220513151218.4010119-2-steffen.klassert@secunet.com>
In-Reply-To: <20220513151218.4010119-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Fri, 13 May 2022 17:12:11 +0200 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> After removal of Innova IPsec support from mlx5 driver, the last user
> of this XFRM_ESP_NO_TRAILER was gone too. This means that we can safely
> remove it as no other hardware is capable (or need) to remove ESP trailer.
> 
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Acked-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> 
> [...]

Here is the summary with links:
  - [1/8] xfrm: free not used XFRM_ESP_NO_TRAILER flag
    https://git.kernel.org/netdev/net-next/c/b01a277a0520
  - [2/8] xfrm: delete not used number of external headers
    https://git.kernel.org/netdev/net-next/c/a36708e64658
  - [3/8] xfrm: rename xfrm_state_offload struct to allow reuse
    https://git.kernel.org/netdev/net-next/c/87e0a94e60ea
  - [4/8] xfrm: store and rely on direction to construct offload flags
    https://git.kernel.org/netdev/net-next/c/482db2f1dd21
  - [5/8] ixgbe: propagate XFRM offload state direction instead of flags
    https://git.kernel.org/netdev/net-next/c/0c05ab78e3f2
  - [6/8] netdevsim: rely on XFRM state direction instead of flags
    https://git.kernel.org/netdev/net-next/c/55e2f83afb1c
  - [7/8] net/mlx5e: Use XFRM state direction instead of flags
    https://git.kernel.org/netdev/net-next/c/3ef535eccea3
  - [8/8] xfrm: drop not needed flags variable in XFRM offload struct
    https://git.kernel.org/netdev/net-next/c/254c4a824c7c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


