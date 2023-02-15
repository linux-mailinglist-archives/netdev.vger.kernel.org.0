Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3FBA697588
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 05:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbjBOEuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 23:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbjBOEuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 23:50:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CD02D161;
        Tue, 14 Feb 2023 20:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1DB861A28;
        Wed, 15 Feb 2023 04:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32C33C4339B;
        Wed, 15 Feb 2023 04:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676436619;
        bh=AutCLz+//uGrZwS7IsrAOyjoLQbAbA9BhegglT0NddE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m9xk736G8V8Va8K+CDs0OXp+pLkiAoDhSWA0lAoWwCkQ5NA6TAOpv+hT9VgpX4pLL
         NnnGJ5nZRre5SikbVkfWjOYTSBAAQGxGaSNhnWQcds0fHByH19BTp6zSv+o8PA3rGX
         WuYw5YGHxQq+4c1yttly/jUM+XAizmbbT7CoxGF/i8zwKr2WUtYai2RwI0M/aDForp
         SGqtzBvJekKDFB34bO1Hi83+qvhWvx0/EpKCdVHfT5CtHy+sOkDBiOVig7FntLSXvg
         8mUMAx83X3hKh34RLHxwlwD+7u7phVIwxKPuYww7LFkpRQt2SNWd5iplFNquadt6FX
         tAAwVvb78ig1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B8A0C41677;
        Wed, 15 Feb 2023 04:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: ipa: define GSI register fields differently
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167643661910.17897.16318206449857009459.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Feb 2023 04:50:19 +0000
References: <20230213162229.604438-1-elder@linaro.org>
In-Reply-To: <20230213162229.604438-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, caleb.connolly@linaro.org, mka@chromium.org,
        evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 13 Feb 2023 10:22:23 -0600 you wrote:
> Now that we have "reg" definitions in place to define GSI register
> offsets, add the definitions for the fields of GSI registers that
> have them.
> 
> There aren't many differences between versions, but a few fields are
> present only in some versions of IPA, so additional "gsi_reg-vX.Y.c"
> files are created to capture such differences.  As in the previous
> series, these files are created as near-copies of existing files
> just before they're needed to represent these differences.  The
> first patch adds files for IPA v4.0, v4.5, and v4.9; the fifth patch
> adds a file for IPA v4.11.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: ipa: populate more GSI register files
    https://git.kernel.org/netdev/net-next/c/4a4270cff65f
  - [net-next,2/6] net: ipa: define GSI CH_C_QOS register fields
    https://git.kernel.org/netdev/net-next/c/f50ca7cef7c7
  - [net-next,3/6] net: ipa: define more fields for GSI registers
    (no matching commit)
  - [net-next,4/6] net: ipa: define fields for event-ring related registers
    https://git.kernel.org/netdev/net-next/c/edc6158b18af
  - [net-next,5/6] net: ipa: add "gsi_v4.11.c"
    https://git.kernel.org/netdev/net-next/c/aa07fd4358f5
  - [net-next,6/6] net: ipa: define fields for remaining GSI registers
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


