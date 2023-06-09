Return-Path: <netdev+bounces-9479-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 142CC7295D3
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:50:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AD6B1C210C1
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25E8614282;
	Fri,  9 Jun 2023 09:50:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E441427C
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D6ECC4339B;
	Fri,  9 Jun 2023 09:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686304221;
	bh=gMM6kqZnf7Q6EqNxzJ39+6u0rzTOHS2HB9Dnx7drWn4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=AL2iXgAGKemrhYIQqzC9i+maBGqc5QGp5fxt756eCNq9UX9MZT669Av68zEuAdesH
	 qpma7xXAFwIInZZuXklCT5/sn4yfQ2ipw8qacHuQLyNDny/Cx6875cmaVIgPYEoL7d
	 RLSjJcab7d1wA4I/0WG+FNK5FCR5S2pEEMEv4VdtEFHtWDxEl80GC2mxtKRttF5qSX
	 izLf8TmZakyMDtMvPPY85x/eoRCEr0BDvMxSuSKiOJBY3rm574Nv4xw90Nv836tgdH
	 MoJMpmrkEvI/i70n3AZyps8HCuUIyxoRguV4ZJ6zdV+HMyp2uB9esdbwRD35CzSVr0
	 eVD7y1AO1k/sA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 55FC6C43157;
	Fri,  9 Jun 2023 09:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net,v2] net/sched: taprio: fix slab-out-of-bounds Read in
 taprio_dequeue_from_txq
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168630422134.21394.6508730197673291133.git-patchwork-notify@kernel.org>
Date: Fri, 09 Jun 2023 09:50:21 +0000
References: <20230608062756.3626573-1-shaozhengchao@huawei.com>
In-Reply-To: <20230608062756.3626573-1-shaozhengchao@huawei.com>
To: shaozhengchao <shaozhengchao@huawei.com>
Cc: netdev@vger.kernel.org, vinicius.gomes@intel.com, jhs@mojatatu.com,
 xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 vladimir.oltean@nxp.com, weiyongjun1@huawei.com, yuehaibing@huawei.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 8 Jun 2023 14:27:56 +0800 you wrote:
> As shown in [1], out-of-bounds access occurs in two cases:
> 1)when the qdisc of the taprio type is used to replace the previously
> configured taprio, count and offset in tc_to_txq can be set to 0. In this
> case, the value of *txq in taprio_next_tc_txq() will increases
> continuously. When the number of accessed queues exceeds the number of
> queues on the device, out-of-bounds access occurs.
> 2)When packets are dequeued, taprio can be deleted. In this case, the tc
> rule of dev is cleared. The count and offset values are also set to 0. In
> this case, out-of-bounds access is also caused.
> 
> [...]

Here is the summary with links:
  - [net,v2] net/sched: taprio: fix slab-out-of-bounds Read in taprio_dequeue_from_txq
    https://git.kernel.org/netdev/net/c/be3618d96510

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



