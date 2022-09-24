Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A205E882E
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 06:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbiIXEK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 00:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbiIXEKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 00:10:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E106AE9D;
        Fri, 23 Sep 2022 21:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBFDE6020F;
        Sat, 24 Sep 2022 04:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5BAB3C433B5;
        Sat, 24 Sep 2022 04:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663992621;
        bh=tFrlN0Ws0MZlv3K/NFJQ7H0ktz5/Fq6FKEEhVnJy0Pc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tVAO99igDi2lZ/6zIpbaII5pMVVHQ6kLYNCEir6ZgknPSTX5Ts6ih+WsOk7z7wCRK
         DtcYn3SxnSZyYcsxumZnGhrHuVafBJWHZWCZGDg/6f+sGpjWWfSXHh5yf+VK3RViQ8
         HorjgX+ognm8I7MW0UZIkXPFWBQKc9uyyQovQW+awDLIcBMoWRVyMaXfI9MFP0WkPJ
         6oWJ5xqA01mcwhUpoctYB5cTeRfQt3DPXk6ytYbBR0SyXFQwcqHKHbVN9ED/D/2CLm
         Zu/UPFndgzX5vQBH9C3WfBFJxvhxLh1gvRJQGHCfAarnMGLfgbDzjRT/E0F6JoOy9I
         e2FH1dIp0OIUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 476A8C072E7;
        Sat, 24 Sep 2022 04:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] net: ipa: another set of cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166399262128.11836.2543789042465500261.git-patchwork-notify@kernel.org>
Date:   Sat, 24 Sep 2022 04:10:21 +0000
References: <20220922222100.2543621-1-elder@linaro.org>
In-Reply-To: <20220922222100.2543621-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Thu, 22 Sep 2022 17:20:52 -0500 you wrote:
> This series contains another set of cleanups done in preparation for
> an upcoming series that reworks how IPA registers and their fields
> are defined.
> 
> The first replaces the use of u32_replace_bits() with a simple
> logical AND operation in two places.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] net: ipa: don't use u32p_replace_bits()
    https://git.kernel.org/netdev/net-next/c/a50d37b7565e
  - [net-next,2/8] net: ipa: introduce ipa_qtime_val()
    https://git.kernel.org/netdev/net-next/c/8be440e17bdb
  - [net-next,3/8] net: ipa: rearrange functions for similarity
    (no matching commit)
  - [net-next,4/8] net: ipa: define BCR values using an enum
    https://git.kernel.org/netdev/net-next/c/21ab2078ff37
  - [net-next,5/8] net: ipa: tidy up register enum definitions
    https://git.kernel.org/netdev/net-next/c/73e0c9efb5ed
  - [net-next,6/8] net: ipa: encapsulate setting the FILT_ROUT_HASH_EN register
    https://git.kernel.org/netdev/net-next/c/b24627b1d9b2
  - [net-next,7/8] net: ipa: encapsulate updating the COUNTER_CFG register
    https://git.kernel.org/netdev/net-next/c/1e5db0965ef5
  - [net-next,8/8] net: ipa: encapsulate updating three more registers
    https://git.kernel.org/netdev/net-next/c/92073b1648cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


