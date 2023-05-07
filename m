Return-Path: <netdev+bounces-764-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C84D6F9C86
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 00:40:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72F79280EB8
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 22:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C132AD36;
	Sun,  7 May 2023 22:40:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77202C2EB
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 22:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14085C433D2;
	Sun,  7 May 2023 22:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683499220;
	bh=wgmIznEbcDXyRqQZTJXLz/JM6Za40CCFYpXa7BdDz3I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=GHQYMKUwOkdDLAzo4Y4Zj1R1bDVESt3Ln77CnqNobEcV9ZdrtQ3Dp8M5cXF9/lMaO
	 4DxMFBEp2wI8wAZid+82OpL1mJn1ml56nKd7vEvdCOyg6JPYXS8jUYn+IgbKjo26Id
	 0Tf1lklYLirCvcVZG9BKAacvgRr6oNaacpvtzqwGaddAeTh0Md8iZiKQMVOh/FYsEp
	 BKCXFfTCnJj8UwVKDEHUInf06ya/lkEjc1Oi1Sbbu9aLA2BMNmveVXj+n/7N+WvjQD
	 UCtmbpUqUFQzVb8NVQ4yzkmYRtJUORchX773xrAkybX5UPckex8Pewp9Hjfy3ioj6N
	 EWaCV9AWnm3Xw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E8326C395C8;
	Sun,  7 May 2023 22:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool] netlink: settings: fix netlink support when PLCA is
 not present
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168349921994.21680.17516407930651873486.git-patchwork-notify@kernel.org>
Date: Sun, 07 May 2023 22:40:19 +0000
References: <20230425000742.130480-1-kuba@kernel.org>
In-Reply-To: <20230425000742.130480-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: mkubecek@suse.cz, netdev@vger.kernel.org, piergiorgio.beruto@gmail.com

Hello:

This patch was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Mon, 24 Apr 2023 17:07:42 -0700 you wrote:
> PLCA support threw the PLCA commands as required into the initial
> support check at the start of nl_gset(). That's not correct.
> The initial check (AFAIU) queries for the base support in the kernel
> i.e. support for the commands which correspond to ioctls.
> If those are not available (presumably very old kernel or kernel
> without ethtool-netlink) we're better off using the ioctl.
> 
> [...]

Here is the summary with links:
  - [ethtool] netlink: settings: fix netlink support when PLCA is not present
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=3d1f1c1e5070

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



