Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E0B2DEA38
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 21:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731767AbgLRUas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 15:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:47424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgLRUar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 15:30:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608323407;
        bh=ErAOJC67CfZa+MW+qzh2sT1GcNSfYSZp0zXfoKDmlpA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SuFqjc3VdEunp1J6f0MB/lokfuIfKf6qqKUFfDHM6JHner9tY6Wpdh9OdBU1veYo9
         0QmxRX4xixOO3+l8o/36fcRGstYa33o+RHX+Y7+YbwDPUe9R0qJXSfVjrhwfl3KXn8
         PjKELeL0m6MMP4p87lL3ZG9TXxnZGQMGiMFJL98OUPINKIhAo+dwXFJh8qe44HraQr
         6BSZ6gi09ysipKDBFy4YRSlGwQAltqyqmX6APRxMN6Twcm1JRNSTp7KnM2TZKhmGTi
         iKX5xJQAxLbZg9+J8T4xg7aqmNZmYfYwjVEzA24HnQkU+hgaeSVlWwr0J//Tx0yEXE
         j0UWpVt5EQpWg==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: af_packet: fix procfs header for 64-bit pointers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160832340724.9967.6300853703964389386.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Dec 2020 20:30:07 +0000
References: <54917251d8433735d9a24e935a6cb8eb88b4058a.1608103684.git.baruch@tkos.co.il>
In-Reply-To: <54917251d8433735d9a24e935a6cb8eb88b4058a.1608103684.git.baruch@tkos.co.il>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 16 Dec 2020 09:28:04 +0200 you wrote:
> On 64-bit systems the packet procfs header field names following 'sk'
> are not aligned correctly:
> 
> sk       RefCnt Type Proto  Iface R Rmem   User   Inode
> 00000000605d2c64 3      3    0003   7     1 450880 0      16643
> 00000000080e9b80 2      2    0000   0     0 0      0      17404
> 00000000b23b8a00 2      2    0000   0     0 0      0      17421
> ...
> 
> [...]

Here is the summary with links:
  - [net] net: af_packet: fix procfs header for 64-bit pointers
    https://git.kernel.org/netdev/net/c/abdcd06c4ded

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


