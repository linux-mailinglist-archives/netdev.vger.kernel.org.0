Return-Path: <netdev+bounces-10986-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15913730ECF
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 07:50:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF723281650
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 05:50:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E00EDA45;
	Thu, 15 Jun 2023 05:50:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2AB810
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F24C4C433C0;
	Thu, 15 Jun 2023 05:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686808220;
	bh=I4oUFX3tC9T2WSrlJfeqimSzQWviEXKAm2Uwvk7Rips=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=UjM/DV4KGJ5V8ByrErIr4vf5tE2nqGOMqaDr0s0upyvDRfQWnuWVudk3nIJkwQIeX
	 2EEkFJt4mwI8z4YdtjXIbAR/yQUTA1t4l2HSvInZxO/TZ315JZdtxSuLM9IQXFJ3BO
	 pqTOQ+eJSuAH094+H+vV2CLShhgrZvvX0N6R8k4Mnswc0ffShSQcOpM23M6TjcHsYp
	 iIePVVH01mvonyA/nM6U7osZfFHqIRaJMFfeE4LeJTIinfU5z+hz3SV+Qg1KJlIuG4
	 eoMJ9Hc/RRB/LzXyIOcCm02Mq6ykuleHtPtatG84SpbHTvQgc61X1Yr5ypI6FAHe+v
	 jsGMs5ZMPmMXQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE393C395C7;
	Thu, 15 Jun 2023 05:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/3][pull request] Intel Wired LAN Driver Updates
 2023-06-12 (igc, igb)
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168680821983.19671.18140959822703552463.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 05:50:19 +0000
References: <20230612205208.115292-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230612205208.115292-1-anthony.l.nguyen@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon, 12 Jun 2023 13:52:05 -0700 you wrote:
> This series contains updates to igc and igb drivers.
> 
> Husaini clears Tx rings when interface is brought down for igc.
> 
> Vinicius disables PTM and PCI busmaster when removing igc driver.
> 
> Alex adds error check and path for NVM read error on igb.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/3] igc: Clean the TX buffer and TX descriptor ring
    https://git.kernel.org/netdev/net/c/e43516f5978d
  - [net,v3,2/3] igc: Fix possible system crash when loading module
    https://git.kernel.org/netdev/net/c/c080fe262f9e
  - [net,v3,3/3] igb: fix nvm.ops.read() error handling
    https://git.kernel.org/netdev/net/c/48a821fd5883

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



