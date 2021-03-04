Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5222432C9DB
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 02:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbhCDBNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 20:13:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:57274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242000AbhCDBKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 20:10:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4D54264F6C;
        Thu,  4 Mar 2021 01:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614820207;
        bh=/qfHgCUQRUTtXcdHTg/4f1oGqVVw7OYzXDkei16Mxyk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EzBTs9e1LYuzADZ949c/ipQWsXZQpjmvSrDB65r12adcaIi0EZb/cT/r70JpTK88/
         I6o51vmspNQ2JHzJYg8bKl0LV6/nszWlz+cyXfdelMMeHdk6v3yhTXUlKnfm8LFlxo
         xftehVbt4CzPwVVDm4JsrSQx8TVRnw/V579tdY+LlBQFmM8w1/91IuLCdpSCZmbgnL
         nPuoZI32XYo8x5yHDKwwwXv7/d8CqCduRFtM2YyPN/BYeAEF48b5AI9EOM8/WVt5zJ
         aLpsewjZxdUPlznSI9qzf3Q7+hWjEsA98xWI1jvcb2RGVDn6X6Lb2M2QxMOe74YHAJ
         2iS9oAu0NZoQQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3D496609D4;
        Thu,  4 Mar 2021 01:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: 9p: advance iov on empty read
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161482020724.32353.3785422808049340949.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Mar 2021 01:10:07 +0000
References: <20210302171932.28e86231@xhacker.debian>
In-Reply-To: <20210302171932.28e86231@xhacker.debian>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        davem@davemloft.net, kuba@kernel.org,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 2 Mar 2021 17:19:32 +0800 you wrote:
> I met below warning when cating a small size(about 80bytes) txt file
> on 9pfs(msize=2097152 is passed to 9p mount option), the reason is we
> miss iov_iter_advance() if the read count is 0 for zerocopy case, so
> we didn't truncate the pipe, then iov_iter_pipe() thinks the pipe is
> full. Fix it by removing the exception for 0 to ensure to call
> iov_iter_advance() even on empty read for zerocopy case.
> 
> [...]

Here is the summary with links:
  - [v2] net: 9p: advance iov on empty read
    https://git.kernel.org/netdev/net/c/d65614a01d24

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


