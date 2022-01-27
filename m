Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4720149D942
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 04:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235533AbiA0DaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 22:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiA0DaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 22:30:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA8AC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 19:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFF58B82137
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 03:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8874DC340EA;
        Thu, 27 Jan 2022 03:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643254210;
        bh=fYrzMJ/Ovo+GvbJjDvZa9qIvoWx1DaT3gQlAptgHP+E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HjmeeE3ymqkweCpOa6nqSO98+pypGzqunlMyO9c1h9B5fOCuLwMZBxj+RiHutBsxr
         SzhVSaRNiskl0VuVWuV3t5GUlEEvKqJ7yx8jloXNaNkfmMFEsVkby/lfr4e3CjUD2q
         LOoVa7kovrCAqtA3DYWu3Pkh5nko3pUMgQ9OLY8jBVNkNADfE9qyujtOYypniWssAd
         Ur3wi0Aq61CgAfglU9Sgg5fydDL00uLii/5we4SOhpxGPyD3isKoe+KWrNmftQtb5H
         FQ9NZpWEnd7H1z+nB4tbTvOnOhKYbnNUU8uNN3DS5TuRf3vTzZfutJVOtQRr8uZE/t
         Nd5qYSE4tn7Cg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 74984F6079C;
        Thu, 27 Jan 2022 03:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: allocate tcp_death_row outside of struct
 netns_ipv4
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164325421047.18421.13634511468557984238.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 03:30:10 +0000
References: <20220126180714.845362-1-eric.dumazet@gmail.com>
In-Reply-To: <20220126180714.845362-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com, pabeni@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 26 Jan 2022 10:07:14 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> I forgot tcp had per netns tracking of timewait sockets,
> and their sysctl to change the limit.
> 
> After 0dad4087a86a ("tcp/dccp: get rid of inet_twsk_purge()"),
> whole struct net can be freed before last tw socket is freed.
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: allocate tcp_death_row outside of struct netns_ipv4
    https://git.kernel.org/netdev/net-next/c/fbb8295248e1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


