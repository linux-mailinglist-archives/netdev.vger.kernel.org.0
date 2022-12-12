Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A51764A941
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 22:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbiLLVLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 16:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbiLLVLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 16:11:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D2B186D7
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 13:11:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 894706116F
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 21:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D21AEC4339B;
        Mon, 12 Dec 2022 21:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670879472;
        bh=z+UQi+kyRm9U+k2/NlmHatNw8Jl9Hs2LV6CBW1IS8U0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JljhBFNct/8mwiKuMxOw3zfcotcFgy+leVSfATqcmDLNyQvtBxw/r+AQqsImuJdC1
         tVy5iSi6vE7J/AC9xnFM6NzcXLu8F/15Bqan451LFVBPaZ1gEZt0OwvKLoYUlDshln
         6246VOVgQsveBxjS3UjSNFzom6r0vq3UuXoNEJd7d/MYyBEqSuqLRQZDRBLGMq3eWh
         4au9Ct7/6hlyNcMhAXyX0i0s7/lyKAA0x5JvpAWNLgIdZF8hIAd59aBZZ9g0CrWCXh
         bJadckQjS/R6DYTtQfOjZuJHXH2HvdYu0WwbGXge3FluS3O7daVheyI1LvZOotyGmV
         9rBj1XR7S5/7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B5F90E270FB;
        Mon, 12 Dec 2022 21:11:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] MAINTAINERS: Update email address for Marvell
 Prestera Ethernet Switch driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167087947274.28989.17366966291523143699.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 21:11:12 +0000
References: <20221209154521.1246881-1-vadym.kochan@plvision.eu>
In-Reply-To: <20221209154521.1246881-1-vadym.kochan@plvision.eu>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, mickeyr@marvell.com, enachman@marvell.com,
        serhiy.pshyk@plvision.eu, serhii.boiko@plvision.eu,
        oleksandr.mazur@plvision.eu, taras.chornyi@plvision.eu,
        maksym.glubokiy@plvision.eu, yevhen.orlov@plvision.eu
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  9 Dec 2022 17:45:21 +0200 you wrote:
> From: Taras Chornyi <taras.chornyi@plvision.eu>
> 
> Taras's Marvell email account will be shut down soon so change it to Plvision.
> 
> Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> 
> [...]

Here is the summary with links:
  - [net-next] MAINTAINERS: Update email address for Marvell Prestera Ethernet Switch driver
    https://git.kernel.org/bpf/bpf-next/c/4e426e2534ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


