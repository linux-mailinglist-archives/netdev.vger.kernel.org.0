Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8CF0534A25
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 07:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345757AbiEZFKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 01:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235296AbiEZFKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 01:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E004BA563;
        Wed, 25 May 2022 22:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A00E661A1E;
        Thu, 26 May 2022 05:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5528C385B8;
        Thu, 26 May 2022 05:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653541812;
        bh=YAEMI9foUeJXrYhFxIiXRdi75jJzUUiEgUqUGPSJSVM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UkSXxeykH/HT7PRibCN3rLBaBVdeplsYpYUEAShrDf3YIYOX/IyqHR5dlVMCsSEoa
         js4M2eo1KVGuTTnFttnutFJ91dw7fCkLJV54E+MIm8qh2QQLeB7iyYwSF/tGkQ8/aA
         Cl8lmrSExgkxp54W6wq3KwNG5w2iW4zFZYE50Vy5EYYUfcZkvP249wjWbMoJuKNcez
         t0UE1hCzLNt39vDbRiAlcf+4ojd3ym3wMEDBlj1YMHnEm2AW6oWcJ7FeYgItTeZAZ8
         sFdTZoNs+KP6BAQVjNX81gRkZSRRWqpD0fJOaECGY/cuO01JcKCfU9bEgYSCJfl6Eo
         rSWERaRiABvyQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A7373F03943;
        Thu, 26 May 2022 05:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] selftests/net: enable lo.accept_local in psock_snd test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165354181267.23912.15289312887162037824.git-patchwork-notify@kernel.org>
Date:   Thu, 26 May 2022 05:10:12 +0000
References: <20220525031819.866684-1-luyun_611@163.com>
In-Reply-To: <20220525031819.866684-1-luyun_611@163.com>
To:     Yun Lu <luyun_611@163.com>
Cc:     willemb@google.com, davem@davemloft.net, edumazet@google.com,
        willemdebruijn.kernel@gmail.com, liuyun01@kylinos.cn,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 25 May 2022 11:18:19 +0800 you wrote:
> From: luyun <luyun@kylinos.cn>
> 
> The psock_snd test sends and recieves packets over loopback, and
> the test results depend on parameter settings:
> Set rp_filter=0,
> or set rp_filter=1 and accept_local=1
> so that the test will pass. Otherwise, this test will fail with
> Resource temporarily unavailable:
> sudo ./psock_snd.sh
> dgram
> tx: 128
> rx: 142
> ./psock_snd: recv: Resource temporarily unavailable
> 
> [...]

Here is the summary with links:
  - [v2] selftests/net: enable lo.accept_local in psock_snd test
    https://git.kernel.org/netdev/net/c/215cd9897afb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


