Return-Path: <netdev+bounces-8246-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E423723415
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 02:36:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82B681C20E00
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 00:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF2E938F;
	Tue,  6 Jun 2023 00:36:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD418364
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39514C433EF;
	Tue,  6 Jun 2023 00:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686011765;
	bh=eqwhEkztg0vqVq7xjd7jZgIPo3J9cEh26WM6lLbpJl8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=kLGIJ1/kRR3qDkIm4ww1PAmCrwbd0Yz3dYIxswPuVC/fO7DAIPNtMUoBN/JujYpRC
	 kQrkGmLD/wDrxQDbjpzJtviMd74gNZYK/xo1yYui4jFX+NOmJK9YD/aAJQkEc4SWws
	 ZGBJQMyu//dClArhKLGhhfhjqgZqZEO3CXIg/6ZDodaKSndf1itEhYYWsDWicNDM/1
	 LBX/wx2bziqrIpFFLyQxKW53c7yRQWIj0cL3S6bEJSCsJd3kqvEXSLPZ25oJ9xZgPz
	 K0aObIFqCRTj+DaaBMgdaHJQU1QFg6SU/9e9ESvIWhQc2qVOTVFkK7ctKzQLwepsIn
	 u03StQ2sreu7A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 101C3E8723C;
	Tue,  6 Jun 2023 00:36:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: skip CCing netdev for Bluetooth patches
From: patchwork-bot+bluetooth@kernel.org
Message-Id: 
 <168601176505.31462.14901912152706348781.git-patchwork-notify@kernel.org>
Date: Tue, 06 Jun 2023 00:36:05 +0000
References: <20230517014253.1233333-1-kuba@kernel.org>
In-Reply-To: <20230517014253.1233333-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, marcel@holtmann.org, johan.hedberg@gmail.com,
 luiz.dentz@gmail.com, linux-bluetooth@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 16 May 2023 18:42:53 -0700 you wrote:
> As requested by Marcel skip netdev for Bluetooth patches.
> Bluetooth has its own mailing list and overloading netdev
> leads to fewer people reading it.
> 
> Link: https://lore.kernel.org/netdev/639C8EA4-1F6E-42BE-8F04-E4A753A6EFFC@holtmann.org/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] MAINTAINERS: skip CCing netdev for Bluetooth patches
    https://git.kernel.org/bluetooth/bluetooth-next/c/bfa00d8f98f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



