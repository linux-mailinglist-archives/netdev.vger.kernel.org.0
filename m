Return-Path: <netdev+bounces-2134-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A52AA700733
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:50:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 532B9281A4C
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61EADD51D;
	Fri, 12 May 2023 11:50:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3F47F0
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 11:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66E2DC4339B;
	Fri, 12 May 2023 11:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683892222;
	bh=oKRE6Q4GQI/Y1RmF1EgRtleKTTwPB5KUpsCqFsVVIBw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=aK4hwUXvdIn19a5zg+gwAyy/Ic9ZAa3to7z9TuzzfTqCWWathA7h8ABAVrdVsVoGT
	 7Lw5Gc3BRjTzrSWoUdTba+lHiINEgaBrW/dKzHWNAm3Y78lqDE9+Nscl4ffAbpOKPt
	 u6vX72A3NGr9UZvI86VZkEBe3ShHlL9RYqLuAWGUK/CbI4IWPil1PCC9wjXX5QTcfW
	 0YGN8F/R7vFOTFiFGhPAkovlMifWo5SuJROCWMa3/fYzz6B369DcDsluhFTqFGCkEQ
	 Gv+o730pZ97zeAbN+zz4od46ZH80/2oYBDoekoPGQb/mfFyYvZC7xMEypFLBtVTkq+
	 5vn4k7/u9yBCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4C2D8E26D20;
	Fri, 12 May 2023 11:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/4] sfc: more flexible encap matches on TC decap
 rules
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168389222130.22326.7832724007367185971.git-patchwork-notify@kernel.org>
Date: Fri, 12 May 2023 11:50:21 +0000
References: <cover.1683834261.git.ecree.xilinx@gmail.com>
In-Reply-To: <cover.1683834261.git.ecree.xilinx@gmail.com>
To:  <edward.cree@amd.com>
Cc: linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com, ecree.xilinx@gmail.com,
 netdev@vger.kernel.org, habetsm.xilinx@gmail.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 May 2023 20:47:27 +0100 you wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> This series extends the TC offload support on EF100 to support optionally
>  matching on the IP ToS and UDP source port of the outer header in rules
>  performing tunnel decapsulation.  Both of these fields allow masked
>  matches if the underlying hardware supports it (current EF100 hardware
>  supports masking on ToS, but only exact-match on source port).
> Given that the source port is typically populated from a hash of inner
>  header entropy, it's not clear whether filtering on it is useful, but
>  since we can support it we may as well expose the capability.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/4] sfc: release encap match in efx_tc_flow_free()
    https://git.kernel.org/netdev/net-next/c/28fa3ac487c6
  - [v2,net-next,2/4] sfc: populate enc_ip_tos matches in MAE outer rules
    https://git.kernel.org/netdev/net-next/c/56beb35d85e2
  - [v2,net-next,3/4] sfc: support TC decap rules matching on enc_ip_tos
    https://git.kernel.org/netdev/net-next/c/3c9561c0a5b9
  - [v2,net-next,4/4] sfc: support TC decap rules matching on enc_src_port
    https://git.kernel.org/netdev/net-next/c/b6583d5e9e94

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



