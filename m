Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698516C423D
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 06:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjCVFkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 01:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjCVFkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 01:40:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83B41258F;
        Tue, 21 Mar 2023 22:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63B80B81B73;
        Wed, 22 Mar 2023 05:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0312FC4339C;
        Wed, 22 Mar 2023 05:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679463619;
        bh=YrKBCjQNcJ4f2rJkrtSBAF6Ozw/HGSPyJag5zYV3isI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DXXc19iFJZoheKTCLlaqQM+rfFwPK0XNqSpd4xLRw0cLu5vjwUuzT37BwJLNaBuU/
         vHt4Apv0rvEoW3cREjLqV+TTyr82z8niQ2uXA0Eo7VFYmg2DsOacZCgQvLSffs0Qc5
         +Xu960RXa8/2YMpboNkYmV+H4HQWHkEV2ZK10qbu2PWCE5tyOMsHHc28lwXMh+mUOQ
         Ce9eOR1+WC3ppypR7ezdqdMUOKTy1nfpRV4bzVG+HfxNrPSVpJhBxj/ZVoEQ0M+B3Q
         zjiUDha+5BkGt3HqiOSJgDpy7b346yZ6qyQMqla5eENi0Lb14yArmRCnGOBuFkClYW
         7uBlrC3aza3Ag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DC074E52513;
        Wed, 22 Mar 2023 05:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: atheros: atl1c: remove unused atl1c_irq_reset function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167946361889.17510.2656366855499005981.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Mar 2023 05:40:18 +0000
References: <20230320232317.1729464-1-trix@redhat.com>
In-Reply-To: <20230320232317.1729464-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com, yuanjilin@cdjrlc.com,
        liew.s.piaw@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 20 Mar 2023 19:23:17 -0400 you wrote:
> clang with W=1 reports
> drivers/net/ethernet/atheros/atl1c/atl1c_main.c:214:20: error:
>   unused function 'atl1c_irq_reset' [-Werror,-Wunused-function]
> static inline void atl1c_irq_reset(struct atl1c_adapter *adapter)
>                    ^
> This function is not used, so remove it.
> 
> [...]

Here is the summary with links:
  - net: atheros: atl1c: remove unused atl1c_irq_reset function
    https://git.kernel.org/netdev/net-next/c/f6f4e739b164

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


