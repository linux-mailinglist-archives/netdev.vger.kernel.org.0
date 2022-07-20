Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C9857B464
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 12:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbiGTKUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 06:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbiGTKUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 06:20:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164B5DB9;
        Wed, 20 Jul 2022 03:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0B0BB81EDB;
        Wed, 20 Jul 2022 10:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71FDCC341D1;
        Wed, 20 Jul 2022 10:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658312413;
        bh=wGgZaOceTr23WAeD4swIODS5yUIifdbxS7SQ1RgbDfQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X88gFFBXwz24sx/eiQHpL1sWTr+yU3NbIrbqyav56Sk6JcuPYsklduwl9gup1aTXF
         QJ76+fydw6s1LkKMOHMjXoQC/Clbg0X0bKuSxgbfxFdZfS3eITgx9tOxYJPAoQfu2z
         PH4EsxI5NI/D11jtvcq7f12DpHW2jIH7OwFv3trfiPpTKYSCA7RHGIcmyDwpGT56tz
         XY+2G/KhVBTmavwJIKnEr+s/obdZaAptAaI0PsoR0ITJq3QAWL7v5s2j4q1igdVHq8
         euaQAefDLrClXsXtvUNlPxJ/ayxY5ZQMsN/vvhAKCnA5drch61N6xJI+x71J84aJ+N
         3u4+g4U01wPoQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5C5CAE451BC;
        Wed, 20 Jul 2022 10:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipa: initialize ring indexes to 0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165831241337.14288.12233136434309116921.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jul 2022 10:20:13 +0000
References: <20220719141855.245994-1-elder@linaro.org>
In-Reply-To: <20220719141855.245994-1-elder@linaro.org>
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Jul 2022 09:18:55 -0500 you wrote:
> When a GSI channel is initially allocated, and after it has been
> reset, the hardware assumes its ring index is 0.  And although we
> do initialize channels this way, the comments in the IPA code don't
> really explain this.  For event rings, it doesn't matter what value
> we use initially, so using 0 is just fine.
> 
> Add some information about the assumptions made by hardware above
> the definition of the gsi_ring structure in "gsi.h".
> 
> [...]

Here is the summary with links:
  - [net-next] net: ipa: initialize ring indexes to 0
    https://git.kernel.org/netdev/net-next/c/5fb859f79f4f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


