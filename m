Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97DBD6258F4
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 12:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbiKKLAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 06:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbiKKLAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 06:00:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0029DB7E6;
        Fri, 11 Nov 2022 03:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8948F61F7C;
        Fri, 11 Nov 2022 11:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1B4FC433D6;
        Fri, 11 Nov 2022 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668164416;
        bh=IQA9c4YIWWV+lEniexvL3pRVvqcJEK+CQlAsEfXFjrM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XFKf0P9jtThe/kb9PmH14MIjtdFBUA6sveJRytpCGS0xLGUGMuquo6Xzvb+kB6EWw
         UtFme5gygK+BLN+p7TXVymkHe3sFunMA29dXqqaE8sAxkETgYJDt1Qy6avHFvP+263
         AnSmw9NX0HmT2Llm1/P+2R44ZqykaF26ROhdwZVnAkyf39pt5+yTcLABrooDc0QI6l
         TZYNiC7FYi/mq3nWC9TX6eqKYYde7Mx5W1aX+5PzYmGipEuFyvUWUI8j8cwIx+1J/4
         fu53if1KBr9FWasLmXwYErXF0n9G+o3JUWVq2FkRZ27iEt0SHecZySIFiQFeq2Qtlk
         0B4qmZzhMnZ2Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AE37CE4D022;
        Fri, 11 Nov 2022 11:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/3] net: marvell: prestera: pci: add support for AC5X family
 devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166816441670.11358.1134767102186026749.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Nov 2022 11:00:16 +0000
References: <20221109222522.14554-1-oleksandr.mazur@plvision.eu>
In-Reply-To: <20221109222522.14554-1-oleksandr.mazur@plvision.eu>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, maksym.glubokiy@plvision.eu,
        vadym.kochan@plvision.eu, tchornyi@marvell.com, mickeyr@marvell.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 10 Nov 2022 00:25:19 +0200 you wrote:
> This patch series introduces a support for AC5X family devices.
> AC5X devices utilize arm64 CPUs, and thus require a new FW (arm64-one)
> to be loaded. The new FW-image for AC5X devices has been introduces in
> the linux-firmware repo under the following commit:
> 
> 60310c2deb8c ("Merge branch 'prestera-v4.1' of
> https://github.com/PLVision/linux-firmware")
> 
> [...]

Here is the summary with links:
  - [1/3] net: marvell: prestera: pci: use device-id defines
    https://git.kernel.org/netdev/net-next/c/c334ac6461d5
  - [2/3] net: marvell: prestera: pci: add support for AC5X family devices
    https://git.kernel.org/netdev/net-next/c/075c881be29b
  - [3/3] net: marvell: prestera: pci: bump supported FW min version
    https://git.kernel.org/netdev/net-next/c/a35608ed8cfd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


