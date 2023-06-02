Return-Path: <netdev+bounces-7304-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E90A871F973
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 06:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72B4B1C211C9
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D520223404;
	Fri,  2 Jun 2023 04:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A563D10F6
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 04:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0FAF2C433EF;
	Fri,  2 Jun 2023 04:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685681420;
	bh=nxetWMwym22r3Da4wkbaXrkCtXnbLkInvpg0/XMvFo8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=VPlAUzeUXhEfS8NNUZpwF4mSXRi2HO5IBa6294KFiOMF1Mo1D1ov7riuzoiAaEPul
	 WIciGZ7Cg+ieIrblvlQ5YJocRkyYqxYYsbAzyjFPsp9r7FfIs5in9GL1WHWafKDukR
	 e6nFYNCfVEl2/mBxCJJAifkMz8Iy/gPjH+b1SG9cA4bYcOpVi3OsJ8DZlenC5MSha7
	 fb9scydjG4ikAI25UJ+4U16/lHXyAaaZT6TthXWzANRjLQTHNwYQipuDFvrV0Q8CfU
	 d3bH1qORg8+3u7fjgk5bjJVeh/QZO9LLOiBqHM6KKcYnUlDiTNhALnDT8llwJUvkw4
	 p+5EF4d0OHa8A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E5339E52BF5;
	Fri,  2 Jun 2023 04:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: lan9303: allow vid != 0 in port_fdb_{add|del}
 methods
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168568141993.21492.6855399273666602310.git-patchwork-notify@kernel.org>
Date: Fri, 02 Jun 2023 04:50:19 +0000
References: <20230531143826.477267-1-alexander.sverdlin@siemens.com>
In-Reply-To: <20230531143826.477267-1-alexander.sverdlin@siemens.com>
To: Sverdlin@codeaurora.org,
	Alexander <alexander.sverdlin@siemens.com>
Cc: netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
 f.fainelli@gmail.com, linux-kernel@vger.kernel.org, privat@egil-hjelmeland.no

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 31 May 2023 16:38:26 +0200 you wrote:
> From: Alexander Sverdlin <alexander.sverdlin@siemens.com>
> 
> LAN9303 doesn't associate FDB (ALR) entries with VLANs, it has just one
> global Address Logic Resolution table [1].
> 
> Ignore VID in port_fdb_{add|del} methods, go on with the global table. This
> is the same semantics as hellcreek or RZ/N1 implement.
> 
> [...]

Here is the summary with links:
  - net: dsa: lan9303: allow vid != 0 in port_fdb_{add|del} methods
    https://git.kernel.org/netdev/net/c/5a59a58ec25d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



