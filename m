Return-Path: <netdev+bounces-3164-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD184705D97
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:00:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 031192813F7
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E69EB17D8;
	Wed, 17 May 2023 03:00:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8D417D0;
	Wed, 17 May 2023 03:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D5F8C4339B;
	Wed, 17 May 2023 03:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684292429;
	bh=TMtC86WXIWYrtgqSSAwhy3lSal74TktJhJH39UpTC3w=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=NRgQey+Qulkvc54G5B37UtVZUK9NIWmxdW197xZiyzsEbn1yULAU6GGX4RmoAWHHO
	 NOTICxgjDyUFjE9Y7541PyZG/0BfJe+VQIcg9WuKRI+fv/Z7qLKUYUkEBnOaUC4eX/
	 i+UyqjipHCrfXl3CXN5O9K8qCwxEKiBy+aCl+4CIuokmjGh9OdTVJm+anYW8vg3oqm
	 06zbeDlmLYqYgYhIOyp/N8wjD3EHBwZ/EuztKSAB59g3iPQgpy2Ik0UL5dvUfC5G3B
	 bIeg62rJexlWd0b9EpTWMd1WtEpbgz5DkIYZfl8BaL/a9qjOdVvyYc51Kma7zrRcL5
	 lMjco1GRlJYXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1298EE54223;
	Wed, 17 May 2023 03:00:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2023-05-16
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168429242907.20975.2621623861246085257.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 03:00:29 +0000
References: <20230515225603.27027-1-daniel@iogearbox.net>
In-Reply-To: <20230515225603.27027-1-daniel@iogearbox.net>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev,
 netdev@vger.kernel.org, bpf@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 16 May 2023 00:56:03 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 57 non-merge commits during the last 19 day(s) which contain
> a total of 63 files changed, 3293 insertions(+), 690 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2023-05-16
    https://git.kernel.org/netdev/net-next/c/a0e35a648faf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



