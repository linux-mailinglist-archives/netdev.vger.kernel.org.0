Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA1B43E08E
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 14:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhJ1MMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 08:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229835AbhJ1MMf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 08:12:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6718B610FC;
        Thu, 28 Oct 2021 12:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635423008;
        bh=eshJVeDJYgjqSvupKAfAJikSzZa3L7984zEyTY/naKk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JFKe3XgKVTYmgPxBYCfaisUDR9/OA1KZIKfBHGTSAISIxYGEU2PnByQoicQcT91gW
         p8stcm7A04+Bo8qvuDqCtD836NcUHeEr7fzfFPIOs4d9QNZ/gFdmkbUCSlw+nf8+xO
         Dor7qqs+MHE3rKqbfMLF9ZjCv6pOtt6d33F+P46RNdbnnvthXXsRQe5J0T9KK3KKz0
         /zpFIxRpPYF6f83QIDsyHBV5yeuTQOrmNoHqddh1ln371ETEImrxeu704h1RbFfNN7
         U5magQZiOdGpAbMkpDhl5HHZxNcOTqNhVz7SKaVSZkTOyhsFNhviKSN+4OddXzUtQx
         Uj2ROSAS1Bb8w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 59D74609CC;
        Thu, 28 Oct 2021 12:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] nfp: bpf: relax prog rejection for mtu check through
 max_pkt_offset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163542300836.24410.928157722340409123.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 12:10:08 +0000
References: <20211028100036.8477-1-simon.horman@corigine.com>
In-Reply-To: <20211028100036.8477-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, yu.xiao@corigine.com,
        yinjun.zhang@corigine.com, niklas.soderlund@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Oct 2021 12:00:36 +0200 you wrote:
> From: Yu Xiao <yu.xiao@corigine.com>
> 
> MTU change is refused whenever the value of new MTU is bigger than
> the max packet bytes that fits in NFP Cluster Target Memory (CTM).
> However, an eBPF program doesn't always need to access the whole
> packet data.
> 
> [...]

Here is the summary with links:
  - [net,v2] nfp: bpf: relax prog rejection for mtu check through max_pkt_offset
    https://git.kernel.org/netdev/net/c/90a881fc352a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


