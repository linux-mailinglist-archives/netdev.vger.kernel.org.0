Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6195630B681
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 05:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhBBEax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 23:30:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:60246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231494AbhBBEas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 23:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7CE1264E9E;
        Tue,  2 Feb 2021 04:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612240207;
        bh=YLHi1Cwx3S3ifeYbkWuF4+Xh5WBWUvKIxdSReU/zWWY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WKBnrN91wWAnA7Jk/LLlaSNCP6nKN131w7hfZS6X6ABliYYWNa/v0Iv813PIaXm+f
         AqvDW+VceOxdRWRNefpBwBpMK4MAi3Ta7ZEjrIfb0Ccid7mJc4QmhtQElBih3qbrRP
         mj1fpN39IoHRwruIFb+dl9eepdE1STQPcL7pgfQVnEh9lQMdXO/ja2BeghLwL+zwDI
         KJW8kKbmW3xzlp2mpNP0SLczo2AhvZ1HwneaOEWgKCf5QBTGu4l/5n9xNhh9i0peEY
         WiyGL0ok0nL3De4Px3LV6/+F978yzdgr4ds86jwyKUW3fzF1eAcFII+iR3meMdDc/U
         GvLo4/6QASjXw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6985B609E1;
        Tue,  2 Feb 2021 04:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH net v4] udp: ipv4: manipulate network header of NATed
 UDP GRO fraglist
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161224020742.9509.1331877778578098305.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Feb 2021 04:30:07 +0000
References: <1611962007-80092-1-git-send-email-dseok.yi@samsung.com>
In-Reply-To: <1611962007-80092-1-git-send-email-dseok.yi@samsung.com>
To:     Dongseok Yi <dseok.yi@samsung.com>
Cc:     davem@davemloft.net, steffen.klassert@secunet.com, alobakin@pm.me,
        namkyu78.kim@samsung.com, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, willemb@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 30 Jan 2021 08:13:27 +0900 you wrote:
> UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
> forwarding. Only the header of head_skb from ip_finish_output_gso ->
> skb_gso_segment is updated but following frag_skbs are not updated.
> 
> A call path skb_mac_gso_segment -> inet_gso_segment ->
> udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
> does not try to update UDP/IP header of the segment list but copy
> only the MAC header.
> 
> [...]

Here is the summary with links:
  - [RESEND,net,v4] udp: ipv4: manipulate network header of NATed UDP GRO fraglist
    https://git.kernel.org/netdev/net/c/c3df39ac9b0e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


