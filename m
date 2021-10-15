Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A3742E691
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 04:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbhJOCcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 22:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234944AbhJOCcO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 22:32:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 76926611F0;
        Fri, 15 Oct 2021 02:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634265008;
        bh=evgSmzWDCoD6D6fJAVt/DwAwh+6gsIO5z9T/Uq3ZXhw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hUyQLBaBa7rNZMASlH/UWxTInad9Dm0JHUrvojESzAqAHR2Ggk1UyDyGRMor043vI
         KcI4RYTY2qEHZNiELrWKKRpn+f4+PGepHLZGmWwIFbjZ7E42YJQBf3ik2/T1tWDuTQ
         pzhLn8qXcj7XMg6DrwvNs6tILBYlb42MCl/1JhNAAr02lvvDZtICk/4q6u1sUkBXBH
         MjgXYn55D9GbwSPOeexeatFSoVbAShz+mMxPi+ljbTU8xhN3wPecpOAiz4DRNIQuLQ
         /W1hES2viDrhY5/fycYemJCp52MaWj+SlIxS9QG1QuzvIBIG7MmE+ZoNCzAPUA0iTY
         mj9YIcdN3Y5Rg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6C1AB60A89;
        Fri, 15 Oct 2021 02:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: tulip: winbond-840: fix build for UML
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163426500843.31820.8624431001183208092.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Oct 2021 02:30:08 +0000
References: <20211014050606.7288-1-rdunlap@infradead.org>
In-Reply-To: <20211014050606.7288-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, linux-um@lists.infradead.org,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        davem@davemloft.net, kuba@kernel.org, linux-parisc@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Oct 2021 22:06:06 -0700 you wrote:
> On i386, when builtin (not a loadable module), the winbond-840 driver
> inspects boot_cpu_data to see what CPU family it is running on, and
> then acts on that data. The "family" struct member (x86) does not exist
> when running on UML, so prevent that test and do the default action.
> 
> Prevents this build error on UML + i386:
> 
> [...]

Here is the summary with links:
  - [net-next] net: tulip: winbond-840: fix build for UML
    https://git.kernel.org/netdev/net-next/c/a3d708925fcc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


