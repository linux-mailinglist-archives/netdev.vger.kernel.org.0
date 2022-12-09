Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160B0647CC6
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 05:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiLIDjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 22:39:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiLIDjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 22:39:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A4F5CD05;
        Thu,  8 Dec 2022 19:39:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 448B662139;
        Fri,  9 Dec 2022 03:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8892DC433F0;
        Fri,  9 Dec 2022 03:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670556620;
        bh=tYbiGrrSL4Z2+K+l+yoYCFganFJL+UrpdaXom8rF+OM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YofdVnnBi8lviXA5NPj1OOZ0QOclRQsRgpyu3SO0qNNZtCFq9NfJsSzojs20fXo8w
         OZ2t7qB/l3B2ZbgfjlKEwg/UUMT+ehKRjUsva/OLChEbJ+Q5zF4fW5AeAtsxdjryO/
         OU//nZZCVyDYSEJaavsu4mOfxaOGHNAusYxnL8bly3biDzLr+zil+CRnCiBUdlyDM4
         SD6HuSzDL4dwUZKv/KtrtY37HtrfvIxGTFZ8vheyuT7rE/dNpF8dWtD8MTTZcXI26H
         5tK8z0nA6eH+W3D+FgxOPXezCak74vYAIO2W0Cv5vinIynZrStroo8zxXGLs2xhMwr
         JLwbw+nmh0xjA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6B1ACC433D7;
        Fri,  9 Dec 2022 03:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: net: Fix O=dir builds
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167055662042.24876.12916521521858694407.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Dec 2022 03:30:20 +0000
References: <20221206102838.272584-1-bjorn@kernel.org>
In-Reply-To: <20221206102838.272584-1-bjorn@kernel.org>
To:     =?utf-8?b?QmrDtnJuIFTDtnBlbCA8Ympvcm5Aa2VybmVsLm9yZz4=?=@ci.codeaurora.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, bjorn@rivosinc.com,
        lina.wang@mediatek.com, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, lkp@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  6 Dec 2022 11:28:38 +0100 you wrote:
> From: Björn Töpel <bjorn@rivosinc.com>
> 
> The BPF Makefile in net/bpf did incorrect path substitution for O=dir
> builds, e.g.
> 
>   make O=/tmp/kselftest headers
>   make O=/tmp/kselftest -C tools/testing/selftests
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: net: Fix O=dir builds
    https://git.kernel.org/netdev/net-next/c/17961a37ce40

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


