Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838B6536D4C
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 16:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236596AbiE1OaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 10:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234642AbiE1OaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 10:30:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1880318E09;
        Sat, 28 May 2022 07:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6E37B82756;
        Sat, 28 May 2022 14:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84DFAC34118;
        Sat, 28 May 2022 14:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653748211;
        bh=hEKQLCPp4VODteRKZhgYlzDwy/YWNyvsmJjZhfDrYK0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oJkFXgbYjjOkb90yYES4xBVEkBv01ffRG4eblilCBE7ySehdJcsOgLMW0PtTVypNL
         1Fzl4X4yjJriYpXxv6jMyTBgjkab6cEjw0s90FIXv4scK7bpwmcntLhLeo+cJsSbIZ
         rMOVDaUCvjMzLGjTP5MLMO2hPOL2A91twVh3Dbg2+5YSnCus51ouBUwMVSEDcY1EaR
         eq8GmXvt4i7NyInW8y2sIoKkDbhoIp45upKFCYYUEwhE7JRrk/RPCGknYc9fxNYRBP
         9xirWbmBlALuAh0mvB73yrFuIhwOKpUWwFYB2mM2hQwNwp3a+QxAtt6M8kNl4T/kGf
         TPPxgWOeS8ECA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6C9DBF0394D;
        Sat, 28 May 2022 14:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: nfc: Directly use ida_alloc()/free()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165374821144.9964.14407131834890855073.git-patchwork-notify@kernel.org>
Date:   Sat, 28 May 2022 14:30:11 +0000
References: <20220527064225.2358248-1-liuke94@huawei.com>
In-Reply-To: <20220527064225.2358248-1-liuke94@huawei.com>
To:     Ke Liu <liuke94@huawei.com>
Cc:     krzysztof.kozlowski@linaro.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 27 May 2022 06:42:25 +0000 you wrote:
> Use ida_alloc()/ida_free() instead of deprecated
> ida_simple_get()/ida_simple_remove() .
> 
> Signed-off-by: keliu <liuke94@huawei.com>
> ---
>  net/nfc/core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - net: nfc: Directly use ida_alloc()/free()
    https://git.kernel.org/netdev/net/c/911799172d2f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


