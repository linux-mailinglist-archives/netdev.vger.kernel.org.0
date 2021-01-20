Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0393E2FC72E
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 02:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731444AbhATBvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 20:51:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731136AbhATBuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 20:50:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8403022C9E;
        Wed, 20 Jan 2021 01:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611107410;
        bh=W9Yppew30qqt90qI9Pcv/yX7QNjXgsxhjuPRrqfoa8k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TsBD9VYGO0Jj/xy1NKBTDptITfSdliOtUA/3/0XUwyLN0roUj6r7k+l+fTZzBOqVx
         boAwpDzF8DkRSg2OX9Qfv7HGlg9jzOORQWRtmJ3ZC1gWYlKA7QHMRGbpaiuJBmavWV
         qpi086TXJv1DcvEVwvSsasXWvksz/KDrzTzPzHOJYf9M51isQ7eMyms0dEAavsL9gw
         OU9yLvM9ckiOkBpiBVkZX+RfXNmabuyRx8UgvvOdHDkLsjD5UYpQbJfcMma92LL4np
         nH0prnWPF7ZkWYNp6oTysX1qvSt/NlrzrxRLRSXOVNPSpWUzi08UfN5TPWa49rNcEh
         jUgb80jyfAMxQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 807B760189;
        Wed, 20 Jan 2021 01:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: smsc911x: Make Runtime PM handling more fine-grained
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161110741052.23772.8110530818754056835.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jan 2021 01:50:10 +0000
References: <20210118150857.796943-1-geert+renesas@glider.be>
In-Reply-To: <20210118150857.796943-1-geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     steve.glendinning@shawell.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 18 Jan 2021 16:08:57 +0100 you wrote:
> Currently the smsc911x driver has mininal power management: during
> driver probe, the device is powered up, and during driver remove, it is
> powered down.
> 
> Improve power management by making it more fine-grained:
>   1. Power the device down when driver probe is finished,
>   2. Power the device (down) when it is opened (closed),
>   3. Make sure the device is powered during PHY access.
> 
> [...]

Here is the summary with links:
  - net: smsc911x: Make Runtime PM handling more fine-grained
    https://git.kernel.org/netdev/net-next/c/1e30b8d755b8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


