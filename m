Return-Path: <netdev+bounces-11245-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 921C1732285
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 00:11:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CB84281511
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 22:11:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 924E518B0D;
	Thu, 15 Jun 2023 22:10:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EF51772E
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 22:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3BDBEC433C9;
	Thu, 15 Jun 2023 22:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686867021;
	bh=EL93ScnYQ//w5eG8jbe3elpsczNkhXXjXDUdTAha0fc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=qt9nCS9iprtlS4Yehhu2kv8KvE9OsfYxOpkzDlZGxA2U1zEHjo3DbEEN2SWa6R7w1
	 l0wmJmN7+anZbTfbXXxpyhbEQlFVwf+FQ2ZLpLSZoZ2e/BmlaUM8dpwQae2qieH7yX
	 Q7HWEnm+qKeoYN3CEx50XpPuDm5hW9uVsnqQ9ehztsNkc4g0gilPwqFEO1m/KIExtb
	 qY8veP85Vxry0JzqQwQyLRviORRu9QAfbr9y/bmK/9mUgFSMNo+kTog0hcToUeueu6
	 gA8u881LgyCitzEA+o/Bk6PET4EFZ5/YCxATaI2XRVjnkV7IKU0GnHXVQu7B1yMoI+
	 CQ7XQdSuTJGOQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 17BD0E21EEA;
	Thu, 15 Jun 2023 22:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1] tipc: resize nlattr array to correct size
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168686702108.9701.16428845157515864960.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 22:10:21 +0000
References: <20230614080013.1112884-1-linma@zju.edu.cn>
In-Reply-To: <20230614080013.1112884-1-linma@zju.edu.cn>
To: Lin Ma <linma@zju.edu.cn>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 14 Jun 2023 16:00:13 +0800 you wrote:
> According to nla_parse_nested_deprecated(), the tb[] is supposed to the
> destination array with maxtype+1 elements. In current
> tipc_nl_media_get() and __tipc_nl_media_set(), a larger array is used
> which is unnecessary. This patch resize them to a proper size.
> 
> Signed-off-by: Lin Ma <linma@zju.edu.cn>
> 
> [...]

Here is the summary with links:
  - [v1] tipc: resize nlattr array to correct size
    https://git.kernel.org/netdev/net/c/44194cb1b604

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



