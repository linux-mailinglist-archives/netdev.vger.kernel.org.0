Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7161E4C5437
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 07:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiBZGas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 01:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiBZGaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 01:30:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3372E5AA70;
        Fri, 25 Feb 2022 22:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48FD860CA0;
        Sat, 26 Feb 2022 06:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9C1F3C340F1;
        Sat, 26 Feb 2022 06:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645857011;
        bh=/K+I88kFOkeotgI9D4BFG3RofsTfjAhqd7KXqU4y6qw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Emu15xM8K5moMZczgPYnEUx4sphKNE03tKA6hoGeOp2h50mVmuvLrVND6cl1r0MfY
         kpnZRapYOs4yOsDze4Cwm3cJmEdU7dytrAuum3nYBhxPkkyE1YCS6V+SUvNWgPFpjB
         1zLPG+jkcsn/9AnnDTCrrMkhPAmrp67NPdyD8uAmrBQYB8OsiwlihauJ3pV6R4Tk0T
         um6cQP+m+oxacpR63vJ8Q0O29e8Vhmp0L15upjtGofU2NsgjlmtZEtfUtTDkzdob20
         HcIHBR8U97Qj/X7pNpYHknibN8SP9kLTdxk7GO7SwG7I+uEjM3xkvGgFLaXpHswigN
         Spd+TTVjEiObw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D41AEAC09B;
        Sat, 26 Feb 2022 06:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] stmmac: intel: Enable 2.5Gbps for Intel
 AlderLake-S
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164585701150.29742.14448723094715573192.git-patchwork-notify@kernel.org>
Date:   Sat, 26 Feb 2022 06:30:11 +0000
References: <20220225023325.474242-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20220225023325.474242-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 25 Feb 2022 10:33:25 +0800 you wrote:
> Intel AlderLake-S platform is capable of running on 2.5GBps link speed.
> 
> This patch enables 2.5Gbps link speed on AlderLake-S platform.
> 
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [net-next,1/1] stmmac: intel: Enable 2.5Gbps for Intel AlderLake-S
    https://git.kernel.org/netdev/net-next/c/23d743301198

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


