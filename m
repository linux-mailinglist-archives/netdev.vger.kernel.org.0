Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202B653F9FA
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 11:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238729AbiFGJkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 05:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbiFGJkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 05:40:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489EDCEBA8;
        Tue,  7 Jun 2022 02:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 070A0B81E77;
        Tue,  7 Jun 2022 09:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B45B8C385A5;
        Tue,  7 Jun 2022 09:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654594812;
        bh=0SyMDivUzEu0tDvgyTj2GJcUW+vtwcWEcGy75q++O74=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p/OPreIcuOwdsWc/MggVL/2zkf+gFgZldCm3LTmtaH92P5L2/oBEV0AJ7kebIM/ba
         +8+I6y17KRGwd522dcGxtWf/xpHdeqJBtHMyD4sXe2u0pdZjTc5oZTbTSRqBSxoeBt
         +2xjvt0wEeMihAgLECaCxHhflEr/74/h3YNvuxyvI/BBA1DNe8C5Fm3DoMrtzhBf22
         5sIe9r0wi8Ru9NHRD1EwFjOOM5XJalU/GFPsJnJOGwLfs+TEgJMSbdR24JbjRqnuVv
         XZK52m97u3BR7zTyf1l+XpNfnePZP9HL/PXC9oIxXDTGgdHGmj9JUaPsHrPO+A1xY8
         k9DSuKnTyAGjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9BD69E737EE;
        Tue,  7 Jun 2022 09:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: altera: Replace kernel.h with the necessary inclusions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165459481263.20204.14162751087523664869.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Jun 2022 09:40:12 +0000
References: <18731e4f6430100d6500d6c4732ee028a729c085.1654325651.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <18731e4f6430100d6500d6c4732ee028a729c085.1654325651.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     joyce.ooi@intel.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Sat,  4 Jun 2022 08:54:20 +0200 you wrote:
> When kernel.h is used in the headers it adds a lot into dependency hell,
> especially when there are circular dependencies are involved.
> 
> Replace kernel.h inclusion with the list of what is really being used.
> 
> While at it, move these includes below the include guard.
> 
> [...]

Here is the summary with links:
  - net: altera: Replace kernel.h with the necessary inclusions
    https://git.kernel.org/netdev/net-next/c/12de1ebd2ae3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


