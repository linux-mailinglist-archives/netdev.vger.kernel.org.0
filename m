Return-Path: <netdev+bounces-4685-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 623B370DDEC
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D1F2281304
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17C391EA9C;
	Tue, 23 May 2023 13:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE0B4A85A
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77D66C433EF;
	Tue, 23 May 2023 13:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684849819;
	bh=sxTiIAaLgwzPwBjNdyaOUpP5ixPNGf4rUtL+qfK4kVM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=COwpi6JNvRmoSTQfTcPoGrJTxp8KiWZs8YEiF440hFMoO0CbnFEVvde3qCeFSVboX
	 zrsHVqqAwtLerDdjq5M0Nezsv4Ir/JzWBfHMem7tmgtzD2dUbF/oIRsiIIL52d9XQu
	 jlvDr2Cy7uIUrVE+udBrrsMZslN7CpKx4JDt0ZLEYGpzMyZBVA8q2y4jWmiBwbEw2d
	 jbfgTRhvWZi/9fRNQLBzLX8XYVaHLb43iY1bvV/D6jWlE3IT7ysogyzPMMKNCvkPUr
	 SkFuRrK+ur/xmNcnwHYD5Ma7meZcGxOnHQKCGrriNHzYlOAZMvtgH8c4EDMIn8RDQH
	 93cqThO9Ek4PQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5DE1AE22B06;
	Tue, 23 May 2023 13:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] ipv{4,6}/raw: fix output xfrm lookup wrt protocol
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168484981938.29246.10376121993213737020.git-patchwork-notify@kernel.org>
Date: Tue, 23 May 2023 13:50:19 +0000
References: <20230522120820.1319391-1-nicolas.dichtel@6wind.com>
In-Reply-To: <20230522120820.1319391-1-nicolas.dichtel@6wind.com>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, dsahern@kernel.org, klassert@kernel.org,
 netdev@vger.kernel.org, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 22 May 2023 14:08:20 +0200 you wrote:
> With a raw socket bound to IPPROTO_RAW (ie with hdrincl enabled), the
> protocol field of the flow structure, build by raw_sendmsg() /
> rawv6_sendmsg()),  is set to IPPROTO_RAW. This breaks the ipsec policy
> lookup when some policies are defined with a protocol in the selector.
> 
> For ipv6, the sin6_port field from 'struct sockaddr_in6' could be used to
> specify the protocol. Just accept all values for IPPROTO_RAW socket.
> 
> [...]

Here is the summary with links:
  - [net,v2] ipv{4,6}/raw: fix output xfrm lookup wrt protocol
    https://git.kernel.org/netdev/net/c/3632679d9e4f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



