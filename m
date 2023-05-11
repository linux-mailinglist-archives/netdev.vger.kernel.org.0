Return-Path: <netdev+bounces-1965-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9A126FFBC8
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 23:21:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C51271C21090
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 21:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FA5E12B86;
	Thu, 11 May 2023 21:20:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE90216434
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 21:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F231C4339E;
	Thu, 11 May 2023 21:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683840021;
	bh=w09YcKkX6aQfB9vMUZtYAlODEZxlD6hnT6Jc/pccq8s=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=nHDAd7npwYE+wzFwSj1CJR5YVBHcQoln2NtXNSfjOlQzT5Af4/Ue/xeGUvOMVzZvK
	 TUn3NautjDJ+/vF7DR56OAYMVCaZi7LRArjpLWysZ8I0+g/PipzM5+Tvu9H1n1DqO4
	 OPlrziAIYJyF27/DUzn+6LBNq8GevYjq2uwm+S5L5wfkplp3FQ2XmzxZkEoAaXSfjW
	 2qgu54Ukqr0cT45VrxVeFDrhOCKnJN3pRgEfcAErYMILk/7eD0RrqSwoMDmEKcCx2W
	 8q44vHDm+Q+7trnf3u2lZd5O23fKkLbv+bBFpGMWJWlE7/k6xqh5N10OtVmQKFh8//
	 /U9wD64k4zt3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F8C6E49F61;
	Thu, 11 May 2023 21:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] ipnetns: fix fd leak with 'ip netns set'
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168384002125.32472.1396715428795599326.git-patchwork-notify@kernel.org>
Date: Thu, 11 May 2023 21:20:21 +0000
References: <20230511144224.26975-1-nicolas.dichtel@6wind.com>
In-Reply-To: <20230511144224.26975-1-nicolas.dichtel@6wind.com>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: stephen@networkplumber.org, dsahern@gmail.com, netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Thu, 11 May 2023 16:42:24 +0200 you wrote:
> There is no reason to open this netns file. set_netnsid_from_name() uses
> netns_get_fd() for this purpose and uses the returned fd.
> 
> Reported-by: Stephen Hemminger <stephen@networkplumber.org>
> Fixes: d182ee1307c7 ("ipnetns: allow to get and set netns ids")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> 
> [...]

Here is the summary with links:
  - [iproute2] ipnetns: fix fd leak with 'ip netns set'
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=465e87a89c13

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



