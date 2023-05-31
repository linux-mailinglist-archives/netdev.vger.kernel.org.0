Return-Path: <netdev+bounces-6738-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96CEA717B62
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:11:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50B1B2813C1
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6188DD531;
	Wed, 31 May 2023 09:10:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEF8C153
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6496EC4339C;
	Wed, 31 May 2023 09:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685524226;
	bh=i6lshncDJIeLa1kUlaumbpkddBNVHnpfwPUQihXnRJM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=IaXWdXOPAn96BdRBhQ4DPzAthy487kYS93n2uzsHOTA1oazIXh1PJLRJjhIMKmARd
	 Zoul+HBtrNLRcpCC2eHgZtX87lOcuHQ3x0ZPDqqbzcWIxV8XrvoFCGWkft9/5+scfE
	 qL6WQPDj9zqbTxH1fqntFPCdWp6px4wZuSYYwPABZ/Ls7K8G4Dc3JtMIzbw/dpzg6Z
	 ZAGWT/0NFGkjpNNgCcGPpQvitaUmaUpqSvWSwM0wSyRffTUG32FqqJAyiRiba9JD7B
	 E5tPgL/2SPQybKEvJ2jMwVPpJme582vDyDEQMZMj4rUKVq94P2u1XjjKvzVdP1jwZr
	 vEUPT+tsZiVoQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 41ADFE21EC7;
	Wed, 31 May 2023 09:10:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] xstats for tc-taprio
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168552422626.12579.6601125654059435231.git-patchwork-notify@kernel.org>
Date: Wed, 31 May 2023 09:10:26 +0000
References: <20230530091948.1408477-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230530091948.1408477-1-vladimir.oltean@nxp.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, jhs@mojatatu.com,
 xiyou.wangcong@gmail.com, jiri@resnulli.us, vinicius.gomes@intel.com,
 kurt@linutronix.de, gerhard@engleder-embedded.com, amritha.nambiar@intel.com,
 ferenc.fejes@ericsson.com, xiaoliang.yang_1@nxp.com, rogerq@kernel.org,
 pranavi.somisetty@amd.com, harini.katakam@amd.com, peppe.cavallaro@st.com,
 alexandre.torgue@foss.st.com, michael.wei.hong.sit@intel.com,
 mohammad.athari.ismail@intel.com, linux@rempel-privat.de,
 jacob.e.keller@intel.com, linux-kernel@vger.kernel.org, andrew@lunn.ch,
 f.fainelli@gmail.com, claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
 UNGLinuxDriver@microchip.com, jesse.brandeburg@intel.com,
 anthony.l.nguyen@intel.com, horatiu.vultur@microchip.com,
 joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
 intel-wired-lan@lists.osuosl.org, muhammad.husaini.zulkifli@intel.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 30 May 2023 12:19:43 +0300 you wrote:
> As a result of this discussion:
> https://lore.kernel.org/intel-wired-lan/20230411055543.24177-1-muhammad.husaini.zulkifli@intel.com/
> 
> it became apparent that tc-taprio should make an effort to standardize
> statistics counters related to the 802.1Qbv scheduling as implemented
> by the NIC. I'm presenting here one counter suggested by the standard,
> and one counter defined by the NXP ENETC controller from LS1028A. Both
> counters are reported globally and per traffic class - drivers get
> different callbacks for reporting both of these, and get to choose what
> to report in both cases.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net/sched: taprio: don't overwrite "sch" variable in taprio_dump_class_stats()
    https://git.kernel.org/netdev/net-next/c/dced11ef84fb
  - [net-next,2/5] net/sched: taprio: replace tc_taprio_qopt_offload :: enable with a "cmd" enum
    https://git.kernel.org/netdev/net-next/c/2d800bc500fb
  - [net-next,3/5] net/sched: taprio: add netlink reporting for offload statistics counters
    https://git.kernel.org/netdev/net-next/c/6c1adb650c8d
  - [net-next,4/5] net: enetc: refactor enetc_setup_tc_taprio() to have a switch/case for cmd
    https://git.kernel.org/netdev/net-next/c/5353599aa745
  - [net-next,5/5] net: enetc: report statistics counters for taprio
    https://git.kernel.org/netdev/net-next/c/4802fca8d1af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



