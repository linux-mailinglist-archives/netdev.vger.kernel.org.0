Return-Path: <netdev+bounces-11285-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E8BE573269F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 07:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 906792813F8
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 05:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0308A3C;
	Fri, 16 Jun 2023 05:30:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8267C
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6EF4C433C9;
	Fri, 16 Jun 2023 05:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686893423;
	bh=r4MmrsvbionKD2QAyPaftFnsfjcVFtcE4wKGX9A+nyg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=rbNYM5iOqMZwA0fvSJKEHMPeMs+wOHMqX03lVuV5evWb2i2XECQKFLGniibVI3duN
	 IDRY9QXhQMJDO+DCS8HUZX8xAZSLz7i+tanQTlnpTgMtU14oIT43oTJNCcVA1ra1fS
	 U6RhX8GciNo+dzkPNx7ZlVizYl/mesE15VxoD4CQpfi8DHnYpXVN2Rs2J9zp9safBK
	 jPOZRsxPgS79jGir7MfDyV5JLUFVqI1pKvJaI3RHEtrEi+AK++Qr7fHCPew2eD1p7p
	 AwSOumVYrRQGyB1mFUb6FTjI2gOfMn/Y3NpFE4CTzilYmTj7+1K8By9HdWNQwVq1+F
	 aZKJEosZCpOmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C50DCC3274B;
	Fri, 16 Jun 2023 05:30:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 0/4] Check if FIPS mode is enabled when running selftests
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168689342279.5522.4120374614331476094.git-patchwork-notify@kernel.org>
Date: Fri, 16 Jun 2023 05:30:22 +0000
References: <20230613123222.631897-1-magali.lemes@canonical.com>
In-Reply-To: <20230613123222.631897-1-magali.lemes@canonical.com>
To: Magali Lemes <magali.lemes@canonical.com>
Cc: davem@davemloft.net, dsahern@gmail.com, edumazet@google.com,
 keescook@chromium.org, kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org,
 tianjia.zhang@linux.alibaba.com, vfedorenko@novek.ru,
 andrei.gherzan@canonical.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 13 Jun 2023 09:32:18 -0300 you wrote:
> Some test cases from net/tls, net/fcnal-test and net/vrf-xfrm-tests
> that rely on cryptographic functions to work and use non-compliant FIPS
> algorithms fail in FIPS mode.
> 
> In order to allow these tests to pass in a wider set of kernels,
>  - for net/tls, skip the test variants that use the ChaCha20-Poly1305
> and SM4 algorithms, when FIPS mode is enabled;
>  - for net/fcnal-test, skip the MD5 tests, when FIPS mode is enabled;
>  - for net/vrf-xfrm-tests, replace the algorithms that are not
> FIPS-compliant with compliant ones.
> 
> [...]

Here is the summary with links:
  - [v4,1/4] selftests/harness: allow tests to be skipped during setup
    https://git.kernel.org/netdev/net/c/372b304c1e51
  - [v4,2/4] selftests: net: tls: check if FIPS mode is enabled
    https://git.kernel.org/netdev/net/c/d113c395c67b
  - [v4,3/4] selftests: net: vrf-xfrm-tests: change authentication and encryption algos
    https://git.kernel.org/netdev/net/c/cb43c60e64ca
  - [v4,4/4] selftests: net: fcnal-test: check if FIPS mode is enabled
    https://git.kernel.org/netdev/net/c/d7a2fc1437f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



