Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B36E403803
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 12:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346293AbhIHKlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 06:41:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233077AbhIHKlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 06:41:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1BDE561163;
        Wed,  8 Sep 2021 10:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631097608;
        bh=JpJ+KCAjqsJnD4fAHueRPorRkCtY3n+wxVMuMO4+jbQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RphSLjLguBg1w6ajGcSR2Sweq+bCZDIvv4v5V7snqH5CyRn+RGsElV1A5E0UyDNF/
         x/3wDC3dDL1HiANbEVGYvX3oc+M6v3WCttsrWtByTt8RGK1nW9O24Kn3tGC52DDN2n
         vqPdzwMAAi7jt/tEnA3e5Gn5B1RmBChu3/YXGOptzYYhkVmaRU5pKbmmz1kE2UEO16
         Grm+PtfgbXWIHwSGCcI9udbNhcZC+L3W2j8N7NvAdQl6y2+f+t6fcPLXDp31d9fZJe
         Ya17SA3+WsuQFKAXTGpCp+ixwQL2hTy1SsSF20MUGvMMXtqqRQH1Xw/jmVtVXtG19F
         QBFfYctLRtH0Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1105F60A24;
        Wed,  8 Sep 2021 10:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dccp: don't duplicate ccid when cloning dccp sock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163109760806.16056.10288524962758514205.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Sep 2021 10:40:08 +0000
References: <F3E0B9C9-14F1-43F5-AC6C-E5DB346A8090@psu.edu>
In-Reply-To: <F3E0B9C9-14F1-43F5-AC6C-E5DB346A8090@psu.edu>
To:     Lin@ci.codeaurora.org, Zhenpeng <zplin@psu.edu>
Cc:     dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        alexey.kodanev@oracle.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 8 Sep 2021 03:40:59 +0000 you wrote:
> Commit 2677d2067731 ("dccp: don't free ccid2_hc_tx_sock ...") fixed
> a UAF but reintroduced CVE-2017-6074.
> 
> When the sock is cloned, two dccps_hc_tx_ccid will reference to the
> same ccid. So one can free the ccid object twice from two socks after
> cloning.
> 
> [...]

Here is the summary with links:
  - dccp: don't duplicate ccid when cloning dccp sock
    https://git.kernel.org/netdev/net/c/d9ea761fdd19

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


