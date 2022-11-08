Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E486206C2
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 03:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbiKHCaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 21:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbiKHCaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 21:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BE512AF1;
        Mon,  7 Nov 2022 18:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C28A96140D;
        Tue,  8 Nov 2022 02:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25051C433B5;
        Tue,  8 Nov 2022 02:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667874616;
        bh=ZdeUYCNwdRpZ5Ec70aBWa2rKZwVGD/HrfJDuOBF1dF4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h5KYIANNMcf+P/+g5IYlVK619zt41lyiHlx9es3Z9i+pKMTPxMvfyb/ywddCt3gK4
         FDBdAenyTOfXsUK8hsQYiG/to4pi6WnqBr+hiJkPR5iMPXPdgmOVAJxNhKOaFUkHvP
         5KsJR4HXxndBgHevd3wuwKA3NCWbpTdHCi32udzioqX3H+/tV3sk/s7h13sGjx/vnG
         M0/exoLktOlVHOmes7Qi4AWwsLI/gMZHdesJLXnLmEKFY9rFr8dBVaRV5nGl/FPGHS
         6V0g4PVkSRXXccxZ6rIuFOaTBkOue+VKufJklHy0PRiabIeSst/sZMtVnG4D4a22bR
         Xty/YFpUc8aXQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 11E64E270D1;
        Tue,  8 Nov 2022 02:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: macb: implement live mac addr change
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166787461606.16737.5486770471731040240.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 02:30:16 +0000
References: <20221104204837.614459-1-roman.gushchin@linux.dev>
In-Reply-To: <20221104204837.614459-1-roman.gushchin@linux.dev>
To:     Roman Gushchin <roman.gushchin@linux.dev>
Cc:     netdev@vger.kernel.org, claudiu.beznea@microchip.com,
        nicolas.ferre@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  4 Nov 2022 13:48:37 -0700 you wrote:
> Implement live mac addr change for the macb ethernet driver.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  drivers/net/ethernet/cadence/macb_main.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: macb: implement live mac addr change
    https://git.kernel.org/netdev/net-next/c/14ef5c39891e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


