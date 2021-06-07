Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3CE39E8EA
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 23:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhFGVMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 17:12:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230386AbhFGVL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 17:11:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CF7656127A;
        Mon,  7 Jun 2021 21:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623100205;
        bh=t9akLMNCK8wuffGSVEkyGoPAxLxoojY0BoaYJuuyKX8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j4mgAIZktedpzxQ4UOOiCZnb1y9UcZNFDQ+5Mh3mtN3EYPhD8+1kr/uG8rXQgcF+g
         V/e0nYFxSg4ulRBxywnTI1vwhaCg9FiGKEMbsnZTloZVDmODsfOLENn/Glb7a9Gd13
         wfFw2QX1xa0z+oz9YD3x8YHwIy1oAkxepwMz+BwH+mzYtRFrTwnRqqil3lbZ2C9mXS
         Kfbgb3yxNjURTUoyImBrF4/UgnsahDEN2EUUl1Ry/afsbqApjQGwKfJ+EhmWgL01fJ
         5c+2kmYd9Rag00yWufbUXEWF5I7FE7SKfyS3Xl8VpWVWB5JW7S581jYVwE3KRWia78
         B3lrFOIba8cGw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BEBD160CD1;
        Mon,  7 Jun 2021 21:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: tulip: Remove the repeated declaration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162310020577.31357.4143491614671166523.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 21:10:05 +0000
References: <1622871776-20567-1-git-send-email-zhangshaokun@hisilicon.com>
In-Reply-To: <1622871776-20567-1-git-send-email-zhangshaokun@hisilicon.com>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 5 Jun 2021 13:42:56 +0800 you wrote:
> Function 'pnic2_lnk_change' is declared twice, so remove the
> repeated declaration.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> 
> [...]

Here is the summary with links:
  - net: tulip: Remove the repeated declaration
    https://git.kernel.org/netdev/net-next/c/90fdd89f6cf9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


