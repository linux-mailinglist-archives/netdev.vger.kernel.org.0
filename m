Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77AE62DA6AE
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgLODRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:17:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:36678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727526AbgLODMf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:35 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608001848;
        bh=oDQcuNAOdeiZhQtYgKXh6WdMFJ5B36qn5PdLWgyADg8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZV3rBC2Wzebxf+rfniXEq27GPt0xE5u3OkuJO1Zp3PglbLpIODEkVXKZTQ3NzEo7Z
         wamxPNfSl9lxYm1DrM3xLgihJfpADJ6CNGApooQRxQ7hDKowNLiXZrGpOw9Kc7TAJ7
         SsAdDz+R7ozaDlq1QqRnXXdf+0ksNFOAITb3CPObIsjg3sLL1kkMeiVVO92WBsmo86
         7v2hDvIlAy83L4MIRFOFxifaxCnN8BmzStk/JtnKPCfab4svqrsm/XQ2vKqoePfre1
         Z+bmFflYnY39v24w/x4EdX80+naylu2xTJUcN6YdMPmuuyTJXJbtZ1IxJS9eYOnhG0
         GawUvHtuH3ZwA==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: drop bogus skb with CHECKSUM_PARTIAL and offset
 beyond end of trimmed packet
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160800184824.22481.2756487220504358038.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 03:10:48 +0000
References: <1b2494af-2c56-8ee2-7bc0-923fcad1cdf8@virtuozzo.com>
In-Reply-To: <1b2494af-2c56-8ee2-7bc0-923fcad1cdf8@virtuozzo.com>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     willemdebruijn.kernel@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 14 Dec 2020 22:07:39 +0300 you wrote:
> syzbot reproduces BUG_ON in skb_checksum_help():
> tun creates (bogus) skb with huge partial-checksummed area and
> small ip packet inside. Then ip_rcv trims the skb based on size
> of internal ip packet, after that csum offset points beyond of
> trimmed skb. Then checksum_tg() called via netfilter hook
> triggers BUG_ON:
> 
> [...]

Here is the summary with links:
  - [v2] net: drop bogus skb with CHECKSUM_PARTIAL and offset beyond end of trimmed packet
    https://git.kernel.org/netdev/net-next/c/54970a2fbb67

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


