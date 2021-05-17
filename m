Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2089F386BAE
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 22:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237109AbhEQUv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 16:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229776AbhEQUv0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 16:51:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 111F160FF0;
        Mon, 17 May 2021 20:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621284610;
        bh=NK651JGTH9G3C2+8v05boysX6klm5Hme/p7+R0ZeZ5k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pyUksgv8zUL3xxEvXr5lRAgvl0DNS6dGyO+WE02uNV5q4eAh42r1WcCLZ7jnobMiB
         iR/62cnwUdEXv+EP+HEuWSjwQQyuLDAj0n5bW8SbhpBsrMK6d9UwyJBgibSShCfbjH
         AgkONhvIqISuwtE/ZMoWd2atCHfAWKC5fPMRwSyjt8sTA0USUaOw6Qc8YyPARVTd1G
         LCRaow6yamXhL4H1aUMzRwYYG2wzSj0G1JHiI+/cMvG7nWZo1TgSvWVEKPF4LEg1Ag
         Jr3l5txphBO5KHB0nWSSTyHKl3oKBlaOPjJHb7R2cq4/2KpbfBTYx7r+XrsFJbQZBm
         fJa53L89xdzWQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 07B5760A35;
        Mon, 17 May 2021 20:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tipc: skb_linearize the head skb when reassembling msgs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162128461002.31061.4134392433331126815.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 20:50:10 +0000
References: <c7d752b5522360de0a6886202c59fe49524a9fda.1620417423.git.lucien.xin@gmail.com>
In-Reply-To: <c7d752b5522360de0a6886202c59fe49524a9fda.1620417423.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        davem@davemloft.net, kuba@kernel.org, jmaloy@redhat.com,
        ying.xue@windriver.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat,  8 May 2021 03:57:03 +0800 you wrote:
> It's not a good idea to append the frag skb to a skb's frag_list if
> the frag_list already has skbs from elsewhere, such as this skb was
> created by pskb_copy() where the frag_list was cloned (all the skbs
> in it were skb_get'ed) and shared by multiple skbs.
> 
> However, the new appended frag skb should have been only seen by the
> current skb. Otherwise, it will cause use after free crashes as this
> appended frag skb are seen by multiple skbs but it only got skb_get
> called once.
> 
> [...]

Here is the summary with links:
  - [net] tipc: skb_linearize the head skb when reassembling msgs
    https://git.kernel.org/netdev/net/c/b7df21cf1b79

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


