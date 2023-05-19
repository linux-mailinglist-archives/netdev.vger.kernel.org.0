Return-Path: <netdev+bounces-3797-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D834E708E27
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 05:10:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 932B2281B23
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 03:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CF45397;
	Fri, 19 May 2023 03:10:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB80648
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 03:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF4A9C433D2;
	Fri, 19 May 2023 03:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684465831;
	bh=u8kx3LOEbya7T6HyYGJ0EUg0VayTQtg4n2Y5FG2OJeM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=eH3CeOPN8vRkVDa3n2jolq95YTffykm2BtkvBBsKdh8anOJ2TUQgIwKOFRcVaovhU
	 pfRTpF3XEeSByAuCZ9hfMj0dorBcuB+QJUITbVy77fywbDZi9W93vCVyEORrjmYsUR
	 yVQmhh/QsehdHUeL426aCyN612F0OJWfkkW7xl0ErctOHZp2yCyRy5shEkawPECRyu
	 8HEzKOjYTdbSBdbWQig+GLksYsmDYaQLUX1Fng9BxL8Cdrug3bwVrhcn1yc5xFURci
	 oFY3yHVi9/biIamMnM5sggWYoz33Zk5sL7PP6gkQ5YzWyHG1XbHU3FZis8NhNrvhBE
	 VwjTxuNM4yImg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B03E8E21EE0;
	Fri, 19 May 2023 03:10:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5][pull request] Intel Wired LAN Driver Updates
 2023-05-17 (ice, MAINTAINERS)
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168446583171.25467.17092070696722040795.git-patchwork-notify@kernel.org>
Date: Fri, 19 May 2023 03:10:31 +0000
References: <20230517165530.3179965-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230517165530.3179965-1-anthony.l.nguyen@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed, 17 May 2023 09:55:25 -0700 you wrote:
> This series contains updates to ice driver and MAINTAINERS file.
> 
> Paul refactors PHY to link mode reporting and updates some PHY types to
> report more accurate link modes for ice.
> 
> Dave removes mutual exclusion policy between LAG and SR-IOV in ice
> driver.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] ice: update ICE_PHY_TYPE_HIGH_MAX_INDEX
    https://git.kernel.org/netdev/net-next/c/578fb0926c12
  - [net-next,2/5] ice: refactor PHY type to ethtool link mode
    https://git.kernel.org/netdev/net-next/c/9136e1f1e5c3
  - [net-next,3/5] ice: update PHY type to ethtool link mode mapping
    https://git.kernel.org/netdev/net-next/c/49eb1c1f2f05
  - [net-next,4/5] ice: Remove LAG+SRIOV mutual exclusion
    https://git.kernel.org/netdev/net-next/c/1c769b1a303f
  - [net-next,5/5] MAINTAINERS: update Intel Ethernet links
    https://git.kernel.org/netdev/net-next/c/ebdf098a0e1b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



