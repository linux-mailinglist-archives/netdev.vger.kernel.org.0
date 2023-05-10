Return-Path: <netdev+bounces-1378-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A3686FDA45
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:01:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B1232812E4
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4150820B4C;
	Wed, 10 May 2023 09:00:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635E765C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F351DC433A1;
	Wed, 10 May 2023 09:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683709223;
	bh=+CPM3S7zZwXBLc96px2hQXE/X0lzOfKXj3hkVrwpPRs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=J5cDiv98F+X+a77zc/69i7xvXPysxCgBa+SY/5s0H7p6LMjNVnWgzblM5wq/O9/JD
	 OUgXQ4HmMFTnapXjrGrgYYxGaGN4cPgEAmdwmP34tUZGNsdqPu6Ed0RGakFDjFK7NL
	 wxPxVal6cL1f8ZlEmKW2izz+R5tu5OB9pZw77ZNa5hTDzAFEHuCPLdsBs55LhQAMao
	 CtAsPMAYU3o9o2cYvCb/4mdcRiWaR6OSxSqq69x0eSeEMMKCYbo0DXCy6TiCmb99KS
	 MD6q648U7y/ol4QgDuRagPd+rjMSydUOEtrJVYEncsiz5x/GBdeOnmNU68GvdWqbWc
	 M4iJu0/P7mS2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B9166E26D21;
	Wed, 10 May 2023 09:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: ipconfig: Allow DNS to be overwritten by
 DHCPACK
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168370922275.25656.6144620974543793055.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 09:00:22 +0000
References: <20230508174446.55948-1-martin@wetterwald.eu>
In-Reply-To: <20230508174446.55948-1-martin@wetterwald.eu>
To: Martin Wetterwald <martin@wetterwald.eu>
Cc: kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
 dsahern@kernel.org, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon,  8 May 2023 19:44:47 +0200 you wrote:
> Some DHCP server implementations only send the important requested DHCP
> options in the final BOOTP reply (DHCPACK).
> One example is systemd-networkd.
> However, RFC2131, in section 4.3.1 states:
> 
> > The server MUST return to the client:
> > [...]
> > o Parameters requested by the client, according to the following
> >   rules:
> >
> >      -- IF the server has been explicitly configured with a default
> >         value for the parameter, the server MUST include that value
> >         in an appropriate option in the 'option' field, ELSE
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: ipconfig: Allow DNS to be overwritten by DHCPACK
    https://git.kernel.org/netdev/net-next/c/81ac2722fa19

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



