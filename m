Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19724D6D29
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 08:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiCLHB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 02:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbiCLHBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 02:01:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F046626C2F3;
        Fri, 11 Mar 2022 23:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACE33B82E11;
        Sat, 12 Mar 2022 07:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A002C340F5;
        Sat, 12 Mar 2022 07:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647068411;
        bh=WTXyElpzQ7cMxgUeslPKgtVFqAbfDhZ3YUjZhIkkBds=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ycx6lGtvE5PON1N6KHvracSs68Ub5ux4xZqzYKhbtYNDMpDI+9BldU5wrJokuifE4
         r4OexrnkH1BR+sLcq2+t2oZ5u++h5iKErNf0ve9oKuBVUEiI0ob4TBxGrOUvWUtITK
         rgPAXhKBqinpk4WBm0VN1ax0k1nYSXspTTl3eHMzkjL7eXTxqm7FMDg7vjeR966Izm
         Dt5VjSDWz6z30pK6S6Szcjziz0lbWa7GqGBPSDatGQteybZaW784Rh2S8oUNlM6Qk5
         uKJgs6nmeLTOGLKJWLFNDwLaevEM+0TqiNARZF8GI3m+ZXbjqOqiYpFH1lAoR/hd4o
         FbjblNm+VVJTQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 31A07E6D3DD;
        Sat, 12 Mar 2022 07:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net: ipa: use struct_size() for the interconnect
 array
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164706841119.27256.3824188698589079166.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Mar 2022 07:00:11 +0000
References: <20220311162423.872645-1-elder@linaro.org>
In-Reply-To: <20220311162423.872645-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        mka@chromium.org, evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 11 Mar 2022 10:24:23 -0600 you wrote:
> In review for commit 8ee7ec4890e2b ("net: ipa: embed interconnect
> array in the power structure"), Jakub Kicinski suggested that a
> follow-up patch use struct_size() when computing the size of the
> IPA power structure, which ends with a flexible array member.
> 
> Do that.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] net: ipa: use struct_size() for the interconnect array
    https://git.kernel.org/netdev/net-next/c/cb631a639819

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


