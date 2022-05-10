Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00DC5211DA
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 12:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239545AbiEJKOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 06:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiEJKOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 06:14:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED102AACE2;
        Tue, 10 May 2022 03:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A7DCB81CA7;
        Tue, 10 May 2022 10:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A1F7C385C9;
        Tue, 10 May 2022 10:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652177412;
        bh=MnaoeGPz7Fq2odEZkhukT5d1h8HFw1tYwdSDDAv0T7s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OMouXlySYEfnIqHyGLcom88RQP+8TUtqR3KeltArziPJPFhn7guAdtq+JU/7XzFfc
         d4r6WdYrY3h0cvh2ZDMT6a019xEo+SuN/TwyJG6zV6Cd1N4RFQ7alqi0xiOA203SqA
         RxYg7pVRJ6GzgbfzuNmgGPMhcLCXcG+nZHsHkWvCNWP7umVUvzMYbZp2F6CARH7llH
         YbHlsTy7JVOExCJ9RwWon9TaO/aYqnJJ0O5GOKovvn1lhAtLosyU0ZnhbQWCe5F2A5
         q66VsG+0VqFlhLx875Gy58+1J7KJBxgUZJdzpOoH7X352mI32ahDWCyfHjCiYeODhf
         sPJ+vkBNZFdBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2DFD6F03876;
        Tue, 10 May 2022 10:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x25: remove redundant pointer dev
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165217741218.27960.5224636019366457113.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 10:10:12 +0000
References: <20220508214500.60446-1-colin.i.king@gmail.com>
In-Reply-To: <20220508214500.60446-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     ms@dev.tdt.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Sun,  8 May 2022 22:45:00 +0100 you wrote:
> Pointer dev is being assigned a value that is never used, the assignment
> and the variable are redundant and can be removed. Also replace null check
> with the preferred !ptr idiom.
> 
> Cleans up clang scan warning:
> net/x25/x25_proc.c:94:26: warning: Although the value stored to 'dev' is
> used in the enclosing expression, the value is never actually read
> from 'dev' [deadcode.DeadStores]
> 
> [...]

Here is the summary with links:
  - x25: remove redundant pointer dev
    https://git.kernel.org/netdev/net-next/c/ecd17a87eb78

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


