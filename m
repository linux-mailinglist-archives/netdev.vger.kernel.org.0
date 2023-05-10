Return-Path: <netdev+bounces-1357-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DC0E6FD957
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:30:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 276B61C20CF2
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A6985692;
	Wed, 10 May 2023 08:30:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF8C14AA8
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0D490C4339B;
	Wed, 10 May 2023 08:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683707423;
	bh=UXWoljZxonZO2CWvaC5I6AsRcsIat3/ngnYrGjXlEEA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=WcPf3dPQ3gFeR9L0tigtDix2dCSetZ3NMSKdbsJKyzUoXM+vUwt8FcSmtYSpOyOBW
	 MEC7YsFWpBmNB8f6n/EXpfESD5gQEhmT2ZGaFvssBulBU/wlIznitDF7d0PcDRMh+S
	 e6TO0X3d0rzo2p4vm/Zpg2+sEk9ssCTUJzvnxZ0NP5ErER+nuaXxhWWhHUT/qn3Cm3
	 UA8RMWhAe0S74Yz/b/+7o77mJNw5dk4jrcC0lM3mMKwl/NdjNQnEPySOwK5G+w1Sqz
	 /BRemONXfOgYtJQL16TpyNMQTKQdfJzQZWAzzKBlC9o31/1taXw8HvH+RRPrIL/jKn
	 KBQ6W6Gsv4/uQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E45E6E26D2A;
	Wed, 10 May 2023 08:30:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 net 0/4] bonding: fix send_peer_notif overflow
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168370742292.8895.15776503512763284416.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 08:30:22 +0000
References: <20230509031200.2152236-1-liuhangbin@gmail.com>
In-Reply-To: <20230509031200.2152236-1-liuhangbin@gmail.com>
To: Hangbin Liu <liuhangbin@gmail.com>
Cc: netdev@vger.kernel.org, j.vosburgh@gmail.com, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, edumazet@google.com, liali@redhat.com,
 vincent@bernat.ch, simon.horman@corigine.com

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  9 May 2023 11:11:56 +0800 you wrote:
> Bonding send_peer_notif was defined as u8. But the value is
> num_peer_notif multiplied by peer_notif_delay, which is u8 * u32.
> This would cause the send_peer_notif overflow.
> 
> Before the fix:
> TEST: num_grat_arp (active-backup miimon num_grat_arp 10)           [ OK ]
> TEST: num_grat_arp (active-backup miimon num_grat_arp 20)           [ OK ]
> 4 garp packets sent on active slave eth1
> TEST: num_grat_arp (active-backup miimon num_grat_arp 30)           [FAIL]
> 24 garp packets sent on active slave eth1
> TEST: num_grat_arp (active-backup miimon num_grat_arp 50)           [FAIL]
> 
> [...]

Here is the summary with links:
  - [PATCHv3,net,1/4] bonding: fix send_peer_notif overflow
    https://git.kernel.org/netdev/net/c/9949e2efb54e
  - [PATCHv3,net,2/4] Documentation: bonding: fix the doc of peer_notif_delay
    https://git.kernel.org/netdev/net/c/84df83e0ecd3
  - [PATCHv3,net,3/4] selftests: forwarding: lib: add netns support for tc rule handle stats get
    https://git.kernel.org/netdev/net/c/b6d1599f8c28
  - [PATCHv3,net,4/4] kselftest: bonding: add num_grat_arp test
    https://git.kernel.org/netdev/net/c/6cbe791c0f4e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



