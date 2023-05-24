Return-Path: <netdev+bounces-4889-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01DFE70EFE5
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:51:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDED31C20BB9
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 07:51:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 967A8C152;
	Wed, 24 May 2023 07:50:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CC1C125
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A347DC4339C;
	Wed, 24 May 2023 07:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684914623;
	bh=+2t0Qbe3ybqnFYjlbeb0dWDOno6/bzR4tiDpBeeEBp4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=q0gPR8zPgBlHAdgMtc+DCHEPMkyjfbqBBITPaG8gsLI2lomg5QcVqwGLpPHUdqkyu
	 xVKtoyb++0MnJ7Gxyn6ofR0+39QOLSaP0khvLHT/VR8WxK+1DWw5i1i1WMKgoPLSVS
	 o4RMQWVnj6YAp+Xi39P9UTFFUEXcRy5EpLV0oiWJKkE5aALw+CikATdWpHZIhSBHn5
	 CNS3TH+vYqpCTpfU1Qjmk8VAKs4v2ZWwRGeBRiZcjl415UXbufovIZq4GRRKt2z+qc
	 91ooWxCALgkZ7RwXKGdFJHTJuWBwbfSiNJ1Yd64aBrhwwy5A/dtHQ13fpet4bnhIpP
	 SnNGWs4qL7hzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8CF67E21ECD;
	Wed, 24 May 2023 07:50:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] tools: ynl: Add byte-order support for struct
 members
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168491462357.4606.5439658550048074441.git-patchwork-notify@kernel.org>
Date: Wed, 24 May 2023 07:50:23 +0000
References: <20230523093748.61518-1-donald.hunter@gmail.com>
In-Reply-To: <20230523093748.61518-1-donald.hunter@gmail.com>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, donald.hunter@redhat.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 23 May 2023 10:37:46 +0100 you wrote:
> From: Donald Hunter <donald.hunter@redhat.com>
> 
> This patchset adds support to ynl for handling byte-order in struct
> members. The first patch is a refactor to use predefined Struct() objects
> instead of generating byte-order specific formats on the fly. The second
> patch adds byte-order handling for struct members.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] tools: ynl: Use dict of predefined Structs to decode scalar types
    https://git.kernel.org/netdev/net-next/c/7c2435ef76e5
  - [net-next,v2,2/2] tools: ynl: Handle byte-order in struct members
    https://git.kernel.org/netdev/net-next/c/bddd2e561b0a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



