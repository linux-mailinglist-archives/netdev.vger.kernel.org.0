Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183F254F5A9
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381901AbiFQKkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381741AbiFQKkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DCD6AA7D;
        Fri, 17 Jun 2022 03:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CF25B8299D;
        Fri, 17 Jun 2022 10:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A10B9C341CB;
        Fri, 17 Jun 2022 10:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655462414;
        bh=FfnaDyOU4tBYtXRnV8yExF0syv6ks0IlfB02Ng05kwI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JDP5Lyz4LmVub2ntySZweDlwak7EoUJ5kzGJ8p5L4tKwEg2n+mMnWeiUdaXVexZ4L
         lDpJcVvNJ+rgqdaavVaO8BkuRfDoxX6dFh09VJX8dTeNJHg++zv1ndyTWRm5ZOsAEs
         7lAGH/5RTIkXpSN5V9pvinY4Rt2OK5eUDB/IxqAGoXjWJgZAkykCHaLkOivRPg4y4e
         xC6SYexLldfnoppE8cffdchK+HIVqppA5C2iKozZAOLzsJ8VZbNiQu2dziLPNOnaUm
         u+qmkXwHvAvtLGnr1R9ECndkBdez5XCEY1bvkvKAL5cw+bj2vYqnGfX61WasgD9a/n
         5FXAAVyGXBo4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8D432E6D466;
        Fri, 17 Jun 2022 10:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] hinic: Replace memcpy() with direct assignment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165546241457.18293.10133826510983697335.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Jun 2022 10:40:14 +0000
References: <20220616052312.292861-1-keescook@chromium.org>
In-Reply-To: <20220616052312.292861-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com, leon@kernel.org, jiri@nvidia.com,
        olteanv@gmail.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Jun 2022 22:23:12 -0700 you wrote:
> Under CONFIG_FORTIFY_SOURCE=y and CONFIG_UBSAN_BOUNDS=y, Clang is bugged
> here for calculating the size of the destination buffer (0x10 instead of
> 0x14). This copy is a fixed size (sizeof(struct fw_section_info_st)), with
> the source and dest being struct fw_section_info_st, so the memcpy should
> be safe, assuming the index is within bounds, which is UBSAN_BOUNDS's
> responsibility to figure out.
> 
> [...]

Here is the summary with links:
  - hinic: Replace memcpy() with direct assignment
    https://git.kernel.org/netdev/net-next/c/2c0ab32b73cf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


