Return-Path: <netdev+bounces-3501-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E541A70794F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 06:50:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A55DE1C20EBE
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 04:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6641644;
	Thu, 18 May 2023 04:50:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90A038D
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 04:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62661C4339B;
	Thu, 18 May 2023 04:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684385423;
	bh=Dx6EnHQo2Yjjh9KrD0mEn6bgue46Bf7wi+SxbOFW2MA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=euBko7G75JYEBaZV4vf7SOQW71XpzQeeJsAa6zH0/QNjVxq4TC1rRUsSX/rT2xPjX
	 LFN6MGPeaUxFVViQQSkw9URfE2lBdMr1S++OP5kuk2Es/90oqpl0BzcPuxZguFpY+O
	 jx+QjOLFJpyPcU8t3m/4nXsTIu92Ylf6hL9xZXIv3eiG2v+CmC5ihNgYNi1sZ7ahcz
	 zbxrkZMyzkAq2CPCpubdQwbJBObOgzfNvHRqCSxruf5Fmx3KLwvQM4ryrd0vnJcOJm
	 r/BfU6xMsIiiwkQ9SCqzJNJ9/Nxc0fwyTCJF5lxw+lojC38PgKO0YzWKImFBrYTJQM
	 DkgKRV5Klm6Iw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 386BDC73FE2;
	Thu, 18 May 2023 04:50:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2023-05-17
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168438542322.13974.13019571815680311724.git-patchwork-notify@kernel.org>
Date: Thu, 18 May 2023 04:50:23 +0000
References: <20230517151914.B0AF6C433EF@smtp.kernel.org>
In-Reply-To: <20230517151914.B0AF6C433EF@smtp.kernel.org>
To: Kalle Valo <kvalo@kernel.org>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 17 May 2023 15:19:14 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2023-05-17
    https://git.kernel.org/netdev/net/c/c259ad11698b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



