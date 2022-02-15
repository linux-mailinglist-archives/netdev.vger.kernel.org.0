Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1604B71A2
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239482AbiBOPAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:00:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiBOPAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:00:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FA7DEB7;
        Tue, 15 Feb 2022 07:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43FCE61522;
        Tue, 15 Feb 2022 15:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A8CFBC340F8;
        Tue, 15 Feb 2022 15:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644937211;
        bh=4EYQjYPn1GhJ8ViQhgPlLRxzOI7VedWVmeC5Eemn+vo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uFUw+86kjx3kDz0YthS9TMGNV1WMZkrQBD8O6Q/cKxYHn+5XIZqRqVCjsG3QRjDD6
         ASn62w9p5JRFttrEZWen7uKkwBq+YGH0feEbLMnlyeJ1jfOnCvsev4f1A0VP7kpQG7
         RfefS831uyMtAwcTc8UKYk43uACIr+eHXe9WtNhalj+Ok7eB8z2oAa+XMc4aLEG4Df
         H4lLCtfrRejrKPbOC7kaOQkdZgGWcflY02An/eAd8sWFFeyb2Uv+SB5Z26LFSI4U+o
         2ffn2DK2orJMFN2iCvghG+3sOgcT4FsWBFlD3bXxlcVslAXQkkvkxWpZT+Ywi/uk47
         Pfye30lnSp/4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 984F7E6BBD2;
        Tue, 15 Feb 2022 15:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] dpaa2-eth: Simplify bool conversion
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164493721161.12867.2133590611452469695.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Feb 2022 15:00:11 +0000
References: <20220215010913.114395-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20220215010913.114395-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, ioana.ciornei@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        abaci@linux.alibaba.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 15 Feb 2022 09:09:13 +0800 you wrote:
> Fix the following coccicheck warnings:
> ./drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:1199:42-47: WARNING:
> conversion to bool not needed here
> ./drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:1218:54-59: WARNING:
> conversion to bool not needed here
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [-next] dpaa2-eth: Simplify bool conversion
    https://git.kernel.org/netdev/net-next/c/99cd6a64e128

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


