Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B635AD229
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 14:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236189AbiIEMK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 08:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235938AbiIEMK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 08:10:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF981D30A;
        Mon,  5 Sep 2022 05:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9242B81136;
        Mon,  5 Sep 2022 12:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7BB89C433D6;
        Mon,  5 Sep 2022 12:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662379816;
        bh=eylQ0s2BbGYGUgUlOOMnOJccPXVbeBe07REu27ee0/s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ns1t5VghnfxehV1jEv633PDLOpY4KUQhwaQTsN595p6I0NTqOa/p0V5mFmqFRtlJ6
         GgicmhSULwuTBctNebrdzyv6g1tQddbnQEKVPHYH5mpSOhD11VdNX2s/I1Px8aJIXv
         NCbiOyEg6evhY29/oew416SOP629bhUzr0/KvW4nabQEYzpWoXAHTJO726Q5MTbZFl
         niiHqd0JAwnadZ8jXOLAknnKuCnR5wjoGvYDvrU0eE3EfsBYcNPaGKUhdoLFdIII6t
         yzhQ9ao0Y0eiF0LrsDUFAUj4xPT2D/vW22E6rag89OeQa33cpS51HtSV22Mlj0zNan
         zAXhq+SRk+zAA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60DD9C73FE0;
        Mon,  5 Sep 2022 12:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: ipa: start using transaction IDs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166237981638.17156.8447007118751978814.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Sep 2022 12:10:16 +0000
References: <20220902210218.745873-1-elder@linaro.org>
In-Reply-To: <20220902210218.745873-1-elder@linaro.org>
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

On Fri,  2 Sep 2022 16:02:12 -0500 you wrote:
> A previous group of patches added ID fields to track the state of
> transactions:
>   https://lore.kernel.org/netdev/20220831224017.377745-1-elder@linaro.org
> 
> This series starts using those IDs instead of the lists used
> previously.  Most of this series involves reworking the function
> that determines which transaction is the "last", which determines
> when a channel has been quiesed.  The last patch is mainly used to
> prove that the new index method of tracking transaction state is
> equivalent to the previous use of lists.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: ipa: rework last transaction determination
    https://git.kernel.org/netdev/net-next/c/b2abe33d23cf
  - [net-next,2/6] net: ipa: use IDs for last allocated transaction
    https://git.kernel.org/netdev/net-next/c/c30623ea0b3a
  - [net-next,3/6] net: ipa: use IDs exclusively for last transaction
    https://git.kernel.org/netdev/net-next/c/897c0ce665d6
  - [net-next,4/6] net: ipa: simplify gsi_channel_trans_last()
    https://git.kernel.org/netdev/net-next/c/e68d1d1591fd
  - [net-next,5/6] net: ipa: further simplify gsi_channel_trans_last()
    https://git.kernel.org/netdev/net-next/c/4601e75596cb
  - [net-next,6/6] net: ipa: verify a few more IDs
    https://git.kernel.org/netdev/net-next/c/8672bab7eb94

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


