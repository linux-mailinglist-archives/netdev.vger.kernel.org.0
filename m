Return-Path: <netdev+bounces-3497-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E635670792F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 06:41:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 862CF1C21033
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 04:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDB7737C;
	Thu, 18 May 2023 04:40:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7E9631
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 04:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90550C4339C;
	Thu, 18 May 2023 04:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684384821;
	bh=nti3XKfDu6OHjOeDxESq78YvWzofdVpLUXmq0Sk1hbQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ISU+E69gGMn6fc69IsSO03wXmLqB+YpaafbpURA31u2lrC/Qac8OgNKKQ+1FW7YYL
	 QDAHZDHLwnHP2wvHE7tp2iIo+VRBXFxG+NLtl8Se1vceOxyd2hqBOqxYqwtxq/utO9
	 w5anzTn/sInRoQE7PCoPinar7/BzaSUzdS7+/gYqafK7Sb5/VxwE9YqlIAJp+MgG2W
	 8fzj4Lk2ioy7/LmUt2mYg15ci7/D7h1xW8c97V+m2zEcOo4qrf09+y+5HU1b/UImqp
	 sG3sAWSTo7OSu0/qEAfckPOSND0wCaQzmRUuuCF4a65MDPrkD15LOm9NdzIUbgjcMO
	 Bk0lliyrz/Kgw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7C88BE54223;
	Thu, 18 May 2023 04:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: openvswitch: Use struct_size()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168438482150.9978.1427720181079235563.git-patchwork-notify@kernel.org>
Date: Thu, 18 May 2023 04:40:21 +0000
References: <e7746fbbd62371d286081d5266e88bbe8d3fe9f0.1683388991.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <e7746fbbd62371d286081d5266e88bbe8d3fe9f0.1683388991.git.christophe.jaillet@wanadoo.fr>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: pshelar@ovn.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org, netdev@vger.kernel.org, dev@openvswitch.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  6 May 2023 18:04:16 +0200 you wrote:
> Use struct_size() instead of hand writing it.
> This is less verbose and more informative.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> It will also help scripts when __counted_by macro will be added.
> See [1].
> 
> [...]

Here is the summary with links:
  - [net-next] net: openvswitch: Use struct_size()
    https://git.kernel.org/netdev/net-next/c/b50a8b0d57ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



