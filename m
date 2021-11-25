Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F9E45DE0E
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 16:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356120AbhKYPzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 10:55:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:32808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356315AbhKYPxV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 10:53:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C69D4610E8;
        Thu, 25 Nov 2021 15:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637855409;
        bh=4AhH5IjSthhf09dg3c+PkeJLOm+b8H9H9uVosand2Ns=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PSY+HkDmZyn9rra+QsaXYAk0zyWSN9MDezGvSR/J8Bxakcdt1fGDre3PftE71TKXF
         sJGQO4lDeSmEiIvZgoIYKnsEcV2cFHUNtKifaDqAAxfEtOo2tJc1qmiJfludRtvrim
         dgyCKmWwgliScNH+vnubL7E1GJd5bI1yG6uRdKi7clpa1w4JZD/cvfZFZQ607WiqpK
         e1eFJtcsaPDMhDh6dIT9tPROD+e8Jh8ld4Z0LoioCGfZLTh4Mbkw3KLN1gfa4pxMvI
         azRrtsf8yiyvpHGA2/NhZdZ+nb3XEmuYsBskpWXra7KqlVcl8uPPEa8y/FxXJzHVJc
         OzPbq+LeIUnkg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BE26660A6C;
        Thu, 25 Nov 2021 15:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] igb: fix netpoll exit with traffic
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163785540977.3411.335611194750877222.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Nov 2021 15:50:09 +0000
References: <20211123204000.1597971-1-jesse.brandeburg@intel.com>
In-Reply-To: <20211123204000.1597971-1-jesse.brandeburg@intel.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        oleksandr@natalenko.name, danieller@nvidia.com,
        alexander.duyck@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 23 Nov 2021 12:40:00 -0800 you wrote:
> Oleksandr brought a bug report where netpoll causes trace
> messages in the log on igb.
> 
> Danielle brought this back up as still occuring, so we'll try
> again.
> 
> [22038.710800] ------------[ cut here ]------------
> [22038.710801] igb_poll+0x0/0x1440 [igb] exceeded budget in poll
> [22038.710802] WARNING: CPU: 12 PID: 40362 at net/core/netpoll.c:155 netpoll_poll_dev+0x18a/0x1a0
> 
> [...]

Here is the summary with links:
  - [net,v2] igb: fix netpoll exit with traffic
    https://git.kernel.org/netdev/net/c/eaeace60778e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


