Return-Path: <netdev+bounces-11855-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 158F0734E1D
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 405DB1C2098E
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 08:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3165DBA20;
	Mon, 19 Jun 2023 08:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953F279C4
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6411DC433C9;
	Mon, 19 Jun 2023 08:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687164019;
	bh=UtjravUBCN3o1U68Iy/Hasvwofkbayx1QqElmRLNbLo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ksgRvdgkbOYVLhm0Mg4tjNiOiG6jqlM0r3VI2AY6TUGc5pWk8+XU5K+/wBAQhSvrU
	 QLWWtZeKjGcBu3F3e4+x130eDB7Ev/n3tiYsnO6h8v+BkLAA2bSU6pF/a62qOtWruv
	 XclF3HrFZxnTYDpxhsmktGohjlJp+IT/uiNMYCpv3KWYn0770cnimUsiEOF9PNguCt
	 8ZzeZ2iUpahXkkRUbXjPUqlQB5xMZloAqDtg4GleSvy+TqwajhVWvvqrg540Y5SWzp
	 wY5XZ4eRUFVhFNzXeL6eiK0/DBQVAN/26bdlyqoCmOSgQ4xi8UhWpSY+M/c3idCrIg
	 LTGIPlj9bFwBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 42789C4316B;
	Mon, 19 Jun 2023 08:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net] net: qca_spi: Avoid high load if QCA7000 is not
 available
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168716401926.31468.11826494564143832409.git-patchwork-notify@kernel.org>
Date: Mon, 19 Jun 2023 08:40:19 +0000
References: <20230614210656.6264-1-stefan.wahren@i2se.com>
In-Reply-To: <20230614210656.6264-1-stefan.wahren@i2se.com>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, stefan.wahren@chargebyte.com, simon.horman@corigine.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 14 Jun 2023 23:06:56 +0200 you wrote:
> In case the QCA7000 is not available via SPI (e.g. in reset),
> the driver will cause a high load. The reason for this is
> that the synchronization is never finished and schedule()
> is never called. Since the synchronization is not timing
> critical, it's safe to drop this from the scheduling condition.
> 
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
> Fixes: 291ab06ecf67 ("net: qualcomm: new Ethernet over SPI driver for QCA7000")
> 
> [...]

Here is the summary with links:
  - [V2,net] net: qca_spi: Avoid high load if QCA7000 is not available
    https://git.kernel.org/netdev/net/c/92717c2356cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



