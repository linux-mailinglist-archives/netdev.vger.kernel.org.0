Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CFF52F739
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 03:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344998AbiEUBAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 21:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244884AbiEUBAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 21:00:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5441B092B;
        Fri, 20 May 2022 18:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAF1861E9F;
        Sat, 21 May 2022 01:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2FDD2C36AE3;
        Sat, 21 May 2022 01:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653094812;
        bh=zilOOzTtILoXvxONEgyn+Rv3B2It2oRDDPX55bj6z2E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g6UQT8pKfgBZR5yyFueB7jOkKjwCcLsaCUlaktjrtHzkHB7C+nF4bhxs6Sk0awoDH
         Zb7O8wz0yncFe0x16s05Ukb0tckP55PtdoG3Qkptx5pTE5i/DeZHPCCIt2lZFVD+Hq
         nBupqWr3dAtTQ66Rpo1ZIlUUW3XJZ08S/iweRYV4p6JAfVSRl/H4+2AtUO7BsAxWpE
         RJ61jeChyBiwBZNqHzgqutG8mK/RmcTm3i0HJyQTicmrDiedAOH+GEzsDAo8UXiKnY
         W0SNrMUN9REmxatczEAUwyYgzP2VERa8jDsuiyyjvajLGSAi+GOf9A1nP9Nb9jfMQG
         /oENKRsqPI9hg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 167F7F03935;
        Sat, 21 May 2022 01:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] hv_netvsc: Fix potential dereference of NULL pointer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165309481208.5645.11194329096449346020.git-patchwork-notify@kernel.org>
Date:   Sat, 21 May 2022 01:00:12 +0000
References: <1652962188-129281-1-git-send-email-lyz_cs@pku.edu.cn>
In-Reply-To: <1652962188-129281-1-git-send-email-lyz_cs@pku.edu.cn>
To:     =?utf-8?b?5YiY5rC45b+XIDxseXpfY3NAcGt1LmVkdS5jbj4=?=@ci.codeaurora.org
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, sashal@kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, fuyq@stu.pku.edu.cn
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 19 May 2022 05:09:48 -0700 you wrote:
> The return value of netvsc_devinfo_get()
> needs to be checked to avoid use of NULL
> pointer in case of an allocation failure.
> 
> Fixes: 0efeea5fb ("hv_netvsc: Add the support of hibernation")
> 
> Signed-off-by: Yongzhi Liu <lyz_cs@pku.edu.cn>
> 
> [...]

Here is the summary with links:
  - hv_netvsc: Fix potential dereference of NULL pointer
    https://git.kernel.org/netdev/net/c/eb4c07889647

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


