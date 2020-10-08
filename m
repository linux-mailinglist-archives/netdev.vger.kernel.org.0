Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA86287CB3
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 22:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgJHUAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 16:00:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729454AbgJHUAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 16:00:06 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602187205;
        bh=eZsDfZl5sMC9EEWPMUZ2j8FlHfnnmv/xFAcWNb6R59U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WjcX2uHrv0Xbas8veuzNPB4flcN7rXquCQ0Pk/sg9WhCDaJvl06geKEiqeONC6rbA
         CPQXolfyVmvGcBjMrJi3VrhPIQHL5+IDtRl1TcoPP+1Z6XEzWnSOvVCpyqfiTklnEN
         fzHDdOHmi7TgZg5aoR0baLLMDDNa916IAmaK8D7s=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: wireless: nl80211: fix out-of-bounds access in
 nl80211_del_key()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160218720521.8125.768342314968863398.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Oct 2020 20:00:05 +0000
References: <20201007035401.9522-1-anant.thazhemadam@gmail.com>
In-Reply-To: <20201007035401.9522-1-anant.thazhemadam@gmail.com>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+b1bb342d1d097516cbda@syzkaller.appspotmail.com,
        johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  7 Oct 2020 09:24:01 +0530 you wrote:
> In nl80211_parse_key(), key.idx is first initialized as -1.
> If this value of key.idx remains unmodified and gets returned, and
> nl80211_key_allowed() also returns 0, then rdev_del_key() gets called
> with key.idx = -1.
> This causes an out-of-bounds array access.
> 
> Handle this issue by checking if the value of key.idx after
> nl80211_parse_key() is called and return -EINVAL if key.idx < 0.
> 
> [...]

Here is the summary with links:
  - net: wireless: nl80211: fix out-of-bounds access in nl80211_del_key()
    https://git.kernel.org/netdev/net/c/3dc289f8f139

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


