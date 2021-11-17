Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3565C453ED1
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhKQDNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:13:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:41628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232582AbhKQDNH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 22:13:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 589DD6108D;
        Wed, 17 Nov 2021 03:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637118609;
        bh=xR9m/FtANsZ7vZKOTPo8FP0ZrO4PaxGSzQzYlQx8odI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NdRK8TWMUfoDyrXzzOOJWvKV1uiG5mbZcl/1/iCiOaBymBaJViCF7j9IVvz0J/GOB
         T/O50pZPgbEGoQohVHBX2RC3tM/ikE0mARAqnTWBTUVMEMwXqA8J34EL4ovIZCT0gY
         6nfkYr459AhvTj9LQx0GcAxLkgF/xaf7x/uhfzJvOMBB9b/5KzOIGIy8lW5eY1UZtq
         35eMy+C4ApNzFy1UsAoqgdOSKptYDkwA/K3zmv1z3gtBYm3R8YlqSB7lQ3yI4etsvU
         xu2LrRTIYNdiXykxhlPTobpcit/sJkX3mkKH5gA31MaLctUHWyRUJ/CXXP6nRdzZ/V
         ndPGU4yiGKLgw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4CD8560A4E;
        Wed, 17 Nov 2021 03:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] MAINTAINERS: remove GR-everest-linux-l2@marvell.com
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163711860931.28737.12115069166861317347.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 03:10:09 +0000
References: <20211116141303.32180-1-paskripkin@gmail.com>
In-Reply-To: <20211116141303.32180-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, manishc@marvell.com,
        netdev@vger.kernel.org, aelior@marvell.com, skalluru@marvell.com,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 16 Nov 2021 17:13:03 +0300 you wrote:
> I've sent a patch to GR-everest-linux-l2@marvell.com few days ago and
> got a reply from postmaster@marvell.com:
> 
> 	Delivery has failed to these recipients or groups:
> 
> 	gr-everest-linux-l2@marvell.com<mailto:gr-everest-linux-l2@marvell.com>
> 	The email address you entered couldn't be found. Please check the
> 	recipient's email address and try to resend the message. If the problem
> 	continues, please contact your helpdesk.
> 
> [...]

Here is the summary with links:
  - [v2] MAINTAINERS: remove GR-everest-linux-l2@marvell.com
    https://git.kernel.org/netdev/net/c/0a83f96f8709

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


