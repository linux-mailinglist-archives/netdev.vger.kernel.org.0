Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039336875C7
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 07:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbjBBGUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 01:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjBBGUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 01:20:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663A18003D
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 22:20:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFFA161783
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 06:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E582C4339C;
        Thu,  2 Feb 2023 06:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675318817;
        bh=oD8RzGC4gPQxGDauN4OgiOSf0XpYZ4jYQdyep7tZPDE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D1kzs7jQ1OT76pRhhKHus5BknR72WHh0aRyWAOnJl/BA7sSzYU/3fKYBpf/hiWlNF
         ds9eBSHhxRiRxF8ZtYjtGhlY0F/v8QbKhJ5ehImA3/1SPqF1fHlDt1UriLZRS4dqbi
         xs/wgo0OTJFAQysPvQBzLLD4O3JWvf0rNi1e3Y4Wc0tjDdrPIOIMdtDhz7fQ/K1CoL
         Ay1804i8+TCuCcaMpooqbKTLlctE1bZhoZzSJujQu2GLiXF1RccvPwbglV9lOXOT2r
         Eipf25c+nYgV8PRoIbn0kovOOs+Y5VAPLfygSknlyu6qddaJM4wiEvX4dgn7XJYc3Y
         KUZrW1oXa3svw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0DC43E4D037;
        Thu,  2 Feb 2023 06:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] netlink: provide an ability to set default extack
 message
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167531881705.1809.1109150044869661715.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 06:20:17 +0000
References: <6993fac557a40a1973dfa0095107c3d03d40bec1.1675171790.git.leon@kernel.org>
In-Reply-To: <6993fac557a40a1973dfa0095107c3d03d40bec1.1675171790.git.leon@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        andrew@lunn.ch, bridge@lists.linux-foundation.org,
        edumazet@google.com, f.fainelli@gmail.com,
        herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        razor@blackwall.org, pabeni@redhat.com, roopa@nvidia.com,
        simon.horman@corigine.com, steffen.klassert@secunet.com,
        olteanv@gmail.com
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

On Tue, 31 Jan 2023 15:31:57 +0200 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> In netdev common pattern, extack pointer is forwarded to the drivers
> to be filled with error message. However, the caller can easily
> overwrite the filled message.
> 
> Instead of adding multiple "if (!extack->_msg)" checks before any
> NL_SET_ERR_MSG() call, which appears after call to the driver, let's
> add new macro to common code.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] netlink: provide an ability to set default extack message
    https://git.kernel.org/netdev/net-next/c/028fb19c6ba7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


