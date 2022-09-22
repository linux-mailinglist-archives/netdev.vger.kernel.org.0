Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F5F5E5FE2
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 12:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbiIVKaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 06:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiIVKaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 06:30:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3BDAE9EF;
        Thu, 22 Sep 2022 03:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC0CAB835B1;
        Thu, 22 Sep 2022 10:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C87BC433C1;
        Thu, 22 Sep 2022 10:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663842614;
        bh=DmUcH2oVcZ3VNoG9feN3+bAOAOPXwAkRWQY5zkCT7qM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dJCFjXVFu93BvAI0cryh4uu9FfoZGqi/oOvhHeqif+zR8VCJIvMNtj9PeGViCMd1L
         uNojopag88WnEPBKwssv2tN508gkKIJxDy8SCSLf0XOwiyW3lXBagCEGkfFyOqVJXG
         jxCweI/0Rp49JWNuxVtsvBN1JenFk/gan5A1NV3WfKOPfXLe4NsO846W/aXQ77oCu+
         BMT+XCF829gUFGHXGgIkNrE40ERLd9PnZfJFD3mmK+be+8hyYHxYPRZH9NcPFG1jQa
         T0igAoMC1ahPXcORwwYFv6xYbWpVsHPfiiQJVcixAPd6oVNcQcVUBNln0bXBz1GKys
         59bumFnA5PV6A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 603A3E4D03D;
        Thu, 22 Sep 2022 10:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: ethernet: altera: TSE: fix error return code in
 altera_tse_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166384261438.4637.5269022548388381069.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 10:30:14 +0000
References: <20220920020041.2685948-1-sunke32@huawei.com>
In-Reply-To: <20220920020041.2685948-1-sunke32@huawei.com>
To:     Sun Ke <sunke32@huawei.com>
Cc:     joyce.ooi@intel.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        maxime.chevallier@bootlin.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 20 Sep 2022 10:00:41 +0800 you wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: fef2998203e1 ("net: altera: tse: convert to phylink")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Sun Ke <sunke32@huawei.com>
> 
> [...]

Here is the summary with links:
  - [v3] net: ethernet: altera: TSE: fix error return code in altera_tse_probe()
    https://git.kernel.org/netdev/net-next/c/9b17dbd97de7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


