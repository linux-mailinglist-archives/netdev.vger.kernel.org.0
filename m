Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD2743E0B8
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 14:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhJ1MWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 08:22:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230170AbhJ1MWj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 08:22:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D9F9761139;
        Thu, 28 Oct 2021 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635423612;
        bh=e+7uQO4Z514COGcNqaZ3IY2XlFDBVpCsFneCDxUupJw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kjx+j+y/HyeRonoj39LE/28b4cXpv+feW6uyU9phCZoYYnsMPxrhOKzsKrZdIJexm
         igRrssjQ9pZTgkWwO3OCX4q2xtF3F+z6UwkROdtrkHo/i4zNljT6Tuh0uvIlBZpGoe
         AedTPullKuBHpURmJQ12yVOzWQ23V+C/L4WJ23oBfc6R5k+225HTG1fKArahTAD8hJ
         FvA4r2ftGwOw5T3ZTNIRKz5RgV7oUatKPfXLyRFne9dmlEvnuiRRK8l26jPAiAjCL+
         SC0qVbASjiohxwSBpFQM7sa9IlUeVgxdUffTg0Wr7Rfd9P7M1WqUi/ocJdh4Zdzy8O
         PD+786maRGmVg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CF57360A25;
        Thu, 28 Oct 2021 12:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] media: use eth_hw_addr_set()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163542361284.29870.3167445851416278772.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 12:20:12 +0000
References: <20211026175250.3197558-1-kuba@kernel.org>
In-Reply-To: <20211026175250.3197558-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 26 Oct 2021 10:52:50 -0700 you wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it go through appropriate helpers.
> 
> Convert media from memcpy(... 6) and memcpy(... addr_len) to
> eth_hw_addr_set():
> 
> [...]

Here is the summary with links:
  - [net-next] media: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/707182e45b81

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


