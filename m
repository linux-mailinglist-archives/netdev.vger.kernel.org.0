Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C341C627B4E
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 12:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236381AbiKNLAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 06:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbiKNLAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 06:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970F813DC3
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 03:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3443960FFB
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 11:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8ADD3C433B5;
        Mon, 14 Nov 2022 11:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668423615;
        bh=OLkncQ0T+2yGZYsqXsqfGZSQ+Nn+fxxTmkat+Ts8aT8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o2B+f5C5JG5s+A0a1RRGax9l0J/Rv0yVHML7l7Xht9UuJzeOHE/FOsDVGk9QKWd+c
         bhx1PCW0hO5v7/x+543p65fVYHEH7FC+aEnQ2mIjHKCm6+zs5gSClA3Pz8FYHVHZvl
         UKSs9kMJyYDfe+d/8wRppbyBnyMYtfTCKKQFNKYQYW486m64nWKUE/TEiJk9119HCo
         Nqc6bI2cmDVIwAcoj87rMljq36R2DD3mLldm2LrNWcPvLYkXqrmErTQQkQxEVMCe+G
         wMsaCrQRJYncQUtvQKErcSsEltdzjP9JYZae3MvKkKMKDdMIorkb53MXRwW0JVqpX/
         Nqx8DPwlz9QFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6D8CCE270C2;
        Mon, 14 Nov 2022 11:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bnxt_en: Remove debugfs when pci_register_driver failed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166842361544.12717.8041428660747446249.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Nov 2022 11:00:15 +0000
References: <20221111070433.3498215-1-cuigaosheng1@huawei.com>
In-Reply-To: <20221111070433.3498215-1-cuigaosheng1@huawei.com>
To:     cuigaosheng <cuigaosheng1@huawei.com>
Cc:     michael.chan@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        gospo@broadcom.com, netdev@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Fri, 11 Nov 2022 15:04:33 +0800 you wrote:
> When pci_register_driver failed, we need to remove debugfs,
> which will caused a resource leak, fix it.
> 
> Resource leak logs as follows:
> [   52.184456] debugfs: Directory 'bnxt_en' with parent '/' already present!
> 
> Fixes: cabfb09d87bd ("bnxt_en: add debugfs support for DIM")
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] bnxt_en: Remove debugfs when pci_register_driver failed
    https://git.kernel.org/netdev/net/c/991aef4ee4f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


