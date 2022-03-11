Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697124D5993
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 05:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346311AbiCKEbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 23:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346285AbiCKEbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 23:31:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6071A58E3
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 20:30:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80B5BB82A6B
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 04:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 30EABC340EE;
        Fri, 11 Mar 2022 04:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646973013;
        bh=B9AsmkPZgR2aDFifdoMbg2BP6eKU301pjBgrtWKes4E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H1tdSigJk3hd9adQOrboAFIWzuuc72Pt2OIcILV8FARUxBm/Q/uBqV9JZ6JR/WiWi
         qh/0Iw/p5oNq824/7C1PUy+G6iHQ1qwqMSy2R2qH+L4g1vhOeWH78d5uRGlIdWtnHq
         RHOa/BfruWj8+imphvSqjIvMhqALgxu7cQZU1Lmcbo3A7ZLl+wQDBstz0EeCY0lwnb
         RREklKSlrrykyzbCfHn73ddqo4aB9anvRaa/Qj7y4feLrukWm0oMRCMcUPRwsdCqV0
         3DTE77Eh+SrY2J+trVjywkTjkpSrs6t2QEfICVbpY5vrgWp2ipOBNalr19X9/0TY4V
         3F0+sXAZr3QMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0EE8CE6D3DD;
        Fri, 11 Mar 2022 04:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: xsk: fix a warning when allocating rx rings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164697301305.12732.4308493310640186191.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Mar 2022 04:30:13 +0000
References: <20220309135533.10162-1-simon.horman@corigine.com>
In-Reply-To: <20220309135533.10162-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, yinjun.zhang@corigine.com,
        niklas.soderlund@corigine.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  9 Mar 2022 14:55:33 +0100 you wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> Previous commits introduced AF_XDP zero-copy support, in which
> we need register different mem model for xdp_rxq when AF_XDP
> zero-copy is enabled or not. And this should be done after xdp_rxq
> info is registered, which is not needed for ctrl port, otherwise
> there complaints warnings: "Missing register, driver bug".
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: xsk: fix a warning when allocating rx rings
    https://git.kernel.org/netdev/net-next/c/87ed3de674c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


