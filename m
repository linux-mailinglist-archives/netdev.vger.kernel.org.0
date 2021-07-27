Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0673D74ED
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 14:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236529AbhG0MUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 08:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231956AbhG0MUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 08:20:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DDECA61A71;
        Tue, 27 Jul 2021 12:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627388405;
        bh=7QqbboyJNPASEkO0eyud8Wcbnkp7e6D1a10bYIhJ5HI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V3CF6lFFO+9qTOICVnuPNLV6wm+kUlp159BmKhQrvvx1r/YOdDXiUbhwy6EALiJnx
         j0R1uQ7dyAv3L/lvttv3v6DLo2EEMK845DWV/Db6ZIVg4hddeYxNjrvOiUo2jWs/0Y
         bmaBypHKdiTIQnv1GCryFgLsCdcrGg7bklIw0j4KsXwbm5DutMZNfTRKWkIPUyCRJr
         7eeVnSiYRLrmMKOLhJJ4tIC8JLnLexUfZ12DLyKil2/BkgHqmqSBEP9sjrajr9qrMb
         XyF3+mdiqJYvdLFyO1MuxIjqjihjRzFCucKTT95OS4yUdyovl2my8CBu/2UvtBxRI4
         eDu++dkR498nw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CD38760A59;
        Tue, 27 Jul 2021 12:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: llc: fix skb_over_panic
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162738840583.23438.3319262289505200786.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Jul 2021 12:20:05 +0000
References: <20210724211159.32108-1-paskripkin@gmail.com>
In-Reply-To: <20210724211159.32108-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        stefan@datenfreihafen.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+5e5a981ad7cc54c4b2b4@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 25 Jul 2021 00:11:59 +0300 you wrote:
> Syzbot reported skb_over_panic() in llc_pdu_init_as_xid_cmd(). The
> problem was in wrong LCC header manipulations.
> 
> Syzbot's reproducer tries to send XID packet. llc_ui_sendmsg() is
> doing following steps:
> 
> 	1. skb allocation with size = len + header size
> 		len is passed from userpace and header size
> 		is 3 since addr->sllc_xid is set.
> 
> [...]

Here is the summary with links:
  - net: llc: fix skb_over_panic
    https://git.kernel.org/netdev/net/c/c7c9d2102c9c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


