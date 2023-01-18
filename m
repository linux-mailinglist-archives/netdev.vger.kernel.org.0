Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8272672012
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 15:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbjAROrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 09:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbjAROrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 09:47:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FDF4589E;
        Wed, 18 Jan 2023 06:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA5426186B;
        Wed, 18 Jan 2023 14:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15F81C433F2;
        Wed, 18 Jan 2023 14:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674052818;
        bh=UvBEJhtTG1NYHyz0Fk7u/xtiyjVh26l+pTdi9ikJmaY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b8d/7f5QApViKtzSIbHytBeFZ/qui1onZvNdo+iLDLJyMqZ5Np7wi1RJhv4lSY/qa
         XMeQSOxz+VWYWkq+eGxoJfRLRRJEEQijZ2yEj0YIne2StV7uwKPiXpBmNwiOV1BjUk
         oXYvRD2PcEJvBBX7Grd3DqRX5PsYgzOUh1wSrjOIv8V1o0/BuLj01QdMxX6NIa0VJx
         CFIU3Er8dJYW5aWdV5Vy5yOGSu0gu7+bi+nUqqYB57voy7tCCsD/MHGFJZp1bN68LH
         YtBvMUtpbpIKr7bf5vqHH6G2Y1pnWcjqnfo5a/SEDfHuuAyPxINX7qb5CIII0Bjc8G
         +tBDtzIHUyyHg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E802AC5C7C4;
        Wed, 18 Jan 2023 14:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] xdp: document xdp_do_flush() before
 napi_complete_done()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167405281794.22945.14035940325138835924.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 14:40:17 +0000
References: <20230117094305.6141-1-magnus.karlsson@gmail.com>
In-Reply-To: <20230117094305.6141-1-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, toke@redhat.com, pabeni@redhat.com,
        davem@davemloft.net, brouer@redhat.com, bpf@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Tue, 17 Jan 2023 10:43:05 +0100 you wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Document in the XDP_REDIRECT manual section that drivers must call
> xdp_do_flush() before napi_complete_done(). The two reasons behind
> this can be found following the links below.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Link: https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
> Link: https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/
> 
> [...]

Here is the summary with links:
  - [net-next] xdp: document xdp_do_flush() before napi_complete_done()
    https://git.kernel.org/netdev/net-next/c/68e5b6aa2795

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


