Return-Path: <netdev+bounces-11017-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CFD273119D
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:00:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA6522816D9
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 08:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B323FFF;
	Thu, 15 Jun 2023 08:00:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D2A1379
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD53CC433C0;
	Thu, 15 Jun 2023 08:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686816020;
	bh=pTeT0+vmohsjW0okNsxofP17LsBpNeEu8djY9+zp/Ik=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=DIkpWe3itlfbrdpjwq/vpZ2byQUgzk0APumt5D8hmOFM9SH1CGtIUxVvhJgcqhDDa
	 mKsGXlU19Uy74J9Bqlijvs+8RPz0VAR2ozJ+ZKjX7VFRXLN39v7N89o2OWy6Ou82sh
	 ADMwkhkVR81LavzM5tkPdZks2M3oCBgbgvc8AUz/Wcthgzc4tKdLtuqZopOahoVM7x
	 zPeEJ1tEEwqNMO41K67b8zN6tGBiuQjlUVbxNnipjyBBafhncpJusN7EkbIhq84e9N
	 Lah2WgS/rwsBY4u6fzKhZ1cHmWJiNr35m02dG/5N0YNQbUSulS32nqeuk9S4K0RZYf
	 AHgPNqiGRMLLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A431FC395C7;
	Thu, 15 Jun 2023 08:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: add reviewers for SMC Sockets
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168681602065.28236.4320550705264513141.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 08:00:20 +0000
References: <20230614065456.2724-1-jaka@linux.ibm.com>
In-Reply-To: <20230614065456.2724-1-jaka@linux.ibm.com>
To: Jan Karcher <jaka@linux.ibm.com>
Cc: davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-s390@vger.kernel.org,
 hca@linux.ibm.com, wintera@linux.ibm.com, wenjia@linux.ibm.com,
 twinkler@linux.ibm.com, raspl@linux.ibm.com, kgraul@linux.ibm.com,
 niho@linux.ibm.com, pasic@linux.ibm.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, alibuda@linux.alibaba.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 14 Jun 2023 08:54:56 +0200 you wrote:
> adding three people from Alibaba as reviewers for SMC.
> They are currently working on improving SMC on other architectures than
> s390 and help with reviewing patches on top.
> 
> Thank you D. Wythe, Tony Lu and Wen Gu for your contributions and
> collaboration and welcome on board as reviewers!
> 
> [...]

Here is the summary with links:
  - MAINTAINERS: add reviewers for SMC Sockets
    https://git.kernel.org/netdev/net/c/7d03646d77cf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



