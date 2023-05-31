Return-Path: <netdev+bounces-6897-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18E0C7189BC
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 21:00:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5483C1C20A30
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D6DE19BAB;
	Wed, 31 May 2023 19:00:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6D8182D4
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 19:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65E4BC4339E;
	Wed, 31 May 2023 19:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685559621;
	bh=hyY/JqW6K6nLzKDxiXx2110t3c/QHoR5jzju90vkioQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=smjiBPfSmG3K855Fps/QfhPC6bhUa9KJVAKE/WUyvBiS+ohdkE4+jR0f0uyof/XQ3
	 gshglM9nJVQyQVErYwiz8PrdSsf9PnZweNnd1erNwRDantBorRzQZmMd0xXD/4XteK
	 PrjwTEs4aXVSSDsYXXvJIAyBCECIZYH2udKvXPkuNCOPXJZh9fWF2TXTOIowERZCw6
	 9B5tgr8JyEhuUaDNhx1z2HMWuX014GtCvUxxQl112OaIlMECP3CzVFnRBo9goVI6+q
	 NAJj+fFZk/DGohVmT5V5b94iXwsGPJxBUc6L0xT7NCB/R92FHwETCTvtkCVVnZrZaw
	 9fcYsxN+VKerg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4A385E21EC7;
	Wed, 31 May 2023 19:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND 0/2] Bluetooth: fix debugfs registration
From: patchwork-bot+bluetooth@kernel.org
Message-Id: 
 <168555962130.19706.12623481688693032536.git-patchwork-notify@kernel.org>
Date: Wed, 31 May 2023 19:00:21 +0000
References: <20230531085759.2803-1-johan+linaro@kernel.org>
In-Reply-To: <20230531085759.2803-1-johan+linaro@kernel.org>
To: Johan Hovold <johan+linaro@kernel.org>
Cc: marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org

Hello:

This series was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Wed, 31 May 2023 10:57:57 +0200 you wrote:
> The HCI controller debugfs interface is created during setup or when a
> controller is configured, but there is nothing preventing a controller
> from being configured multiple times (e.g. by setting the device
> address), which results in a host of errors in the logs:
> 
> 	debugfs: File 'features' in directory 'hci0' already present!
> 	debugfs: File 'manufacturer' in directory 'hci0' already present!
> 	debugfs: File 'hci_version' in directory 'hci0' already present!
> 	...
> 	debugfs: File 'quirk_simultaneous_discovery' in directory 'hci0' already present!
> 
> [...]

Here is the summary with links:
  - [RESEND,1/2] Bluetooth: fix debugfs registration
    https://git.kernel.org/bluetooth/bluetooth-next/c/3e972279b782
  - [RESEND,2/2] Bluetooth: hci_qca: fix debugfs registration
    https://git.kernel.org/bluetooth/bluetooth-next/c/22307d477e3f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



