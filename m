Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414D94DB82E
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354915AbiCPSv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238021AbiCPSv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:51:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126DB6BDC1
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 11:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A53F2618F3
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 18:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8248C340EC;
        Wed, 16 Mar 2022 18:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647456611;
        bh=9jz0Dx6j9OI8jR/xaOpm6lC3t6nIel6Cw9eh/Mv2mfA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E5RCg3ZvB2g8cLdyjsXWjDuf+4czS4qLY7MUexQgqX9zh291RpONx/+8tt5kcIHV6
         FX+RCvPieWHhY3mBfTd4dsusjNh+ty6apNPthUGktqGMDMFo+Ar6Vr1uQkLABPc1Qp
         iE5EQKpbxG5d+dogbsQgROzuxB0nicpKNWslVMmbJoqUSfodljI2QnB8PcR+PEpVE4
         iapFVp3Qh4B3om8SHlM03ejLjJ56X13k7o7/DP4ooWc4yp4tpSoMeNt8LeZfz7UbVs
         HNfyus+gBcb07W63MWE5djwGmVyawrOeaDxTtoi0E02Yre64CUIbNZFbRIga9Q7bC3
         K+xIAjCxijAUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE049F0383F;
        Wed, 16 Mar 2022 18:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request (net): ipsec 2022-03-16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164745661083.4226.16212995235722338132.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Mar 2022 18:50:10 +0000
References: <20220316121142.3142336-1-steffen.klassert@secunet.com>
In-Reply-To: <20220316121142.3142336-1-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Wed, 16 Mar 2022 13:11:40 +0100 you wrote:
> Two last fixes for this release cycle:
> 
> 1) Fix a kernel-info-leak in pfkey.
>    From Haimin Zhang.
> 
> 2) Fix an incorrect check of the return value of ipv6_skip_exthdr.
>    From Sabrina Dubroca.
> 
> [...]

Here is the summary with links:
  - pull request (net): ipsec 2022-03-16
    https://git.kernel.org/netdev/net/c/186abea8a80b
  - [2/2] esp6: fix check on ipv6_skip_exthdr's return value
    https://git.kernel.org/netdev/net/c/4db4075f92af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


