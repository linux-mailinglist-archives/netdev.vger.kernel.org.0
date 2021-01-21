Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811DB2FE2A6
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 07:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbhAUGVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 01:21:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbhAUGUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 01:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A43A42395C;
        Thu, 21 Jan 2021 06:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611210008;
        bh=tj4JK3IB/3p1xKzetsEkCQt0VSWUeJtezzq7et1ohkE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KKR/LFn2VWRzjUqoTM97wyZ+NfpQynnCJPxa6Uw0462xPCUQ8Aty2/6qJpGySw0K2
         6x3XHwWKMBp5wQNMqFDEkwCX2l/4hG09rtBACnvDbl/Nlh6zOsDvU0aBk1MmctBU+1
         j1Bw/f5QJvAP9X3nZUQXbAETU5h1gQKCU6icTabrqjs5YKxsJUllp50RH/gc8dLRfQ
         ye6yQaq6n4nsAIEKcKkepLLwL7ueWvBfkQBU90WY2XNlI4B+CCdcjMvqu1W6+agW9F
         OXYdKK6vaaBIOY3Mwq4j4k3NqImFRMb1nzXT+Jc6TTtB0dLyZiEmyV61r+V2Tld+g/
         nKmR2cnMl+iNQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 943BC60641;
        Thu, 21 Jan 2021 06:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] udp: not remove the CRC flag from dev features when
 need_csum is false
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161121000860.22302.16062823158085262531.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jan 2021 06:20:08 +0000
References: <1e81b700642498546eaa3f298e023fd7ad394f85.1610776757.git.lucien.xin@gmail.com>
In-Reply-To: <1e81b700642498546eaa3f298e023fd7ad394f85.1610776757.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com,
        davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 16 Jan 2021 13:59:17 +0800 you wrote:
> In __skb_udp_tunnel_segment(), when it's a SCTP over VxLAN/GENEVE
> packet and need_csum is false, which means the outer udp checksum
> doesn't need to be computed, csum_start and csum_offset could be
> used by the inner SCTP CRC CSUM for SCTP HW CRC offload.
> 
> So this patch is to not remove the CRC flag from dev features when
> need_csum is false.
> 
> [...]

Here is the summary with links:
  - [net-next] udp: not remove the CRC flag from dev features when need_csum is false
    https://git.kernel.org/netdev/net-next/c/4eb5d4a5b4d6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


