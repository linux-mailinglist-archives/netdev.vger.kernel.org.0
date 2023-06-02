Return-Path: <netdev+bounces-7307-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4535971F982
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 07:00:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3E2F1C211C0
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 05:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D78D81FB5;
	Fri,  2 Jun 2023 05:00:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CC517EE
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 05:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED92AC433A7;
	Fri,  2 Jun 2023 05:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685682021;
	bh=pKGmAe66iVLtkWUtmlwgBrvTsp94xc4/jO8ObBITOyU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=P/qG1Mn9OHhZoEFIa5G1BcJ947PXozhstqYoKzh6WY9J0C15t1yzlJpkiH41jE6bs
	 u82zT1I7w9WK5oNQSzkuIdNMvUxoKZ56cHbDYWUrecp67ovar/YZD90jJoy+3zb/Wz
	 FZ9cRE8gBy+9MTPtmWw1VNvJo0Oqdb5RvW5iEh4vlzR5w7iNULIyJEFA8e0aLLubt1
	 P4Z3ARqVPkioKGrmv7NfbJOarfIQqXpRw64jCGGRGncRu6arR2+NJVhe7APNbRau3k
	 IjOkfz8vIYD7PYEKkpLFbXR/4abguZQxWo0MobQMnT2SVrRzUY9ybzxJu4hIr6Cnsq
	 OQm/5efmm5svg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C1639E4F125;
	Fri,  2 Jun 2023 05:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: broadcom: Add LPI counter
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168568202078.24823.16258287038709902570.git-patchwork-notify@kernel.org>
Date: Fri, 02 Jun 2023 05:00:20 +0000
References: <20230531231729.1873932-1-florian.fainelli@broadcom.com>
In-Reply-To: <20230531231729.1873932-1-florian.fainelli@broadcom.com>
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: netdev@vger.kernel.org, f.fainelli@gmail.com,
 bcm-kernel-feedback-list@broadcom.com, andrew@lunn.ch, hkallweit1@gmail.com,
 linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 31 May 2023 16:17:29 -0700 you wrote:
> Add the ability to read the PHY maintained LPI counter which is in the
> Clause 45 vendor space, device address 7, offset 0x803F. The counter is
> cleared on read.
> 
> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
> ---
>  drivers/net/phy/bcm-phy-lib.c | 19 ++++++++++++-------
>  include/linux/brcmphy.h       |  2 ++
>  2 files changed, 14 insertions(+), 7 deletions(-)

Here is the summary with links:
  - [net-next] net: phy: broadcom: Add LPI counter
    https://git.kernel.org/netdev/net-next/c/e8b6f79b4184

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



