Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0064C6B45
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 12:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236025AbiB1Luy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 06:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234423AbiB1Luv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 06:50:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9D6593A9;
        Mon, 28 Feb 2022 03:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AB14610A3;
        Mon, 28 Feb 2022 11:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 640F4C340F8;
        Mon, 28 Feb 2022 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646049010;
        bh=BmsfSKcZuGovauzItirHH1LKDVWGBOyN50g10SbtrMY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Yir59Ls9c7Yoy/NaGYlRFLpUCKvumUNoW1gSeUcB3+Gkz0K+iSQKHzTouS9OnLcI8
         ohKRrkW4fDZoVUUzyKvT++iWiJtpjpuCEDiKw+B6dO+BPH9I71b1BLULhxQa62zS/q
         e5y72dMD6HmUG6JonMbSESNGsi3O3DlxLlTIEtOA/Fzpg2HfwX/2MwwtiPf/JmQOfe
         TrhQ/d0WBZvOy7ur5O4Oz11G3LbbibLlEn5dNZtvYM+wGvitsQmElvQ7RUag2B8/fk
         PY5QzgwVY3e+HC4Zb0tAyVOkEWSKO2rfLjsBRD21lnZblkBEyr3GhmdCtFvAQmMZqu
         Wt20PebZalNBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B010EAC09E;
        Mon, 28 Feb 2022 11:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ipa: fix a build dependency
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164604901029.16787.14124027324200684971.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 11:50:10 +0000
References: <20220225201530.182085-1-elder@linaro.org>
In-Reply-To: <20220225201530.182085-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, rdunlap@infradead.org,
        bjorn.andersson@linaro.org, mka@chromium.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, avuyyuru@codeaurora.org,
        jponduru@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 25 Feb 2022 14:15:30 -0600 you wrote:
> An IPA build problem arose in the linux-next tree the other day.
> The problem is that a recent commit adds a new dependency on some
> code, and the Kconfig file for IPA doesn't reflect that dependency.
> As a result, some configurations can fail to build (particularly
> when COMPILE_TEST is enabled).
> 
> The recent patch adds calls to qmp_get(), qmp_put(), and qmp_send(),
> and those are built based on the QCOM_AOSS_QMP config option.  If
> that symbol is not defined, stubs are defined, so we just need to
> ensure QCOM_AOSS_QMP is compatible with QCOM_IPA, or it's not
> defined.
> 
> [...]

Here is the summary with links:
  - [net] net: ipa: fix a build dependency
    https://git.kernel.org/netdev/net/c/caef14b7530c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


