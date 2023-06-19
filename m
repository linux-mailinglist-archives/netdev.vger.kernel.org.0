Return-Path: <netdev+bounces-11949-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89231735679
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:10:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4F022810E2
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09740107BC;
	Mon, 19 Jun 2023 12:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8422FC14A;
	Mon, 19 Jun 2023 12:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C913C433CA;
	Mon, 19 Jun 2023 12:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687176621;
	bh=gyZBJ07gcbD6a4Fyl1xZ2umbKV3jBW9w9n9qetj27So=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=OGJRj69ii7V/JoFUMgpHyyPVnJdSFl31f9yU/1cbIuzwZaNj6vK9+92cXKVMaW+Jz
	 5l74n1cSs2Vl4P0HcSJkWVgJlcZm1yv+c9q7L1pKNlIFzo6lHr1dDd0zzYAscr45Sq
	 71W3n3CFg8mdU8leGewDeXT0b7u8LR7XEHoH5rwAme/LbVo2tWrVIC1n283UaFXthd
	 ro81fJ96dzMrFOocP8+AdXYH2UXTk9Ipe5PxhVC2Su3BOSkPeSl8XFR/6uZXUMhdYK
	 hMxWaN+Vq22myfIZGT4F1aDkPyAZ3mtyvgB2oPvhTWcLXE76flsd1G8NWx2KHwfGLR
	 nUvMFVXtOsxTA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 019A9E301FA;
	Mon, 19 Jun 2023 12:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next] xsk: Remove unused inline function
 xsk_buff_discard()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168717662100.5239.549809460077247982.git-patchwork-notify@kernel.org>
Date: Mon, 19 Jun 2023 12:10:21 +0000
References: <20230616062800.30780-1-yuehaibing@huawei.com>
In-Reply-To: <20230616062800.30780-1-yuehaibing@huawei.com>
To: YueHaibing <yuehaibing@huawei.com>
Cc: bjorn@kernel.org, magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
 jonathan.lemon@gmail.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
 hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
 bpf@vger.kernel.org, linux-kernel@vger.kernel.org, maxtram95@gmail.com,
 simon.horman@corigine.com

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 16 Jun 2023 14:28:00 +0800 you wrote:
> commit f2f167583601 ("xsk: Remove unused xsk_buff_discard")
> left behind this, remove it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
> v2: resend to bpf-next tree
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next] xsk: Remove unused inline function xsk_buff_discard()
    https://git.kernel.org/bpf/bpf-next/c/e2fa5c2068fb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



