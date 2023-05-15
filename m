Return-Path: <netdev+bounces-2638-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A684702C5D
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:11:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 302B91C20B98
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:11:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70FFDC8C9;
	Mon, 15 May 2023 12:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD267C2FF
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D43CC4339B;
	Mon, 15 May 2023 12:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684152620;
	bh=knmX2hbyeuH2Fxmczb3rA1YEedMCegcc1TMU46kf35Y=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=IpzVY81XIXCAqf1P16YBk24AWZzK+0l6k41mnBgLSB0cNKcbAzlDdQfV4lXDRmVwh
	 cUeQL1uUrEpenLjI5rrrb1ADtbtDQbXXERsPQ8lqs6fQ+0AQ0AVE8llc4slbVJWOg2
	 u8+WDkk28GTSabyEO989a8vpVpZGhnpQAI2/Q4mfxeqRwXXQ1jstWxDKnYPgc4TE//
	 wpUQBM7oxCsDuUkegsVg3gUIGH48VLJqWpejaIEnth48gvu/zmdiAdLcDGnWi1QYNk
	 nZKJ2gkFDCr1nI9zH7QmJ2+n19oYl0TO5fvwexwvBRQlaTr5KpkniAOZB15u1nLixo
	 rKynv5ubO3lZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B251E5421D;
	Mon, 15 May 2023 12:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] nfc: llcp: fix possible use of uninitialized
 variable in nfc_llcp_send_connect()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168415262030.24388.6199183287824170155.git-patchwork-notify@kernel.org>
Date: Mon, 15 May 2023 12:10:20 +0000
References: <20230513115204.179437-1-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230513115204.179437-1-krzysztof.kozlowski@linaro.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, thierry.escande@collabora.com, sameo@linux.intel.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat, 13 May 2023 13:52:04 +0200 you wrote:
> If sock->service_name is NULL, the local variable
> service_name_tlv_length will not be assigned by nfc_llcp_build_tlv(),
> later leading to using value frmo the stack.  Smatch warning:
> 
>   net/nfc/llcp_commands.c:442 nfc_llcp_send_connect() error: uninitialized symbol 'service_name_tlv_length'.
> 
> Fixes: de9e5aeb4f40 ("NFC: llcp: Fix usage of llcp_add_tlv()")
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] nfc: llcp: fix possible use of uninitialized variable in nfc_llcp_send_connect()
    https://git.kernel.org/netdev/net-next/c/0d9b41daa590

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



