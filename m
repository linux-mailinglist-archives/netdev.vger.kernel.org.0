Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365A06D0E12
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 20:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjC3SuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 14:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjC3SuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 14:50:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE950E050
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C5716217C
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 18:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD364C4339C;
        Thu, 30 Mar 2023 18:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680202218;
        bh=g061aUJvljjulHFokRqHYcj1E0+OZVAo/p09l72DH3g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F8ejELQ+kmnNAVKp7xEXTtsziKEtWv36T7KuXHhsHkWkCyO0M0TolamMYPeajzV8Y
         B7ZtPn8l19r2iKpK8A4rOUQwf3mZ5+O2119aYRC6yLv8UFCF8DV3T5eOF01RgKYh/r
         2wkLAPSMlwjhB92UCMhEO70CsEqeCBgGQqbWkmN3rCzJwUh2XzGBhJD25tMeqo4eX2
         75Yr4ClINDK2tjh43lV6zRrXl8/6j7/A5caODnBizx5PLSLul5mYbnHrZyI1/Jfgpa
         cmO+79oo45mondEBC8W4tH/hFzcWDuM1fG+PKSnIg+p7h/S2XW4U0/XwcP+ZT30Nva
         T5oZBXX651Ckw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 97BF7C41612;
        Thu, 30 Mar 2023 18:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/3] net: ethernet: mtk_eth_soc: fix flow block
 refcounting logic
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168020221861.6825.13155238714164252504.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Mar 2023 18:50:18 +0000
References: <20230330120840.52079-1-nbd@nbd.name>
In-Reply-To: <20230330120840.52079-1-nbd@nbd.name>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 30 Mar 2023 14:08:38 +0200 you wrote:
> Since we call flow_block_cb_decref on FLOW_BLOCK_UNBIND, we also need to
> call flow_block_cb_incref for a newly allocated cb.
> Also fix the accidentally inverted refcount check on unbind.
> 
> Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] net: ethernet: mtk_eth_soc: fix flow block refcounting logic
    https://git.kernel.org/netdev/net/c/8c1cb87c2a5c
  - [net,v2,2/3] net: ethernet: mtk_eth_soc: fix L2 offloading with DSA untag offload
    https://git.kernel.org/netdev/net/c/5f36ca1b841f
  - [net,v2,3/3] net: ethernet: mtk_eth_soc: add missing ppe cache flush when deleting a flow
    https://git.kernel.org/netdev/net/c/924531326e2d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


