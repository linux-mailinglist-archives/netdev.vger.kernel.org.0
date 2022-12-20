Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA9E651869
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 02:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbiLTBoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 20:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbiLTBns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 20:43:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D152F20361
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 17:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65D77B8111A
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 01:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22568C433F0;
        Tue, 20 Dec 2022 01:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671499816;
        bh=5dZsTU7vHVbtkb90gtqvvNrI0mlHsSIq99fWwsEtl3E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oLmzBHU7MjrkHWYC6/sVo9jBjI8Z5s6dvNiwCMw4Nu11fdRkCTIh7nWQevdtwff83
         egFcU25QXVL7k97tbe4iOlBxhQq9p8OPU5KtAE/kucfx5omUymI1mgDNKnu5MXhiQ6
         Mfoj9UYU5ziDqWA0gtImGllxtNl58F899KYX6WweKsyI5qGpVbTg6tLK8paVTFPaTX
         NMVGPdFnOhP2vTKBkDhxXGLbCPwcNfZv5jJu3KMyUhqXfuPD43CpmymIvDdq76H+F4
         lasi+rFMA+wSG80Pj8DDyslk3xdjOE9M6Yt0Gwkeg3GAWK5t2Myj3ghtciBn8OOg0R
         zbDsLyr1/Jkog==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 06289C41622;
        Tue, 20 Dec 2022 01:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] mctp: Remove device type check at unregister
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167149981602.31045.8486930650217477816.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Dec 2022 01:30:16 +0000
References: <20221215054933.2403401-1-matt@codeconstruct.com.au>
In-Reply-To: <20221215054933.2403401-1-matt@codeconstruct.com.au>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jk@codeconstruct.com.au,
        alexander.duyck@gmail.com
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

On Thu, 15 Dec 2022 13:49:33 +0800 you wrote:
> The unregister check could be incorrectly triggered if a netdev
> changes its type after register. That is possible for a tun device
> using TUNSETLINK ioctl, resulting in mctp unregister failing
> and the netdev unregister waiting forever.
> 
> This was encountered by https://github.com/openthread/openthread/issues/8523
> 
> [...]

Here is the summary with links:
  - [net,v2] mctp: Remove device type check at unregister
    https://git.kernel.org/netdev/net/c/b389a902dd5b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


