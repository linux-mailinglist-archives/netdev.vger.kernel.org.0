Return-Path: <netdev+bounces-10594-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 50F0B72F3FA
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 07:10:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FE06281038
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 05:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 780CDA50;
	Wed, 14 Jun 2023 05:10:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1741D361
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 05:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 69B9BC433C9;
	Wed, 14 Jun 2023 05:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686719429;
	bh=3sGXZ7z/sPBpvq2al6Aj5QjOXMcMqKujVylOzPVS6vc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=guuaC5aCF2wnDhF6gJwiexTISGqMnPyqKBzb+Y5JEsnTlBgbMSRgmWWIViks5MEKc
	 MeXCB2sFVnDWf2WTKU73orddYlvFzXVAtsCFJyHEpHBfuwHZuSsUgbPw6kL/esuc45
	 JauRrUx4Gfpzb0UDrf4/cbZhvgkAhrJWkYl/ocVNiuN+vgaWiTIoYdvddezdMfN/6d
	 OjpPKiBVcqnbIJaIyBU6Iy4H4A9Ue/HuJPPoSiv0cGSRaZOE8amZQNPBahTa/EF0MC
	 A2DfDQlCZSpRAp7mSkIRNltBaJlU2K5LShMhcngknaJc2VdxKV0vkIGH/gnq9OW+wJ
	 +aneJ5OcpsgmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2750BC3274C;
	Wed, 14 Jun 2023 05:10:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethtool: ioctl: account for sopass diff in set_wol
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168671942914.26522.8914520829149345552.git-patchwork-notify@kernel.org>
Date: Wed, 14 Jun 2023 05:10:29 +0000
References: <1686605822-34544-1-git-send-email-justin.chen@broadcom.com>
In-Reply-To: <1686605822-34544-1-git-send-email-justin.chen@broadcom.com>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew@lunn.ch, d-tatianin@yandex-team.ru, marco@mebeim.net,
 mailhol.vincent@wanadoo.fr, korotkov.maxim.s@gmail.com, gal@nvidia.com,
 jiri@resnulli.us, kuniyu@amazon.com, simon.horman@corigine.com,
 florian.fainelli@broadcom.com, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 12 Jun 2023 14:37:00 -0700 you wrote:
> sopass won't be set if wolopt doesn't change. This means the following
> will fail to set the correct sopass.
> ethtool -s eth0 wol s sopass 11:22:33:44:55:66
> ethtool -s eth0 wol s sopass 22:44:55:66:77:88
> 
> Make sure we call into the driver layer set_wol if sopass is different.
> 
> [...]

Here is the summary with links:
  - [net-next] ethtool: ioctl: account for sopass diff in set_wol
    https://git.kernel.org/netdev/net-next/c/2bddad9ec65a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



