Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABAD333241
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 01:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhCJAU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 19:20:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:53414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230372AbhCJAUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 19:20:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6982C64FD2;
        Wed, 10 Mar 2021 00:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615335608;
        bh=LexbJovwWtLGbZmuJDjjQa+ZkyKN8g10bCy4WoOO6zM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KvGhmx+D8Bfs3tDiXwHaTSPqvIbBHRj8n2YOFoChhcajwgfK9HFbF023dEBxg7mhI
         BJxQTCri2+9CD/K3LsB3oghHhauBzYT6fwMS+HWCM3ix5W5AL8dYd+SuNFZvDtSFCQ
         /bA4AZ5nHBF6dDtj7tnuTiQj0bqqvAZHh0CmECANLS+00pnX40s7xJFS0DGHllvjSK
         Kja4KUWvExGKbeR0MV+U/umtCGP8ZT+abL2fbB0TX4W5ruUDLempQIFxDSRI+vsknr
         UuLIL0gZBdlTNebhvpdqM/vwCOqByQbCJ04opBdCr6F1k34fRCMlFOoQyayq3ge7CS
         CdwGhqkzwUUbg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 57C7E609EC;
        Wed, 10 Mar 2021 00:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v6 0/2] Optimize bpf_redirect_map()/xdp_do_redirect()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161533560835.32666.14006286141763345790.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 00:20:08 +0000
References: <20210308112907.559576-1-bjorn.topel@gmail.com>
In-Reply-To: <20210308112907.559576-1-bjorn.topel@gmail.com>
To:     =?utf-8?b?QmrDtnJuIFTDtnBlbCA8Ympvcm4udG9wZWxAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, bjorn.topel@intel.com,
        maciej.fijalkowski@intel.com, hawk@kernel.org, toke@redhat.com,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Mon,  8 Mar 2021 12:29:05 +0100 you wrote:
> Hi XDP-folks,
> 
> This two patch series contain two optimizations for the
> bpf_redirect_map() helper and the xdp_do_redirect() function.
> 
> The bpf_redirect_map() optimization is about avoiding the map lookup
> dispatching. Instead of having a switch-statement and selecting the
> correct lookup function, we let bpf_redirect_map() be a map operation,
> where each map has its own bpf_redirect_map() implementation. This way
> the run-time lookup is avoided.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v6,1/2] bpf, xdp: make bpf_redirect_map() a map operation
    https://git.kernel.org/bpf/bpf-next/c/e6a4750ffe9d
  - [bpf-next,v6,2/2] bpf, xdp: restructure redirect actions
    https://git.kernel.org/bpf/bpf-next/c/ee75aef23afe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


