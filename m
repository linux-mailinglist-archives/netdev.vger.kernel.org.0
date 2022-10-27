Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5EC60F6A7
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 14:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbiJ0MA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 08:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235453AbiJ0MA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 08:00:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6973B447;
        Thu, 27 Oct 2022 05:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 79E43CE2645;
        Thu, 27 Oct 2022 12:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB4DAC433D6;
        Thu, 27 Oct 2022 12:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666872017;
        bh=JfPJWLo2/MXWbmo3lmwaTqHkhHCSrHs+eujYR/yhiwE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eNuQ7Mixoe4tj4T68o4XImg26CqvBUYlPygf8ScXRsgXp52llJQgSkfIx3Gfl4f2S
         wOryIAR21htbRi8UYGUhQtT/otfM8OAiosvZbliN6xK0pqk6+tPskdjm381xKddm3w
         +VGsER+hgtugW7ryPWjvM3Ffj9Lq7iUJpvSL7QjnbhLK6+OfMCp4gdQ1279W9tuKE+
         vzdVx9JjmHMxF5r6zL8Hfbq+BCqXKkHwR58FS8FNkA4MDEbKdYYKkIq50YEFXsk6J6
         hTKvMcG6EGUIqfNjcOMXfToA7y0d5STGrn5/fsO+kP8g8CwPSY8wsRuN/J7vOeQ/fv
         SiOnu5M51BqUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8C9E8E270DA;
        Thu, 27 Oct 2022 12:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: ipa: don't use fixed table sizes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166687201757.29716.7404783392276656944.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 12:00:17 +0000
References: <20221025195143.255934-1-elder@linaro.org>
In-Reply-To: <20221025195143.255934-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 25 Oct 2022 14:51:39 -0500 you wrote:
> Currently, routing and filter tables are assumed to have a fixed
> size for all platforms.  In fact, these tables can support many more
> entries than what has been assumed; the only limitation is the size
> of the IPA-resident memory regions that contain them.
> 
> This series rearranges things so that the size of the table is
> determined from the memory region size defined in configuration
> data, rather than assuming it is fixed.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: ipa: record the route table size in the IPA structure
    https://git.kernel.org/netdev/net-next/c/fc094058ce01
  - [net-next,2/4] net: ipa: determine route table size from memory region
    https://git.kernel.org/netdev/net-next/c/0439e6743c5c
  - [net-next,3/4] net: ipa: don't assume 8 modem routing table entries
    https://git.kernel.org/netdev/net-next/c/8defab8bdfb1
  - [net-next,4/4] net: ipa: determine filter table size from memory region
    https://git.kernel.org/netdev/net-next/c/f787d8483015

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


