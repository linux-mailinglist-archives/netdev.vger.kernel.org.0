Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E035442EEB0
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 12:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhJOKWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 06:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230061AbhJOKWN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 06:22:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 48E3260FDA;
        Fri, 15 Oct 2021 10:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634293207;
        bh=layviOlym3XQHi5ErpUCAn17rbJSMBf73Ptgsdy19oU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NEvYmhT+rUicoBCRGAZ+QBCms6p/Q8jvX8cjzX13nBoCvXfmzJkb+hAaWZE0/pRVu
         ZbNsgFkM8bH172JjhTvngrG+zA4Rxw3LDqU3I2s6Iqm22X87qCEpZPvgLsA2ONhtHJ
         xUlgJ1kldicTn59rqGF/UHD3uncbLfoMP+qwf0/TxGQNQIoLNzwKyZlFAYBSYzD8j9
         tNlAfOPqkk2exBbJTkDLLg57LpZp9aAnuh/lpm2d4CjIedT9vz6VBMBBIiTaH/exl8
         BOR6Jf9XzH82zJ/iCbTA2B7KzDAkuDxKsoliqCfA+jS9uUlOgnBG1ZjxiTAMjlYrOg
         I/l8s3lVrvDMg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3757660A47;
        Fri, 15 Oct 2021 10:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ptp: fix error print of ptp_kvm on X86_64 platform
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163429320722.30649.15225917576713116209.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Oct 2021 10:20:07 +0000
References: <20211014031952.1573640-1-huangkele@bytedance.com>
In-Reply-To: <20211014031952.1573640-1-huangkele@bytedance.com>
To:     Kele Huang <huangkele@bytedance.com>
Cc:     richardcochran@gmail.com, xieyongji@bytedance.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 14 Oct 2021 11:19:52 +0800 you wrote:
> Commit a86ed2cfa13c5 ("ptp: Don't print an error if ptp_kvm is not supported")
> fixes the error message print on ARM platform by only concerning about
> the case that the error returned from kvm_arch_ptp_init() is not -EOPNOTSUPP.
> Although the ARM platform returns -EOPNOTSUPP if ptp_kvm is not supported
> while X86_64 platform returns -KVM_EOPNOTSUPP, both error codes share the
> same value 95.
> 
> [...]

Here is the summary with links:
  - ptp: fix error print of ptp_kvm on X86_64 platform
    https://git.kernel.org/netdev/net/c/c2402d43d183

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


