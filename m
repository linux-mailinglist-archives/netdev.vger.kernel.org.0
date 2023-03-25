Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0C36C8A39
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 03:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbjCYCU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 22:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbjCYCUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 22:20:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03E86A60;
        Fri, 24 Mar 2023 19:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C24EB826E2;
        Sat, 25 Mar 2023 02:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6C1EC433A8;
        Sat, 25 Mar 2023 02:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679710818;
        bh=jiplVCNriojy+nf2WdLXtsmNZPWEOshG+t98bcIRQtU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KgKQz3i5iTHd6n0XBO6foofCGe5I9Ut73E3BfRBM0SiI/hcSxSrKCmM3thlNP8P+F
         BesCv+7B7ML6O5TBjkQtIs2kASr6NDzDNBwcSET4TrK/r3TgvFKcrRP5lDhIaABt3d
         LNdGHKoGCcQ1OsMK3Fo59+Mti/Z85kynkNmtm6UrGPq0ViflN81sQel6S8YvcUgAXD
         3qVUGRl0XcgBgXnDh93dIEfABUTqMpw6l9kkvcFoAFGKPqmp6m8h1/kNzYsEmTTEiK
         DhPmq8iKMqEjUrFRk/4oPiT90MGjPKY2HshBdk3yT5d1KH3Lz3bjiLxZPdn+z/7PDD
         2WboU1NgRlMbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2F68C41612;
        Sat, 25 Mar 2023 02:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mISDN: remove unused vpm_read_address and cpld_read_reg
 functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167971081886.20950.372072594002078226.git-patchwork-notify@kernel.org>
Date:   Sat, 25 Mar 2023 02:20:18 +0000
References: <20230323161343.2633836-1-trix@redhat.com>
In-Reply-To: <20230323161343.2633836-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     isdn@linux-pingi.de, nathan@kernel.org, ndesaulniers@google.com,
        yangyingliang@huawei.com, alexanderduyck@fb.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, simon.horman@corigine.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Mar 2023 12:13:43 -0400 you wrote:
> clang with W=1 reports
> drivers/isdn/hardware/mISDN/hfcmulti.c:667:1: error: unused function
>   'vpm_read_address' [-Werror,-Wunused-function]
> vpm_read_address(struct hfc_multi *c)
> ^
> 
> drivers/isdn/hardware/mISDN/hfcmulti.c:643:1: error: unused function
>   'cpld_read_reg' [-Werror,-Wunused-function]
> cpld_read_reg(struct hfc_multi *hc, unsigned char reg)
> ^
> 
> [...]

Here is the summary with links:
  - mISDN: remove unused vpm_read_address and cpld_read_reg functions
    https://git.kernel.org/netdev/net-next/c/2d08f3e128b1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


