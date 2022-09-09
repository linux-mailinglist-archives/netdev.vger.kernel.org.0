Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30015B3597
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 12:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiIIKud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 06:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiIIKuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 06:50:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DF1A50DA;
        Fri,  9 Sep 2022 03:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DFA0B824DE;
        Fri,  9 Sep 2022 10:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0C222C433D6;
        Fri,  9 Sep 2022 10:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662720618;
        bh=laW7ELmbx0lEiOBpS3r7eozL35pkZ33FbUZhr4ymljs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vOmeRLS9EnSLo+qURrmLE558XhriCuS1toBEZTI/cIwmc0o8M4HxqAHfbDVJF+z9/
         CqdLukR+4oTOffGUTGKwtvmCUA998dZAelVARMVgPcDCbAC+gJk6nhf+maZtCSXPfN
         Gos7EmW3qOs+3dBmfHObap8E32wZxRY3dCSrQ+ZYG/PuNOyRaa4m/yq3Z1kZPTZwsu
         Q9zHa+rbJhsWua+LgWA/D8MhtYrlgYFb4y8iRMirk1YZe6xUgPH1owGtAt/pLLf4xF
         s1AXWPiYPZtzsVXOYgifUZ7F6KNNgE2dNQHwh9l03MrRULqatz9qkT2iEdiqWBbvhL
         nanm3ZZNzOPMg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E5CC8C73FE7;
        Fri,  9 Sep 2022 10:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: ipa: don't use lists for transaction state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166272061793.26556.14430225024454087661.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Sep 2022 10:50:17 +0000
References: <20220906171942.957704-1-elder@linaro.org>
In-Reply-To: <20220906171942.957704-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mka@chromium.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  6 Sep 2022 12:19:37 -0500 you wrote:
> This is the last series of patches to convert the IPA code so
> integer IDs are used rather than lists to track the state of
> transactions.
> 
> A first series of patches added ID fields to track the state of
> transactions:
>   https://lore.kernel.org/netdev/20220831224017.377745-1-elder@linaro.org
> The second series started transitioning code to use these IDs rather
> than lists to manage state:
>   https://lore.kernel.org/netdev/20220902210218.745873-1-elder@linaro.org
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: ipa: always use transaction IDs instead of lists
    (no matching commit)
  - [net-next,2/5] net: ipa: kill the allocated transaction list
    https://git.kernel.org/netdev/net-next/c/11902b41f2fa
  - [net-next,3/5] net: ipa: kill all other transaction lists
    https://git.kernel.org/netdev/net-next/c/d338ae28d8a8
  - [net-next,4/5] net: ipa: update channel in gsi_channel_trans_complete()
    https://git.kernel.org/netdev/net-next/c/e0e3406c60d7
  - [net-next,5/5] net: ipa: don't have gsi_channel_update() return a value
    https://git.kernel.org/netdev/net-next/c/019e37eaef97

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


