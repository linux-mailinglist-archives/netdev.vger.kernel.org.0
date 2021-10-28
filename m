Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F175243D86C
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 03:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhJ1BMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 21:12:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhJ1BMe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 21:12:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0FAA4610EA;
        Thu, 28 Oct 2021 01:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635383408;
        bh=09eO0wZDntI55W+cJ/zA1jTOTJ0PpNEQU1zaPA1N6DU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SblHX/hUnfL14q7+i0jVaYArVCWX/SOxhcv0meW3kQMPfOkO68cQ/T6mN/MBJpIiq
         gjI2UbGcXLL2KZBehsgS8kc1SA1vWrT4SEIPEDeJnzZdeiQIFrO0gmkM/mjMB4htpb
         5T1t3bqjsCgzUXpi6jN46Hx7Q3PO83M8440JWQyn0w3t8hO2QSrbD5ElsY6GthxzPB
         eCcNVpwpTJ69lmGTrcjyWTLVZq6ri15ylTPTTqUAoNMrb3yeZYCd0tRKWYdLGqO7+l
         ImUyC3OZg+zr0vxJHXhNlzCw1D8zGPJXCVWhs+pT0Qx9vjoSpbbpl4qJTA0I413Fr/
         5nBK/jSZewCYQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EA80660A88;
        Thu, 28 Oct 2021 01:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: thunderbolt: use eth_hw_addr_set()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163538340795.2556.11827618042244324032.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 01:10:07 +0000
References: <20211026175547.3198242-1-kuba@kernel.org>
In-Reply-To: <20211026175547.3198242-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.jamet@intel.com, mika.westerberg@linux.intel.com,
        YehezkelShB@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 Oct 2021 10:55:47 -0700 you wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it go through appropriate helpers.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: thunderbolt: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/5a48585d7ec1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


