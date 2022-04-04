Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAF04F143C
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 14:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbiDDMCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 08:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbiDDMCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 08:02:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB2034BAA;
        Mon,  4 Apr 2022 05:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9684BB8160F;
        Mon,  4 Apr 2022 12:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37741C3411B;
        Mon,  4 Apr 2022 12:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649073615;
        bh=qUidViL1LvhqdQqpS2FVmNOwiqg49fGf8cAlxjDQ3qI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fN8sCUeazir5IPtGfNoEkbMwx1QZQNzUj9gtq9xB3mDd5r2WoK8Qj3DCFTwPe8EkH
         nREXReexspqQYlTg7d2SnEuP4owi3CFCXusMxBAqN2AdhG0JZjfW3n97Uvbpu+YXmy
         nbd/zqz/AIPeioxzx4vGksDnUVoKHTEQB+Po5HjGA31Ne9cXR7hYqrcqegrmVivoKP
         Qz83X9nCm6yXdxCsy9H1PgqWLBGYypZtGTPJ0zUx1GOAOIVlRXYFR4N2Qma0CNmOHT
         jfv/kLKAaXR7Orx4wN/OaKPpFVRyJLqLUZfzoSs6iR+6xOOkp2/UHdQ6MPZKY31Lih
         Ez2gRSUrk5nNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 199CCE85B8C;
        Mon,  4 Apr 2022 12:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] stmmac: dwmac-loongson: change loongson_dwmac_driver from
 global to static
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164907361510.19769.8704118113413570807.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Apr 2022 12:00:15 +0000
References: <20220403140202.2191516-1-trix@redhat.com>
In-Reply-To: <20220403140202.2191516-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun,  3 Apr 2022 10:02:02 -0400 you wrote:
> Smatch reports this issue
> dwmac-loongson.c:208:19: warning: symbol
>   'loongson_dwmac_driver' was not declared.
>   Should it be static?
> 
> loongson_dwmac_driver is only used in dwmac-loongson.c.
> File scope variables used only in one file should
> be static. Change loongson_dwmac_driver's
> storage-class-specifier from global to static.
> 
> [...]

Here is the summary with links:
  - stmmac: dwmac-loongson: change loongson_dwmac_driver from global to static
    https://git.kernel.org/netdev/net/c/2baed4f9b085

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


