Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0875F2FE2B0
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 07:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbhAUGWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 01:22:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:56150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbhAUGUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 01:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 968D8238EF;
        Thu, 21 Jan 2021 06:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611210008;
        bh=8FE7KSgHlbHUXfjNJOeuXK0ZRoy9n5aV0wuYEKHYw0I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DG6cKIfJfR9Kz3FAec1MTPvh4z+ZnC+UV9liZ1Z/eCHMWey3mA/lGxT7/jczEgfCj
         HQvLXsP0Jfxt8VAdp0Ryg22v9gET++zfP1iYsZziMrLku8fRMxQfYFedTdTbDX1Q5H
         CelrAnZgUrFjrVMATfusPD4YEEL6EBJE7blwtDYW77xnknyOFILDDVr8c9Y2dC6vke
         EeYfMmM1+MKQNuKpuXgUzZeF/6w8ovxwKX/at0AtJZNNxlV+8nuTx0F9clsKgOKh4X
         58uj+89Tg8f0oqymWCRyhsC5vWjC+T3jMbG/CpZ2J0ZhYr/VWNcydjblufB95498fs
         LD/CfCjopruNw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 895E9600E0;
        Thu, 21 Jan 2021 06:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 net-next] ip_gre: remove CRC flag from dev features in
 gre_gso_segment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161121000855.22302.10418362018948069217.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jan 2021 06:20:08 +0000
References: <00439f24d5f69e2c6fa2beadc681d056c15c258f.1610772251.git.lucien.xin@gmail.com>
In-Reply-To: <00439f24d5f69e2c6fa2beadc681d056c15c258f.1610772251.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com,
        davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com,
        lorenzo@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 16 Jan 2021 12:44:11 +0800 you wrote:
> This patch is to let it always do CRC checksum in sctp_gso_segment()
> by removing CRC flag from the dev features in gre_gso_segment() for
> SCTP over GRE, just as it does in Commit 527beb8ef9c0 ("udp: support
> sctp over udp in skb_udp_tunnel_segment") for SCTP over UDP.
> 
> It could set csum/csum_start in GSO CB properly in sctp_gso_segment()
> after that commit, so it would do checksum with gso_make_checksum()
> in gre_gso_segment(), and Commit 622e32b7d4a6 ("net: gre: recompute
> gre csum for sctp over gre tunnels") can be reverted now.
> 
> [...]

Here is the summary with links:
  - [PATCHv3,net-next] ip_gre: remove CRC flag from dev features in gre_gso_segment
    https://git.kernel.org/netdev/net-next/c/1a2367665ac2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


