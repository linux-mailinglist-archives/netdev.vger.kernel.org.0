Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F645BD660
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 23:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiISVaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 17:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiISVaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 17:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38D42AC5F
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 14:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73C226207E
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 21:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4234C433D7;
        Mon, 19 Sep 2022 21:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663623014;
        bh=+0shaxCNezLnaF9Y4DQpwJCAQIO1sNvWlTVvcv4GhE0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NWt0FBgCohURuf6PraUwOB7hue1IwhEE+/CHC9frBc49Yyemdf03YS40pj8LXX1Lr
         buOjWPwRoHPFp2qMzB/CBgmOnyUR9gPxlWcEInipUZRXTS3FKhotPHyzp8aYM66WBl
         sJvTIzIVtUw4rfv+vn5fFqV6seYQADFgbLjYs/567GERtv6ftV0fucFqBRJ+ukDG08
         yxeB+kzgLSZdFgYIM4pPwx5TkBzX1LatWJBRliZMX5eBT0OeJADtgTnNVA4enb7ICw
         LObuvBu6F0AaInOJKLU4UngCNnq0smqx5B4I/JGZoKPUAT0n6weUa5bz1LZNZcaFSc
         nwIEQNiaxBJzw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 93602E52535;
        Mon, 19 Sep 2022 21:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v1] mlxbf_gige: clear MDIO gateway lock after read
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166362301458.9084.5292056267200738171.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Sep 2022 21:30:14 +0000
References: <20220902164247.19862-1-davthompson@nvidia.com>
In-Reply-To: <20220902164247.19862-1-davthompson@nvidia.com>
To:     David Thompson <davthompson@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, cai.huoqing@linux.dev,
        brgl@bgdev.pl, limings@nvidia.com, asmaa@nvidia.com
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

On Fri, 2 Sep 2022 12:42:47 -0400 you wrote:
> The MDIO gateway (GW) lock in BlueField-2 GIGE logic is
> set after read.  This patch adds logic to make sure the
> lock is always cleared at the end of each MDIO transaction.
> 
> Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
> Reviewed-by: Asmaa Mnebhi <asmaa@nvidia.com>
> Signed-off-by: David Thompson <davthompson@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net,v1] mlxbf_gige: clear MDIO gateway lock after read
    https://git.kernel.org/netdev/net/c/182447b12144

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


