Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D840261F1DD
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 12:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbiKGLaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 06:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiKGLaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 06:30:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F860F3D;
        Mon,  7 Nov 2022 03:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59F83B8101F;
        Mon,  7 Nov 2022 11:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7564C433D7;
        Mon,  7 Nov 2022 11:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667820616;
        bh=cb5dwF1IkVJGTe7DJ/2CzobyMHYTx1Umgpq8tkUo5gg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fctU8VtyolVdVacrOmVTViNNfTvD18i913KCEdGAPe+oFAn8E9NNd6N0CNdHqxMid
         9hEE7yUBTiDemhThutRDgauAD5EfUaU+EPnOf3uE7Vyqy8Su4H/ofWS/Bzu2CbDJ3N
         GVX1tg1dTF34tDFUbiZdylq/aTP9yLXMHCbqkM9vdMaOVT6xqE0PlQofCw6yglsSKH
         lRPlppywZwhAaY9WudtVoBXGKDiKt5lbmKZM85b9X344jUPEpPRg4c3Ah2EVUY6gX7
         Gha9XdBmnl/zkDb9am1IIhBRTQ41VNdmrGSAgu/8yELjliCzOFnxuIvGElaQ43h+WN
         LgjJjGQA0lS9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA490C41671;
        Mon,  7 Nov 2022 11:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/3] s390/ctcm: Fix return type of ctc{mp,}m_tx()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166782061582.15100.14489619331442535139.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Nov 2022 11:30:15 +0000
References: <20221103170130.1727408-1-nathan@kernel.org>
In-Reply-To: <20221103170130.1727408-1-nathan@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     wintera@linux.ibm.com, wenjia@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        ndesaulniers@google.com, trix@redhat.com, keescook@chromium.org,
        samitolvanen@google.com, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
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

On Thu,  3 Nov 2022 10:01:28 -0700 you wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
> [...]

Here is the summary with links:
  - [v2,1/3] s390/ctcm: Fix return type of ctc{mp,}m_tx()
    https://git.kernel.org/netdev/net-next/c/aa5bf80c3c06
  - [v2,2/3] s390/netiucv: Fix return type of netiucv_tx()
    https://git.kernel.org/netdev/net-next/c/88d86d18d7cf
  - [v2,3/3] s390/lcs: Fix return type of lcs_start_xmit()
    https://git.kernel.org/netdev/net-next/c/bb16db839365

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


