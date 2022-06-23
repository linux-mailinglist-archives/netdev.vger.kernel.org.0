Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04CE556FEC
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 03:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237617AbiFWBaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 21:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbiFWBaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 21:30:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB1B4339C;
        Wed, 22 Jun 2022 18:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53E7A61C83;
        Thu, 23 Jun 2022 01:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A3DEAC341C6;
        Thu, 23 Jun 2022 01:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655947813;
        bh=Or7lz5rgi4hs2oJviuhLBvWJuG2uvZFvd4T5aczeYl0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V4ZhtHDJMRX3bJgm2q/CzmHnR/7mg9kXdRKyZbYpy4v2EpSWw2Rwa0kqToS03WFHN
         SnmMUB1Zt0x5Aczw0sqyWRztVRiCwNMWOx+wI1HAdXB7B7hZMEwkV0ndIFVPezA6e3
         8HpWBVys2ofTyoXZhSe6RutWHrBStFUWsOb2rCO6iykRG6Vr8z6c7VkJXa7nBY0iKr
         OTLzuNn2RKMVWgAcbinmg4yNLWB2/7He3pVP6iW9d2aBlexGq2XvmHg/SIj9sNhJts
         o68qJnAVttLy9XF8x8Jre4NmYntqHbsYUVhIjZhD2NzO0cyBjwco41ZF9pSHuafYQs
         5HYuUk4uACVjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 873F4E574DA;
        Thu, 23 Jun 2022 01:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ipa: remove unexpected word "the"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165594781355.21755.12568994842405294882.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Jun 2022 01:30:13 +0000
References: <20220621085001.61320-1-jiangjian@cdjrlc.com>
In-Reply-To: <20220621085001.61320-1-jiangjian@cdjrlc.com>
To:     Jiang Jian <jiangjian@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, elder@kernel.org, netdev@vger.kernel.org,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Jun 2022 16:50:01 +0800 you wrote:
> there is an unexpected word "the" in the comments that need to be removed
> 
> Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
> ---
>  drivers/net/ipa/gsi_trans.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - net: ipa: remove unexpected word "the"
    https://git.kernel.org/netdev/net-next/c/7c0d97e4b696

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


