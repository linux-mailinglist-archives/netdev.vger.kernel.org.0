Return-Path: <netdev+bounces-7963-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFAFE722382
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:31:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C8F228125A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD9A617AAB;
	Mon,  5 Jun 2023 10:30:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DC71801E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D40DAC433A7;
	Mon,  5 Jun 2023 10:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685961024;
	bh=4AQ5/g06koP3UfGOY+KI/8fdUylCLf5TsqPr3nNfEkE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=S5n2rTBZz+CkmmLs8GXRirzEI1nyNxXcuH7cAy8OvCOnTS3b1Yl2sLkaAIeRmQzew
	 H0w+5yOWVcQclSPoLu7pp60oDxRZzD0pG56Ho7KEIKUBS45KQ78izTXHB14EPk9Srq
	 +gy97u2Q5ZlaJiFn3O8E6T3oG/CbX9hVldn4Qr1PqAQsuLUD8w8RVeIy8v46tf+Ukn
	 fCfllaMetTPyfUL2uvTIz5yNT+4mPzidV/OUAseo97bhSUdFSyyPqCxppFPrz5UGx3
	 6Uv5lZmDCLx7QTktW1wcbzRGMDvLLu5pstn9QOyMjbTwU56IFX6kU8ovZfuYWs0nP6
	 5Px9dOSdSw9Pg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ADED2E87231;
	Mon,  5 Jun 2023 10:30:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] convert sja1105 xpcs creation and remove
 xpcs_create
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168596102470.26938.11958236997158848504.git-patchwork-notify@kernel.org>
Date: Mon, 05 Jun 2023 10:30:24 +0000
References: <ZHn1cTGFtEQ1Rv6E@shell.armlinux.org.uk>
In-Reply-To: <ZHn1cTGFtEQ1Rv6E@shell.armlinux.org.uk>
To: Russell King (Oracle) <linux@armlinux.org.uk>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
 edumazet@google.com, f.fainelli@gmail.com, kuba@kernel.org,
 Jose.Abreu@synopsys.com, netdev@vger.kernel.org, pabeni@redhat.com,
 olteanv@gmail.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 2 Jun 2023 14:58:09 +0100 you wrote:
> Hi,
> 
> This series of three patches converts sja1105 to use the newly
> provided xpcs_create_mdiodev(), and as there become no users of
> xpcs_create(), removes this function from the global namespace to
> discourage future direct use.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: dsa: sja1105: allow XPCS to handle mdiodev lifetime
    https://git.kernel.org/netdev/net-next/c/9607eaadba68
  - [net-next,2/3] net: dsa: sja1105: use xpcs_create_mdiodev()
    https://git.kernel.org/netdev/net-next/c/bf9a17b04c85
  - [net-next,3/3] net: pcs: xpcs: remove xpcs_create() from public view
    https://git.kernel.org/netdev/net-next/c/4739b9f3d211

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



