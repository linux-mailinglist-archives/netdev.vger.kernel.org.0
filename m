Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BE0479870
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 04:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhLRDaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 22:30:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56446 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbhLRDaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 22:30:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DC92B82B80;
        Sat, 18 Dec 2021 03:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D869DC36AE9;
        Sat, 18 Dec 2021 03:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639798214;
        bh=QdTDB7qdKP1o53aWlKmb6YDWyWQ+kJEOTT8F73iezvE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mrvhzXmbrRSccjcSMhu3PDAon9fSdTbCvSRZsk3pt8Z+8UyZ4fAXxalK9trK2HOnp
         BdcwnqZVnVPA4sbzkT3CuPDixesmR+4XJZmcTRxachbn7Jh8Ffa+3BymkNU65w4809
         tU8ndRPdP2VqErN4pfniIC9Gl/Hu+we6/9shhxn1MzTH8O/EXCHVFP40dKWbaGi8TX
         9VER/IE9TKmZ3lK1npAmGkK5NOP29BSjOS1vOwfUBB/dIT7TRFOlutjmLqE2c1/0jM
         kQKyJbyZv6jEM1bR8plk7xAYeoD0TihdlRRjq65rau5rFNK1GUPaF0C48OjGjAO7Tx
         KTwcN0VZ62jBA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BE1E260A4F;
        Sat, 18 Dec 2021 03:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] tun: avoid double free in tun_free_netdev
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163979821477.17814.7095226046090435782.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Dec 2021 03:30:14 +0000
References: <1639679132-19884-1-git-send-email-george.kennedy@oracle.com>
In-Reply-To: <1639679132-19884-1-git-send-email-george.kennedy@oracle.com>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     kuba@kernel.org, stephen@networkplumber.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Dec 2021 13:25:32 -0500 you wrote:
> Avoid double free in tun_free_netdev() by moving the
> dev->tstats and tun->security allocs to a new ndo_init routine
> (tun_net_init()) that will be called by register_netdevice().
> ndo_init is paired with the desctructor (tun_free_netdev()),
> so if there's an error in register_netdevice() the destructor
> will handle the frees.
> 
> [...]

Here is the summary with links:
  - [v3] tun: avoid double free in tun_free_netdev
    https://git.kernel.org/netdev/net/c/158b515f703e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


