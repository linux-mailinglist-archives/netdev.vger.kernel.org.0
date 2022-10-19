Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEFC603817
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 04:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiJSCaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 22:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiJSCaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 22:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84904BA914
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 19:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6F8D6175D
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 02:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 152A5C433B5;
        Wed, 19 Oct 2022 02:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666146619;
        bh=TmlY1HsWAA+Nbw8tSPW5pNQB/quXQlHBIfRO4kTxCzE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nvwEs9UCxFHBNO4Uyf/aBU8INzCOpsuGSbo+lQcA+zMd13ZU3dh3VbjNHsuWxSC+i
         TaiFg7wWJY3yzN0sVZKaZJt9s9ROR5Yzxf6yh5tkuVnOuBTPKDgBVzz5fLqX3b3wGA
         +9Ja36WRyIbibC/msjioXzi7ACK6sPSJyv/eGibfufBXZSRBhpPPkPzbxEVQAMdOIK
         0JuscWiApsFc/AOi5M01lysfnNo2w6XO4o5n62lA+zX94FDVJsDEe7x6KgOFAv8h9j
         x11gcXSPHJO8M1nr9IjbI8h2/Cm/dR8hg57CYapbT1J8BDpLWy1BLYoMh8Ceo2ckMd
         pLI8WAipzJFHg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C633AE4D008;
        Wed, 19 Oct 2022 02:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bnxt_en: fix memory leak in bnxt_nvm_test()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166614661880.8072.17602449790469089702.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Oct 2022 02:30:18 +0000
References: <1666020742-25834-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1666020742-25834-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, gospo@broadcom.com,
        vikas.gupta@broadcom.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 17 Oct 2022 11:32:22 -0400 you wrote:
> From: Vikas Gupta <vikas.gupta@broadcom.com>
> 
> Free the kzalloc'ed buffer before returning in the success path.
> 
> Fixes: 5b6ff128fdf6 ("bnxt_en: implement callbacks for devlink selftests")
> Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> 
> [...]

Here is the summary with links:
  - [net] bnxt_en: fix memory leak in bnxt_nvm_test()
    https://git.kernel.org/netdev/net/c/ba077d683d45

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


