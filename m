Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2EA57C340
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 06:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiGUEK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 00:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbiGUEKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 00:10:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F720DEE4;
        Wed, 20 Jul 2022 21:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C374619A9;
        Thu, 21 Jul 2022 04:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82B01C341CB;
        Thu, 21 Jul 2022 04:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658376617;
        bh=5ea/JMJLPuN1XzRzMsOTLW90JIiXD8BBSVxFB7V9ALY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OiKWUFnIR9IbWxZGyIYopVVfX5oOuo+8I8wFK9dqsuYm1jOaMaDqU5ILQgmEdSIMD
         9dGmtdfISBQ1M4P7P/9rihCsFPobEjezXq9/sSgAqVldyY/Mv0uUHkbQer4Jwr3wwM
         ws0AWIzKcReDeGll4qNOqY5+NySFCxT2hGi27Nk0ykbPxEPhvHHM2i+rEdjpXctT30
         KPwDBZW6hJw3iy4SdCBgEwSFapRrHv69ak4SNO5ts2Rgn0jzrNtIpWal6HMEQw2TKR
         CaMFCJAtP2oUr1U04w4s2FgNRKhZfc2naS8tSMQHyxkauq9tcApvb5trOmTw9uUglT
         qs827jpRAIgEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 679F1E451BB;
        Thu, 21 Jul 2022 04:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/5] net: ipa: small transaction updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165837661742.25559.4645505157556019794.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jul 2022 04:10:17 +0000
References: <20220719181020.372697-1-elder@linaro.org>
In-Reply-To: <20220719181020.372697-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mka@chromium.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 19 Jul 2022 13:10:15 -0500 you wrote:
> Version 2 of this series corrects a misspelling of "outstanding"
> pointed out by the netdev test bots.  (For some reason I don't see
> that when I run "checkpatch".)  I found and fixed a second instance
> of that word being misspelled as well.
> 
> This series includes three changes to the transaction code.  The
> first adds a new transaction list that represents a distinct state
> that has not been maintained.  The second moves a field in the
> transaction information structure, and reorders its initialization
> a bit.  The third skips a function call when it is known not to be
> necessary.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/5] net: ipa: add a transaction committed list
    https://git.kernel.org/netdev/net-next/c/b63f507c06e6
  - [net-next,v2,2/5] net: ipa: rearrange transaction initialization
    (no matching commit)
  - [net-next,v2,3/5] net: ipa: skip some cleanup for unused transactions
    https://git.kernel.org/netdev/net-next/c/4d8996cbeeab
  - [net-next,v2,4/5] net: ipa: report when the driver has been removed
    https://git.kernel.org/netdev/net-next/c/3c91c86d1bb6
  - [net-next,v2,5/5] net: ipa: fix an outdated comment
    https://git.kernel.org/netdev/net-next/c/616c4a83b6ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


