Return-Path: <netdev+bounces-11780-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D829073470C
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 18:40:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 930BC2810BE
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 16:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F1B463BE;
	Sun, 18 Jun 2023 16:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B49D4408
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 16:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58EA9C433CC;
	Sun, 18 Jun 2023 16:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687106419;
	bh=D//mGu6mGIbJ0KVnNbXE+63kbF//AIUOltdoKTGLfeQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=LjWZu0SBwT1NwvatZb0A8+RxP1x/lyysoGVs11N+mdGzylwwVMPCRi0JI58qd4bv9
	 EZ/LXpFLTcEJK1qyIe+THhtUayWw1j97cwdCcW5DwksUe51v9DFY+CILLi4tMkvbY1
	 PCddjyc8ZEyVs12oVCTWz/qyFJR+3gcllYv8C5suaLvZz6zeVXtubnlgQfVjUnU83N
	 YFnfVxUIoDKdDmv7HrBOaPBu4vR6O2otwbAhMfzu+jukuxsdAMjNZdS45UyU7/r/gf
	 jucQAIfjj0KnQLT9GKSJCY2pZq/uKCTXR+lw7FpjL7XQcW12+JXmFZd4p+gJdok4wh
	 IimH5Jd71SAXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 45776C395C7;
	Sun, 18 Jun 2023 16:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: at803x: Use
 devm_regulator_get_enable_optional()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168710641928.5271.4893587679808456480.git-patchwork-notify@kernel.org>
Date: Sun, 18 Jun 2023 16:40:19 +0000
References: <f5fdf1a50bb164b4f59409d3a70a2689515d59c9.1687011839.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <f5fdf1a50bb164b4f59409d3a70a2689515d59c9.1687011839.git.christophe.jaillet@wanadoo.fr>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 lgirdwood@gmail.com, broonie@kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat, 17 Jun 2023 16:24:37 +0200 you wrote:
> Use devm_regulator_get_enable_optional() instead of hand writing it. It
> saves some line of code.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Compile tested-only.
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: at803x: Use devm_regulator_get_enable_optional()
    https://git.kernel.org/netdev/net-next/c/988e8d90b3dc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



