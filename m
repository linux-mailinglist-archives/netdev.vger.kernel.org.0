Return-Path: <netdev+bounces-10325-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF7C972DE40
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 11:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A21DA1C20C07
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 09:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CFD728C16;
	Tue, 13 Jun 2023 09:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0274E2915
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 09:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60A59C4339B;
	Tue, 13 Jun 2023 09:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686649820;
	bh=gB2z3twwnLe7B5jH4TQLcyTgPGLcdatUY3cYduFoYz0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=n3kdbOSzu4ThBJoNvMd4lcZeYXXjGjo6BxgR9Dtnu6yawItyeDVkDh995elMWgvEz
	 WOV3LycNRp8ctJOSybEQOgLDFNP/922kb8CnOXqzHPWULDNVfE/l+slbxuqL5iMk7I
	 prS4EsKfK7PH5vgg1HFQZt7zqPTSGZuha+Rack8fWhJvqahD59IunlSaoWK1NnT2St
	 eZuV1ENrbWLJhCEzC9xu15tf20pN82qjYp/eV3QSkhMIzlAYywh0yRgfnUq58kecS+
	 8YJ9e48V59sWOBXYuM7MVYPTmA6+gY22q+OOPzzy0ETsa7mdu0qxARv/bqvmEZtmBN
	 pq/Rl+fxMdWww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 45928E1CF31;
	Tue, 13 Jun 2023 09:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] amd-xgbe: extend 10Mbps support to MAC version
 21H
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168664982027.27814.16610653252620862168.git-patchwork-notify@kernel.org>
Date: Tue, 13 Jun 2023 09:50:20 +0000
References: <20230612060724.1414349-1-Raju.Rangoju@amd.com>
In-Reply-To: <20230612060724.1414349-1-Raju.Rangoju@amd.com>
To: Raju Rangoju <Raju.Rangoju@amd.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, Shyam-sundar.S-k@amd.com,
 sridhar.samudrala@intel.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 12 Jun 2023 11:37:24 +0530 you wrote:
> MAC version 21H supports the 10Mbps speed. So, extend support to
> platforms that support it.
> 
> Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] amd-xgbe: extend 10Mbps support to MAC version 21H
    https://git.kernel.org/netdev/net-next/c/6b5f9a87e12d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



