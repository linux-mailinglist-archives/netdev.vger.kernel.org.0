Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC12B566737
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiGEKAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiGEKAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:00:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8754325D6;
        Tue,  5 Jul 2022 03:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34CBBB8173F;
        Tue,  5 Jul 2022 10:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EBC37C341CF;
        Tue,  5 Jul 2022 10:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657015213;
        bh=78ksWqfiWLicUtwIUduk+lCOxEwssJXumFPveTIH1og=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bMD8XRaU+DJI+6pQvI4VwlpkhevhVPItFr1WM4gM8iv2B2H8Wv4iV605B3bppg8Jz
         IvfrD+XXdU7VfT7nkVhUZ5nyxjMMp6DqQKcSwFe2Hg/VVr+OE+ADFg9S2fg0fzbAMm
         hv57Z0w+shNGCf/MUaaYb4p8QA3BjhDTntwA5aIvWEKhxlFi1ftbWzjZmuWN4+eUCN
         N1yLhymEOl5AD+0Mfw7L52pNtq5QpA3Bg5QgjmGbf/N9czJPN8OXIa5G8SSqzB2S92
         +niJU9PEBVR33yOak9/ssMXVYWyaaEQzmT/1+058XtGLsw72HZScglk1LhHIRC+lyR
         qL9MxxQwF4t7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CDAEDE45BDF;
        Tue,  5 Jul 2022 10:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: omit superfluous address family check in
 __bpf_skc_lookup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165701521283.30326.9772990999417260206.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Jul 2022 10:00:12 +0000
References: <20220630082618.15649-1-tklauser@distanz.ch>
In-Reply-To: <20220630082618.15649-1-tklauser@distanz.ch>
To:     Tobias Klauser <tklauser@distanz.ch>
Cc:     martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 30 Jun 2022 10:26:18 +0200 you wrote:
> family is only set to either AF_INET or AF_INET6 based on len. In all
> other cases we return early. Thus the check against AF_UNSPEC can be
> omitted.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
>  net/core/filter.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [bpf-next] bpf: omit superfluous address family check in __bpf_skc_lookup
    https://git.kernel.org/bpf/bpf-next/c/2064a132c0de

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


