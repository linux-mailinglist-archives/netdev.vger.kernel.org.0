Return-Path: <netdev+bounces-5807-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8585A712D19
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 21:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F1372819AD
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32DD12910E;
	Fri, 26 May 2023 19:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF13628E8
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 19:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6CB98C4339E;
	Fri, 26 May 2023 19:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685128220;
	bh=/b+4fFQMElBM3+sGEWG+BcQj8AgGBG78gYyqCBLaKKg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=EMD0E6gE5sKt8Hv06cZAVhjEUyegZaztp5ttvBQQoQBiDn0RL0BDV46uz6t57pNNO
	 epEqK0v3PFyRM4W1elGyu1qzIrxrACSn88kGyOhZaahcX4kqkV6jlFr9BzeUfvpa9b
	 mRdb7jtZ9mwUmHouRAE3ON3RO7Y3Cegqo7AyDSli8FQ4AYGATSNLT8r5tU+x0Xst52
	 WK+z76p9G8Pu+Lmc+SkF6wB6IdClamxyfDKew7RPGfy9hYEXjsplgX2lezIxQcx+w5
	 6AEt+C1SvQjx4d3LOh/I0R2jNVuzphO6GoAsgSTwvGRX8cwUemjsllnXfAuKrQyeA/
	 j/ApQLb4rl3RQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 52874C4166F;
	Fri, 26 May 2023 19:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next] bridge: vni: remove useless checks on vni
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168512822033.18754.15237669183328247603.git-patchwork-notify@kernel.org>
Date: Fri, 26 May 2023 19:10:20 +0000
References: <ebcffc302b5886a71a3e7aaec4561be2d65de30f.1685095619.git.aclaudi@redhat.com>
In-Reply-To: <ebcffc302b5886a71a3e7aaec4561be2d65de30f.1685095619.git.aclaudi@redhat.com>
To: Andrea Claudi <aclaudi@redhat.com>
Cc: netdev@vger.kernel.org, stephen@networkplumber.org, dsahern@gmail.com,
 roopa@nvidia.com, razor@blackwall.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Fri, 26 May 2023 19:27:20 +0200 you wrote:
> After the (d == NULL || vni == NULL) check, vni cannot be NULL anymore.
> 
> This remove two useless conditional checks on vni value:
> - the first check cannot be true, so remove the whole conditional block
> - the second check is always true, so remove the check
> 
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> 
> [...]

Here is the summary with links:
  - [iproute2-next] bridge: vni: remove useless checks on vni
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=33c3776b3ab6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



