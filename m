Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36FDB67A8AB
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 03:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjAYCUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 21:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjAYCUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 21:20:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9EE46727
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 18:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B4D5FCE1D2E
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E1707C4339B;
        Wed, 25 Jan 2023 02:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674613215;
        bh=lSkjMkXk9e0apOuXH9EvGuV7rqwgEfSppKTDf+PqZVQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o7A9296l84wxswXRadNM2IOAIzN4T8uT2NyIQ/Brm8IwxKQmUhjZ8uk8RTvqRGbMW
         DSmkckrBkwGT47qFZaoYORCgZP3zRC2WbatsSor9JsF6l6mJIU8vBpr7+JEHyoDApy
         7gFovuaxBAsSXQDOC7mEKZs7BhT3rjJOp/NZBwkXmt/fRaPYKj5UkNyjznY6yrujNV
         O0nrb74UGLbFcOnBnI7dKHKIM1fm4S6cdyw28L3s5p6uLX2/Qe3y0uRXQvmOHNRxgQ
         eDxpfteIoVRb7/VEqk6wgUOQEsScurkoJf/b5w/Mpd6kwBKB1A69YzBh+a8ZBB9LTS
         qGyIqtcb3LASA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C80B1E52508;
        Wed, 25 Jan 2023 02:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv6: Make ip6_route_output_flags_noref() static.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167461321581.24818.14399079611335409374.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Jan 2023 02:20:15 +0000
References: <50706db7f675e40b3594d62011d9363dce32b92e.1674495822.git.gnault@redhat.com>
In-Reply-To: <50706db7f675e40b3594d62011d9363dce32b92e.1674495822.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 23 Jan 2023 18:47:09 +0100 you wrote:
> This function is only used in net/ipv6/route.c and has no reason to be
> visible outside of it.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  include/net/ip6_route.h | 4 ----
>  net/ipv6/route.c        | 8 ++++----
>  2 files changed, 4 insertions(+), 8 deletions(-)

Here is the summary with links:
  - [net-next] ipv6: Make ip6_route_output_flags_noref() static.
    https://git.kernel.org/netdev/net-next/c/90317bcdbd33

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


