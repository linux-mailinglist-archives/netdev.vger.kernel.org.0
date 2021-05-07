Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17382376D2A
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 01:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhEGXLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 19:11:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229869AbhEGXLM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 19:11:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 72A2E61468;
        Fri,  7 May 2021 23:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620429011;
        bh=vH9/PlnWodNLLX7YiWuIeY8MrQ5kTnF5JqlpsgZeC5k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cbdkmH6tirbe6p1MTM6UV1zegrRvhjBp1iQrk1eyeQDQQRyoF5HoQXAy+AaUxYBzZ
         92rbUN73OFAnmgI5+fEc6OcjPOBAvwMTZ9Qno0kLCHQ1HGvOEc5AgS+NTnOxgD6UnV
         50NExga12nvpl/+UyX62vBwgZyAPq6U4X9fAu2LPHMG97Z1lQ5Q1L/PfgtvnuN/Z+A
         6MMi+H3S97kZ+WdNa4wxWGd8te0Hmvr6ea95FSM/1AAjPpUZn2gOl1lyz/lvqPxdN2
         svz8Fvf9d1iM7xppInWcMcBZSP+xjMmmUF5bT7IEjN0myGWJSNHfxLa3wfiFETCXaK
         4AVr+odpzFB5A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 62C9A60A02;
        Fri,  7 May 2021 23:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] atm: firestream: Use fallthrough pseudo-keyword
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162042901140.19618.2988190478817675772.git-patchwork-notify@kernel.org>
Date:   Fri, 07 May 2021 23:10:11 +0000
References: <20210507123843.10602-1-jj251510319013@gmail.com>
In-Reply-To: <20210507123843.10602-1-jj251510319013@gmail.com>
To:     Wei Ming Chen <jj251510319013@gmail.com>
Cc:     linux-kernel@vger.kernel.org, 3chas3@gmail.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  7 May 2021 20:38:43 +0800 you wrote:
> Add pseudo-keyword macro fallthrough[1]
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through
> 
> Signed-off-by: Wei Ming Chen <jj251510319013@gmail.com>
> ---
>  drivers/atm/firestream.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - atm: firestream: Use fallthrough pseudo-keyword
    https://git.kernel.org/netdev/net/c/7d18dbddb727

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


