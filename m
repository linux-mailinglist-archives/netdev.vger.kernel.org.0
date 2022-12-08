Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427E86474F1
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 18:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiLHRUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 12:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiLHRUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 12:20:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDADF8D648;
        Thu,  8 Dec 2022 09:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BB41B82585;
        Thu,  8 Dec 2022 17:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 353D3C433F0;
        Thu,  8 Dec 2022 17:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670520016;
        bh=hFob7TwQilPKAp/EbGgcL8WbPxsR9ATZ+6+QcULd6aA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Dc2Aee2zm4N1H8seCCEvqP40Dtyg6AsmFhvKJQXHoM7wChw8YSMhL/u+EtTTK9eT3
         LKzJpHtwZAUGRNw54grISyJA+B/r6Kj4jBUgDw3v45D0JzjJRO8B1KvwXk52ldeh9L
         GwQPZeJQM015GN7y3pWcJgphcNWVQ34ifXGekqwaQQrMLFfQqG1tnDsB5Db+YTeD1y
         8qItX9M4RaA5q7C/FP6EC7kYybUB52vcsFuJuNQFeijlkgqXKNMywhHnJQWC5EHkbB
         zaKvXTF5f7zwkWwpaVIuL2ztr1N1c3V7PFy7QHwqcJrdJz2gDz8i9ouRk4KOGwsGTk
         2Q/bTxDi9nEPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0D04FE1B4D8;
        Thu,  8 Dec 2022 17:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] macsec: add missing attribute validation for offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167052001604.19571.10800860281620878893.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 17:20:16 +0000
References: <20221207101618.989-1-ehakim@nvidia.com>
In-Reply-To: <20221207101618.989-1-ehakim@nvidia.com>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, raeds@nvidia.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, sd@queasysnail.net,
        atenart@kernel.org, jiri@resnulli.us
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

On Wed, 7 Dec 2022 12:16:18 +0200 you wrote:
> From: Emeel Hakim <ehakim@nvidia.com>
> 
> Add missing attribute validation for IFLA_MACSEC_OFFLOAD
> to the netlink policy.
> 
> Fixes: 791bb3fcafce ("net: macsec: add support for specifying offload upon link creation")
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net] macsec: add missing attribute validation for offload
    https://git.kernel.org/netdev/net/c/38099024e51e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


