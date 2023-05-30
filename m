Return-Path: <netdev+bounces-6534-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34463716D8F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:30:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADF0C1C20CE1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:30:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 995812A9D4;
	Tue, 30 May 2023 19:30:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A9020683
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 403BAC4339C;
	Tue, 30 May 2023 19:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685475020;
	bh=JsNRwr135mqH5s0R/7I01Ilk8IeETU2gZ8xnS7eiEAs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Y8DXsJjc03ponVjoGDMUqv3G+Ns2gllKe9+AyYP45GWRIDvpdV5bb2Ub5E8E9d6fb
	 p82PrHMLs/iM9Uy9P9P6sbHU/EPqGL9Am+hdUoTR8rg6WezR4A31N1s3VQugg+CNQm
	 k20SL2AxcMGPXboWNo4VzAc1TSBH8G7thWK45W9Ijv5lxD5bkS+ohyaq623F+LCr22
	 GPSsggeC5nUxcU1Y8K4JbjlM/UN2N5AzNpF2jxY1bFbTTYky1mqrl7Qrk90S1dan4S
	 mmharXQvYX7RyPRoT+wGQQkNk7bThioy2SuMuYqLw/KPb7lq+Sq+9jcKUScgariO1v
	 TcybS7ha/UGdQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 22920E52C11;
	Tue, 30 May 2023 19:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] ipstats: fix message reporting error
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168547502013.11706.8026190249596630284.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 19:30:20 +0000
References: <e8875ce96124d1f30acf6a237d0a67f2194d13a6.1685379264.git.aclaudi@redhat.com>
In-Reply-To: <e8875ce96124d1f30acf6a237d0a67f2194d13a6.1685379264.git.aclaudi@redhat.com>
To: Andrea Claudi <aclaudi@redhat.com>
Cc: netdev@vger.kernel.org, stephen@networkplumber.org, dsahern@gmail.com,
 me@pmachata.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Mon, 29 May 2023 18:59:15 +0200 you wrote:
> strerror() accepts any integer as arguments, but returns meaningful
> error descriptions only for positive integers.
> 
> ipstats code uses strerror on a code path where either err is 0 or
> -ENOMEM, thus resulting in a useless error message.
> 
> Fix this using errno and moving the error printing closer to the only
> function populating it in this code path.
> 
> [...]

Here is the summary with links:
  - [iproute2] ipstats: fix message reporting error
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=995096d946cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



