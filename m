Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27FB064ABE7
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 01:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbiLMAAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 19:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbiLMAAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 19:00:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E08E0D2;
        Mon, 12 Dec 2022 16:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5869B81035;
        Tue, 13 Dec 2022 00:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A5DBC433F0;
        Tue, 13 Dec 2022 00:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670889617;
        bh=Cst6AOSuyr2pYX+vTiqsEKzRScISrWRNJjgvWWKhSAU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hd9rcWAMdNpjkIDc8vwsetsAALGbRKfFvfcuXz3mKWfXr6L2Ve+aVHoytwjYixp98
         aTvslYquNyzad2H+K0hEWSLCMNFw7k7hNqK+BYT46/xBsNiF6V3Nqfr6285QweZbs3
         +wQpn+9KAVW971cDV05UVW6Kii+enfTFOeXvWVqhMAJ5UThK8xkd+R8EwgqyM+DqpE
         YID4YuCJMG8hzC+afaij2a4MMIMkqgN0TL/x2l59zwSYIAHBFDUTYTU2F7PFOp3IHk
         M0p5PgF0NAi0uti0ahc8OElD/1H3gyGgP/A78o4fLHJzKNhs5Z6Yor8gKlpbzDTsyg
         G/lmwZBN9YSGw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C129C41612;
        Tue, 13 Dec 2022 00:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: ipa: enable IPA v4.7 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167088961711.16932.6698108343031122896.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Dec 2022 00:00:17 +0000
References: <20221208211529.757669-1-elder@linaro.org>
In-Reply-To: <20221208211529.757669-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, andersson@kernel.org, konrad.dybcio@linaro.org,
        agross@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Thu,  8 Dec 2022 15:15:27 -0600 you wrote:
> The first patch in this series adds "qcom,sm6350-ipa" as a possible
> IPA compatible string, for the Qualcomm SM6350 SoC.  That SoC uses
> IPA v4.7
> 
> The second patch in this series adds code that enables support for
> IPA v4.7.  DTS updates that make use of these will be merged later.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] dt-bindings: net: qcom,ipa: Add SM6350 compatible
    https://git.kernel.org/netdev/net-next/c/5071429f8281
  - [net-next,2/2] net: ipa: add IPA v4.7 support
    https://git.kernel.org/netdev/net-next/c/b310de784bac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


