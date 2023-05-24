Return-Path: <netdev+bounces-4846-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18B5370EBF1
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 05:40:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2C3A281182
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 03:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7ED915B8;
	Wed, 24 May 2023 03:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B86D15B2
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 03:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D55BC433AA;
	Wed, 24 May 2023 03:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684899620;
	bh=mpjvNHwSCKt0Bcer23U1Bfg5fBeRwoJhyEh4MoqqTTg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=EvHWDyIzOolWGSJaXoYT63ouZVUTE6ExYaR/kuAqR6yvbZVgq61eM82lxBcR/v74E
	 XQUjPan7afK+bTxyaJKfQhUA0/zhxposBhSuzZcgMUdBMFQuO9b0xu3U0vnB9by3FE
	 sdxVjeWehebR7AmYQzgJyJ068xR8MOBVfpM2OkKYKVUlnaP6X5QZC4pxHpirm7FTPb
	 /HJU/to5IcS3uc/HhH1FYJBqaDdiJenaYRXoIrfugZ9hLjwde6QhkA943fpBVF5dhn
	 cMQ/okAqcw/7Ax9K7U48Kcuet6hT04342LfMTktepZMBYRzXv9GvhCeeqF8PQf15Nc
	 tAp+QZd0EwC/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 09C64C395F8;
	Wed, 24 May 2023 03:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/1] net: sfp: add support for HXSX-ATRI-1 copper SFP+ module
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168489962003.3716.7853325122486686133.git-patchwork-notify@kernel.org>
Date: Wed, 24 May 2023 03:40:20 +0000
References: <20230522145242.30192-1-josua@solid-run.com>
In-Reply-To: <20230522145242.30192-1-josua@solid-run.com>
To: Josua Mayer <josua@solid-run.com>
Cc: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 22 May 2023 17:52:41 +0300 you wrote:
> Add quirk for this SFP module, which is the industrial version of
> Walsun HXSX-ATRC-1, for which Russell King already submitted support.
> 
> Please apply only after Russell King patch:
> "net: sfp: add support for a couple of copper multi-rate modules"
> 
> Josua Mayer (1):
>   net: sfp: add support for HXSX-ATRI-1 copper SFP+ module
> 
> [...]

Here is the summary with links:
  - [1/1] net: sfp: add support for HXSX-ATRI-1 copper SFP+ module
    https://git.kernel.org/netdev/net-next/c/ac2e8e3cfe48

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



