Return-Path: <netdev+bounces-6281-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 017F471580B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 514BA1C20B84
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 08:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D599112B6D;
	Tue, 30 May 2023 08:10:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60DA125CC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 08:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5843FC4339B;
	Tue, 30 May 2023 08:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685434220;
	bh=wP/OUCblEiuLbp6g1irH70e9sSm6nSIGbaKASk5qUCY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=REiUkh4fn3b38tHn3HqR3yXrY3plxwsafqP/SbClBKN71aw4AfiYts/Z0R1pZxVTq
	 YJmWveqNL01TgB2hClQlKUi2UJZRL1X0AfIc7PfU+95D2K0ZyQqTyM7RD/8GBD8/nX
	 M6aXoIreVmRQEkc5UW0ZKvy9GnQhGdrDYUwy7O8q8IltxswPDe4CldDrIt5Q4qU7Yx
	 BynDqXmUgSCGU5D+igQu7/tevyas67TnfRO0icXoPoDUhfTf/l40OcHf8vNLUcMCIJ
	 +XCW1Mi1+n5/iXliudzlx/0ZvhpqMVXOIlSzR7V+aCzXkDws6VZafwxvSLvK0QttIG
	 L68CIvZOFnvCw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3883FE52C02;
	Tue, 30 May 2023 08:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rxrpc: Truncate UTS_RELEASE for rxrpc version 
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168543422022.28448.2604307451072571667.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 08:10:20 +0000
References: <654974.1685100894@warthog.procyon.org.uk>
In-Reply-To: <654974.1685100894@warthog.procyon.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, Kenny.Ho@amd.com, marc.dionne@auristor.com,
 andrew@lunn.ch, David.Laight@ACULAB.COM, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 26 May 2023 12:34:54 +0100 you wrote:
> UTS_RELEASE has a maximum length of 64 which can cause rxrpc_version to
> exceed the 65 byte message limit.
> 
> Per the rx spec[1]: "If a server receives a packet with a type value of 13,
> and the client-initiated flag set, it should respond with a 65-byte payload
> containing a string that identifies the version of AFS software it is
> running."
> 
> [...]

Here is the summary with links:
  - [net] rxrpc: Truncate UTS_RELEASE for rxrpc version
    https://git.kernel.org/netdev/net/c/020c69c1a793

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



