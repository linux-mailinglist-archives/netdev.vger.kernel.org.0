Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC492692D83
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBKDKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjBKDKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:10:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A47348A25;
        Fri, 10 Feb 2023 19:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3354CB82683;
        Sat, 11 Feb 2023 03:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DCFA6C4339C;
        Sat, 11 Feb 2023 03:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676085018;
        bh=cBejn06qRQOtVQcUYiftkCpqHPejhJ6akSojdxItpsY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jSwS4nFWk3/KDTYe9vKdxHcm5rJ8gk5mBx/DnWK3u0rBEMtVSPr17oXoKwk3ww31B
         USzlE+DNVQqHCRvXEZRg4trWEDjfBcUse2sw3RBEg5Lfm2rroQxZKHBcmSfbJiNeNV
         ux34OvM+nLBnOmXh/Xshuu3n3KhLEd9sxcgHtPHs7tl/4DrXyNM5YQZYWBxJSu+kvQ
         6YJnMKxAn+4Mpmu25LpTzqmt3NtPNGXtEzuRM3fjp67e9lF+5Gdlfnx847DfCqqGco
         icvwr1f1kqTPmS/lP4qWfLH/qcDZ1CKKmt591NW9A1OqMoTeZ2WIMGEezB2CsVfreo
         AvXoSUx90hbxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C27F0E21EC7;
        Sat, 11 Feb 2023 03:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth-next 2023-02-09
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167608501879.9768.615911961609409706.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Feb 2023 03:10:18 +0000
References: <20230209234922.3756173-1-luiz.dentz@gmail.com>
In-Reply-To: <20230209234922.3756173-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Feb 2023 15:49:22 -0800 you wrote:
> The following changes since commit 8697a258ae24703267d2a37d91ab757c91ef027e:
> 
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-02-09 12:25:40 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2023-02-09
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth-next 2023-02-09
    https://git.kernel.org/netdev/net-next/c/ee7e1788ae3d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


