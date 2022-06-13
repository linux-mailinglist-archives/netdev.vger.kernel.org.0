Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184455499F1
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 19:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbiFMR0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 13:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235934AbiFMRZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 13:25:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC2F28983
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 05:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4006DCE1171
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 12:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F21EC3411C;
        Mon, 13 Jun 2022 12:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655124013;
        bh=L6gSIWMEQwBM15MXyEH/t2zRwBUN7RRzEm/w0OZJ0dE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YkGuOhOa7KYtQ64a7RmMP/EmVZ2NP4FxYbeCd4t5Xlf/0JX9hbGlJDQIuJodDEnif
         800n6i2q0hmM7Vu1dOqWXftNK5uuFGpPQHoOOSQxnM2w57kjDkrxhvbViaj+26qulP
         I/RXqyIvw0hX4OHKWPRic4RINrtooZMEMFWBgisEx6Ozb1gA4j7l4Prbn/wiQYAgDI
         hOZxXtPu5yuvrAo8g51rLI5s6+bwPuJuXk8Fhd8WtjS8VkXarLnhB5tdSvGLGkrBFo
         CF2XAg6YegUQsXPbiMWRNy8+nSAzezkbLnQgsAIPIECvx5pLIy6Bu3x8e0uerNMuDf
         yB7gdHLIE94Pw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 541B2E57538;
        Mon, 13 Jun 2022 12:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: support 48-bit DMA addressing for NFP3800
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165512401334.9046.8201110639385289473.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Jun 2022 12:40:13 +0000
References: <20220613095831.4963-1-simon.horman@corigine.com>
In-Reply-To: <20220613095831.4963-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Jun 2022 11:58:31 +0200 you wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> 48-bit DMA addressing is supported in NFP3800 HW and implemented
> in NFDK firmware, so enable this feature in driver now. Note that
> with this change, NFD3 firmware, which doesn't implement 48-bit
> DMA, cannot be used for NFP3800 any more.
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: support 48-bit DMA addressing for NFP3800
    https://git.kernel.org/netdev/net-next/c/5f30671d8dc6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


