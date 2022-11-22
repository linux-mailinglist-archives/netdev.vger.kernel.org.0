Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74908633D02
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbiKVNAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbiKVNAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:00:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E6C6204D;
        Tue, 22 Nov 2022 05:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE88DB81AE1;
        Tue, 22 Nov 2022 13:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF5E8C433D6;
        Tue, 22 Nov 2022 13:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669122015;
        bh=z0Fco7E4SfXTPOQY+lSeOyP+mLkBQwCTY7p/eqOFDes=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Krbaz0OWc26ozGEo3RbI1KOyoq2Z/CMVI0f/any9WUg2xzpQwSkxWO4i/TX8tcmZE
         W55cpnszlzHGTy1kEDmt4eShIUcQTb0seph4PyujRJOS+qOFvzwflPaT95R4Kt7JEy
         OiZtVYa+mH6KqBcOeArJ1LVUk0AWjBthuFHBUzTOZnPsTFUNnNjHlJZpEHOyJkYgVw
         pC+QYEMphHEIjj2rdHbE2efnhAvf/ZZfRmvW20s7XvTyGHpkRVVOd07OkUv377x9Jt
         ND8C0132ySGqS0Dz03NuF5zmQel8tde3gTv21zM2pSMh3Zbo1h6POZtjeJz/cH8qOL
         PFyk3+Gviuqlw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8273CE29F42;
        Tue, 22 Nov 2022 13:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: net: Add cross-compilation support for
 BPF programs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166912201552.5123.8530809477540331372.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 13:00:15 +0000
References: <20221119171841.2014936-1-bjorn@kernel.org>
In-Reply-To: <20221119171841.2014936-1-bjorn@kernel.org>
To:     =?utf-8?b?QmrDtnJuIFTDtnBlbCA8Ympvcm5Aa2VybmVsLm9yZz4=?=@ci.codeaurora.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, bjorn@rivosinc.com,
        lina.wang@mediatek.com, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 19 Nov 2022 18:18:41 +0100 you wrote:
> From: Björn Töpel <bjorn@rivosinc.com>
> 
> The selftests/net does not have proper cross-compilation support, and
> does not properly state libbpf as a dependency. Mimic/copy the BPF
> build from selftests/bpf, which has the nice side-effect that libbpf
> is built as well.
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: net: Add cross-compilation support for BPF programs
    https://git.kernel.org/netdev/net-next/c/837a3d66d698

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


