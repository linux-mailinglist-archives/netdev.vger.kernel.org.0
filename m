Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06613605A2A
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 10:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiJTIuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 04:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiJTIuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 04:50:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9B011701C;
        Thu, 20 Oct 2022 01:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4608561A9C;
        Thu, 20 Oct 2022 08:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4BA31C4314B;
        Thu, 20 Oct 2022 08:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666255817;
        bh=E3xpOIEteQXFleAx3p+y6v3LsALPWIW5v62pwBCoKZs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O67hm3NpvRmveytv6hYHOUz+iOXQZLLmCvgytlYLBxXBHy1eutU2TbJJg5JQ1/rjR
         kUsYaJcOAYXG+VbP8Wu5ppHwP060mIF959kOKbx4K61j1GeMFyK0NI/notPGrXzFGu
         dt4KAbh+Cl3M6pEGANleJ8XeK065SRonVw8/ikwL3GhNVhlWV1EBoelgDGioknS278
         wF/JZe661/08Ccu8hqj9KIF7DUKVmwDDm1Qkxww+55qJQhwd5AldRtqCWRmM9SBLwF
         Y77HHfZ8mzpsHWZdO8Ayxnsdds2TiGC6YP4Wcf8tYQb56fXyPeubVd3t+XE6o2orXF
         cEKbtABD46BFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DB7B1E270E3;
        Thu, 20 Oct 2022 08:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: ipa: Proactively round up to kmalloc bucket size
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166625581689.27221.12370908891307752871.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Oct 2022 08:50:16 +0000
References: <20221018092724.give.735-kees@kernel.org>
In-Reply-To: <20221018092724.give.735-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, elder@linaro.org,
        elder@kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 18 Oct 2022 02:28:27 -0700 you wrote:
> Instead of discovering the kmalloc bucket size _after_ allocation, round
> up proactively so the allocation is explicitly made for the full size,
> allowing the compiler to correctly reason about the resulting size of
> the buffer through the existing __alloc_size() hint.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Reviewed-by: Alex Elder <elder@linaro.org>
> Link: https://lore.kernel.org/lkml/4d75a9fd-1b94-7208-9de8-5a0102223e68@ieee.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> [...]

Here is the summary with links:
  - [v3] net: ipa: Proactively round up to kmalloc bucket size
    https://git.kernel.org/netdev/net-next/c/36875a063b5e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


