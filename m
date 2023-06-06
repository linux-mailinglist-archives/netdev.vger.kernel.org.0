Return-Path: <netdev+bounces-8525-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D976F724747
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:10:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D5721C20AC5
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 281852A71F;
	Tue,  6 Jun 2023 15:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E822337B97;
	Tue,  6 Jun 2023 15:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88483C433EF;
	Tue,  6 Jun 2023 15:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686064220;
	bh=S8zUBfcGXSsgf/1vq5tSuv+A3LfStY7eiIOnuijlnEs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=FKH2w9q8koezsPRfzA9bNkj+oKTJgq+RkW6rFYFOJZdDE83Uqt63Mjnv7h2srkgMY
	 HFwO+j/0ufq1t8n6Cea/ZXj2CNfaShOTDPbf6KLaLSg4MM7tTXI4oOAw1c7qtBJtww
	 y2bnQwSq5BW369DxdwDvTAzEx84Q8EuIicNbkMKN9lDlEr+v9OaqkAPreN7Lgi18NO
	 d/sOt5YJVXwfCjgXeT2pAyRB9RyqjJSzfQrKNXfPl1cksbysFYQSLPxg89OBWe62B0
	 QOticL/RRQEgDHG7FbrU0EJbk7hIdg5WMu+1iFTNj/qXpu7rgln7tFAOTgen+p5TmL
	 wdTv8gu+hM54Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6520FE29F3B;
	Tue,  6 Jun 2023 15:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next V1] selftests/bpf: Fix check_mtu using wrong variable
 type
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168606422041.10567.18202804005249837982.git-patchwork-notify@kernel.org>
Date: Tue, 06 Jun 2023 15:10:20 +0000
References: <168605104733.3636467.17945947801753092590.stgit@firesoul>
In-Reply-To: <168605104733.3636467.17945947801753092590.stgit@firesoul>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: borkmann@iogearbox.net, ast@kernel.org, andrii.nakryiko@gmail.com,
 bpf@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 06 Jun 2023 13:30:47 +0200 you wrote:
> Dan Carpenter found via Smatch static checker, that unsigned
> 'mtu_lo' is never less than zero.
> 
> Variable mtu_lo should have been an 'int', because read_mtu_device_lo()
> uses minus as error indications.
> 
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next,V1] selftests/bpf: Fix check_mtu using wrong variable type
    https://git.kernel.org/bpf/bpf-next/c/095641817e1b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



