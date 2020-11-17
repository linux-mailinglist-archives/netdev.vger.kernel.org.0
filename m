Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF642B716E
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 23:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbgKQWUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 17:20:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726182AbgKQWUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 17:20:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605651604;
        bh=qzRI9uT2iGGQRysuIv26yOPJqnQBw2/VNZOzRcnDgXI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ie09gbz9fVWYuM3htYBjqmqIYtsSD4FM/FsD5qQhqK9+9m/CXr/Tbd9wrYkRXbCO6
         aH5+kbdn2yccx583QolLx5n+5AkLnQibTwHmIYQFyI2lF188IRD0QzWZvSQUCkhAmi
         NsHXvK82ammpcTpA60IReG1HEcueMWT42lr2Oiio=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] netdevsim: set .owner to THIS_MODULE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160565160473.20427.16591628260770677986.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Nov 2020 22:20:04 +0000
References: <20201115103041.30701-1-ap420073@gmail.com>
In-Reply-To: <20201115103041.30701-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 15 Nov 2020 10:30:41 +0000 you wrote:
> If THIS_MODULE is not set, the module would be removed while debugfs is
> being used.
> It eventually makes kernel panic.
> 
> Fixes: 82c93a87bf8b ("netdevsim: implement couple of testing devlink health reporters")
> Fixes: 424be63ad831 ("netdevsim: add UDP tunnel port offload support")
> Fixes: 4418f862d675 ("netdevsim: implement support for devlink region and snapshots")
> Fixes: d3cbb907ae57 ("netdevsim: add ACL trap reporting cookie as a metadata")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v3,net] netdevsim: set .owner to THIS_MODULE
    https://git.kernel.org/netdev/net/c/a5bbcbf29089

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


