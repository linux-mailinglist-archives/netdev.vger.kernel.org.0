Return-Path: <netdev+bounces-5308-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2226710B3E
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 13:40:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE4662814D6
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 387A6FC0A;
	Thu, 25 May 2023 11:40:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE9ADF52
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97FCFC4339B;
	Thu, 25 May 2023 11:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685014821;
	bh=u+NJSIQnL60LQGr9dkqnEEy4CU1ey6fkOe3wqBhgBgU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=a+dxj8Wb0ZJyeRsgQWWNi7ZVyzSPSbtYlhtEHx2fq6ILc4QNZvKIFEFX5/DlAAIay
	 vLBEyVzPNqn0vHDo8ir0N7abGtPYzA0qrLmMbIhG/KFxgJr7z8VqeQY5JpJrChk1Fg
	 4dnU+LPkv82O7yJHnXQIK1gkko5yq3RNIKdEjTH5mnxhRsqVHrR05J3Du+3cA2yQW7
	 bzukoJMk6loDuTao7MNJGyN1OkTKDw7IBMuBAOu07aU4JPZ5iRHaLmjrAciYdTs35E
	 rXgP5FHgb9oY63QqdMaaEbly6fyN7nKgGjhaZ04rClFwWVtbUEFY6Z/IrVMmCXCgUe
	 wOoDuf/g31f/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7E48CE21ECD;
	Thu, 25 May 2023 11:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] net: tcp: make txhash use consistent for IPv4
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168501482150.11061.12977720818758543959.git-patchwork-notify@kernel.org>
Date: Thu, 25 May 2023 11:40:21 +0000
References: <20230523161453.196094-1-atenart@kernel.org>
In-Reply-To: <20230523161453.196094-1-atenart@kernel.org>
To: Antoine Tenart <atenart@kernel.org>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, i.maximets@ovn.org,
 dceara@redhat.com

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 23 May 2023 18:14:50 +0200 you wrote:
> Hello,
> 
> Series is divided in two parts. First two commits make the txhash (used
> for the skb hash in TCP) to be consistent for all IPv4/TCP packets (IPv6
> doesn't have the same issue). Last commit improve a hash-related doc.
> 
> One example is when using OvS with dp_hash, which uses skb->hash, to
> select a path. We'd like packets from the same flow to be consistent, as
> well as the hash being stable over time when using net.core.txrehash=0.
> Same applies for kernel ECMP which also can use skb->hash.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] net: tcp: make the txhash available in TIME_WAIT sockets for IPv4 too
    https://git.kernel.org/netdev/net-next/c/4fbfde4e2720
  - [net-next,v2,2/3] net: ipv4: use consistent txhash in TIME_WAIT and SYN_RECV
    https://git.kernel.org/netdev/net-next/c/c0a8966e2bc7
  - [net-next,v2,3/3] Documentation: net: net.core.txrehash is not specific to listening sockets
    https://git.kernel.org/netdev/net-next/c/7016eb738651

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



