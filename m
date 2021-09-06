Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F32401B1F
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 14:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242147AbhIFMZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 08:25:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241229AbhIFMZK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 08:25:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0143C6103C;
        Mon,  6 Sep 2021 12:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630931046;
        bh=YULqZ7PAmbBPcJ7FXr2g4qWerqk8Tks9eq37lD6X+eM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RXm8f2YFBAzFzDnvUxv0Rhfa/OCCRLNfn8PY86xbqGs0ELl0ZCoTJtPrgWOgAxcZi
         WPT0vSsh3SMTvQRveSAqFTAkFoOTwuXJUK8uycMJxGhlmhaldEu1YMBi08byT8tWDt
         5A03HXWDbiQ8GHsJaB7sRkYv4NTeuIU0NyYLwLCSLc67pt3s7025x6p7yAewdqHwP8
         gZl1CPidNx49bxka0bVVIekwXVVd6PXhwSk+r64wd5ZT2HpqwxZdnDh/EXoLbmU/4o
         ytqRJsPMMW5CuRFJThsPUxGYpL1ULRlvtH5cDHEl01vzkynRbbCjEMVt9RY2VUKbdX
         KzoGVmMbNrEEQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E69E8608FA;
        Mon,  6 Sep 2021 12:24:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: add VM SOCKETS (AF_VSOCK) entry
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163093104594.13830.8442258230605832776.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Sep 2021 12:24:05 +0000
References: <20210906091159.66181-1-sgarzare@redhat.com>
In-Reply-To: <20210906091159.66181-1-sgarzare@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        davem@davemloft.net, decui@microsoft.com,
        linux-kernel@vger.kernel.org, jhansen@vmware.com, mst@redhat.com,
        stefanha@redhat.com, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  6 Sep 2021 11:11:59 +0200 you wrote:
> Add a new entry for VM Sockets (AF_VSOCK) that covers vsock core,
> tests, and headers. Move some general vsock stuff from virtio-vsock
> entry into this new more general vsock entry.
> 
> I've been reviewing and contributing for the last few years,
> so I'm available to help maintain this code.
> 
> [...]

Here is the summary with links:
  - MAINTAINERS: add VM SOCKETS (AF_VSOCK) entry
    https://git.kernel.org/netdev/net/c/e0b6417be088

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


