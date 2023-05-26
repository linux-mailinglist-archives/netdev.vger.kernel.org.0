Return-Path: <netdev+bounces-5653-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D37AA71255F
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:20:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60D392816BE
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:20:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C4E742EB;
	Fri, 26 May 2023 11:20:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDAA742E5
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 11:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2BBD3C4339C;
	Fri, 26 May 2023 11:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685100020;
	bh=/iFbHvI1F44N2/kQ8LmYj9oanMdiRvrW6PzFHCnZioQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=I0u5SEJzDATXNqjU+xWPztw68Wz+JVaLjDs3JECtHJm6kDKUrIY3I1/VBNwvY5Mm3
	 rOXQpbsfHGrYYfM2R2ho1lOnuzXsw1GiYsSyrzkfFmjeGbONSlGXewPkEu1VQgA+fP
	 uYteniyn7Bci3k3kXsiFL0b8WtJ+Qc4fSSHg9tgzslwOITYhWW2lkuIuWdTlZSxFAd
	 8N78rHlmvPQ+0n16aBJ6Z1fIa94rQcRH05naE4S7WJruqOaSA4eFM+nuawhCfJWbed
	 Tg00Ikek9mUkQsJlgve7Y5WaR9DN+ouzaVxJ3b2QlMsGckCOmlNdgup0wPB3HWsmMM
	 VhhGfo5a1CXWg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 170AEE4D00E;
	Fri, 26 May 2023 11:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: phy: broadcom: Register dummy IRQ handler
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168510002008.13772.7984718177310797518.git-patchwork-notify@kernel.org>
Date: Fri, 26 May 2023 11:20:20 +0000
References: <20230525175916.3550997-1-florian.fainelli@broadcom.com>
In-Reply-To: <20230525175916.3550997-1-florian.fainelli@broadcom.com>
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: netdev@vger.kernel.org, doug.berger@broadcom.com,
 bcm-kernel-feedback-list@broadcom.com, andrew@lunn.ch, hkallweit1@gmail.com,
 linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, simon.horman@corigine.com,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 25 May 2023 10:59:15 -0700 you wrote:
> In order to have our interrupt descriptor fully setup and in particular
> the action, ensure that we register a full fledged interrupt handler.
> This also allow us to set the interrupt polarity and flow through the
> same call.
> 
> This is specifically necessary for kernel/irq/pm.c::suspend_device_irq
> to set the interrupt descriptor to the IRQD_WAKEUP_ARMED state and
> enable the interrupt for wake-up since it was still in a disabled state.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: phy: broadcom: Register dummy IRQ handler
    https://git.kernel.org/netdev/net-next/c/4781e965e655

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



