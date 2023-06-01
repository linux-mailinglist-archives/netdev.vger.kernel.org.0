Return-Path: <netdev+bounces-7182-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BD4071F058
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:11:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E607C1C2106D
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:11:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A13946FE8;
	Thu,  1 Jun 2023 17:10:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3C64252F;
	Thu,  1 Jun 2023 17:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59430C433EF;
	Thu,  1 Jun 2023 17:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685639424;
	bh=h5gHmJP822qFRyXKTj2ZclAqMJbAbBm5SymtVNN5Bug=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=K4Z8E6PMRKO8p6aQ5mYOqbEUmGyXt6awThB1sLwSDOLXcO3yYD2MUGXxjDDD13ElE
	 TZcnA8fVg2wJJPYzmtzcPKRyhsd1Vqq3h265iXszdT8B1OdNVy7PbxTCRg/Xb529Lt
	 HmrVVATA2EXUIlwtigvpC58f7w8H1bcXSpxFdGEkj9+NF+1420DGqgKGXwapMvQQDl
	 JXzl59kmibdPWG/0fUn2/+CpqrlD/gPav555cNpOphiqAsyGxl8LgPia/Gik0ahS6a
	 STX8uD1aeUDReuTYl7pDBsFhrJdr4eAo1YOzIkrYtM836O51/u1JgsATu7MQApgZp7
	 In0BVGK6bSpHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2FF08C43162;
	Thu,  1 Jun 2023 17:10:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ice: recycle/free all of the fragments from multi-buffer
 frame
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168563942418.9709.5547131028372889354.git-patchwork-notify@kernel.org>
Date: Thu, 01 Jun 2023 17:10:24 +0000
References: <20230531154457.3216621-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230531154457.3216621-1-anthony.l.nguyen@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
 magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
 hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
 simon.horman@corigine.com, chandanx.rout@intel.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 31 May 2023 08:44:57 -0700 you wrote:
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> The ice driver caches next_to_clean value at the beginning of
> ice_clean_rx_irq() in order to remember the first buffer that has to be
> freed/recycled after main Rx processing loop. The end boundary is
> indicated by first descriptor of frame that Rx processing loop has ended
> its duties. Note that if mentioned loop ended in the middle of gathering
> multi-buffer frame, next_to_clean would be pointing to the descriptor in
> the middle of the frame BUT freeing/recycling stage will stop at the
> first descriptor. This means that next iteration of ice_clean_rx_irq()
> will miss the (first_desc, next_to_clean - 1) entries.
> 
> [...]

Here is the summary with links:
  - [net] ice: recycle/free all of the fragments from multi-buffer frame
    https://git.kernel.org/netdev/net/c/abaf8d51b0ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



