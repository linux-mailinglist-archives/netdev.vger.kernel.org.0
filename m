Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0EF961945C
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 11:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbiKDKUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 06:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbiKDKUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 06:20:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AD225E9B;
        Fri,  4 Nov 2022 03:20:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 197AEB82CD5;
        Fri,  4 Nov 2022 10:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8FCAFC433D7;
        Fri,  4 Nov 2022 10:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667557219;
        bh=1QAp6R4OhEVBViSbCctOc2XRBVTc/Th1TNMoCMIQDg4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lFh690D0Huc12CBXhTIqb8GSLetAfqww1qr7tQjm+t1ZATQns7dGuGBhZOdqL9OdB
         1d/ne3UF77QJfPJ/KlHkKMt/tPyv2INfyLK8fbXzBL5ZI67UcF23EFhxNyRVD7rfcc
         Y4RRIaVTUknvoUA2/wpaEQClDXo9tKjABF4LdQw85SM5pAqon3BpP90jacafe8WbXc
         8VZV/W/HqHeLDt95g8h+FLjZg2/vDVDdCHt7B1cbILPJmQirE3b1mOAlPnphk8rrx5
         /5JpBEaAx/JvCeeIhYdx7QycnVJGvcno0NaVCYakMDQtd/OirKCy3UplR92P/rQEOF
         vys4FTveNTtgQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79550E270F6;
        Fri,  4 Nov 2022 10:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/9] net: ipa: support more endpoints
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166755721948.22576.16201941889810013711.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 10:20:19 +0000
References: <20221102221139.1091510-1-elder@linaro.org>
In-Reply-To: <20221102221139.1091510-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  2 Nov 2022 17:11:30 -0500 you wrote:
> This series adds support for more than 32 IPA endpoints.  To do
> this, five registers whose bits represent endpoint state are
> replicated as needed to represent endpoints beyond 32.  For existing
> platforms, the number of endpoints is never greater than 32, so
> there is just one of each register.  IPA v5.0+ supports more than
> that though; these changes prepare the code for that.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/9] net: ipa: reduce arguments to ipa_table_init_add()
    https://git.kernel.org/netdev/net-next/c/5cb76899fb47
  - [net-next,v2,2/9] net: ipa: use ipa_table_mem() in ipa_table_reset_add()
    https://git.kernel.org/netdev/net-next/c/6337b147828b
  - [net-next,v2,3/9] net: ipa: add a parameter to aggregation registers
    https://git.kernel.org/netdev/net-next/c/1d8f16dbdf36
  - [net-next,v2,4/9] net: ipa: add a parameter to suspend registers
    (no matching commit)
  - [net-next,v2,5/9] net: ipa: use a bitmap for defined endpoints
    (no matching commit)
  - [net-next,v2,6/9] net: ipa: use a bitmap for available endpoints
    https://git.kernel.org/netdev/net-next/c/88de7672404d
  - [net-next,v2,7/9] net: ipa: support more filtering endpoints
    https://git.kernel.org/netdev/net-next/c/0f97fbd47858
  - [net-next,v2,8/9] net: ipa: use a bitmap for set-up endpoints
    https://git.kernel.org/netdev/net-next/c/ae5108e9b7fa
  - [net-next,v2,9/9] net: ipa: use a bitmap for enabled endpoints
    https://git.kernel.org/netdev/net-next/c/9b7a00653651

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


