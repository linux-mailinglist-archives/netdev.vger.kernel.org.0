Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 570976E8386
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 23:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbjDSVVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 17:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232657AbjDSVVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 17:21:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E54AF0B
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 14:21:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA994642D1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 21:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D283C433A4;
        Wed, 19 Apr 2023 21:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681939219;
        bh=KpJ7XLsKKnBeLIGXWBpEZvcr7RBJ8U6CRvk+kbdj2FM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IOczVSTjvuXz33dWcCnL5zmmF6kqTdVGxM7pLhWZDJ/1T3eHCwLbWacjiy95Kk4/R
         R73Ygcp3EDmFdmlY9d1v4f1ZGdyUPYCnGigkkMBVgjDvwV2IKuIaLbSzHLDyhnm+xA
         5LYnPvFFWvlhoDU9LFJ7r1635lRrJcvxjS87LxBvGbPdqszxwpDmSn2LVj376Et2VE
         93e7fEVGjpA91sJXQBCYlhcl7oCNEbPH3/vlaiC4w2cmFTR4k5Dw1vv7Q3yFjdjlOH
         bl4pzTiPqOM6KFmvLR9pY+iMdg5KTgCweLMmnKrQUlt+ax2nklWt1Rfp6yusKTKOhJ
         tm/HGw/HIPjzw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 19FE9E4D033;
        Wed, 19 Apr 2023 21:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] page_pool: add DMA_ATTR_WEAK_ORDERING on all
 mappings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168193921910.10989.972039174371061274.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Apr 2023 21:20:19 +0000
References: <20230417152805.331865-1-kuba@kernel.org>
In-Reply-To: <20230417152805.331865-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, michael.chan@broadcom.com, hawk@kernel.org,
        ilias.apalodimas@linaro.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 17 Apr 2023 08:28:05 -0700 you wrote:
> Commit c519fe9a4f0d ("bnxt: add dma mapping attributes") added
> DMA_ATTR_WEAK_ORDERING to DMA attrs on bnxt. It has since spread
> to a few more drivers (possibly as a copy'n'paste).
> 
> DMA_ATTR_WEAK_ORDERING only seems to matter on Sparc and PowerPC/cell,
> the rarity of these platforms is likely why we never bothered adding
> the attribute in the page pool, even though it should be safe to add.
> 
> [...]

Here is the summary with links:
  - [net-next] page_pool: add DMA_ATTR_WEAK_ORDERING on all mappings
    https://git.kernel.org/netdev/net-next/c/8e4c62c7d980

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


