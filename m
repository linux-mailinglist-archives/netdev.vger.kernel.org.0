Return-Path: <netdev+bounces-766-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D16046F9C88
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 00:41:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E911280E95
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 22:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1892210975;
	Sun,  7 May 2023 22:40:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A657101F0
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 22:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 26D6FC4339B;
	Sun,  7 May 2023 22:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683499220;
	bh=iWtDz+ULGzXuTe0/LwmDvreKkzoJP39QKU6Hj0E7kzo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=UJOpnV69dif272mrK5eBbVZHzie7ce+JG3boLnzsm4tk6yOpTVMAs9TP+VNEUAj7G
	 baQ4/NL085LCs54UeAqogWZZ4t97GbyaDX05b5RK5Mra3BBUvdgMGf9wiAaFqzXjuG
	 SRvuIsnWCD/CYGxKyqmlBF7xVYSCHGeUQY5ZYjuFRLvdw6GTBmjlFqMImTRYQhOXV3
	 1Q3Xxtb+kPIwFNEUY3JimlvW/XMREnRhnek6+8yROdzvTOef9uJjnR1LG+EEJCPpHC
	 ukOmZOnDuaXVZWp/+/hCWiEu+Px6OgE2o6E9/oaNHAFZNPfZu86xCZ/OZvgF9rMx+7
	 Yoz2l8R9Tp96Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 069C9E26D25;
	Sun,  7 May 2023 22:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool] rxclass: Fix return code in rxclass_rule_ins
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168349922002.21680.13472993184135234744.git-patchwork-notify@kernel.org>
Date: Sun, 07 May 2023 22:40:20 +0000
References: <20230503165106.9584-1-dsahern@kernel.org>
In-Reply-To: <20230503165106.9584-1-dsahern@kernel.org>
To: David Ahern <dsahern@kernel.org>
Cc: mkubecek@suse.cz, netdev@vger.kernel.org, alexanderduyck@fb.com

Hello:

This patch was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Wed,  3 May 2023 10:51:06 -0600 you wrote:
> ethtool is not exiting non-0 when -N fails. e.g.,
> 
> $ sudo ethtool -N eth0 flow-type tcp4 src-ip 1.2.3.4 action 3 loc 1023
> rmgr: Cannot insert RX class rule: No such device
> $ echo $?
> 0
> 
> [...]

Here is the summary with links:
  - [ethtool] rxclass: Fix return code in rxclass_rule_ins
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=67c9ebf907d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



