Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF6350DDDF
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 12:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239442AbiDYKdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 06:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238598AbiDYKdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 06:33:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D88FC13;
        Mon, 25 Apr 2022 03:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C2A560EC8;
        Mon, 25 Apr 2022 10:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C8B1C385AE;
        Mon, 25 Apr 2022 10:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650882612;
        bh=kMSI7jYM56shSMbM4ufkb7PWdB8PwotuJ9mxtYzPqSg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b7q+a271nra3bDS2ncH4iyVSDSN1JWY+xbWh4Kql9JCSN8qGwFuXS98TxK2SOUOk+
         uZg4+AxYPqtEhAzGq5iKwTsgCG61De2sYSlQU/K+Gt6t54bW3Om0Pg8VzZhYkcFwgg
         2/o7iKPqvsSRWWs7fPs1eAZZkTOXQW8Ev66r87YTUjc1+ICzqJ8w3kdzzTxkepCduc
         nQEFZ4hceirJlQQlwIdewQKphvDKTfQtvILGJk/GvPODA8B0nJGak/PzTFhG+Y0zJc
         pmcF8i+IxNwGn0sMh89Ei/wH05vkCXCPS9AAF42StwlSSzowI9ZagVRPALcywQrQq2
         g6/bQgh5lSENg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66BBEEAC09C;
        Mon, 25 Apr 2022 10:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipa: compute proper aggregation limit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165088261241.604.18011066317491406409.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Apr 2022 10:30:12 +0000
References: <20220421185333.1371632-1-elder@linaro.org>
In-Reply-To: <20220421185333.1371632-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, mka@chromium.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, avuyyuru@codeaurora.org,
        jponduru@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 21 Apr 2022 13:53:33 -0500 you wrote:
> The aggregation byte limit for an endpoint is currently computed
> based on the endpoint's receive buffer size.
> 
> However, some bytes at the front of each receive buffer are reserved
> on the assumption that--as with SKBs--it might be useful to insert
> data (such as headers) before what lands in the buffer.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ipa: compute proper aggregation limit
    https://git.kernel.org/netdev/net-next/c/c5794097b269

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


