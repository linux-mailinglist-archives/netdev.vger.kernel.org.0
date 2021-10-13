Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963CD42C535
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 17:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhJMPwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 11:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234299AbhJMPwK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 11:52:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6D79E611AD;
        Wed, 13 Oct 2021 15:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634140207;
        bh=sG+TG1u5j7ErDejAVWh66SJVs20pq/mNb/xd97N6u/s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Nk3rBf5K1DSuoNzJm+4qsFvTznaummtEFDa47TCbY6fy+qF9NvW2RqfirASNkLFUr
         L283BgBNPLX0GuKg3MOIHtKHSwU/C3ZMJAGUXNsId4VAjDYROUwxXIawpuBh2rD2+/
         ly+lQr0pArXxrajngWDbamJoKODIz+Bw2SAXk/d3PlSaF4Qbffh+TmiQ/ZZ2CiBoRa
         JnPuqil6kt47YfRT2WWkW0HQfMfhh2ZtYsBBE77TqcxL1B6Y93AiLfXpVVrAGhcXAB
         Ly8cz+ALCoENsFrhxAOD0+l4dBb9cj2j9sp95wmd/WctCTfvYPA2dweupb9pq2ALvo
         KbOlWYYHjNG7g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5E77A60966;
        Wed, 13 Oct 2021 15:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: qed_debug: fix check of false (grc_param < 0)
 expression
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163414020738.31183.2999950120466707875.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Oct 2021 15:50:07 +0000
References: <20211012074645.12864-1-sakiwit@gmail.com>
In-Reply-To: <20211012074645.12864-1-sakiwit@gmail.com>
To:     =?utf-8?q?J=CE=B5an_Sacren_=3Csakiwit=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 Oct 2021 01:46:45 -0600 you wrote:
> From: Jean Sacren <sakiwit@gmail.com>
> 
> The type of enum dbg_grc_params has the enumerator list starting from 0.
> When grc_param is declared by enum dbg_grc_params, (grc_param < 0) is
> always false.  We should remove the check of this expression.
> 
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: qed_debug: fix check of false (grc_param < 0) expression
    https://git.kernel.org/netdev/net-next/c/50515cac8d0e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


