Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F303FC6C9
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 14:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241567AbhHaLvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 07:51:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229952AbhHaLvA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 07:51:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 975DB60FED;
        Tue, 31 Aug 2021 11:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630410605;
        bh=NVpP+rTjFMERe3yvEPi30QfNOHarsp5IPtCTOz/Z7/s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bcuy6lVylagG+O1d4v1vYyG0LSQj/yEAOjJIiJ6Ke+yTeO8A2Ohh7nlBX0pX8+veY
         bNR3AgV5yH8SqQC/DDe4nZSNrNT1Jri7C9gJLNGVBSQyHdjb5ZejsrTdJ9/gXkdYhD
         AZtpgqkBNE3LmgOfaqi8PbJ/3qYKCCggx/kQQEF4x9QKdhsgOfQqd6qxJ4NYEIJWXR
         13Rcl5DcvxD7RN2zmaeyqYgmds1oZReE5jYkOxcnLCXvpZ0F5X/j3BQFLABX2jedjR
         XIOkb+RArqWAsqyOlAYxRekS79dSm1DyXRFEajTMBuPLsfeNDg6Wo+jB2EeDee4HfP
         aJzgrbXRUGHhQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8F2A360A6F;
        Tue, 31 Aug 2021 11:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv6: seg6: remove duplicated include
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163041060558.24859.6240399073052101215.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Aug 2021 11:50:05 +0000
References: <20210831112250.17429-1-lv.ruyi@zte.com.cn>
In-Reply-To: <20210831112250.17429-1-lv.ruyi@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lv.ruyi@zte.com.cn, zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 31 Aug 2021 04:22:50 -0700 you wrote:
> From: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> Remove all but the first include of net/lwtunnel.h from 'seg6_local.c.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - ipv6: seg6: remove duplicated include
    https://git.kernel.org/netdev/net-next/c/a9e7c3cedc29

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


