Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C39E60AE70
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 17:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbiJXPAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 11:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbiJXPAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 11:00:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD1FAF1A6;
        Mon, 24 Oct 2022 06:37:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 724AB6121A;
        Mon, 24 Oct 2022 13:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9DE0C433C1;
        Mon, 24 Oct 2022 13:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666618012;
        bh=82Mx6eY+oAfpldeHtj6eBrLJqfgk2NfThEcLNuXtxSo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X2vosre/1HSA/V5iNsBEdIBehMhE8Nl/jFynyeLPjA+8ykLy8K3F+oyiiXZGJ/Ygn
         Pd6YNO6YtRbR2nX0/Zq1XpvAnKRJdiP7qK30eG12yGbl2vUSADSLsrDo1PBZWcdIz6
         xrGHr3ef/YGknQAQWxp94DBEGkIYwHLDX0X4h6BhhEuHJAK4T+/LB9b0ye1Pp+4/8Z
         3VzBbynoJ2MabmktcfZf+zQNk+F8MkOviSuRMPIP1EE8HHtxeiu8kHyiEZKnE0mn7e
         FukpngA4Cd4oTnOVDjtWeTpgflsKKeyveGTGQOwkKS+WAWxvz/oLBDizQfcPgI0gZR
         Bz71sC/90xVBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B1106E270DD;
        Mon, 24 Oct 2022 13:26:52 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: skb: move skb_pp_recycle() to skbuff.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166661801272.19025.11654719633874185289.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 13:26:52 +0000
References: <20221021025822.64381-1-linyunsheng@huawei.com>
In-Reply-To: <20221021025822.64381-1-linyunsheng@huawei.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        pabeni@redhat.com, hawk@kernel.org, ilias.apalodimas@linaro.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 21 Oct 2022 10:58:22 +0800 you wrote:
> skb_pp_recycle() is only used by skb_free_head() in
> skbuff.c, so move it to skbuff.c.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  include/linux/skbuff.h | 7 -------
>  net/core/skbuff.c      | 7 +++++++
>  2 files changed, 7 insertions(+), 7 deletions(-)

Here is the summary with links:
  - [net-next] net: skb: move skb_pp_recycle() to skbuff.c
    https://git.kernel.org/netdev/net-next/c/4727bab4e9bb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


