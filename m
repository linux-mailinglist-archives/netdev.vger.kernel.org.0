Return-Path: <netdev+bounces-1995-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1099F6FFE47
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 03:10:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4E972817AA
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF7E939D;
	Fri, 12 May 2023 01:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D827F0
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 01:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F742C4339B;
	Fri, 12 May 2023 01:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683853821;
	bh=O6DIk8+nqvg238LCXy1SDs0FU+DW//DHdImCvTlHupw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=X4xYdP2NdAioZg7jHQAvx8lr0+/5LX1hy+aG5ypfIxGFUclLPnOe1q8D+kI7o42Bw
	 7jFlIupkXoWX6HCWcgFdXfYNyfFC5hJvQle40i2gRoNunejgPLVWuhrvZSPAJzhPeJ
	 7q3g1n31cxZabIT2IeBjPDAUANzu//rb3QGPVX1O1eWhZsmBjUlsXUR4BxX4ejGf/r
	 wjyOy3JpOg0kPCK9Jsv5d5p6PBC/4opv5uzKwzSvi6GePwDhxRoVFYgPMVs8iqg6jN
	 6bNUqzY9xL23xQ+A4MoDIe/0tu0FXVGZ2M7UsMlYF2u2u3u/8AtnwK0qNgauWQHD3Y
	 DgKpNQngkkJJQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 753B1E270C4;
	Fri, 12 May 2023 01:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 0/2] selftests: seg6: make srv6_end_dt4_l3vpn_test more robust
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168385382147.13567.8508818014030321805.git-patchwork-notify@kernel.org>
Date: Fri, 12 May 2023 01:10:21 +0000
References: <20230510111638.12408-1-andrea.mayer@uniroma2.it>
In-Reply-To: <20230510111638.12408-1-andrea.mayer@uniroma2.it>
To: Andrea Mayer <andrea.mayer@uniroma2.it>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, dsahern@kernel.org, shuah@kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, stefano.salsano@uniroma2.it,
 paolo.lungaroni@uniroma2.it, ahabdels.dev@gmail.com, liuhangbin@gmail.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 10 May 2023 13:16:36 +0200 you wrote:
> This pachset aims to improve and make more robust the selftests performed to
> check whether SRv6 End.DT4 beahvior works as expected under different system
> configurations.
> Some Linux distributions enable Deduplication Address Detection and Reverse
> Path Filtering mechanisms by default which can interfere with SRv6 End.DT4
> behavior and cause selftests to fail.
> 
> [...]

Here is the summary with links:
  - [net,1/2] selftests: seg6: disable DAD on IPv6 router cfg for srv6_end_dt4_l3vpn_test
    https://git.kernel.org/netdev/net/c/21a933c79a33
  - [net,2/2] selftets: seg6: disable rp_filter by default in srv6_end_dt4_l3vpn_test
    https://git.kernel.org/netdev/net/c/f97b8401e0de

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



