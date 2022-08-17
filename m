Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9459E596795
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 05:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238142AbiHQDA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 23:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238109AbiHQDAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 23:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0231B97D4C;
        Tue, 16 Aug 2022 20:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5BBDB81BA7;
        Wed, 17 Aug 2022 03:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44460C433C1;
        Wed, 17 Aug 2022 03:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660705216;
        bh=49IKIY0EzXHB6rqen/2hZmKInU7bG9C6lG5mMlou1pA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hxS7253n3hmV80+2BLu6LjrPfOyVNFFSDli9hhH4vVOVwhJNZwyN1Jq4ahh7qt3h/
         gypKasJv+X0b/GUVwDH62a+ZMsWZ3jZsRwjQ99amd1FG+tB9x2vKyDxNJpbleIM9ku
         qg57REJ4XZmTcdtFn5PZBcwkMBSLE1ok9EgSjwV4+JZg281OfGptbS+jDcfQuS/gmg
         GI+rxaG4Szu5wX1US6cfkagu1l+hC1mzTBz5IC+VNC5kdh1om729H8HDFIhosx9z6C
         zX4e/WfSN2CmDnirx3P0CjT+ylDyFP0HnPJwK0JRUeSKsCoaaVj7SX96k+YMb1ObJh
         SX3KuMYGe49nw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 282EAE2A04C;
        Wed, 17 Aug 2022 03:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] dt-bindings: vertexcom-mse102x: Update email address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166070521616.25002.9383068256865638135.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Aug 2022 03:00:16 +0000
References: <20220815080626.9688-1-stefan.wahren@i2se.com>
In-Reply-To: <20220815080626.9688-1-stefan.wahren@i2se.com>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 15 Aug 2022 10:06:25 +0200 you wrote:
> in-tech smart charging is now chargebyte. So update the email address
> accordingly.
> 
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
> ---
>  Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [1/2] dt-bindings: vertexcom-mse102x: Update email address
    https://git.kernel.org/netdev/net-next/c/d56ef29afb39
  - [2/2] net: vertexcom: mse102x: Update email address
    https://git.kernel.org/netdev/net-next/c/56cb6a59da67

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


