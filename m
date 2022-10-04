Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4411F5F3C4B
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 07:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiJDFAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 01:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJDFAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 01:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1AF16599
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 22:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37AF9B818FF
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 05:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C600DC433D7;
        Tue,  4 Oct 2022 05:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664859614;
        bh=EP3X0TJXObpJ+sKOMTc+NvIF8zNzfGDpcowDqGsAn8Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Wv/IKlnJJWMCBRjTwWvOB1WEVJ4udAoFSF1oTAUFBquytyu4sDo6LLU+L/V5teQWB
         IYSkHUIyKWEfP4uCsGMnz4fRLLa+ItBE87t5f1zJDAdEzovql5xgHCoeaoCkLPC5i2
         qm3QrSpL3fyu/qSo/nQB5f7zt6tCsEBnmM/1TsL2bdYohL9Oy4Pst+pbGwUfY8Vivc
         NVSgKuY66Qo04svC3OfGolTL9CjhQXKnII9Vf/VWUlCbd1Ie0G5JLHVcvdD0+k6+ID
         9k0mYAuWBnPooyi8P6uvIyScmpiLHm6s4U6TBKCqY+0JexeoTF9fdfIv8lKXOdk387
         csCVRlxYXnsJA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AACD9E49FA3;
        Tue,  4 Oct 2022 05:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] eth: pse: add missing static inlines
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166485961469.21231.228944158609233581.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Oct 2022 05:00:14 +0000
References: <20221004040327.2034878-1-kuba@kernel.org>
In-Reply-To: <20221004040327.2034878-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, lkp@intel.com, linux@rempel-privat.de,
        andrew@lunn.ch, bagasdotme@gmail.com
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

On Mon,  3 Oct 2022 21:03:27 -0700 you wrote:
> build bot reports missing 'static inline' qualifiers in the header.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 18ff0bcda6d1 ("ethtool: add interface to interact with Ethernet Power Equipment")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: linux@rempel-privat.de
> CC: andrew@lunn.ch
> CC: bagasdotme@gmail.com
> CC: lkp@intel.com
> 
> [...]

Here is the summary with links:
  - [net-next] eth: pse: add missing static inlines
    https://git.kernel.org/netdev/net-next/c/681bf011b9b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


