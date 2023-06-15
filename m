Return-Path: <netdev+bounces-10987-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3866B730ED7
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 07:51:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6D8D281640
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 05:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED296810;
	Thu, 15 Jun 2023 05:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1A5813
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38B44C43391;
	Thu, 15 Jun 2023 05:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686808220;
	bh=VLXog8Q1W0+XIgi9Uv7LA9VFCZFsLHZV1HMd4QdhynQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=pGAFZ7rcNJq9pYI/nCTLNdsH1izY9wDLKNGfv78YajxLtoXOnXdnIw206xnCfk9Uj
	 yldfANhznc5FP+taYwklDwW6jAR4wb91JdgSUoUBDYByRVqBYCfDMSPydPBLjZpqeq
	 mTEqAiX7+Hlm4b7Uno9hWC177h2qdmCEsDTnQscIQkxbxzLynY4XwT1czhwuhAn+r4
	 hCR9ufZ1nDUh0Oc3uwfqQJsxqMgGnbvKoEl2gLS0t5F1W02BaO7ElXkKPcBsFK4Uyj
	 8GqUaVStnejVPpLMLoCbp6woGhGj8uO1l+YE92yjvYO3Ox9OC971nSJVgdbNzB7EcY
	 JK7oDmfwaJhlw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 24450C3274B;
	Thu, 15 Jun 2023 05:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] rtnetlink: move validate_linkmsg out of do_setlink
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168680822014.19671.5306336972644889162.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 05:50:20 +0000
References: <cf2ef061e08251faf9e8be25ff0d61150c030475.1686585334.git.lucien.xin@gmail.com>
In-Reply-To: <cf2ef061e08251faf9e8be25ff0d61150c030475.1686585334.git.lucien.xin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
 edumazet@google.com, pabeni@redhat.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 12 Jun 2023 11:55:34 -0400 you wrote:
> This patch moves validate_linkmsg() out of do_setlink() to its callers
> and deletes the early validate_linkmsg() call in __rtnl_newlink(), so
> that it will not call validate_linkmsg() twice in either of the paths:
> 
>   - __rtnl_newlink() -> do_setlink()
>   - __rtnl_newlink() -> rtnl_newlink_create() -> rtnl_create_link()
> 
> [...]

Here is the summary with links:
  - [net-next] rtnetlink: move validate_linkmsg out of do_setlink
    https://git.kernel.org/netdev/net-next/c/89da780aa4c7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



