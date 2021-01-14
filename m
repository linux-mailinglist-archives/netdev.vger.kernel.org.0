Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D152F6E5F
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 23:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730793AbhANWlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 17:41:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:57998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728452AbhANWlT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 17:41:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3DDF323977;
        Thu, 14 Jan 2021 22:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610664039;
        bh=f7FdxZlvX3iXHrhJjazOt7jDXpblTW06ltYkPFES+Ho=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t9LXk8jOXoNXcW7Fwr8Lb6CUdB0aaCRecE055xySyXP9DVF3I2elxdb+MMWsM4s2t
         OXm8VcOwFs6CWvV4TRiugakSWeGXac4693Bul3tVLny7+srBaCJANYqhFrrYEU0t5n
         JzuDiMWFNVgUSdEDKUwIxXtVilUZafhCUpxCuKwqFfDRChygwGaKwxGt36JQaGazeX
         74XYKlpXGb4ByjgkcE08rTDZF1xugLDtwWs3/Ja4w4F8onpoXg1S0kKzYo+thIxm2D
         bUp4R33GhqzcHBe5lKKGEFtpD5OjAtrPE+DHPKCviXPAkM3jijUNGQEbK4Z4cgOuHU
         np8cpkkUM+bqg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 359156018E;
        Thu, 14 Jan 2021 22:40:39 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking for 5.11-rc4
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161066403921.16239.10890664021293856691.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jan 2021 22:40:39 +0000
References: <20210114200551.208209-1-kuba@kernel.org>
In-Reply-To: <20210114200551.208209-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Thu, 14 Jan 2021 12:05:51 -0800 you wrote:
> Hi!
> 
> We have a few fixes for long standing issues, in particular
> Eric's fix to not underestimate the skb sizes, and my fix for
> brokenness of register_netdevice() error path. They may uncover
> other bugs so we will keep an eye on them. Also included are
> Willem's fixes for kmap(_atomic).
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking for 5.11-rc4
    https://git.kernel.org/netdev/net/c/e8c13a6bc8eb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


