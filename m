Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5D92C1BCF
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 04:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgKXDAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 22:00:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:38058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726256AbgKXDAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 22:00:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606186805;
        bh=YnsOH/f7iO3Fr4ckpGtwCt36G6/TTuRCj2NR6vrVQV0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dGSVfXtK2qz4ewLcYhLqdReoEnBx1EXDlbGmaib65UjEGxilEEN7+CSTFn5uVXPCO
         fLvT3AQYNl19jcv3oSFJmLODmePWr7+7KJKS4LWkTVj4Z1IDU30tf/7JkknbKKX1Di
         +z6oWDfyaNTctYnr6s9mA46McnxkRLEGXQRx0U3k=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sctp: Fix some typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160618680549.17854.4429784178862016350.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Nov 2020 03:00:05 +0000
References: <20201122180704.1366636-1-christophe.jaillet@wanadoo.fr>
In-Reply-To: <20201122180704.1366636-1-christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 22 Nov 2020 19:07:04 +0100 you wrote:
> s/tranport/transport/
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  net/sctp/transport.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - sctp: Fix some typo
    https://git.kernel.org/netdev/net-next/c/5112cf59d76d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


