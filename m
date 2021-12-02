Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5ED5466369
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 13:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357831AbhLBMXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 07:23:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53556 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357789AbhLBMXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 07:23:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E821B82348;
        Thu,  2 Dec 2021 12:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D99F8C53FCB;
        Thu,  2 Dec 2021 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638447610;
        bh=H9gMyXEtFtkR6vGx6oZvhsc5sE5YnTIHEtLBaiZVQ7Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NMMoYbGomDF9v4sdefH/UBvxKJyyX+jpAJHg67ue51CYBDEezYUtd2prU83z8kiXi
         hX6XyO8MQDGJ/5AUQeJgcGKtKNsS8zNtWBcrqDDOiWMgaaObXA6shrWyrDyHAetWUi
         6M4FeDeB0p4eby2bPLQUB3ZcvL+KRzGfb7TmPRe5F8u99WBEa+s6KYh6HCsRBcyGTR
         Vl/4a4Y+HVAW6jzxkOiyxeZUQawA+4WEgiXjDMc6a4Yi4Hs52ivIfch8DyY/mkVfAS
         Z/sNiIiU33t9Wty44O7td5AvttUm7BZyZXrtjErJoN+EXP+2Sbbp0v5UgifEyY/UqV
         6BvcFZxiLSW9w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BC3A760A88;
        Thu,  2 Dec 2021 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3] ethernet: aquantia: Try MAC address from device tree
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163844761076.9736.9081757784180554336.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 12:20:10 +0000
References: <20211201025706.GA2181732@cth-desktop-dorm.mad.wi.cth451.me>
In-Reply-To: <20211201025706.GA2181732@cth-desktop-dorm.mad.wi.cth451.me>
To:     Tianhao Chai <cth451@gmail.com>
Cc:     irusskikh@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, jwi@linux.ibm.com,
        marcan@marcan.st, sven@svenpeter.dev, alyssa@rosenzweig.io
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 30 Nov 2021 20:57:06 -0600 you wrote:
> Apple M1 Mac minis (2020) with 10GE NICs do not have MAC address in the
> card, but instead need to obtain MAC addresses from the device tree. In
> this case the hardware will report an invalid MAC.
> 
> Currently atlantic driver does not query the DT for MAC address and will
> randomly assign a MAC if the NIC doesn't have a permanent MAC burnt in.
> This patch causes the driver to perfer a valid MAC address from OF (if
> present) over HW self-reported MAC and only fall back to a random MAC
> address when neither of them is valid.
> 
> [...]

Here is the summary with links:
  - [PATCHv3] ethernet: aquantia: Try MAC address from device tree
    https://git.kernel.org/netdev/net/c/553217c24426

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


