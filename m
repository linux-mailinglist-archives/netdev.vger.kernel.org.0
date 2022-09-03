Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6D25ABCD1
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 06:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbiICEUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 00:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbiICEUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 00:20:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3448132AA7;
        Fri,  2 Sep 2022 21:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9463FB82E32;
        Sat,  3 Sep 2022 04:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1510CC433D7;
        Sat,  3 Sep 2022 04:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662178817;
        bh=rtFupttbrocc//hi2dAYjl4KhKvr3MtZmnTX4JhTOLM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bxuRUKEmJqCsaggfm/dbq9/FfGLTtPZSNvHcIuTzUja1dCw1he5huNIWMDWz8DPg3
         L9pcoPxmf95S36WM2vi2CLPX+e6uGIK3V7+ADXQwZ95E3KaYlSAYcvnkvLZhqNGJZL
         Xu8dDZrcAzIqb/USyFfy7ZGMVCFkGCK23wo2dDjqRCDzdAjhiKXWFveOob9A6Y+HJv
         jqnAwDad/A071WGiJJ6BXuQ87+OtYAUdJ9nLj/0mOYTaSBiwbHQ2TMjcU3fEwvBSE9
         zA1NCzy923SvXyVMPGH5rEjcXnFLlHDQf1xNWkaE7UyuR/AECnd3s417HacYRjR8G1
         5qx4q+vTGS31w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EB3AAC73FE1;
        Sat,  3 Sep 2022 04:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: fec: add pm_qos support on imx6q platform
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166217881695.4142.6608924461529704195.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Sep 2022 04:20:16 +0000
References: <20220830070148.2021947-1-wei.fang@nxp.com>
In-Reply-To: <20220830070148.2021947-1-wei.fang@nxp.com>
To:     Wei Fang <wei.fang@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 Aug 2022 15:01:48 +0800 you wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> There is a very low probability that tx timeout will occur during
> suspend and resume stress test on imx6q platform. So we add pm_qos
> support to prevent system from entering low level idles which may
> affect the transmission of tx.
> 
> [...]

Here is the summary with links:
  - [net] net: fec: add pm_qos support on imx6q platform
    https://git.kernel.org/netdev/net/c/7d650df99d52

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


