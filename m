Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682B3555305
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 20:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377068AbiFVSKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 14:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377046AbiFVSKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 14:10:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727043A1AB;
        Wed, 22 Jun 2022 11:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1461B61CCA;
        Wed, 22 Jun 2022 18:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62C5AC3411D;
        Wed, 22 Jun 2022 18:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655921412;
        bh=RdMpY98Dovcj8Z5McfPbAv7/dxekKq/qt1Sdz8M2fns=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M1lnBRZaS91Spw1v4oBV9+wAMRBYZpEKHBZlajh/I4BZwsxJzUq/TN9FYY7dTowck
         7+XYe0koh8xbcF9qhQfI/hA1fEDchj3QWRnqtfkTv+9B5zIN9fueH47uAqbCy8rCxG
         D5q0LIP7vLum99NLJIhVaCxA6s2PDrJmAR0YbcAebZVNwxWzZyR8qjtubKkKGDfeMw
         MUtdS5clzwM/Vo28yYszTNtQbe8QjUXLvQQXc264lUxGBcPXZq5PaY36A8sq9caJG5
         jFVzNz75LQxpk8mljr6k9eIbV6IOgQh84y+sPRut1RbPi55soJGFQJ5DX4Hgf77lR+
         7RklIbc4+3DuA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 480A7E7386C;
        Wed, 22 Jun 2022 18:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] hinic: Replace memcpy() with direct assignment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165592141229.24504.12499679747935394239.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Jun 2022 18:10:12 +0000
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

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
    https://git.kernel.org/netdev/net/c/1e70212e0315

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


