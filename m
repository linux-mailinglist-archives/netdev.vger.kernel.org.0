Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 172756EC9DD
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 12:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjDXKK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 06:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjDXKKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 06:10:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B48B3A8E;
        Mon, 24 Apr 2023 03:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A7D161449;
        Mon, 24 Apr 2023 10:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 877B0C433EF;
        Mon, 24 Apr 2023 10:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682331020;
        bh=iOAG2mjz5qtCBCYdkcCJEO4M/H7p9iv4JDMP+h1LvR0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R1ywCOFfwcRyUlPqlIls5FmumkyQNF7VISIM0dlLzoba1mxitZ+ZRxyvyGhh0LPyV
         JB3RYiPSqaHXzujJcw0IL91KfxR7/GJv3MBrMsiOr2oS/3KHyoLpQH4CH74XGopsjt
         ezvmVSnulbyj3qOJ0Oy7HeJSdfhdjNgCykm8uhMGtBAagXvMK41n4qtp4EGdUdaK7d
         857BQRqW4nQWUIntcDCpG6qN7kfS+1k7LV8jmUZDkArnyszQxHrfJRzXSkigVyDeS7
         DxOGJ1D09UJqw6H5NWnoMmePHjnADE0I0ENUQNvLGxKjTfK8Myq9zbio+gxqWnc0w7
         X4N9GzvVTVSSQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 676BDC395C5;
        Mon, 24 Apr 2023 10:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: Remove PPP maintainer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168233102042.17847.1507255515078426933.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Apr 2023 10:10:20 +0000
References: <ZEW5CLw7MW4tPxml@cleo>
In-Reply-To: <ZEW5CLw7MW4tPxml@cleo>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 24 Apr 2023 09:02:32 +1000 you wrote:
> I am not currently maintaining the kernel PPP code, so remove my
> address from the MAINTAINERS entry for it.
> 
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
> ---
> I am still maintaining the user-space PPP daemon, though.
> Also, the paulus@samba.org address will probably stop working soon.
> 
> [...]

Here is the summary with links:
  - MAINTAINERS: Remove PPP maintainer
    https://git.kernel.org/netdev/net/c/60fd497c99b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


