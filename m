Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90B859CDE6
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 03:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239320AbiHWBaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 21:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239275AbiHWBaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 21:30:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797785A173;
        Mon, 22 Aug 2022 18:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DFA3B81A03;
        Tue, 23 Aug 2022 01:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5AAAC433D6;
        Tue, 23 Aug 2022 01:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661218214;
        bh=HHXSTMZr4xr2sTTiYpzVKksEG/XyjauMOiNow2DWcHo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DnRU4Nq7TYgclcveo/IifXP9CEZFpmftUlAiEyRrglLEETWxXzHCooKicVOKB0373
         /a0uIf6OU3dJTo4P1b8WH1xi9C/cg0xxfsaEUjdo/AM2SD0CGexOvlitPxQrTKjr8y
         3yx1XTVQhSdiy26U36XmTRUP6t+ZlLB6V1aOmc0wJzEMTlOa1Jt1m53fjs5bFutpyX
         HoF0teZwFckPpsFwXkqI6/MUb5DqVGDthmFxeGusf1TS6BpVmZ3jqfjeEzJjRQz6L9
         bFfM5obshFvqOYRih5kJQt6YUGbZcHH3Fkz+Ji6h3Oop0hp+s5T26gMRtx4GgbmhEu
         fPh2M/E1V5VJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B7C80C4166E;
        Tue, 23 Aug 2022 01:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ipa: don't assume SMEM is page-aligned
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166121821474.29630.17318268860191872272.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Aug 2022 01:30:14 +0000
References: <20220818134206.567618-1-elder@linaro.org>
In-Reply-To: <20220818134206.567618-1-elder@linaro.org>
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 18 Aug 2022 08:42:05 -0500 you wrote:
> In ipa_smem_init(), a Qualcomm SMEM region is allocated (if needed)
> and then its virtual address is fetched using qcom_smem_get().  The
> physical address associated with that region is also fetched.
> 
> The physical address is adjusted so that it is page-aligned, and an
> attempt is made to update the size of the region to compensate for
> any non-zero adjustment.
> 
> [...]

Here is the summary with links:
  - [net] net: ipa: don't assume SMEM is page-aligned
    https://git.kernel.org/netdev/net/c/b8d4380365c5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


