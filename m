Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5846623B23
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 06:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbiKJFKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 00:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKJFKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 00:10:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BD62BB2E;
        Wed,  9 Nov 2022 21:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21A95B8204E;
        Thu, 10 Nov 2022 05:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 972E1C433B5;
        Thu, 10 Nov 2022 05:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668057014;
        bh=IO33j7RZWmfOCG9e737qUHjjkTadcYqtqmj67eSTiro=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mNjf+3OmVfNcmV+2vld3EA+prXI1LhyxuegLJFRzUDNQ58CR87C0OsSf/Yu5vV8t/
         TROV7HdYidp9NMH4npk9PXgNTm1Dt7Z0f+3exHWPgOnsKTii8ENxJKEvZwd2ZAmNZ9
         0iWc6nUNPgWpmov1ARu4/DX8I/LG11I3V5T0FzI2x2NOb7o+obyUDg51pdsL5hmFtK
         /8Ca+vsmjPieo39w4aeixAjx8R3s2FGg6htyis45x0AExGyVoRDvFpvx7dgSdLKHpD
         8BzExZvsQrnKUHMltE0q0IDfaABT9UkqPfFlgqVyVSu/oXbc+uwzE3IPJhQPOr2BQB
         ESxwcbmE5NePw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 800DDE21EFF;
        Thu, 10 Nov 2022 05:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [0/1 bpf-next] fix panic bringing up veth with xdp progs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166805701452.8788.5070214676768918519.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 05:10:14 +0000
References: <20221108221650.808950-1-john.fastabend@gmail.com>
In-Reply-To: <20221108221650.808950-1-john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.net, kuba@kernel.org, davem@davemloft.net,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
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
by Martin KaFai Lau <martin.lau@kernel.org>:

On Tue,  8 Nov 2022 14:16:49 -0800 you wrote:
> Not sure if folks want to take this through BPF tree or networking tree.
> I took a quick look and didn't see any pending fixes so seems no one
> has noticed the panic yet. It reproducible and easy to repro.
> 
> I put bpf in the title thinking it woudl be great to run through the
> BPF selftests given its XDP triggering the panic.
> 
> [...]

Here is the summary with links:
  - [1/1,bpf-next] bpf: veth driver panics when xdp prog attached before veth_open
    https://git.kernel.org/bpf/bpf-next/c/5e5dc33d5dac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


