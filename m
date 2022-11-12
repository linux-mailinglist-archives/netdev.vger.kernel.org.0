Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEC04626741
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 07:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbiKLGA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 01:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233446AbiKLGAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 01:00:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EC61183A;
        Fri, 11 Nov 2022 22:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E25FE60B7C;
        Sat, 12 Nov 2022 06:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F361C433D6;
        Sat, 12 Nov 2022 06:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668232818;
        bh=Cc00GUziqpEEUO2BSbvzg6qh2KbXsDUerRvn2urwehE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JZUjRRdgPq1XPkkWGuabvIGGQPiqmYtVzXkyQAyNJgnSEQtUeJ2qJ3OJ21Z7t8Jqk
         6lYmt9p5zeFEM+Llaa5+YC9Fpn1wKxDtdgxKN0B+1dzjwV+3rmwt+mlmBOhCrKjWe2
         0TesZrqXYkDZ4MEFHwaTVQW3Tts8R744seZtXYqu76076gZqk4jftGV7z6uHQQymZ7
         ZNuuh8RtqY02kNhU72kfnTzHp7ozJ5qWp4JZgdneEiUoFMGn1XXt+Pix7iCl9ky4FJ
         r+7cHg6MHKPeiavVmUCGMe/O8HNvuR6wKy/pUJzbH1+pt8KsLv+IN6s//fi1hFeImt
         yTQCsC5YkX/AA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 119ADE270C3;
        Sat, 12 Nov 2022 06:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] dt-bindings: net: qcom,ipa: relax some
 restrictions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166823281806.10181.477421817831482606.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Nov 2022 06:00:18 +0000
References: <20221110195619.1276302-1-elder@linaro.org>
In-Reply-To: <20221110195619.1276302-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, andersson@kernel.org, konrad.dybcio@linaro.org,
        agross@kernel.org, elder@kernel.org, linux-arm-msm@vger.kernel.org,
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

On Thu, 10 Nov 2022 13:56:16 -0600 you wrote:
> The first patch in this series simply removes an unnecessary
> requirement in the IPA binding.  Previously, if the modem was doing
> GSI firmware loading, the firmware name property was required to
> *not* be present.  There is no harm in having the firmware name be
> specified, so this restriction isn't needed.
> 
> The second patch restates a requirement on the "memory-region"
> property more accurately.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] dt-bindings: net: qcom,ipa: remove an unnecessary restriction
    https://git.kernel.org/netdev/net-next/c/9d26628a4ce2
  - [net-next,2/2] dt-bindings: net: qcom,ipa: restate a requirement
    https://git.kernel.org/netdev/net-next/c/7a6ca44c1e61

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


