Return-Path: <netdev+bounces-2379-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 209C1701995
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 22:00:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD75B281742
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 20:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 908109455;
	Sat, 13 May 2023 20:00:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD3179F7
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 20:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 847F4C433D2;
	Sat, 13 May 2023 20:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684008020;
	bh=eUhAHC/Mjz+KeSXonfjEeINXLGPhel+E0J4Y3yjfr3o=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=HsO/p1zOCWYJphYFRwdCL1FhcuUl7fYCGy3R3oQXXSqy0MlGOQtNw27ws5NYnVaYd
	 zVPXWjhiQALJeokeO0N6C5qbq/cffcFkPQsMRxWAqgv09jlg27R5ANT5XC5ncHnSNv
	 VMZ146Kd7MrGnlfbiyLu9Jm3JShRwnmazheH+SZxIkBUrLNruczrA208awLOfZ1fCR
	 1TgTXB8tZXNab+72/3selu3F/X/Hh+oXIZv6V3CFzsAau/oEN3lUKWCfsVfQSXQV0S
	 zLSaYAv6mLueTski5+PBxM72ts+OptIMXswIbTd0ZceaeHFemyLukHCs7G9En9ietC
	 vV5Bcr1mEygjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5AB5BE450BB;
	Sat, 13 May 2023 20:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sfc: fix use-after-free in
 efx_tc_flower_record_encap_match()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168400802036.779.18008463088768762971.git-patchwork-notify@kernel.org>
Date: Sat, 13 May 2023 20:00:20 +0000
References: <20230512153558.15025-1-edward.cree@amd.com>
In-Reply-To: <20230512153558.15025-1-edward.cree@amd.com>
To:  <edward.cree@amd.com>
Cc: linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com, ecree.xilinx@gmail.com,
 netdev@vger.kernel.org, habetsm.xilinx@gmail.com, simon.horman@corigine.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 12 May 2023 16:35:58 +0100 you wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> When writing error messages to extack for pseudo collisions, we can't
>  use encap->type as encap has already been freed.  Fortunately the
>  same value is stored in local variable em_type, so use that instead.
> 
> Fixes: 3c9561c0a5b9 ("sfc: support TC decap rules matching on enc_ip_tos")
> Reported-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] sfc: fix use-after-free in efx_tc_flower_record_encap_match()
    https://git.kernel.org/netdev/net-next/c/befcc1fce564

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



