Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 681BB69C601
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 08:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbjBTHaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 02:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjBTHaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 02:30:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344AEF774;
        Sun, 19 Feb 2023 23:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CC10B80B03;
        Mon, 20 Feb 2023 07:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 20B2CC4339B;
        Mon, 20 Feb 2023 07:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676878218;
        bh=0Q5DvfBKLzMEvPRk6Khvj7WAHQqy61n6TJtFUoO/Ug8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MM3Jfl82nVK/9FCgXr2u3IKDi9rDqtYmHluTT/VyXjj1tpw2oEBpr6Rko5+rHQD+X
         tbfR9aYjGWNNnyu7+c1Uv6VVp9HoMmFDOPClTc+YbiMVBLOKD4KkjTUynOrxXWw0Aj
         GD5MhF7ejYLWBP+5ew/k71Ej4O9PneBgPdIrBS+VT1YfEJqPjxCnY0bIm2HPdTPZjq
         VO8qRDq+RUvE3W46FUeiM++Oj/k7+MJI9Zsk8JPxbdnCEOIQZMESOD23PDoeKjpg5+
         LaVcsh26P+s+UuvieT9EHNh+p+Ng3ooiJtxHS+DwYl1p82Z0CS2vNDdrG3DxZLUNv+
         jNsphShqN1xWg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F33E8E68D22;
        Mon, 20 Feb 2023 07:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: final GSI register updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167687821799.27034.15184583882441170933.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 07:30:17 +0000
References: <20230215195352.755744-1-elder@linaro.org>
In-Reply-To: <20230215195352.755744-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, caleb.connolly@linaro.org, mka@chromium.org,
        evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 15 Feb 2023 13:53:46 -0600 you wrote:
> I believe this is the last set of changes required to allow IPA v5.0
> to be supported.  There is a little cleanup work remaining, but that
> can happen in the next Linux release cycle.  Otherwise we just need
> config data and register definitions for IPA v5.0 (and DTS updates).
> These are ready but won't be posted without further testing.
> 
> The first patch in this series fixes a minor bug in a patch just
> posted, which I found too late.  The second eliminates the GSI
> memory "adjustment"; this was done previously to avoid/delay the
> need to implement a more general way to define GSI register offsets.
> Note that this patch causes "checkpatch" warnings due to indentation
> that aligns with an open parenthesis.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: ipa: fix an incorrect assignment
    https://git.kernel.org/netdev/net-next/c/ecfa80ce3b87
  - [net-next,2/6] net: ipa: kill gsi->virt_raw
    https://git.kernel.org/netdev/net-next/c/59b12b1d27f3
  - [net-next,3/6] net: ipa: kill ev_ch_e_cntxt_1_length_encode()
    https://git.kernel.org/netdev/net-next/c/f75f44ddd4cb
  - [net-next,4/6] net: ipa: avoid setting an undefined field
    https://git.kernel.org/netdev/net-next/c/62747512ebe6
  - [net-next,5/6] net: ipa: support different event ring encoding
    https://git.kernel.org/netdev/net-next/c/37cd29ec8401
  - [net-next,6/6] net: ipa: add HW_PARAM_4 GSI register
    https://git.kernel.org/netdev/net-next/c/f651334e1ef5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


