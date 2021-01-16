Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF36C2F8B20
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 05:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbhAPEUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 23:20:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:51516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbhAPEUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 23:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6135523A9C;
        Sat, 16 Jan 2021 04:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610770808;
        bh=W5rBZx73glnhlM2B5B21uekMfNKe0hoDqmtviqOSbIQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kF75DHrDx/24EBL6UuFrrm3P04yj74QqejouOs5u4H3okH+zSR5Z+IuwzVu2TqnTn
         1pceKU1zyiySIabIBx7caQWTkrMQoEveN8xQ/+sOJUIW//K5fwxdCGSATk80QMqEEj
         rzIfddDmNIQswoDm1rpXlJ79HkQC5TD03//8W3ItEU9K94vCOLuVqXqr24qDOxn+TZ
         yHvYZwqH8AkioZ6QtvLXr++fcIJRGsE6Lsqhnoz14+LUcdTfCcRNKf/jVmQia8pTwX
         dsTFa0BFv1atP+pvnyrq6gE6mQR6/Ll0M5JGm3u5kJDv0G+HSfxfhjoCc7s3ikoCJO
         E532YnfSCBN4w==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 563EE605AB;
        Sat, 16 Jan 2021 04:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfc: netlink: use &w->w in nfc_genl_rcv_nl_event
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161077080834.25355.8798518836189769677.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Jan 2021 04:20:08 +0000
References: <f0ed86d6d54ac0834bd2e161d172bf7bb5647cf7.1610683862.git.geliangtang@gmail.com>
In-Reply-To: <f0ed86d6d54ac0834bd2e161d172bf7bb5647cf7.1610683862.git.geliangtang@gmail.com>
To:     Geliang Tang <geliangtang@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 15 Jan 2021 12:14:53 +0800 you wrote:
> Use the struct member w of the struct urelease_work directly instead of
> casting it.
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
>  net/nfc/netlink.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] nfc: netlink: use &w->w in nfc_genl_rcv_nl_event
    https://git.kernel.org/netdev/net-next/c/32d91b4af353

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


