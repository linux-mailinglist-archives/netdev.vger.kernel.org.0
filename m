Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D6842E68E
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 04:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbhJOCcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 22:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231580AbhJOCcO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 22:32:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 609A6611C8;
        Fri, 15 Oct 2021 02:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634265008;
        bh=15UENu5nbar5CfBfiiflqMOoq3UrkgZsIwBjCFi825E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h92Qh8GjCK+j6DafuOKDprvTwmYcS4+HN3nzn8zD3J+Tgf4l+bHuQhBohJvVANuob
         OOsVViuxcm4UPoNipCcDHVv+ElAP5BxzJ7Iz85IjAhBIFz2nslhnaEkMbVV5LKQSeg
         BempBpraRu3M1NzXJNNxj/SkvZvCsmZSKFISDCBaEh929PI49l4f0B/F1wHtcP4wNv
         W2nvnr/ZG3VDXIFeO0jwQ187Mbl5SFXtjkLQc5W97hZQBpxA5xdEDU6VRL0RGoXOrt
         5JqKbK/p1aPULZK6hInwPHU3nLUCQly8iRlgOrKV69SRIAK1EDP6ZknhWPw+BaCUvz
         579xlOcQPp8GQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5506B60A39;
        Fri, 15 Oct 2021 02:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: intel: igc_ptp: fix build for UML
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163426500834.31820.14758482906938638216.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Oct 2021 02:30:08 +0000
References: <20211014050516.6846-1-rdunlap@infradead.org>
In-Reply-To: <20211014050516.6846-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, linux-um@lists.infradead.org,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        davem@davemloft.net, kuba@kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, intel-wired-lan@lists.osuosl.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Oct 2021 22:05:16 -0700 you wrote:
> On a UML build, the igc_ptp driver uses CONFIG_X86_TSC for timestamp
> conversion. The function that is used is not available on UML builds,
> so have the function use the default system_counterval_t timestamp
> instead for UML builds.
> 
> Prevents this build error on UML:
> 
> [...]

Here is the summary with links:
  - [net-next] net: intel: igc_ptp: fix build for UML
    https://git.kernel.org/netdev/net-next/c/523994ba3ad1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


