Return-Path: <netdev+bounces-7797-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 026CD7218B6
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 18:58:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 745B1280E6C
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 16:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91C05DDD7;
	Sun,  4 Jun 2023 16:58:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385CA28EC
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 16:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B26FBC4339B;
	Sun,  4 Jun 2023 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685897926;
	bh=cl8Z4lNxakzndB+ZO48d0dZ+UKVDOh+bjBhY3pf35Tk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=LVkkRqNB4HqSao6f3z1gUXlAjJr8al6K52SRG94vhKMK1bIOuPAQwdV5j/h2067bS
	 SvWr8+mCPQD3buYioWMS71Xb/lDW4SVjRCo8Nw1rS73waKCv0s9oTCZu2nCLLTSreA
	 ZM1TVClyvg/j3liaYrZAxnxLxOGW3HU3E+lyFRTFwQGjGlFebuX3emErdVKdi7Sd1G
	 aW+vWfYEhmqhNRw5DVtDgN/lKqQ4IYQnzUkzvWycv6v5RvCnKBQG1QvBkNp/7gfCHX
	 E6eMIEgZ0pzVQrEhGe9KQMayKpsVmRzyZW10szep9pBIclQe3imw/gDgRogJTVq49y
	 4iBLm8wxp+iYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 85A98C395E0;
	Sun,  4 Jun 2023 16:58:46 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: enetc: correct the statistics of rx bytes
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168589792654.18651.16742899391823119808.git-patchwork-notify@kernel.org>
Date: Sun, 04 Jun 2023 16:58:46 +0000
References: <20230602094659.965523-1-wei.fang@nxp.com>
In-Reply-To: <20230602094659.965523-1-wei.fang@nxp.com>
To: Wei Fang <wei.fang@nxp.com>
Cc: claudiu.manoil@nxp.com, vladimir.oltean@nxp.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.or, pabeni@redhat.com, ast@kernel.org,
 daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri,  2 Jun 2023 17:46:57 +0800 you wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> The purpose of this patch set is to fix the issue of rx bytes
> statistics. The first patch corrects the rx bytes statistics
> of normal kernel protocol stack path, and the second patch is
> used to correct the rx bytes statistics of XDP.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: enetc: correct the statistics of rx bytes
    https://git.kernel.org/netdev/net/c/7190d0ff0e17
  - [net,2/2] net: enetc: correct rx_bytes statistics of XDP
    https://git.kernel.org/netdev/net/c/fdebd850cc06

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



