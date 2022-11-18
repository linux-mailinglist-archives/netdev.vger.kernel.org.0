Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6231162ED27
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 06:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240796AbiKRFUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 00:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240580AbiKRFUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 00:20:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE9E6E561;
        Thu, 17 Nov 2022 21:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0C26B82293;
        Fri, 18 Nov 2022 05:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 722FEC433D6;
        Fri, 18 Nov 2022 05:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668748816;
        bh=mP4/veKAzM1jDiDRDAX0XkfzBPnPYLCw1dOUugeWDpo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D9hxhMiTpI+iOriuyaRd2KaxvFboIuSITuHxF1yFXmNRafc3Dv/ztCi2ztajLuGw5
         HXmWw1tzBEb+n8xdtZxJxI5kl6eJmaz2not8fz0lg9yYBUfvcJ8PGiKw1B+M1CaxXW
         NO/5lTEKe2OIuclx7KiF28DZ2VAuA2OjquGtBIsBO44293DjETrmqft6P1IRGCjH01
         ZQZLIWqcSCY7ZOvbyGRFUCJYLSl6G//DrPoDBoQVTaYgDD+9cJYvdn6OlphH8eiYBU
         EP48TacITqzHT+bh2/idsFZ72zlN1kjNoEzAGrz16l2f6TQWoaX8g6HdaobCDVnwdH
         N0gLmGA3Y6Png==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4D480E270D5;
        Fri, 18 Nov 2022 05:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/5] dt-bindings: net: ipq4019-mdio: document IPQ6018
 compatible
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166874881630.4500.14407842263163608974.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 05:20:16 +0000
References: <20221114194734.3287854-1-robimarko@gmail.com>
In-Reply-To: <20221114194734.3287854-1-robimarko@gmail.com>
To:     Robert Marko <robimarko@gmail.com>
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
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

On Mon, 14 Nov 2022 20:47:30 +0100 you wrote:
> Document IPQ6018 compatible that is already being used in the DTS along
> with the fallback IPQ4019 compatible as driver itself only gets probed
> on IPQ4019 and IPQ5018 compatibles.
> 
> This is also required in order to specify which platform require clock to
> be defined and validate it in schema.
> 
> [...]

Here is the summary with links:
  - [v2,1/5] dt-bindings: net: ipq4019-mdio: document IPQ6018 compatible
    https://git.kernel.org/netdev/net-next/c/cbe5f7c0fbcd
  - [v2,2/5] dt-bindings: net: ipq4019-mdio: add IPQ8074 compatible
    https://git.kernel.org/netdev/net-next/c/05c1cbb96f3d
  - [v2,3/5] dt-bindings: net: ipq4019-mdio: require and validate clocks
    https://git.kernel.org/netdev/net-next/c/e50c50367d98
  - [v2,4/5] dt-bindings: net: ipq4019-mdio: document required clock-names
    https://git.kernel.org/netdev/net-next/c/4a8c14384fa9
  - [v2,5/5] arm64: dts: qcom: ipq8074: add SoC specific compatible to MDIO
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


