Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400336BAA78
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbjCOIKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbjCOIKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:10:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59B810EF;
        Wed, 15 Mar 2023 01:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87D53B81D48;
        Wed, 15 Mar 2023 08:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1EF97C4339C;
        Wed, 15 Mar 2023 08:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678867819;
        bh=OBbchMB77kcbwa/kEFFAQFBIGw38CmUFDiLdASMYaVk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E9ODLlL05y8I2Rc6fOxfwWE1IGjqrtpgG8WO+TNco8FjjxALeVYYjn8oHbO2zztwn
         NBGUvwazi+OYiLT8eTm03MbGcYFyYGbvI3W5cb5Hm6/aBd5iSwSx27T86+zjEqOJLY
         OzpEDO0Dwysjc4tR3Xyus3CkPGm1tCupQUrTkOX6VPFcWGTlxSgfEk+4R75ZZr+ato
         9rhkbaPsP1OfJsBCCJY9erA65ZOXPrBcb9VxLc0DLoA9QHiRAfR5p+5fAp6c/LlERA
         nq9Zh17EOz9jp2Jah13EhxRz+qgZM+FSZnDmAOgm046Q620l6HJUJmMBsNlQASinr0
         CphgZCmH3pl5A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0097BC43161;
        Wed, 15 Mar 2023 08:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: trf7970a: mark OF related data as maybe unused
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167886781899.24118.1945055950810799082.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Mar 2023 08:10:18 +0000
References: <20230311111328.251219-1-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230311111328.251219-1-krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     mgreer@animalcreek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Sat, 11 Mar 2023 12:13:28 +0100 you wrote:
> The driver can be compile tested with !CONFIG_OF making certain data
> unused:
> 
>   drivers/nfc/trf7970a.c:2232:34: error: ‘trf7970a_of_match’ defined but not used [-Werror=unused-const-variable=]
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> [...]

Here is the summary with links:
  - nfc: trf7970a: mark OF related data as maybe unused
    https://git.kernel.org/netdev/net-next/c/a52ed50a04de

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


