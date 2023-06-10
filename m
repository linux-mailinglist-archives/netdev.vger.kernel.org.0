Return-Path: <netdev+bounces-9791-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7483872A9BA
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 09:12:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FA072819BA
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 07:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8311E79C6;
	Sat, 10 Jun 2023 07:12:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2D879C1;
	Sat, 10 Jun 2023 07:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 973FCC4339B;
	Sat, 10 Jun 2023 07:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686381133;
	bh=K3Igb5YMWK6KPdrjSVblOoG6UAOBqAV7a08r3ShDDlI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=IQ7t6lO0VH0WLXPmmd/2BtTQFbjyqKPpmE2p6wL4TZy3ZaSl5W0too1n06LM7EOj6
	 cvJvXyqILXnqz6AFieTOeXMRWvej7bH/Psy5n7hldJLsqvCOnoPqhMNiL78u00aTep
	 FiUmD1nLAKTI4Y0SMconXCUnI1VsG1SQOimAdwEC24pyshMPrYed2Cb01xL7YiCCao
	 V0UoE4KSLRs97MokVIs95wYe/4/AfMOjDSv+I752JLsTSGJ2m48S3cy9apXHHPtn0r
	 Eu2wrAXfn5y/S8Mki0SSphR5IiUTXHRWwDfdCvlZvnzQR9gmbLKH+6fZ7piF/8fonF
	 LmukqB72tqz8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 63D3DE1CF31;
	Sat, 10 Jun 2023 07:12:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 00/14] selftests: mptcp: skip tests not supported by
 old kernels (part 2)
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168638113340.4960.10867122127600688062.git-patchwork-notify@kernel.org>
Date: Sat, 10 Jun 2023 07:12:13 +0000
References: <20230608-upstream-net-20230608-mptcp-selftests-support-old-kernels-part-2-v1-0-20997a6fd841@tessares.net>
In-Reply-To: <20230608-upstream-net-20230608-mptcp-selftests-support-old-kernels-part-2-v1-0-20997a6fd841@tessares.net>
To: Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: mptcp@lists.linux.dev, martineau@kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org,
 dcaratti@redhat.com, dmytro@shytyi.net, imagedong@tencent.com,
 geliang.tang@suse.com, kishen.maloor@intel.com, fw@strlen.de,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 08 Jun 2023 18:38:42 +0200 you wrote:
> After a few years of increasing test coverage in the MPTCP selftests, we
> realised [1] the last version of the selftests is supposed to run on old
> kernels without issues.
> 
> Supporting older versions is not that easy for this MPTCP case: these
> selftests are often validating the internals by checking packets that
> are exchanged, when some MIB counters are incremented after some
> actions, how connections are getting opened and closed in some cases,
> etc. In other words, it is not limited to the socket interface between
> the userspace and the kernelspace.
> 
> [...]

Here is the summary with links:
  - [net,01/14] selftests: mptcp: lib: skip if missing symbol
    https://git.kernel.org/netdev/net/c/673004821ab9
  - [net,02/14] selftests: mptcp: connect: skip transp tests if not supported
    https://git.kernel.org/netdev/net/c/07bf49401909
  - [net,03/14] selftests: mptcp: connect: skip disconnect tests if not supported
    https://git.kernel.org/netdev/net/c/4ad39a42da2e
  - [net,04/14] selftests: mptcp: connect: skip TFO tests if not supported
    https://git.kernel.org/netdev/net/c/06b03083158e
  - [net,05/14] selftests: mptcp: diag: skip listen tests if not supported
    https://git.kernel.org/netdev/net/c/dc97251bf0b7
  - [net,06/14] selftests: mptcp: diag: skip inuse tests if not supported
    https://git.kernel.org/netdev/net/c/dc93086aff04
  - [net,07/14] selftests: mptcp: pm nl: remove hardcoded default limits
    https://git.kernel.org/netdev/net/c/2177d0b08e42
  - [net,08/14] selftests: mptcp: pm nl: skip fullmesh flag checks if not supported
    https://git.kernel.org/netdev/net/c/f3761b50b8e4
  - [net,09/14] selftests: mptcp: sockopt: relax expected returned size
    https://git.kernel.org/netdev/net/c/8dee6ca2ac1e
  - [net,10/14] selftests: mptcp: sockopt: skip getsockopt checks if not supported
    https://git.kernel.org/netdev/net/c/c6f7eccc5198
  - [net,11/14] selftests: mptcp: sockopt: skip TCP_INQ checks if not supported
    https://git.kernel.org/netdev/net/c/b631e3a4e94c
  - [net,12/14] selftests: mptcp: userspace pm: skip if 'ip' tool is unavailable
    https://git.kernel.org/netdev/net/c/723d6b9b1233
  - [net,13/14] selftests: mptcp: userspace pm: skip if not supported
    https://git.kernel.org/netdev/net/c/f90adb033891
  - [net,14/14] selftests: mptcp: userspace pm: skip PM listener events tests if unavailable
    https://git.kernel.org/netdev/net/c/626cb7a5f6b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



