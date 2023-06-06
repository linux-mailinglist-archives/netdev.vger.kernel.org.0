Return-Path: <netdev+bounces-8245-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E81CF723412
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 02:36:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5311828147B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 00:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEA1136A;
	Tue,  6 Jun 2023 00:36:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CE17F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 250E3C4339B;
	Tue,  6 Jun 2023 00:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686011765;
	bh=yIesLC+hu0MamvZ+Xj58+7hUqD8ObtDUOk5djfVXd0w=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=nV7HeQ+s3TW1J84psv/8uC+TZYC5XCRhxOadbVqFB02TIXO2IW9nZeuhipYPIXOzj
	 bxvhWYIp7dgH7ZTeY06lX4H5jlNRtia9WIgqK2vCthJU7j74MPXW/HkP99Y7ROIf3I
	 lR1ZM6Glwp27gLeLvYkSHHgrLYwz0pkAjn+QbpMjcGc4UZympMW6O8VsZEJVZLr5re
	 CbNtjZpBJJxyydu1VbZxo9hV9GBe0lc0fmtLQ0km5VhH9TER7TLvfX25ZN6lKlGhYd
	 5o6+XKXKB/YemVMmyGDF7292zhdFb+LjVIZqdNYWq3j/aEQeIVS5k8BmwUjQ4xHZ64
	 jirfeYQI3aFyw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 051CFE4F0A7;
	Tue,  6 Jun 2023 00:36:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bluetooth 2023-05-19
From: patchwork-bot+bluetooth@kernel.org
Message-Id: 
 <168601176501.31462.8894416742474090660.git-patchwork-notify@kernel.org>
Date: Tue, 06 Jun 2023 00:36:05 +0000
References: <20230519233056.2024340-1-luiz.dentz@gmail.com>
In-Reply-To: <20230519233056.2024340-1-luiz.dentz@gmail.com>
To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: davem@davemloft.net, kuba@kernel.org, linux-bluetooth@vger.kernel.org,
 netdev@vger.kernel.org

Hello:

This pull request was applied to bluetooth/bluetooth-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 19 May 2023 16:30:56 -0700 you wrote:
> The following changes since commit 9025944fddfed5966c8f102f1fe921ab3aee2c12:
> 
>   net: fec: add dma_wmb to ensure correct descriptor values (2023-05-19 09:17:53 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2023-05-19
> 
> [...]

Here is the summary with links:
  - pull-request: bluetooth 2023-05-19
    https://git.kernel.org/bluetooth/bluetooth-next/c/67caf26d769e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



