Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C54515D54
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 15:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382659AbiD3NNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 09:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382163AbiD3NNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 09:13:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D0412A8F
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 06:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D2E6B82B73
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 13:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2CD95C385B3;
        Sat, 30 Apr 2022 13:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651324211;
        bh=7iXkDtgmQm5DFArI6yT9zNrS8pvZphAbFajOLUL8wjM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BH9fCcj05HIxiWgCC/cDYspy9nFYK6VMmtDX/sIF0ieN+cV1h7RXpt/9f+i8CTaer
         Y2i6l4ABGX3XdNyFemQ7Abf/eY3ThzBveiHGHPJgvzD9nKlTlp1K4ackD4WKZ1a3bd
         wc2WwnobkM1wU0TlvmCvU+Oa0bx4135Ix1OZ5pC6qpCqOMz7CXg+tszNMy2QYFxV87
         CbzltTNuqFqgwZ1BvlcqDDQEgKCd9cflO3R/t/TbWSe48wyvE1XAqenkesJnEwr8kt
         cTRSBOQEq0VSKC2VoW252mb7SpRiS3ITKZXK3xMiK1ukKlqLExAlocpVp7MF4IJLjX
         5gd4K3DNDn02A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 13D0CF03847;
        Sat, 30 Apr 2022 13:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] eth: remove remaining copies of the NAPI_POLL_WEIGHT
 define
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165132421107.7001.9428464723444325952.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 13:10:11 +0000
References: <20220429174330.196459-1-kuba@kernel.org>
In-Reply-To: <20220429174330.196459-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, shayagr@amazon.com, akiyano@amazon.com,
        darinzon@amazon.com, ndagan@amazon.com, saeedb@amazon.com,
        rmody@marvell.com, skalluru@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, rain.1986.08.12@gmail.com,
        zyjzyj2000@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Apr 2022 10:43:30 -0700 you wrote:
> Defining local versions of NAPI_POLL_WEIGHT with the same
> values in the drivers just makes refactoring harder.
> 
> This patch covers three more drivers which I missed in
> commit 5f012b40ef63 ("eth: remove copies of the NAPI_POLL_WEIGHT define").
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] eth: remove remaining copies of the NAPI_POLL_WEIGHT define
    https://git.kernel.org/netdev/net-next/c/36ffca1afea9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


