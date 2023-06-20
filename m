Return-Path: <netdev+bounces-12145-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E332736681
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:40:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A8DD2811F5
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D091C13B;
	Tue, 20 Jun 2023 08:40:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB23883A
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 08:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E070C433C8;
	Tue, 20 Jun 2023 08:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687250421;
	bh=kErwKwo+EYHKvcMbPgNsAvybz33Jox8dGvAzlDYX0WE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=TE9W033wJe1vrj2BD1Fq4qgDk/ooJrhb+2sELLFNU9vk1Q4wDd6ZnnggUIi6KKh1o
	 05zlC4xtLjureKdpJpdzEXnMn1qay8Epr/Ht2Fx+MXTd4ZlpxEKDKaqqt+vXsia0IZ
	 k7SZg1FF/9/kJPUOVQseKp4rZk6owNMqAeD0hcJUoC/6JsekBGQStkU430lZI2yS+L
	 e25pDl6YaxQ5dUhJ/QgE99HsuT00TN1zgOfHzxWFz4ul2sxjuJRRk/ljkXKfAtc3Zb
	 InVRXXWV0goyPl9TmgQvcwqXqTRdSrhxlIB9eu2JtPeD0iECnC+2Kh1KfOL3SnT9Lf
	 EKwZ7Chnrdo1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7E73EE21EDF;
	Tue, 20 Jun 2023 08:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dpaa2-mac: add 25gbase-r support
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168725042151.7255.16176413891658881208.git-patchwork-notify@kernel.org>
Date: Tue, 20 Jun 2023 08:40:21 +0000
References: <20230616111414.1578-1-josua@solid-run.com>
In-Reply-To: <20230616111414.1578-1-josua@solid-run.com>
To: Josua Mayer <josua@solid-run.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 ioana.ciornei@nxp.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 16 Jun 2023 14:14:14 +0300 you wrote:
> Layerscape MACs support 25Gbps network speed with dpmac "CAUI" mode.
> Add the mappings between DPMAC_ETH_IF_* and HY_INTERFACE_MODE_*, as well
> as the 25000 mac capability.
> 
> Tested on SolidRun LX2162a Clearfog, serdes 1 protocol 18.
> 
> Signed-off-by: Josua Mayer <josua@solid-run.com>
> 
> [...]

Here is the summary with links:
  - net: dpaa2-mac: add 25gbase-r support
    https://git.kernel.org/netdev/net/c/9a43827e876c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



