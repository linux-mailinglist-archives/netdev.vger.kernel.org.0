Return-Path: <netdev+bounces-2366-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9390F701830
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 18:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C49842819DA
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 16:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2419A6FA8;
	Sat, 13 May 2023 16:30:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA6B2583
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 16:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B5DDC4339C;
	Sat, 13 May 2023 16:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683995421;
	bh=Rm1B/Tz+qEEuzzgM/Dcy1wNsz3PFzjdL0rMTDxR3Y/o=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=XG09ILYUmOfqlLRnYrSBcPvN6b1ak51XidSLs05b4AuoOuq+vS8wv/McSW5muA75X
	 lvs5IPm4e7whMu3ecGTmJfJXF9wqRnJ5TFpaS7hwsav0x/j2tABSGHmZoEWpcOmJCi
	 UOH/WPE/1YsbeXYc4nWnzPN8po7ivjhhV2FbNkl7jRIb4tz48Z3YjMnQJnXUfwrvsM
	 v7n+wlW3rf/7MrdRc6wrsNIwR5femu2uI63X2jrTRVrXu5AfgTqM/jkp1x+MAasrOg
	 pAnFJTaZC6JDNK1IEWlhz/qqDplobwqMzZVxKz3zn1F6OShdK5rH9k8geQd7McV27p
	 tGxO21HbBqqlg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 64A5BE4D011;
	Sat, 13 May 2023 16:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/3] net: dsa: rzn1-a5psw: fix STP states handling
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168399542140.7347.2797429777879901839.git-patchwork-notify@kernel.org>
Date: Sat, 13 May 2023 16:30:21 +0000
References: <20230512072712.82694-1-alexis.lothore@bootlin.com>
In-Reply-To: <20230512072712.82694-1-alexis.lothore@bootlin.com>
To: =?utf-8?q?Alexis_Lothor=C3=A9_=3Calexis=2Elothore=40bootlin=2Ecom=3E?=@codeaurora.org
Cc: andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
 herve.codina@bootlin.com, miquel.raynal@bootlin.com, milan.stevanovic@se.com,
 jimmy.lalande@se.com, pascal.eberhard@se.com

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 12 May 2023 09:27:09 +0200 you wrote:
> From: Alexis Lothoré <alexis.lothore@bootlin.com>
> 
> This small series fixes STP support and while adding a new function to
> enable/disable learning, use that to disable learning on standalone ports
> at switch setup as reported by Vladimir Oltean.
> 
> This series was initially submitted on net-next by Clement Leger, but some
> career evolutions has made him hand me over those topics.
> Also, this new revision is submitted on net instead of net-next for V1
> based on Vladimir Oltean's suggestion
> 
> [...]

Here is the summary with links:
  - [net,v3,1/3] net: dsa: rzn1-a5psw: enable management frames for CPU port
    https://git.kernel.org/netdev/net/c/9e4b45f20c5a
  - [net,v3,2/3] net: dsa: rzn1-a5psw: fix STP states handling
    https://git.kernel.org/netdev/net/c/ebe9bc509527
  - [net,v3,3/3] net: dsa: rzn1-a5psw: disable learning for standalone ports
    https://git.kernel.org/netdev/net/c/ec52b69c046a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



