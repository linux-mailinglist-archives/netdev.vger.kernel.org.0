Return-Path: <netdev+bounces-6535-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3CE8716D90
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B047281318
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C81AF2D268;
	Tue, 30 May 2023 19:30:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A943C23C78
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5292BC433A0;
	Tue, 30 May 2023 19:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685475020;
	bh=Oq190asejlgpO9eMmHw3eeAyL/dxIDeN4+exuiNgpVE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=XAPVtw3rlTecVasuv1ybxaPTsA4R6GMNhUCei1pS0H2CzUnEzkuZdYMEgAdMA44hd
	 bUaECINHgoxJ2Wt+FXhK9C6VytSnVrOiCDyniF+o+sXfoSXAFULlVbvHKy5UEotPbS
	 9SK1TQ1kMwKWxGiIL2lJ0sxNO59HiWS1Bvr9rjg3fyUftvJiw997pWFO8X0FXuNPub
	 HB9AMvpr88Qo5J4bz228l21ZpTWJ8cZWTIPsY/TfzJKTNmfFdxctD75KhIHX3psspP
	 GsqzAZ9M1wNxYWqL+IcNGVrH8q8gC/tXqPN4hhM71HpaH+Pfk/Q0bl460fCyk93j7q
	 829I5xJlF+eGg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 37C91E52BF6;
	Tue, 30 May 2023 19:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] vdpa: propagate error from cmd_dev_vstats_show()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168547502022.11706.10561152444482963252.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 19:30:20 +0000
References: <5290b224a23e36b22e179ca83f2ce377f6d8dd1c.1685396319.git.aclaudi@redhat.com>
In-Reply-To: <5290b224a23e36b22e179ca83f2ce377f6d8dd1c.1685396319.git.aclaudi@redhat.com>
To: Andrea Claudi <aclaudi@redhat.com>
Cc: netdev@vger.kernel.org, stephen@networkplumber.org, dsahern@gmail.com,
 parav@nvidia.com

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Mon, 29 May 2023 23:41:41 +0200 you wrote:
> Error potentially returned from mnlu_gen_socket_sndrcv() are propagated
> for each and every invocation in vdpa. Let's do the same here.
> 
> Fixes: 6f97e9c9337b ("vdpa: Add support for reading vdpa device statistics")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  vdpa/vdpa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [iproute2] vdpa: propagate error from cmd_dev_vstats_show()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=b2c6613ef955

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



