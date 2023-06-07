Return-Path: <netdev+bounces-8794-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F886725D22
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03AB01C20994
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FEAD30B9C;
	Wed,  7 Jun 2023 11:30:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E8117AAA
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04DB5C433AC;
	Wed,  7 Jun 2023 11:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686137422;
	bh=DWKC357UeEDhSAvsjAKfUWSmSKmkkYjJvL3H9IvKKbs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=vCVZP72HiqTnhztMjnaRFfPG+NJv4cp4EM9nIWMGEFqe+AxYugM2QEWWW9Cp1u2j/
	 zSN/qRooSXxlZlO8OUaN0XZ14G3xf9GBJ5UTGpmTc1f2RNHJtbqCjjgIR/m2nWScYD
	 NzY7QN/uHXSudD1pFI40a3Ynv5xk9nh2WuS59FO5oZeeCVWK1mJzak30tskzydxnu0
	 3YU/X3m4QcANnUxcvwPqaSvrtRo0zuVPCP4NTFAX5DSb0vCpfNbmbTIKbH3WIBKmTm
	 /of0G+ro7Ql+c6XNFfocDKzuTEUsNFHRCFZCkEJOcYEX8Y/4j+y5Kntw47EBnhClyE
	 S0iLJ3vjxakaw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E24A6E29F3C;
	Wed,  7 Jun 2023 11:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: txgbe: Avoid passing uninitialised
 parameter to pci_wake_from_d3()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168613742192.29815.17974673130309841655.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 11:30:21 +0000
References: <20230605-txgbe-wake-v2-1-82e1f0441c72@kernel.org>
In-Reply-To: <20230605-txgbe-wake-v2-1-82e1f0441c72@kernel.org>
To: Simon Horman <horms@kernel.org>
Cc: kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, jiawenwu@trustnetic.com, mengyuanlou@net-swift.com,
 dan.carpenter@linaro.com, maciej.fijalkowski@intel.com,
 netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 06 Jun 2023 15:49:45 +0200 you wrote:
> txgbe_shutdown() relies on txgbe_dev_shutdown() to initialise
> wake by passing it by reference. However, txgbe_dev_shutdown()
> doesn't use this parameter at all.
> 
> wake is then passed uninitialised by txgbe_dev_shutdown()
> to pci_wake_from_d3().
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: txgbe: Avoid passing uninitialised parameter to pci_wake_from_d3()
    https://git.kernel.org/netdev/net-next/c/e7214663e023

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



