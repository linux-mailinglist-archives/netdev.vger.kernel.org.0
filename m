Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7DE96F0D26
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 22:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344246AbjD0UaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 16:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344203AbjD0UaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 16:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B032137;
        Thu, 27 Apr 2023 13:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D236563F9B;
        Thu, 27 Apr 2023 20:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E8E4C433EF;
        Thu, 27 Apr 2023 20:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682627420;
        bh=24+VeYb6T1HFq5slOW08jZBYoMoL09riRKeWSl9l4fw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eeueGLik8VI+eJ0ZEr/XqtVsKbAzc8EADDE48BRLYguiMOdXsaSUXMYgeHT0Zy9km
         T07nmKpZgmQPMTr2emCg1dpWmVQKPXFMpZMpwzIWXYjGKECCBuZuKwF8tMd57Dprf6
         NftzojSxUchoMYm/pdF3VZ189sntw1rje+Zxngo4JC2IUjMmBa2MFwji8GP0B0FabT
         IS7FW3sWMrBF+EO6aRWUArAaSjX8lPxTznC+ZFUdltm0cFvO0JHztUzCcoTlN0OisT
         wZ2rdxsMv4gdUdTGTP5trrOu2zz6pZjxpLo2iMk61ykqLpcLKMnu3vTSfxj+qsxtQi
         xof7JXbYy+eMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 08E3CE5FFC8;
        Thu, 27 Apr 2023 20:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] xsk: Use pool->dma_pages to check for DMA
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168262742003.5696.300971021135194454.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Apr 2023 20:30:20 +0000
References: <20230423180157.93559-1-kal.conley@dectris.com>
In-Reply-To: <20230423180157.93559-1-kal.conley@dectris.com>
To:     Kal Cutter Conley <kal.conley@dectris.com>
Cc:     bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Sun, 23 Apr 2023 20:01:56 +0200 you wrote:
> Compare pool->dma_pages instead of pool->dma_pages_cnt to check for an
> active DMA mapping. pool->dma_pages needs to be read anyway to access
> the map so this compiles to more efficient code.
> 
> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next] xsk: Use pool->dma_pages to check for DMA
    https://git.kernel.org/bpf/bpf-next/c/6ec7be9a2d2b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


