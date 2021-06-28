Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F243B6A72
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 23:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbhF1Vcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 17:32:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235053AbhF1Vca (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 17:32:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2F23661CC6;
        Mon, 28 Jun 2021 21:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915804;
        bh=sO4hAC6hZFrnpVkW5mU6PlP8/AVHaKM3AmKArTwZA4w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FSeXYULFg0ld5GHnnEIkyN9uVuQQQGw59s7eB8tiRFlPgYy+e5v+1ilsamz5XCuX8
         1zlt5bRVTCbEm3hoIa2myjvdofAt52vmW83AULi5r5a5Ll2Qp3wbdJdbEqMMSCU6Fr
         JcT07OBKoG3+tumP2CJUdwBGIGtIArsOVY0pwm+rp/TuUSvrUyfvo9SpXYpLKwQs+1
         HbRMueVSFGLoe5jpK9r9VoCVjNrlgQWc+CyLA5S90IeMtjI84SYhwCrY1K7zzHf0di
         FH5VE1BmD+NvFg2I0o+2r2T0PlWOPCcZk2UPl2QIzlUk7Mvxd6roYblH93zVU5YkFU
         hXx1Hp04Ce/Hw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 248B860A38;
        Mon, 28 Jun 2021 21:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] flow_offload: action should not be NULL when it is referenced
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162491580414.14567.18353749735111413224.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 21:30:04 +0000
References: <20210626115606.1243151-1-13145886936@163.com>
In-Reply-To: <20210626115606.1243151-1-13145886936@163.com>
To:     None <13145886936@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 26 Jun 2021 04:56:06 -0700 you wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> "action" should not be NULL when it is referenced.
> 
> Signed-off-by: gushengxian <13145886936@163.com>
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> 
> [...]

Here is the summary with links:
  - flow_offload: action should not be NULL when it is referenced
    https://git.kernel.org/netdev/net/c/9ea3e52c5bc8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


