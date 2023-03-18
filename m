Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F996BF815
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 06:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjCRFk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 01:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjCRFkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 01:40:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0750B2365E;
        Fri, 17 Mar 2023 22:40:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6244CCE1726;
        Sat, 18 Mar 2023 05:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A402C4339E;
        Sat, 18 Mar 2023 05:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679118019;
        bh=6T6etlrRYYQ9UGMIdnLTJdf49W53EzudtlsJRMxOGj8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j6/ADecuEzsC26zRngxf18YAqDGL0aoFTAF6eeXmt/O4/q+Z2Eq5yy67mmMZhCoIS
         GyVQirKubt7UiNWf4FFiq6klPesR28FoWyxAqDsqayAiITuZ8T5O5QnM9O6/jd9ErU
         umEw7hNlNUoIPzpKaJpHgBEcEUN4nSZMNncouF+8ebfsO26AVkyR1LaSy198vONgPB
         dXd+DnPGJMif5YyqSz/ejXYhO8e2jxvabxrxZrzcYm578aIFhOVSQzvxqGXeW61xfZ
         mmBLccVwKsGP1AoLmW4v95v2uUU8LYfF0YPHn5TT/6JSOcaXosMetg1T84Cd67oCjV
         jdCv9wy9AIgcg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2A729E21EE5;
        Sat, 18 Mar 2023 05:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] dt-bindings: net: qcom,ipa: add SDX65 compatible
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167911801917.9150.18113422396759927365.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Mar 2023 05:40:19 +0000
References: <20230315194305.1647311-1-elder@linaro.org>
In-Reply-To: <20230315194305.1647311-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        andersson@kernel.org, konrad.dybcio@linaro.org, agross@kernel.org,
        devicetree@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        simon.horman@corigine.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 15 Mar 2023 14:43:05 -0500 you wrote:
> Add support for SDX65, which uses IPA v5.0.
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
> v2: Add review tag; base on linux-next/master; drop "net-next" in subject
> 
> [...]

Here is the summary with links:
  - [v2] dt-bindings: net: qcom,ipa: add SDX65 compatible
    https://git.kernel.org/netdev/net-next/c/0de10fd6eb94

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


