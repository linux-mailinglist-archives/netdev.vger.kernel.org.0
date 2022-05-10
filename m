Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C81B520E8E
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 09:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236444AbiEJHh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 03:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241599AbiEJHeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 03:34:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7562A4A06
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 00:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A9990CE1CA8
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 07:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2171C385C9;
        Tue, 10 May 2022 07:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652167813;
        bh=xxp/JwAQqSxOYKtB1prTM3yiZwTtoGwWzZua41IqlE4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W33i+RQL54Oh3nuFOuv/UeHsQhefQXg5GFxkh85+Y/ldr4b1+ueCmjEcqG+m7Pv4I
         6WBBLJ6z5m83To9zSvmixifab9ifRtBl6I+yiC5R7B1UouuTo9mf24y47ptU9hgebv
         08jmxGY9EjD4tRINst7Rru9HJF2je3cCH3ARZoxpcGQiVKARrSCFGAmUBkOfa+gYBp
         tSXj9+A6AmZnKeKdhphm+x2onZBxZJonyJvObs7Nopy5PVsz4NR2eEb/ghpiTken1O
         92Grf8cIf04jcw0Lrh8Snitxc6dFT51WEvLjt1NEwo5Q3vARzOz6cidTJgvwsE9G2N
         YhOmMfpjyuBaA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C58B2F03929;
        Tue, 10 May 2022 07:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] eth: dpaa2-mac: remove a dead-code NULL check on
 fwnode parent
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165216781280.23380.14407674972174398784.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 07:30:12 +0000
References: <20220506200029.852310-1-kuba@kernel.org>
In-Reply-To: <20220506200029.852310-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, ioana.ciornei@nxp.com
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

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri,  6 May 2022 13:00:29 -0700 you wrote:
> Since commit 4e30e98c4b4c ("dpaa2-mac: return -EPROBE_DEFER from dpaa2_mac_open in case the fwnode is not set")
> @parent can't be NULL after the if. It's either the address
> of the ->fwnode of @dpmacs or @fwnode in case of ACPI.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Right, Ioana? Let's clean this up so the of_node_put() bots
> go away.
> 
> [...]

Here is the summary with links:
  - [net-next] eth: dpaa2-mac: remove a dead-code NULL check on fwnode parent
    https://git.kernel.org/netdev/net-next/c/b3552d6a3b8b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


