Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE284C6E33
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236162AbiB1Nbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236102AbiB1Nbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:31:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5504832EE5;
        Mon, 28 Feb 2022 05:31:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D641B81188;
        Mon, 28 Feb 2022 13:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9A91CC340F8;
        Mon, 28 Feb 2022 13:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646055059;
        bh=055+r7Bv0YKZLvW2yw6sPT6DWnJzO/MTP8OxhUtCSac=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E584kEgauBkAa3o8F4en2NVEZC4Hk4ZoqFTLbuItRh27GHeySF6/923XzN5UXuP/b
         INGgWhp8e7E/rsaATEq16lh9k+h13PIKyBXqSc+bu7X+lvYKOCxTWeAHGp/feK67T4
         d+BxSZxZAUyAyrKhQxmpkmsR0bTTAvSZQuDjKJ92G+xiCEi4Q1cDjIFGcyzt6qiB5W
         c9s1eCSLXs3P6pdURXzwE1GahI581Ep7y/Ebsck+gBY9ubuRA/e3K9R3XzaDCtFzjd
         iUGokDX6+uvEMMtMuTfJ9UnNnl5QVN3Hzpf9QDzB5O20XDnFG4leONFkwYxb85bwKh
         cK3OFRLKoeQDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81852F0383A;
        Mon, 28 Feb 2022 13:30:59 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: hamradio: use time_is_after_jiffies() instead of open
 coding it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164605505952.13902.7199174306567919754.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 13:30:59 +0000
References: <1646018012-61129-1-git-send-email-wangqing@vivo.com>
In-Reply-To: <1646018012-61129-1-git-send-email-wangqing@vivo.com>
To:     Qing Wang <wangqing@vivo.com>
Cc:     jreuter@yaina.de, davem@davemloft.net, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun, 27 Feb 2022 19:13:31 -0800 you wrote:
> From: Wang Qing <wangqing@vivo.com>
> 
> Use the helper function time_is_{before,after}_jiffies() to improve
> code readability.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> 
> [...]

Here is the summary with links:
  - net: hamradio: use time_is_after_jiffies() instead of open coding it
    https://git.kernel.org/netdev/net-next/c/61c4fb9c4d09

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


