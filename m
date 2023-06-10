Return-Path: <netdev+bounces-9849-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B01F72AE54
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 21:12:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B96351C20AC9
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 19:12:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DB58C8F6;
	Sat, 10 Jun 2023 19:12:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5C320684
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 19:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23661C433D2;
	Sat, 10 Jun 2023 19:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686424348;
	bh=MnsFWRXlDOpNeOfrRaLfHEX8hGlKa+XhJ7sR/IyaEcg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=hBqldKsToM4vwuBKc2rZNUZT6IVkm+cpN8e63BKu1vKEC+t/TKo7qHPiFOQ/+zUIZ
	 5NFG3c+b2njXJSIMAVJ9CZSI2tQncmOzks8rj8477QYVqfuF2qTafpA12NL4m4RJGM
	 OtOYwZy/F8DaOlte+eX/1yLEpMA2HywQtsjBpjIxl+dERPlIPBP1aa09dhlL99dmQJ
	 JyDt/48WUyTPP6EZgPakDN8XTwTfrrWJTlyoE88cfWzPog/Lx3hyT73kf4pA/kIfqz
	 Jfllwabowm10fIfSKdq1oUaygLyY1tEH2WioZV1A6IOxx3xELYmRVDLukemuxnhtoD
	 7cFmJZJk4FAhw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 050CAC395F3;
	Sat, 10 Jun 2023 19:12:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nf_tables: integrate pipapo into commit
 protocol
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168642434801.30474.1571791241057313404.git-patchwork-notify@kernel.org>
Date: Sat, 10 Jun 2023 19:12:28 +0000
References: <20230608195706.4429-2-pablo@netfilter.org>
In-Reply-To: <20230608195706.4429-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu,  8 Jun 2023 21:57:04 +0200 you wrote:
> The pipapo set backend follows copy-on-update approach, maintaining one
> clone of the existing datastructure that is being updated. The clone
> and current datastructures are swapped via rcu from the commit step.
> 
> The existing integration with the commit protocol is flawed because
> there is no operation to clean up the clone if the transaction is
> aborted. Moreover, the datastructure swap happens on set element
> activation.
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: nf_tables: integrate pipapo into commit protocol
    https://git.kernel.org/netdev/net/c/212ed75dc5fb
  - [net,2/3] netfilter: nfnetlink: skip error delivery on batch in case of ENOMEM
    https://git.kernel.org/netdev/net/c/a1a64a151dae
  - [net,3/3] netfilter: nf_tables: incorrect error path handling with NFT_MSG_NEWRULE
    https://git.kernel.org/netdev/net/c/1240eb93f061

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



