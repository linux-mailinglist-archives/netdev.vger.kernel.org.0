Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC1446DF6C
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 01:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241471AbhLIAdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 19:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235439AbhLIAdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 19:33:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD12C061746;
        Wed,  8 Dec 2021 16:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3ABBB82313;
        Thu,  9 Dec 2021 00:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B004BC00446;
        Thu,  9 Dec 2021 00:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639009809;
        bh=ogftWMpqNYBxuUBslduVH4IFMYjcAAF8DLNMMzlsSU0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OhmSATsUARcLKIov3JLz7V6+11T0f1bibCsVpmxcjyHpCAGYnV4cklFU1bOErMzEk
         lND7TwhIKaX8a2DjvR44KRw46+mSXntmqzixjfzFpCg7qYvZADRhti0d2tfRoxsJQu
         7CNvxJ9KEp+wdNkk5uQMmQUic/n8KFWK1Xo2D4pqUTRvpVFeH/ZSfHAsmmd0DsWGNV
         ikKbApgwuCblPrAinyzs+1I1GsRIKPX4MtbuhwBgbvL25PwI33C3DvwrEO0zxve+0H
         5/sAB/bitIsHzMi5V3PBcI2MrirSFwVPgoitYXhyXdOFiYzXMmn6+84nzfrXIZ3iRz
         HRX++WUxiXNOg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8F90060A3C;
        Thu,  9 Dec 2021 00:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2021-12-08
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163900980958.13240.10328840106514754059.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 00:30:09 +0000
References: <20211208155125.11826-1-daniel@iogearbox.net>
In-Reply-To: <20211208155125.11826-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Dec 2021 16:51:25 +0100 you wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 12 non-merge commits during the last 22 day(s) which contain
> a total of 29 files changed, 659 insertions(+), 80 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2021-12-08
    https://git.kernel.org/netdev/net/c/6efcdadc157f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


