Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8926B38F43A
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 22:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbhEXUVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 16:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233073AbhEXUVi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 16:21:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 07ECA6140B;
        Mon, 24 May 2021 20:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621887610;
        bh=cIwn6YUq4dP0J1MFHjACwwFulsSLzXbskBKBG/NuD/Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WK3LePyLFqRtlTXpJ4bBIyHRhcW4p93/l81KV08eQ0qnBmGSY+c2eJceMf5jo3KQz
         k/OaURyU4f+N+U7R2WTYWgSB87o7qdbSAAx3oU3JPDC8QL2ADNwQtdiBFDbskLfDOv
         r/AFmmpiUHcBs58Im2FrzB5Ghxn3xbdlYPDrAzSrvDFypp1nyQGnrd/K3jMAfK5ReR
         3zRRuGmzcmBxAffepfu5ygpFRiYMf/i1X2+5RFFav0ljiJUuIdBVyQsmDsTUZJNKML
         qCKvopZUSoUbMqkTqfWIHSUYMlzAXFt+8toEkJIU5c0SuavLUoNhhv0phhK4Swb4/r
         KNmPaLa6ggr3Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EAAF260A56;
        Mon, 24 May 2021 20:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] r8152: check the informaton of the device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162188760995.19394.10849632943787697818.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 20:20:09 +0000
References: <1394712342-15778-365-Taiwan-albertk@realtek.com>
In-Reply-To: <1394712342-15778-365-Taiwan-albertk@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 24 May 2021 14:49:42 +0800 you wrote:
> Verify some fields of the USB descriptor to make sure the driver
> could be used by the device.
> 
> Besides, remove the check of endpoint number in rtl8152_probe().
> usb_find_common_endpoints() includes it.
> 
> BugLink: https://syzkaller.appspot.com/bug?id=912c9c373656996801b4de61f1e3cb326fe940aa
> Reported-by: syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com
> Fixes: c2198943e33b ("r8152: search the configuration of vendor mode")
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> 
> [...]

Here is the summary with links:
  - [net,v3] r8152: check the informaton of the device
    https://git.kernel.org/netdev/net/c/1a44fb38cc65

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


