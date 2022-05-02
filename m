Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA29C517956
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 23:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238654AbiEBVoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 17:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387851AbiEBVoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 17:44:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40D31B5
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 14:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2726260FE4
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 21:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72B1DC385AC;
        Mon,  2 May 2022 21:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651527611;
        bh=zD9wYlpVxK4yEFKuMEdXqEiEOG2vO7qZBPfy87GiFdk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RPZoyhyCRKnWK6KAkSI7wc38LQCOdLbbvWP6e3RcClIxP0CN0rMBAMalZbavhR7TP
         OZ8QLg5ihwZM51jSjEJ2NzZDjoEATJuBThUejILhxxTyLRp/N+btHL7ZC54QL0P/n2
         hK/H0wzjNf/VCWSeqkAGeznO9Ex22WY/fU65wQ2O04kW2Sa9q6ioq/GBv4dsNbG+IY
         DQbrfr+o/5qDlOfnseJrSP9ThWKd23iOhIr3vBF7l2gxjKPHR8uUbk/K0/XyZIrTbs
         TTcF6xdYX97A6RqxwLkWXWO4a8Jx2bLCzYpjAqSpk+XX7YrxhwGceqMCrvWbVO5Ezn
         IXSvOFiohCyhw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4C295E8DBDA;
        Mon,  2 May 2022 21:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] octeontx2-af: debugfs: fix error return of allocations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165152761130.17258.7951991990194173640.git-patchwork-notify@kernel.org>
Date:   Mon, 02 May 2022 21:40:11 +0000
References: <20220430194656.44357-1-dossche.niels@gmail.com>
In-Reply-To: <20220430194656.44357-1-dossche.niels@gmail.com>
To:     Niels Dossche <dossche.niels@gmail.com>
Cc:     netdev@vger.kernel.org, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, hkelam@marvell.com,
        sbhatta@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hkalra@marvell.com,
        cjacob@marvell.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 30 Apr 2022 21:46:56 +0200 you wrote:
> Current memory failure code in the debugfs returns -ENOSPC. This is
> normally used for indicating that there is no space left on the
> device and is not applicable for memory allocation failures.
> Replace this with -ENOMEM.
> 
> Fixes: 0daa55d033b0 ("octeontx2-af: cn10k: debugfs for dumping LMTST map table")
> Fixes: 23205e6d06d4 ("octeontx2-af: Dump current resource provisioning status")
> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] octeontx2-af: debugfs: fix error return of allocations
    https://git.kernel.org/netdev/net-next/c/0b9f1b265ee1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


