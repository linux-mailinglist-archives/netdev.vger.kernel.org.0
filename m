Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91ACF65098F
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 10:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiLSJuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 04:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiLSJuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 04:50:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15638D2EA;
        Mon, 19 Dec 2022 01:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B348AB80BA3;
        Mon, 19 Dec 2022 09:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 687ECC43396;
        Mon, 19 Dec 2022 09:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671443416;
        bh=39AaLIEWFIQskMzhGuFVWOTbXa7X4viiTu8/D1DBPKg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nfkqsporUMPQNhz29OmGvmQ78isR14ALdzPoe++NxCx/KRWrJDHsqMsGgOcDqwB/z
         xe1gU70D2Z8fIzg3P4CyFOWEq28O/8oDh5FNcccSx9h5oRAv9p3RFZRDQOprc+PcTx
         wX7GmsKRYEY9R1pa0KE8qzJjQ8aF2PxlXJeRs/rYq+shFSuwor/7dvNbexpL1UAYGd
         AeKmyOH3rXrn/bM4/HjvPi5z9sLZaWkOSKF5UmLfZmOws3PaOmPr1KY5hGTuDhvZzQ
         I7o3hk+ixgteDGp0T+1dPQrFkl1Fm9vb/EUL7ppY/PDb041HEf6adAS1NA5a1gINB6
         lhoCof3dzUR7Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 53843E451B7;
        Mon, 19 Dec 2022 09:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] hamradio: baycom_epp: Do not use x86-specific rdtsc()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167144341633.12312.2432800353975438526.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Dec 2022 09:50:16 +0000
References: <20221218120405.2431-1-bp@alien8.de>
In-Reply-To: <20221218120405.2431-1-bp@alien8.de>
To:     Borislav Petkov <bp@alien8.de>
Cc:     t.sailer@alumni.ethz.ch, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Sun, 18 Dec 2022 13:04:05 +0100 you wrote:
> From: "Borislav Petkov (AMD)" <bp@alien8.de>
> 
> Use get_cycles() which is provided by pretty much every arch.
> 
> The UML build works too because get_cycles() is a simple "return 0;"
> because the rdtsc() is optimized away there.
> 
> [...]

Here is the summary with links:
  - hamradio: baycom_epp: Do not use x86-specific rdtsc()
    https://git.kernel.org/netdev/net-next/c/aba5b397cad7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


