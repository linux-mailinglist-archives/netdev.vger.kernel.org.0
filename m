Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC3A616206
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 12:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiKBLuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 07:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiKBLuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 07:50:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37C028720
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 04:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3F742CE209F
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 11:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7BBB4C433D7;
        Wed,  2 Nov 2022 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667389815;
        bh=6W1V5t0bkW9UU0LWRsCYwGGh4NAAMz7GFA3MEnXEJRI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GCsNSsKsE+h+nOnrPsamu4TEY5fkEgEgA4sQDI//nrWjtxqrXQznseyULlo/LWBmS
         hpmUH/yjo2LnrFVasrfRGOZkFJXlBXBAymRm3pOPUb/nhaHH8SNMWH+jlh1cZ0VzhO
         9upBCpQDtZTxVKNjyRBWTYvGGAucYprKIGX7WI9/VhQMPz7IikdfGXEMahUf5E52in
         S0lBJGVSJRCY/hfsvGbXxXsubnL0gS22LOy6YUsk5jfPJhnTGL0BwtyFtIzLMoOukD
         5Q4FtJLY4FnHq9m0YwvNtRuwjny04zd4qkXZaC8R3eax2EuaUE55zTDp9qbXlg1XeH
         e1l1EA90Rc0CA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 62FC9C41620;
        Wed,  2 Nov 2022 11:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V7 net-next 1/2] net: wwan: t7xx: use union to group port type
 specific data
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166738981540.3925.13741131885340014451.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Nov 2022 11:50:15 +0000
References: <20221028153450.1789279-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20221028153450.1789279-1-m.chetan.kumar@linux.intel.com>
To:     Kumar@ci.codeaurora.org, M Chetan <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, linuxwwan@intel.com,
        linuxwwan_5g@intel.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Oct 2022 21:04:50 +0530 you wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> Use union inside t7xx_port to group port type specific data members.
> 
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> --
> v7:
>  * No change.
> v5,v6:
>  * Date correction.
> 
> [...]

Here is the summary with links:
  - [V7,net-next,1/2] net: wwan: t7xx: use union to group port type specific data
    https://git.kernel.org/netdev/net-next/c/fece7a8c65d1
  - [V7,net-next,2/2] net: wwan: t7xx: Add port for modem logging
    https://git.kernel.org/netdev/net-next/c/3349e4a48acb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


