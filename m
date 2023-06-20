Return-Path: <netdev+bounces-12217-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E575A736C19
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:40:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96E40281227
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 12:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA91C101F9;
	Tue, 20 Jun 2023 12:40:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022CA1FA1
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 12:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77AFCC433C9;
	Tue, 20 Jun 2023 12:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687264823;
	bh=YZHfMq2+jE29no30sjmNvnq+ySZsu7Yhlr+608D3LMA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=lm47Bb/FxHeZfjkNnjOHyWRqUe6KpXQXzmS/6uI/z303XArIDSleL/aJ07dGSLStn
	 yDIAXRm7TZgU7TMzOMpRzNT63BaeJrz9SG3KG65b/Y41kjGOkUYPqDtuhEWXS9SRh8
	 CNVnIjL/5quK7RYg2KqODp1g3QGQzuyL8/DAA7bH+dWtL6ZiCU+oCO50GkswQyLvKS
	 hZgBFmczjFsq/CQFWKNhp9bHg7uUyAMiONRFxMuLwFRQxeCi2YRnLgbbwCBfqvR3uj
	 k16kuM4lnDs75Vw6SXgkC6C5GA9VNNDVxDjYzF4QdBRUk6+o2MoVG66/xvVjHUZ22r
	 QJPVBXCZ07tRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5EBEDC395C7;
	Tue, 20 Jun 2023 12:40:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v6 0/6] net: dsa: mt7530: fix multiple CPU ports,
 BPDU and LLDP handling
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168726482338.31923.2814815946421844984.git-patchwork-notify@kernel.org>
Date: Tue, 20 Jun 2023 12:40:23 +0000
References: <20230617062649.28444-1-arinc.unal@arinc9.com>
In-Reply-To: <20230617062649.28444-1-arinc.unal@arinc9.com>
To: =?utf-8?b?QXLEsW7DpyDDnE5BTCA8YXJpbmM5LnVuYWxAZ21haWwuY29tPg==?=@codeaurora.org
Cc: arinc.unal@arinc9.com, daniel@makrotopia.org, Landen.Chao@mediatek.com,
 dqfext@gmail.com, sean.wang@mediatek.com, andrew@lunn.ch,
 f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
 linux@armlinux.org.uk, landen.chao@mediatek.com, frank-w@public-files.de,
 bartel.eerdekens@constell8.be, mithat.guner@xeront.com,
 erkin.bozoglu@xeront.com, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat, 17 Jun 2023 09:26:43 +0300 you wrote:
> Hi.
> 
> This patch series fixes all non-theoretical issues regarding multiple CPU
> ports and the handling of LLDP frames and BPDUs.
> 
> I am adding me as a maintainer, I've got some code improvements on the way.
> I will keep an eye on this driver and the patches submitted for it in the
> future.
> 
> [...]

Here is the summary with links:
  - [net,v6,1/6] net: dsa: mt7530: set all CPU ports in MT7531_CPU_PMAP
    https://git.kernel.org/netdev/net/c/ff221029a51f
  - [net,v6,2/6] net: dsa: mt7530: fix trapping frames on non-MT7621 SoC MT7530 switch
    https://git.kernel.org/netdev/net/c/4ae90f90e490
  - [net,v6,3/6] net: dsa: mt7530: fix handling of BPDUs on MT7530 switch
    https://git.kernel.org/netdev/net/c/d7c660735593
  - [net,v6,4/6] net: dsa: mt7530: fix handling of LLDP frames
    https://git.kernel.org/netdev/net/c/8332cf6fd7c7
  - [net,v6,5/6] net: dsa: introduce preferred_default_local_cpu_port and use on MT7530
    https://git.kernel.org/netdev/net/c/b79d7c14f480
  - [net,v6,6/6] MAINTAINERS: add me as maintainer of MEDIATEK SWITCH DRIVER
    https://git.kernel.org/netdev/net/c/94d12d88b4a8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



