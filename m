Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3085549E0
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbiFVMUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 08:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbiFVMUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 08:20:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D7C1A3AF
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 05:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E662F618EC
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 12:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45E87C341C0;
        Wed, 22 Jun 2022 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655900412;
        bh=kvAjat3o8t+lRG3G2/p+gSW5PlPLibw00UA9P/6SFsc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qht1ZKUYM27I1/byoJ9BvM6w1GqfTaK51Ddnt9Tje8qP7vYZDmTWmTaCnujbpVPP1
         S8Jvb4jVfnnOGr/W9sWToPqn4LsCDz0N41zHCDzuQ36LMr3f+0lLvE622iBk3OQb0I
         5rWtQAp24bawvJb0zAY3mEFl+d7aSOQdV2X/lBMsuO8BL4jzXcabKI+I6JwbGwRTz3
         eOXi5cl7irCEk+PFVLnzPOBM5kf1OMZOjyDZLvWJS+oHhdOBSDEc67IW2uyZYFe0h/
         VFkfJFNOg5hV/HxL2hpPzwxD9SdDOZ8/ak5at3LG6b3+YTLR1oNNJfrmx1gB+I268K
         6zf8xgzhvDxlw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 285A6E7B9A4;
        Wed, 22 Jun 2022 12:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "drivers/net/ethernet/neterion/vxge: Fix a
 use-after-free bug in vxge-main.c"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165590041216.22299.13905831445847902661.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Jun 2022 12:20:12 +0000
References: <20220620191237.1183989-1-kuba@kernel.org>
In-Reply-To: <20220620191237.1183989-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jdmason@kudzu.us, christophe.jaillet@wanadoo.fr,
        Wentao_Liang_g@163.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 20 Jun 2022 12:12:37 -0700 you wrote:
> This reverts commit 8fc74d18639a2402ca52b177e990428e26ea881f.
> 
> BAR0 is the main (only?) register bank for this device. We most
> obviously can't unmap it before the netdev is unregistered.
> This was pointed out in review but the patch got reposted and
> merged, anyway.
> 
> [...]

Here is the summary with links:
  - [net] Revert "drivers/net/ethernet/neterion/vxge: Fix a use-after-free bug in vxge-main.c"
    https://git.kernel.org/netdev/net/c/877fe9d49b74

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


