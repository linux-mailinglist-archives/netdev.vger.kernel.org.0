Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63CC9617A1D
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 10:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiKCJkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 05:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiKCJkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 05:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DC495A6;
        Thu,  3 Nov 2022 02:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F181F61DDB;
        Thu,  3 Nov 2022 09:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 554A5C433C1;
        Thu,  3 Nov 2022 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667468415;
        bh=l+c1kjFNq2OOVRwV530ZwP3z8tX3+xyIPW26VTl4Mdg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qhIOQve+rQIYFChOua8rsojSoLJRlr4UJaZe075cNPYjwjmTwzJCXGlOqGfYDKf0A
         QMAJO2x3cEfhRBgmww/6bvS2wdRVlOLWYbciEzlhln+K5OJMdASEek08JLSJ5cykH4
         7ZVp7JDFdjD4iafd7OV5AUS8v38SQi78a0stLNdba153Ihhc/Kk+bXWDtTSqMl6EMl
         dGNyPAQ1E6KopyJKxhjC+0kcamTZTiihvQ+pIjDkKRACAA2Ri+pm44cTOlLdKLeZdD
         I9reRZOkVuUzEswDNLPyyfuYIvS4nhuds9xF/xCM+HZ8kvpKiIWRHG9XvMK/c6Crl8
         oMAz4nTNuel1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3812BE29F4C;
        Thu,  3 Nov 2022 09:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 1/1] net: fec: add initial XDP support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166746841521.16372.10021204129091202949.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 09:40:15 +0000
References: <20221031185350.2045675-1-shenwei.wang@nxp.com>
In-Reply-To: <20221031185350.2045675-1-shenwei.wang@nxp.com>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, imx@lists.linux.dev, lkp@intel.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 31 Oct 2022 13:53:50 -0500 you wrote:
> This patch adds the initial XDP support to Freescale driver. It supports
> XDP_PASS, XDP_DROP and XDP_REDIRECT actions. Upcoming patches will add
> support for XDP_TX and Zero Copy features.
> 
> As the patch is rather large, the part of codes to collect the
> statistics is separated and will prepare a dedicated patch for that
> part.
> 
> [...]

Here is the summary with links:
  - [v3,1/1] net: fec: add initial XDP support
    https://git.kernel.org/netdev/net-next/c/6d6b39f180b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


