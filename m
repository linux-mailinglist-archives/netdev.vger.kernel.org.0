Return-Path: <netdev+bounces-10020-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 620B672BB30
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:51:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2E841C20A86
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF73B134BA;
	Mon, 12 Jun 2023 08:50:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1595B111A1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83F7BC4339B;
	Mon, 12 Jun 2023 08:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686559840;
	bh=NmEEcRXm/Mlu+/E+rKftskNVCFyCyTVQii2TPDG184A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=o/zrfgPHjl6NjzaDMqJZ/4XHEgSaib4SU2Bpg5q3jKdffFWGMUP2nYVQyOItQWlbi
	 FjECoyfiz2O2/DnT9xdiM/4eICS91drsxOCBCPw0ORGANvGxTguADJcC/UXwWbr8LI
	 mtv95Ea/8cNDB3mh2V8LJ7RO3I3XY+KpxNjaokZWCBp1zDdU3bvnxFf4IblvIVkhYw
	 SuKR1kiHX+vYPEBUfG62I2hG08SriW//voVJ+bs3XrqTV/2cScyUGj2zIZmfyzkuNE
	 ZM+G4EZM3pmsMzALcLYARLWwW9mIZw/pZlKNpxJLZc1QULs8aueI8XGjp0kP2xkLSK
	 pQ7gbBDQ5+LyQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6B39CE21EC0;
	Mon, 12 Jun 2023 08:50:40 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] nfc: nxp-nci: store __be16 value in __be16
 variable
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168655984043.8602.16440207310260960824.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 08:50:40 +0000
References: <20230608-nxp-nci-be16-v2-1-cd9fa22a41fd@kernel.org>
In-Reply-To: <20230608-nxp-nci-be16-v2-1-cd9fa22a41fd@kernel.org>
To: Simon Horman <horms@kernel.org>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, krzysztof.kozlowski@linaro.org, luca.ceresoli@bootlin.com,
 michael@walle.cc, u.kleine-koenig@pengutronix.de,
 sridhar.samudrala@intel.com, kalesh-anakkur.purayil@broadcom.com,
 netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 09 Jun 2023 15:31:57 +0200 you wrote:
> Use a __be16 variable to store the big endian value of header in
> nxp_nci_i2c_fw_read().
> 
> Flagged by Sparse as:
> 
>  .../i2c.c:113:22: warning: cast to restricted __be16
> 
> [...]

Here is the summary with links:
  - [net-next,v2] nfc: nxp-nci: store __be16 value in __be16 variable
    https://git.kernel.org/netdev/net-next/c/f2ea0c3582ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



