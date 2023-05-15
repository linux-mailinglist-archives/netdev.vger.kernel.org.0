Return-Path: <netdev+bounces-2538-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 481EB70266A
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:51:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 052EB1C20ABF
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F3F8488;
	Mon, 15 May 2023 07:50:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB5D8F42
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 07:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85900C433A4;
	Mon, 15 May 2023 07:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684137025;
	bh=WPkossC5wCRbrnRCBcADhhmyj2KDsombbtJfKgYZl8A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=HjzxpCGz+Acela76tqnVmbBKETgX9yK4lu1FpvpY4698y6tdrSEH27dsidhwp5/tG
	 /6BovS1FpoAD3FLrDKW342NnC2ue9+cXi/7zzWtSn5+L9ic1RLG0rpRtPVHPjw1+Ps
	 nV10BsO/QlOXMgiPt+h+Pv9wZzKRIaoWQ/9uHHRE6fS+Zy+Vkfl74q8zSUHReLvfLm
	 8ddGZJwjXdJOcn+kGSaHexDdYBXRBDaz5PCIMpno9HjDYMS3uWnbF5HPQDxAOT+eNC
	 NpjoXWGeAkTYFDA4l6Zi+D/LdzdAZhTZRLitaorX7ofn31xvagHNIB2YEy/nij1M6Q
	 fAISdzh7j0vIA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 54E7DE5421B;
	Mon, 15 May 2023 07:50:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2023-05-12
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168413702534.26935.6972873267729953061.git-patchwork-notify@kernel.org>
Date: Mon, 15 May 2023 07:50:25 +0000
References: <20230512102647.8C727C433EF@smtp.kernel.org>
In-Reply-To: <20230512102647.8C727C433EF@smtp.kernel.org>
To: Kalle Valo <kvalo@kernel.org>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 12 May 2023 10:26:47 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2023-05-12
    https://git.kernel.org/netdev/net-next/c/6d4ff8aed3b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



