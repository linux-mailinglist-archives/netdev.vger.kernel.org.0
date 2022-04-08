Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6277E4F9388
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 13:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbiDHLMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 07:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbiDHLMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 07:12:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BBD1AF3E;
        Fri,  8 Apr 2022 04:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70A4561F70;
        Fri,  8 Apr 2022 11:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C502AC385A1;
        Fri,  8 Apr 2022 11:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649416218;
        bh=U5QxndAG2nFRPxoNl+peZKZcg6U9u4gTa5L//g70nk4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bDAj3cTYKX3M+505jqnV3MZJc2Bu0wJHsLfzVepwBQFganBiB9SAaze2LlJMQQHC6
         qA2vFOcb+d8lqGFzp7cn1uV9jdyJE4dux6r1Q1r+As2hm83EDDtJGXrLdznREGugoq
         kHEj+ej41uBxTH86q38LMZYaxvlMKlDZwinLtiNzCr7BMLHCDy8cegAL7R1xsam/zZ
         gaytSvb1iyyzaPFsizV0Yy7dafwwCVIFXJC+Ta75RfWCfJDt6tYuyRDBI/WzU16X57
         3/ql2OpX7czuulfG26Pmeevu5P8th1K+et9imRsu+/AYisodT6n/Aq3Ftz6lOAtNpT
         kDkv/MMtU96bA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9A31FE85BCB;
        Fri,  8 Apr 2022 11:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: atm: remove the ambassador driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164941621862.19376.14956904760944872806.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 11:10:18 +0000
References: <20220406041627.643617-1-kuba@kernel.org>
In-Reply-To: <20220406041627.643617-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        arnd@kernel.org, myxie@debian.org, jj@chaosbits.net,
        dan.carpenter@oracle.com, 3chas3@gmail.com,
        linux-atm-general@lists.sourceforge.net, tsbogend@alpha.franken.de,
        linux-mips@vger.kernel.org, p.zabel@pengutronix.de
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  5 Apr 2022 21:16:27 -0700 you wrote:
> The driver for ATM Ambassador devices spews build warnings on
> microblaze. The virt_to_bus() calls discard the volatile keyword.
> The right thing to do would be to migrate this driver to a modern
> DMA API but it seems unlikely anyone is actually using it.
> There had been no fixes or functional changes here since
> the git era begun.
> 
> [...]

Here is the summary with links:
  - [net-next] net: atm: remove the ambassador driver
    https://git.kernel.org/netdev/net-next/c/e05afd0848f8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


