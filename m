Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A6957C342
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 06:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbiGUEK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 00:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiGUEKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 00:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A040ADF22;
        Wed, 20 Jul 2022 21:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA07B619E0;
        Thu, 21 Jul 2022 04:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A498AC341D2;
        Thu, 21 Jul 2022 04:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658376617;
        bh=cpM7HtbnSCzJSPsJLCcRFhmeFbJULjPZNAkllVf4fA0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Hph3xJ2xhdK7bzTG+A34eCwX65tqYJvl5WA9QUM8df92z8yvJIYhqKXNzVYrpJkkR
         ffERw3c/Etvrw9fxeop6SqyjRO+xpbwzlt2ckgj+/13TpzCF+AXszhimEa9hqUSuD3
         OWE5Ks+Qj7yuRl6WtBpbm89jhH6CyQueio8X/4kjG+KCsfqNW8CjwOeM6S0a7KjgEp
         Do92SFxLn6hdujBWCZwKuWrp8WCt7JbfLGox3OXlAxYXLLH4shsO8d5UIu1p9wJrUM
         XtwoTIB0dupkv0BYO+DxG5vzCmQOaUNdhK/4uregKAHkMjUAZDsQIg+SM2mL69Wawi
         V5yf1Z5TcTlIQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79458E451BD;
        Thu, 21 Jul 2022 04:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: ipa: move configuration data files
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165837661749.25559.12147959193781616422.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jul 2022 04:10:17 +0000
References: <20220719150827.295248-1-elder@linaro.org>
In-Reply-To: <20220719150827.295248-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mka@chromium.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 19 Jul 2022 10:08:25 -0500 you wrote:
> This series moves the "ipa_data-vX.Y.c" files into a subdirectory.
> The first patch adds a Makefile variable containing the list of
> supported IPA versions, and uses it to simplify the way these files
> are specified.
> 
> 					-Alex
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: ipa: list supported IPA versions in the Makefile
    https://git.kernel.org/netdev/net-next/c/ec2ea5e06c67
  - [net-next,2/2] net: ipa: move configuration data files into a subdirectory
    https://git.kernel.org/netdev/net-next/c/2c7b9b936bdc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


