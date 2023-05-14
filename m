Return-Path: <netdev+bounces-2402-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 122E9701B28
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 04:20:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A42921C20A4A
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 02:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CA531112;
	Sun, 14 May 2023 02:20:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F0E10E3
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 02:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9882DC433EF;
	Sun, 14 May 2023 02:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684030821;
	bh=GTAUYG+VfFiVHfEz+Cq/X+hiK55+UhtiQw6kntpGHZk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=LDINGk/o7bY3S7ygWCI7K89BuhTojrjj/Axkf03uf4Z7l2GqXNvO7iBYt0b3TEts8
	 SXE4TukvWj+1vopyZdqzX11CJRaXfOy7C8MFrstPd5J4uT5r3eA5/AC8HDZM/+r1cj
	 KRAKwY7VkuxlYMk1qJ4aHgVGaQL5wdz0PdClnB9jxKoTpsPJJ40bJRdEyPhjQu30R7
	 zROoIzik/UKTDWyrh5qSssA2lx2vM+3lhlWPxwb4/egUKG5AjkpYbdexCJS5ltxuev
	 BzDECzwKuVuCZqRkoG2OX5wziR90n0EYBb7gfzagPhHREPeYRHi7TeRJuPT47pse+J
	 YYTOgerEYeKbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 77700E270C2;
	Sun, 14 May 2023 02:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2 00/11] fix analyzer warnings
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168403082148.25388.12692487341186294291.git-patchwork-notify@kernel.org>
Date: Sun, 14 May 2023 02:20:21 +0000
References: <20230509212125.15880-1-stephen@networkplumber.org>
In-Reply-To: <20230509212125.15880-1-stephen@networkplumber.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Tue,  9 May 2023 14:21:14 -0700 you wrote:
> Address some (but not all) of the issues reported by gcc 13
> new analyzer.  These are mostly just issues like not checking
> for malloc() failure.
> 
> Stephen Hemminger (11):
>   lib/fs: fix file leak in task_get_name
>   ipmaddr: fix dereference of NULL on malloc() failure
>   iproute_lwtunnel: fix possible use of NULL when malloc() fails
>   tc_filter: fix unitialized warning
>   tc_util fix unitialized warning
>   tc_exec: don't dereference NULL on calloc failure
>   m_action: fix warning of overwrite of const string
>   netem: fix NULL deref on allocation failure
>   nstat: fix potential NULL deref
>   rdma/utils: fix some analyzer warnings
>   tc/prio: handle possible truncated kernel response
> 
> [...]

Here is the summary with links:
  - [iproute2,01/11] lib/fs: fix file leak in task_get_name
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=9f0fe8ee0900
  - [iproute2,02/11] ipmaddr: fix dereference of NULL on malloc() failure
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=8cda7a24a971
  - [iproute2,03/11] iproute_lwtunnel: fix possible use of NULL when malloc() fails
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=fa44c2d6f1da
  - [iproute2,04/11] tc_filter: fix unitialized warning
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=c73a41054638
  - [iproute2,05/11] tc_util fix unitialized warning
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=c9c1c9d59a6c
  - [iproute2,06/11] tc_exec: don't dereference NULL on calloc failure
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=0b9b9d659880
  - [iproute2,07/11] m_action: fix warning of overwrite of const string
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=b134c2c34458
  - [iproute2,08/11] netem: fix NULL deref on allocation failure
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=6c266d7c22a8
  - [iproute2,09/11] nstat: fix potential NULL deref
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=d348d1d6466a
  - [iproute2,10/11] rdma/utils: fix some analyzer warnings
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=33722349feb9
  - [iproute2,11/11] tc/prio: handle possible truncated kernel response
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=c90d25e96b01

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



