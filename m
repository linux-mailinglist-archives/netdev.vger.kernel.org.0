Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899ED36627F
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 01:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbhDTXav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 19:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233992AbhDTXao (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 19:30:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E5C7A6141F;
        Tue, 20 Apr 2021 23:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618961411;
        bh=4dr0pHBisN+aUtWV+J+hwo4Eu7Ikw3gYSfMuxrTaw0Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qgbcq35CW/ltmIrUO7phljd9PMytJ2vzE3WBEDFSK5HaIXwu5yNqMjYpC5uRLsd1A
         PeVhrrkEpoNpo/o+OEDEd4l4d422NWREsUpbEY5dFJlD40fLVQKhkbCXStfkFqyxQt
         +nyjp5eUGIwpZy5ll7ij9BY2clbbaUpmh0TU4wLfrQtalqpBYPbsR2vs7q8dUU890r
         Akx+kFO/zNT31cBLZBVyG+WG0GDocnpsgV/63IvcI8cYFz9yttwvcReivW5YDTx78N
         V4xFwDBBSj8G17LYHJmqXpq11obO2gMsjB6Q5aifN7L0SpkF50IYn0hJEpMnA28SBO
         paQi21fYhK+og==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DB2E260A4E;
        Tue, 20 Apr 2021 23:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] korina: Fix conflict with global symbol
 desc_empty on x86.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161896141189.22203.6427387274902723252.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Apr 2021 23:30:11 +0000
References: <20210420.162627.432702890482234178.davem@davemloft.net>
In-Reply-To: <20210420.162627.432702890482234178.davem@davemloft.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Apr 2021 16:26:27 -0700 (PDT) you wrote:
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/ethernet/korina.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

Here is the summary with links:
  - [net-next] korina: Fix conflict with global symbol desc_empty on x86.
    https://git.kernel.org/netdev/net-next/c/56e2e5de441a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


