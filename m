Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75D656188B
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbiF3KuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbiF3KuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:50:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D763826ACF;
        Thu, 30 Jun 2022 03:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7431662290;
        Thu, 30 Jun 2022 10:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0112C341CA;
        Thu, 30 Jun 2022 10:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656586212;
        bh=o3A7DYU5awU1d/z9r3oEioXza8+hckAhRjRc0+BAcL0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ufRIvNi+Np3POCiyPs//7ux51eRVUl8rCtB8Q7ANKrVWnIXmmgCBFCAKH2fG3M9/8
         iMOW6WWtDtWqecszTgOQvfFcQsB2csrWMcevdP62PZcnZ4ER6YFTQpn/tUYYoYjQFK
         ++5kLbFVoeIRuixfJZ7PnN3nq9wi+OujaBZunxvYnYo0mCCq4bOwjMgr7uZxF98JpN
         OR5vvyELYZIzBaVEObaMVD/gnbF6ERNDXZmPvMpLNWJSv3+1gRCFQTiJ5C3AEiglDV
         fbJrKgwJ0S2RF7+i7KsBj/it3vCngShv1FJZYZgDFzXcBCtfVTqcQ8pUAqYi+kyETO
         EPMyw11A80XFw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B12DDE49BBB;
        Thu, 30 Jun 2022 10:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] atheros/atl1c:fix repeated words in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165658621272.26569.8259852406347498555.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 10:50:12 +0000
References: <20220629081632.54445-1-yuanjilin@cdjrlc.com>
In-Reply-To: <20220629081632.54445-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 29 Jun 2022 16:16:32 +0800 you wrote:
> Delete the redundant word 'slot'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>  drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - atheros/atl1c:fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/d19b4c52f7c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


