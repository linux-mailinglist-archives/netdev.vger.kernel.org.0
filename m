Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976872DB766
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 01:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgLPAB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 19:01:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:36796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbgLOXjy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 18:39:54 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608075554;
        bh=UctxaTse4ctySKNhnVjJyQq9QpoH8biXP4cixE1GM8c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eXDPhKAGWy4yoJmKRlwOctidkjHEPXG10oGFbdaOGddA86u7u1ME6F7zSyWLFwoc7
         7+bnkJeVGGhc5KEkNy3R4eACZIJzVryzn1vAp4nzz9o3m6lDrKLkKkBZNmT/UqDplJ
         buNMvormHyDA6VS3rJF824+1NJZWsdpey8XPHKFKR0nE/Mg8kMfTdkLyJKzoJkDIpm
         JnwfWWRbrMvNoi+DXIDPWkUrJjCADjYfS6PPHTCeed9ueMBQz/usvb/kXfhvUsDTpL
         rS0MdGxRLXAvBkm0SS7/R7OtbwTAH3TD+2DsG7Dkhl53QXFrePeaN7dlLiu82liuAn
         IPen6EWW+/FyQ==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] lan743x: fix for potential NULL pointer dereference with
 bare card
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160807555409.8012.8873780215201516945.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 23:39:14 +0000
References: <20201215161252.8448-1-sbauer@blackbox.su>
In-Reply-To: <20201215161252.8448-1-sbauer@blackbox.su>
To:     Sergej Bauer <sbauer@blackbox.su>
Cc:     andrew@lunn.ch, Markus.Elfring@web.de, thesven73@gmail.com,
        kuba@kernel.org, bryan.whitehead@microchip.com,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Tue, 15 Dec 2020 19:12:45 +0300 you wrote:
> This is the 4th revision of the patch fix for potential null pointer dereference
> with lan743x card.
> 
> The simpliest way to reproduce: boot with bare lan743x and issue "ethtool ethN"
> command where ethN is the interface with lan743x card. Example:
> 
> $ sudo ethtool eth7
> dmesg:
> [  103.510336] BUG: kernel NULL pointer dereference, address: 0000000000000340
> ...
> [  103.510836] RIP: 0010:phy_ethtool_get_wol+0x5/0x30 [libphy]
> ...
> [  103.511629] Call Trace:
> [  103.511666]  lan743x_ethtool_get_wol+0x21/0x40 [lan743x]
> [  103.511724]  dev_ethtool+0x1507/0x29d0
> [  103.511769]  ? avc_has_extended_perms+0x17f/0x440
> [  103.511820]  ? tomoyo_init_request_info+0x84/0x90
> [  103.511870]  ? tomoyo_path_number_perm+0x68/0x1e0
> [  103.511919]  ? tty_insert_flip_string_fixed_flag+0x82/0xe0
> [  103.511973]  ? inet_ioctl+0x187/0x1d0
> [  103.512016]  dev_ioctl+0xb5/0x560
> [  103.512055]  sock_do_ioctl+0xa0/0x140
> [  103.512098]  sock_ioctl+0x2cb/0x3c0
> [  103.512139]  __x64_sys_ioctl+0x84/0xc0
> [  103.512183]  do_syscall_64+0x33/0x80
> [  103.512224]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  103.512274] RIP: 0033:0x7f54a9cba427
> ...
> 
> [...]

Here is the summary with links:
  - [v4] lan743x: fix for potential NULL pointer dereference with bare card
    https://git.kernel.org/bpf/bpf/c/e9e13b6adc33

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


