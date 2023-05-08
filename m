Return-Path: <netdev+bounces-972-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C0CF16FB94B
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 23:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEB3D2810F3
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 21:20:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0758B11CA9;
	Mon,  8 May 2023 21:20:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0E1111BC
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 21:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9E98C433D2;
	Mon,  8 May 2023 21:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683580820;
	bh=mZsoy81imcfoL6MAmcDxawSnX7qdz2rvc6Rmw/QhMIg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=SMCau+zE/gZwlWTE0I3wCTAu+/Dz2vWGrTmfHw2EtRDYhjIZUoBzPqCFcH9AAVE8A
	 sowkwRigh9+zJ2MJpzh/3a2pA7d9/G74LgeQJV7EIbHDjBnV35nemya+CVUpAnEsQY
	 JVLPIsiQZYsmgIrtyC1Va6li+uH2cOicToGzFZ2kUZQkvsd8I0nfFwF7Wzq3Tc/7L6
	 6yUK0z0UivvJcnZWZ6bWGRVTaF4OrZ9CkBLKUJ6B27fTIjKlbO+DSGKbAF5hq+4EwT
	 IdLIW/vqVCQG7vhGDVRxcpXT2K8rhjh5Ruh08G1W9thi9gmo1ukmJsQm3fDwq2C6Vg
	 PAtBFVKmKk+EQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 96A51E26D26;
	Mon,  8 May 2023 21:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool v2] Fix argc and argp handling issues
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168358082060.17129.9657788188051603.git-patchwork-notify@kernel.org>
Date: Mon, 08 May 2023 21:20:20 +0000
References: <4b89caeddf355b07da0ba68ea058a94e5a55ff59.1683549760.git.nvinson234@gmail.com>
In-Reply-To: <4b89caeddf355b07da0ba68ea058a94e5a55ff59.1683549760.git.nvinson234@gmail.com>
To: Nicholas Vinson <nvinson234@gmail.com>
Cc: mkubeck@suse.cz, netdev@vger.kernel.org

Hello:

This patch was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Mon,  8 May 2023 16:23:07 -0400 you wrote:
> Fixes issues that were originally found using gcc's static analyzer. The
> flags used to invoke the analyzer are given below.
> 
> Upon manual review of the results and discussion of the previous patch
> '[PATCH ethtool 3/3] Fix potential null-pointer deference issues.', it
> was determined that when using a kernel lacking the execve patch ( see
> https://github.com/gregkh/linux/commit/dcd46d897adb70d63e025f175a00a89797d31a43),
> it is possible for argc to be 0 and argp to be an array with only a
> single NULL entry. This scenario would cause ethtool to read beyond the
> bounds of the argp array. However, this scenario should not be possible
> for any Linux kernel released within the last two years should have the
> execve patch applied.
> 
> [...]

Here is the summary with links:
  - [ethtool,v2] Fix argc and argp handling issues
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=7e21a348b37a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



