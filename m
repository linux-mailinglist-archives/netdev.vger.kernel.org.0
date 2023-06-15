Return-Path: <netdev+bounces-11246-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81952732286
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 00:11:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A9F21C20F22
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 22:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B15B018B1B;
	Thu, 15 Jun 2023 22:10:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A730A1773A
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 22:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 56FE3C43391;
	Thu, 15 Jun 2023 22:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686867021;
	bh=PvDVB/s3EYPnFpmPS9hYT5dQN4Ri0f5Z0pnM2zA+VP8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=MFbYa0FBEeGECayN1plDNj1lAef0yDQu8if4g9haK9ewoi/d/74KLnAx0lnv/hUiU
	 G+hL0SUH+FfFxhio6bHu8NOrYDI23DCuWXBHO7SR16Kj3XPknD3PaxqVpBZFRO2bQz
	 LZ60e4NpFsTi8nlNL75Tyr0mHzEtITSt92FyD1e2ci63cbq+6F+P1Dl+4gEQl/4yei
	 BMFJ/N3QvqrS2XZ+N+juySIfH+jId3DUQBJxZ4r1cso9lYpnglPulc5DOtvk0CrWx6
	 RbeqZnoTLWoad0Yvxn2eHmD7PM/LVXtHKdOpyB8twpk6u+Rv4uGXXERF45RXhxbdw1
	 +yPx7w3ELz4fw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 33F2EE270FB;
	Thu, 15 Jun 2023 22:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] octeon_ep: Add missing check for ioremap
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168686702120.9701.16100974127550672864.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 22:10:21 +0000
References: <20230615033400.2971-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20230615033400.2971-1-jiasheng@iscas.ac.cn>
To: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc: kuba@kernel.org, vburru@marvell.com, aayarekar@marvell.com,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 sburla@marvell.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 15 Jun 2023 11:34:00 +0800 you wrote:
> Add check for ioremap() and return the error if it fails in order to
> guarantee the success of ioremap().
> 
> Fixes: 862cd659a6fb ("octeon_ep: Add driver framework and device initialization")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
> Changelog:
> 
> [...]

Here is the summary with links:
  - [v2] octeon_ep: Add missing check for ioremap
    https://git.kernel.org/netdev/net/c/9a36e2d44d12

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



