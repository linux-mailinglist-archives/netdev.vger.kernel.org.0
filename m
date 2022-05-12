Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F1252489B
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 11:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351847AbiELJKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 05:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245413AbiELJKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 05:10:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E87663D0;
        Thu, 12 May 2022 02:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2888CB8272B;
        Thu, 12 May 2022 09:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF90AC34113;
        Thu, 12 May 2022 09:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652346611;
        bh=kUPt1JGo77MEfjogn7nGeG3UDhmsUV3GQWIzv8lF14Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mXLE976MDSdaGva2IOVKZsYlaOhHbRsU2ZlMdi0x2Owc7vPtqZUzar04Qym3o5AFa
         /BB5hmaEH2CkdSeNJG6rMVkEwQJiC9N9UaGPxBr+yYJ6f1JD+cH4JHjgRXUKncWcHW
         kUQLF2yN1tT1xwdq2jE1aKTN+rvXeKWainM0zc16X1eaMrK6CLesZ/slJpEDJTdFfT
         luwd64+ZQytmqUGFRBM7UQuIrgNAZ0AsfczMpSSOJdZ8OM1ahPeg0HzpiGUCxQhb3B
         6xrE0IVle8pnxt+MMK3BkFKsyU8C0UspUXlwAPyEMhZ8WYYwmw3uIop4zKH24MMqiH
         csRbX6DkdrgTw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9F682F03935;
        Thu, 12 May 2022 09:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] fortify: Provide a memcpy trap door for sharp corners
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165234661164.9393.13826110571393484922.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 09:10:11 +0000
References: <20220511025301.3636666-1-keescook@chromium.org>
In-Reply-To: <20220511025301.3636666-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        pabeni@redhat.com, lixiaoyan@google.com, tariqt@nvidia.com,
        saeedm@nvidia.com, leon@kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 10 May 2022 19:53:01 -0700 you wrote:
> As we continue to narrow the scope of what the FORTIFY memcpy() will
> accept and build alternative APIs that give the compiler appropriate
> visibility into more complex memcpy scenarios, there is a need for
> "unfortified" memcpy use in rare cases where combinations of compiler
> behaviors, source code layout, etc, result in cases where the stricter
> memcpy checks need to be bypassed until appropriate solutions can be
> developed (i.e. fix compiler bugs, code refactoring, new API, etc). The
> intention is for this to be used only if there's no other reasonable
> solution, for its use to include a justification that can be used
> to assess future solutions, and for it to be temporary.
> 
> [...]

Here is the summary with links:
  - fortify: Provide a memcpy trap door for sharp corners
    https://git.kernel.org/netdev/net-next/c/43213daed6d6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


