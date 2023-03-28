Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B445C6CB451
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 04:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjC1Cu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 22:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbjC1CuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 22:50:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6385226A2;
        Mon, 27 Mar 2023 19:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B16E7B81A43;
        Tue, 28 Mar 2023 02:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64FC0C433D2;
        Tue, 28 Mar 2023 02:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679971819;
        bh=aQDi9ckmCb/RBFxUSwC2YEMEUG9O2Ay2bDiRKwbkDLM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TZ3QLfBeNv3xH9ry2owvom4TXFodO4NkcSldllsjNlTDctwgsMevafxx5+a1qBsSg
         lKp0OoxFJPX34ElfgiNrWN/bphDZzb/tQjT/5yhfw5UGqNa/pKx01dO5U5nGpWttDf
         sQbIurqwfZ5UQ1zJ2CCVR41K78mzYxYFc8wKSV8pmIMPGTXfHDPwbbLDhT0Q+XlHf0
         R4onTLr2yG+yQTFrpT5UQuGAJMKYuBBHCLluRX0GPOhcfvJxmcBouJmUezvalzyxe7
         W0okBFGgbJHK0953MbAiOlQo37fUBdjIWWzbuIhcpjKOfKPVpRdtPSBBmkPWMc5QGX
         BJAiL/+YRsVxg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 48970E4D02F;
        Tue, 28 Mar 2023 02:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qed: remove unused num_ooo_add_to_peninsula variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167997181929.12698.4724410106148898115.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Mar 2023 02:50:19 +0000
References: <20230326001733.1343274-1-trix@redhat.com>
In-Reply-To: <20230326001733.1343274-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, ndesaulniers@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 25 Mar 2023 20:17:33 -0400 you wrote:
> clang with W=1 reports
> drivers/net/ethernet/qlogic/qed/qed_ll2.c:649:6: error: variable
>   'num_ooo_add_to_peninsula' set but not used [-Werror,-Wunused-but-set-variable]
>         u32 num_ooo_add_to_peninsula = 0, cid;
>             ^
> This variable is not used so remove it.
> 
> [...]

Here is the summary with links:
  - qed: remove unused num_ooo_add_to_peninsula variable
    https://git.kernel.org/netdev/net-next/c/2bcc74ffd21a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


