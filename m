Return-Path: <netdev+bounces-9945-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 49C4A72B3E8
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 22:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FCF128114C
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 20:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9186B107B4;
	Sun, 11 Jun 2023 20:10:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1608F2CAB
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 20:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8848CC4339B;
	Sun, 11 Jun 2023 20:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686514219;
	bh=kxItdV2xrsIwVRSmOAfsIMjWriPh99MIZwn1F5ZwZF8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ZevjjO+Nf8TtlDJhSLvOz4DyPMdocF3FHMGZx6GsYQTMtjfvtYYx/Do446ZH+CgBE
	 G3//426I3HFJcjyUm4nbnnzCa5d2ZiHzW+bEI5i8ueLLJYatWplLv04H/LhViN8IE2
	 OtFZthU3svUD5POde4Gjrvb79oozkKGM1ZmgBxij6zR6xrGqC1oC8b2Ny/z269b3PG
	 rxHof8ax0P4+MqGE9khr2h+dWd73iU0odAQtKO6j7y/m0x+mrA3khL76ZxInjBP8m7
	 tn1HNJ7b/+DJvL5hcod7C2FwmkPe3QiXKJIYDX1JBAPI64/0FayuKV5yO5/xJ+T8kB
	 GflBQVHmn7uSg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6BFEFC43143;
	Sun, 11 Jun 2023 20:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] selftests: net: vxlan: Fix selftest regression
 after changes in iproute2.
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168651421943.22537.15519197522384035626.git-patchwork-notify@kernel.org>
Date: Sun, 11 Jun 2023 20:10:19 +0000
References: <20230608064448.2437-1-vladimir@nikishkin.pw>
In-Reply-To: <20230608064448.2437-1-vladimir@nikishkin.pw>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
 gnault@redhat.com, razor@blackwall.org, idosch@nvidia.com,
 liuhangbin@gmail.com, eyal.birger@gmail.com, jtoppins@redhat.com,
 shuah@kernel.org, linux-kselftest@vger.kernel.org, stephen@networkplumber.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  8 Jun 2023 14:44:48 +0800 you wrote:
> The iproute2 output that eventually landed upstream is different than
> the one used in this test, resulting in failures. Fix by adjusting the
> test to use iproute2's JSON output, which is more stable than regular
> output.
> 
> Fixes: 305c04189997 ("selftests: net: vxlan: Add tests for vxlan nolocalbypass option.")
> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] selftests: net: vxlan: Fix selftest regression after changes in iproute2.
    https://git.kernel.org/netdev/net-next/c/26a4dd839eeb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



