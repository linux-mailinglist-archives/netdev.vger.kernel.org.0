Return-Path: <netdev+bounces-7079-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4757E719B12
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 13:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1C701C20D30
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 11:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B3122342C;
	Thu,  1 Jun 2023 11:40:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCD423404
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 11:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1044C433EF;
	Thu,  1 Jun 2023 11:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685619620;
	bh=tWKWC14NSUd9pJRuuWFe1qj5v2WPgvywMtEEIdSejIQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=OAid/USZoUrsOwc/UoTVAc9n8Ib6Bb98eKvWIutHzXLvme7rZuzV03ywKtqEr5yis
	 d2nqmszqr2+DxstOFkZENbQfg6BpEgMY1VJZG4wf7YFo5uJ8uE3vgCqVRwnz7IpfhZ
	 +7TeifzsaKJkQOe+Db3OLHjoOrSYOtD02aEmh+5H9qG3p+6mDXlrEmSRiwMofDi1yq
	 H+VcLfUj0f+B2sMEjhHMeoKEz87LPqa4uCS+evPsz5IyE/bbUh3RDuCOrHF6BjbzXP
	 WlJRiJvJWPPU/EihT9Cqqzy5EgI6F4uBmOxfwO6YOzVDEW1WSY4cEIwBqE9qPYvvue
	 dS5SSdeaHq/TA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CD2DCC395E5;
	Thu,  1 Jun 2023 11:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: ipa: Use correct value for IPA_STATUS_SIZE
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168561961983.20738.2293135915204536945.git-patchwork-notify@kernel.org>
Date: Thu, 01 Jun 2023 11:40:19 +0000
References: <20230531103618.102608-1-spasswolf@web.de>
In-Reply-To: <20230531103618.102608-1-spasswolf@web.de>
To: Bert Karwatzki <spasswolf@web.de>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, elder@kernel.org, netdev@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 31 May 2023 12:36:19 +0200 you wrote:
> IPA_STATUS_SIZE was introduced in commit b8dc7d0eea5a as a replacement
> for the size of the removed struct ipa_status which had size
> sizeof(__le32[8]). Use this value as IPA_STATUS_SIZE.
> 
> Fixes: b8dc7d0eea5a ("net: ipa: stop using sizeof(status)")
> Signed-off-by: Bert Karwatzki <spasswolf@web.de>
> 
> [...]

Here is the summary with links:
  - [net,v3] net: ipa: Use correct value for IPA_STATUS_SIZE
    https://git.kernel.org/netdev/net/c/be7f8012a513

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



