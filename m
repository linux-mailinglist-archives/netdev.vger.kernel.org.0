Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5624C46E0BD
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 03:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhLICNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 21:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhLICNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 21:13:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47395C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 18:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 861B4CE2473
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 02:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE70CC341CE;
        Thu,  9 Dec 2021 02:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639015810;
        bh=krOSCiNn85mh7S9xU43MhWd2PW7E8k1810WGngvp2Mk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y1m+nqkzP4BHB+3s9uxiHaLki6uDl0a4KeNq/854tFd1WVd+YGb1NwKG0Gcrwq2Xz
         MSc+p4d7uYB9AYym6aUhcY3sPoVrxp9kTspX1MJxJOlJrdE2jtTyxsO1NX2kotyfHX
         5mPiYVvCtg6gxnZrp9EcI883b2HQMYUI5w6F2R9J3unltajnPRxvGDisIYPfF4R+Gz
         d1Xx5ik8cnRDz9H7dkAhvi/U+83BW/LFf5mMRRaiKeJB80pOhyis+pioqNj59W0w5x
         dEoEB71rpWY4yJT/DRojGIeDKdGW1I1Jh0+spokI/bJVyDaoYGaYRwpCD/IclJqKxY
         plx6jf1p2RmNQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9C8F760A36;
        Thu,  9 Dec 2021 02:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net-next v2 0/4] WWAN debugfs tweaks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163901581063.22374.5474223279474124190.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 02:10:10 +0000
References: <20211207092140.19142-1-ryazanov.s.a@gmail.com>
In-Reply-To: <20211207092140.19142-1-ryazanov.s.a@gmail.com>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        m.chetan.kumar@intel.com, linuxwwan@intel.com,
        loic.poulain@linaro.org, johannes@sipsolutions.net, leon@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Dec 2021 12:21:36 +0300 you wrote:
> Resent after dependency [2] was merged to the net-next tree. Added
> Leon's reviewed-by tag from the first V2 submission.
> 
> This is a follow-up series to just applied IOSM (and WWAN) debugfs
> interface support [1]. The series has two main goals:
> 1. move the driver-specific debugfs knobs to a subdirectory;
> 2. make the debugfs interface optional for both IOSM and for the WWAN
>    core.
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next,v2,1/4] net: wwan: iosm: consolidate trace port init code
    https://git.kernel.org/netdev/net-next/c/e9877d4ef856
  - [RESEND,net-next,v2,2/4] net: wwan: iosm: allow trace port be uninitialized
    https://git.kernel.org/netdev/net-next/c/13b94fbaa28c
  - [RESEND,net-next,v2,3/4] net: wwan: iosm: move debugfs knobs into a subdir
    https://git.kernel.org/netdev/net-next/c/cf90098dbb1f
  - [RESEND,net-next,v2,4/4] net: wwan: make debugfs optional
    https://git.kernel.org/netdev/net-next/c/283e6f5a8166

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


