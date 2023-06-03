Return-Path: <netdev+bounces-7632-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31894720E2D
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 08:40:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F2561C212BE
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 06:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F38BF8831;
	Sat,  3 Jun 2023 06:40:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB78A8464
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 06:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64A78C433EF;
	Sat,  3 Jun 2023 06:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685774421;
	bh=LuvSHNRes99DWQA0Ih+zpldC/FdMitplRJcvVZ14NxE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Jyi82PZKYx3sFHQaBpX5YRtPAROWlYUwDmA/Wugn/17taV1VrbfOJmufImTYsRkRL
	 hkP8FeIBlrrROtzz3M0PF/MXSfnJOf5ntXyrPbxEqncO4BQvjJPRbtj8bI4reHOjdy
	 bZyVHSp1BsQwg7gtGpoRK/rbhceAyUFeSzkNyi4CmEveG94R7qVH0hUXx2+2jj+5PV
	 Gb+6yDwB4KL4IHF0lFdwveVCp4TI/Xv/vEaE4c5YBWlUto2NO32WY1Ij3QaA0EOEEE
	 1XWWY0lCZQAx6QEoyP9D8h12VQFd3ktvcjZHZ3+v6Opm/+YcToCw2e1Fe+M/3LKRO3
	 75owbJJz5GVnQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 406BAC395E0;
	Sat,  3 Jun 2023 06:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phylib: fix phy_read*_poll_timeout()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168577442125.6340.10105288306910035273.git-patchwork-notify@kernel.org>
Date: Sat, 03 Jun 2023 06:40:21 +0000
References: <E1q4kX6-00BNuM-Mx@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1q4kX6-00BNuM-Mx@rmk-PC.armlinux.org.uk>
To: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 dan.carpenter@linaro.org, linux@rempel-privat.de, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 01 Jun 2023 16:48:12 +0100 you wrote:
> Dan Carpenter reported a signedness bug in genphy_loopback(). Andrew
> reports that:
> 
> "It is common to get this wrong in general with PHY drivers. Dan
> regularly posts fixes like this soon after a PHY driver patch it
> merged. I really wish we could somehow get the compiler to warn when
> the result from phy_read() is stored into a unsigned type. It would
> save Dan a lot of work."
> 
> [...]

Here is the summary with links:
  - [net-next] net: phylib: fix phy_read*_poll_timeout()
    https://git.kernel.org/netdev/net-next/c/4ec732951702

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



