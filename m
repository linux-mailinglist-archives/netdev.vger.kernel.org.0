Return-Path: <netdev+bounces-9422-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF4E3728E26
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 04:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E3D4F1C21014
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 02:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ED991398;
	Fri,  9 Jun 2023 02:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372641386
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B08BCC4339C;
	Fri,  9 Jun 2023 02:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686279020;
	bh=9XE/aBLxnKMdqLDenhDeAhA38jTfuwn2mUKmq3kpYuc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ramFlwHe1u9ty3a8wUHHGozQS701/KPFr5HLCcvAHy4M3cFxDQEvWDck86B0eLCgN
	 tMbV4Np8l8g6MwChL13cCARkhoLjOnZZHYB8c/o2kz26AYNKLeIzIfche8q+grcihH
	 qKlHy5zZC7Dgakmwp9v08LOvIMIV7GB+NG9UQKezKu7yBTZrtjhNXOxOC+WODwHWgx
	 QV5iz3Yqsb3k0DJFYbSh6+wLpYJYox09sX4H7hdQW+fbATXNT1FQC2bcPUNIHbRL+1
	 EpQ/CwE1lIGd7peiZ3Ft8rEViiGRtlxnS+F0nG375nkCc1gCnpnaG2Qw0TvEn1G8jg
	 fr4GX7T/pAR4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 91EBCE4D030;
	Fri,  9 Jun 2023 02:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] igb: Fix extts capture value format for 82580/i354/i350
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168627902059.16434.12226841821081359803.git-patchwork-notify@kernel.org>
Date: Fri, 09 Jun 2023 02:50:20 +0000
References: <20230607164116.3768175-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230607164116.3768175-1-anthony.l.nguyen@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, eggcar.luan@gmail.com,
 kernel.hbk@gmail.com, richardcochran@gmail.com, jacob.e.keller@intel.com,
 himasekharx.reddy.pucha@intel.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  7 Jun 2023 09:41:16 -0700 you wrote:
> From: Yuezhen Luan <eggcar.luan@gmail.com>
> 
> 82580/i354/i350 features circle-counter-like timestamp registers
> that are different with newer i210. The EXTTS capture value in
> AUXTSMPx should be converted from raw circle counter value to
> timestamp value in resolution of 1 nanosec by the driver.
> 
> [...]

Here is the summary with links:
  - [net] igb: Fix extts capture value format for 82580/i354/i350
    https://git.kernel.org/netdev/net/c/6292d7436cf2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



