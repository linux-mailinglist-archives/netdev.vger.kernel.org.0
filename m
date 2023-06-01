Return-Path: <netdev+bounces-6987-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D483B71926D
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 07:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CD172802AD
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9846F23D9;
	Thu,  1 Jun 2023 05:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6E063CE;
	Thu,  1 Jun 2023 05:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6D82C433D2;
	Thu,  1 Jun 2023 05:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685598019;
	bh=pEVo9xIa9BpPfqZFt0k5HK2cgrdMWpYhxHV01xYYtZI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=lTx2I/cjv4dPW3t57Q8DT8pY4RbSxuc0z3E/oIlExhbfqptkAXVNJ2TZ/Qy5s/r2X
	 qA+psfkhQIgDZaHg5dTtY7BjSE/HnlLnEap4g6OpxNQ9ehqbCgqEhIjQpkwl/1jtqy
	 O8dUSrmCIeLb0QW2kgk7IQcMTg3fnW0e/r7DIU4EdpoR0K4uKOEYqhzngXy+Xt9d1b
	 uST9clAxM/THiU9Uhaza+K0qpEzjipEGg7I/9uEGMfh1kat9cSLT7c3ez9Irm85Xj9
	 82NFMGZPVzEMFj/tiyMjnWmHmAicv+IbcM5Q/L0qlO9tviEitCW5N2QTVyRIvutaw/
	 iIUAhiqpIj5ZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9A809C43162;
	Thu,  1 Jun 2023 05:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sfc: fix error unwinds in TC offload
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168559801962.10778.8818500062633828561.git-patchwork-notify@kernel.org>
Date: Thu, 01 Jun 2023 05:40:19 +0000
References: <20230530202527.53115-1-edward.cree@amd.com>
In-Reply-To: <20230530202527.53115-1-edward.cree@amd.com>
To:  <edward.cree@amd.com>
Cc: linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com, ecree.xilinx@gmail.com,
 netdev@vger.kernel.org, habetsm.xilinx@gmail.com, dan.carpenter@linaro.org,
 oe-kbuild-all@lists.linux.dev, lkp@intel.com, error27@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 May 2023 21:25:27 +0100 you wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Failure ladders weren't exactly unwinding what the function had done up
>  to that point; most seriously, when we encountered an already offloaded
>  rule, the failure path tried to remove the new rule from the hashtable,
>  which would in fact remove the already-present 'old' rule (since it has
>  the same key) from the table, and leak its resources.
> 
> [...]

Here is the summary with links:
  - [net] sfc: fix error unwinds in TC offload
    https://git.kernel.org/netdev/net/c/622ab656344a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



