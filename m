Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5443A57418D
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 04:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiGNCuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 22:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiGNCuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 22:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C031022505;
        Wed, 13 Jul 2022 19:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AB9861DE0;
        Thu, 14 Jul 2022 02:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B42FFC341C0;
        Thu, 14 Jul 2022 02:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657767013;
        bh=FCZFnhXyh+lfrPcxJ48T/CH+JC21T5uXUjkG/sGSH1s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pHhPgx7i3PgHba3UOUV5ewm7rR7725dh3eS/rlTcV9F8YzH6HfNOV+I6BVfHvh1Pg
         5FLZFj6LYjpEAD9fxVJ1igtYckrUDCFWimyD7u61Rt3PbFl5o9DuXTSZADB4wUnlKS
         /82LcA2S0k8ra4KXSeafPzoh0Leqk032bqyw3AUWPMykhuPvOnubG3/daXY+20VCi3
         INRfNRTbqMF6DBWanA5tg5a91A0LVBpsEoDbyiuQ5E/omx3X+NFnSWsdX7bHcBPj/f
         RFpGpqW0CugICy2vIF9QYgwDEzPdzAcrx+ItZs5IKfU6W8yA5etEPKC8vkOm/R+gy2
         wtmoDWPkuwqrw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 94675E4521F;
        Thu, 14 Jul 2022 02:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] NFC: nxp-nci: add error reporting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165776701360.26805.7732027276081136696.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jul 2022 02:50:13 +0000
References: <20220712170011.2990629-1-michael@walle.cc>
In-Reply-To: <20220712170011.2990629-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org
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

On Tue, 12 Jul 2022 19:00:10 +0200 you wrote:
> The PN7160 supports error notifications. Add the appropriate callbacks.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/nfc/nxp-nci/core.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)

Here is the summary with links:
  - NFC: nxp-nci: add error reporting
    https://git.kernel.org/netdev/net-next/c/5dc0f7491f9a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


