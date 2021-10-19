Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD4E43350D
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 13:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235447AbhJSLwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235425AbhJSLwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:52:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E92DC6137B;
        Tue, 19 Oct 2021 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634644211;
        bh=UHOGUKFhhRXbcfzVbtkZfqKIOunGDgIcbQYsQ7jgDwY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CLwEnXZU8oX37i8abkHJOflluMBY8GfBbaR/N0P1Pa85S9Vb2REp2QGCngphHVv5m
         126p7cJSVhdLx1CQCp5JDNbi5L0kPEzq5o4grkrsbj5gvTsBZU2KiIYmxmlGCGQJ8T
         RRI7cZfQxGvYqHsej/xn8MY4rlhCW6McenJhu7MesGTrhB2iOHEW72xLDk6204Aq7I
         867JEmZxh0kboRUxhN2rqWa8H/0TUJdxwEszThyHcTRTncp4LWV8T6EPLWSdzGs846
         x5Bn1wsxNR0/rdFi3D+ePpSpoRB0rebsSfzNYoEG0jLIYyxl+4TCdPCbCE0rB5ODrD
         kgXVw57aQ8+yg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DB1A160A4E;
        Tue, 19 Oct 2021 11:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH linux-next] e1000e: Remove redundant statement
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163464421089.25315.8858510384823584691.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Oct 2021 11:50:10 +0000
References: <20211018085154.853744-1-luo.penghao@zte.com.cn>
In-Reply-To: <20211018085154.853744-1-luo.penghao@zte.com.cn>
To:     Ye Guojin <cgel.zte@gmail.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo.penghao@zte.com.cn,
        zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 18 Oct 2021 08:51:54 +0000 you wrote:
> This assignment statement is meaningless, because the statement
> will execute to the tag "set_itr_now".
> 
> The clang_analyzer complains as follows:
> 
> drivers/net/ethernet/intel/e1000e/netdev.c:2552:3 warning:
> 
> [...]

Here is the summary with links:
  - [linux-next] e1000e: Remove redundant statement
    https://git.kernel.org/netdev/net-next/c/1bd297988b75

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


