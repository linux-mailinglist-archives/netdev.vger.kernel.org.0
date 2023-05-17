Return-Path: <netdev+bounces-3243-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2C567062EA
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:31:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4BC32815CE
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 289491548D;
	Wed, 17 May 2023 08:30:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB338168DE
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 79BA0C433A7;
	Wed, 17 May 2023 08:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684312223;
	bh=AkicJvr+p/llY46l/lSvL7nS97pOBvL0l7vAaCiDYPY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=rziNbBVfcIoplcdZYc7FPpdw2N/zdGeAC00bUpGo0Ri6e0dq/Af8FGBNCMYKVvR0B
	 bKLs+dIKwYyaHfnY7y2ZcQhXMR2HLo1FzVPdOh/cweoMI5HfokKMqzavAceHbcTMRa
	 Ged12AZyZdEAW99xXkcBABGfFdMK23Z3+2r+A+OjOJOShLhGvRGU5oLnflNQXc5DI1
	 TXKvMrfFBkA+C55GBs5evb4Ml5h3UoHOele7LwTOLCtXbIM0Ub2+bo7vBSE4acF+3n
	 Eyyhp8fCSEGykU6jpDk9fzGUhJY27KTHvCBh3At1ShfpIZaxgkKi9uaUAYvawabHkG
	 myCQ3+Zl2kiiw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 55341C41672;
	Wed, 17 May 2023 08:30:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/8][pull request] ice: support dynamic interrupt
 allocation
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168431222334.29655.6434690104586042687.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 08:30:23 +0000
References: <20230516174021.2707029-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230516174021.2707029-1-anthony.l.nguyen@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, piotr.raczynski@intel.com

Hello:

This series was applied to netdev/net-next.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 16 May 2023 10:40:13 -0700 you wrote:
> Piotr Raczynski says:
> 
> This patchset reimplements MSIX interrupt allocation logic to allow dynamic
> interrupt allocation after MSIX has been initially enabled. This allows
> current and future features to allocate and free interrupts as needed and
> will help to drastically decrease number of initially preallocated
> interrupts (even down to the API hard limit of 1). Although this patchset
> does not change behavior in terms of actual number of allocated interrupts
> during probe, it will be subject to change.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/8] ice: move interrupt related code to separate file
    https://git.kernel.org/netdev/net-next/c/38e97a98e371
  - [net-next,v2,2/8] ice: use pci_irq_vector helper function
    https://git.kernel.org/netdev/net-next/c/afe87cfe820e
  - [net-next,v2,3/8] ice: use preferred MSIX allocation api
    https://git.kernel.org/netdev/net-next/c/05018936a1fe
  - [net-next,v2,4/8] ice: refactor VF control VSI interrupt handling
    https://git.kernel.org/netdev/net-next/c/369bb5a2a9a7
  - [net-next,v2,5/8] ice: remove redundant SRIOV code
    https://git.kernel.org/netdev/net-next/c/524012c69ee1
  - [net-next,v2,6/8] ice: add individual interrupt allocation
    https://git.kernel.org/netdev/net-next/c/4aad5335969f
  - [net-next,v2,7/8] ice: track interrupt vectors with xarray
    https://git.kernel.org/netdev/net-next/c/cfebc0a36ea5
  - [net-next,v2,8/8] ice: add dynamic interrupt allocation
    https://git.kernel.org/netdev/net-next/c/011670cc340c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



