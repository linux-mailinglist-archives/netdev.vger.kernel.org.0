Return-Path: <netdev+bounces-11244-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08865732284
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 00:11:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6F1D2815B1
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 22:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AD6C1772D;
	Thu, 15 Jun 2023 22:10:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A937B17AA4
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 22:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C6B9C433CB;
	Thu, 15 Jun 2023 22:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686867021;
	bh=OO4GIh2UDuRjnfoglLA7j6vUZuazCf3QLb7484E5bXE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=IDAi/BKbufdSM+RgZXbfmTpMBdoN2Mg8HncIcXAyxaCHv+UVk/q7VMqBESxbEwrmk
	 0pk2ssL7tNp+IHJeGmPPDWh4vOg5kQW2XtC9uU/7E0yu6vMCNrNp+gTLGWXhk9HX93
	 FN0cwU61YkRWw1MIr7u4XUf5E6YNkW17SmoCJtOv/YH8f89nmrfgJpNPd9qOUyJ+nf
	 c8yfnFtZdQO2WZ1iZuXzF1TBcTOY0xBzIsmBqyFqCtzOTssZhEyolJkMpqhhgpF9o/
	 cro/iWfuIMlXBWKnNXReJmtNncF4uHS4uqQ9PQcVT4D5RGRTjGUm7gpC+TqcP2arp+
	 0CAB+2LVtjPNw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 29DDEE29F32;
	Thu, 15 Jun 2023 22:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests/ptp: Fix timestamp printf format for PTP_SYS_OFFSET
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168686702116.9701.8936089484702817897.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 22:10:21 +0000
References: <20230615083404.57112-1-alex.maftei@amd.com>
In-Reply-To: <20230615083404.57112-1-alex.maftei@amd.com>
To: Alex Maftei <alex.maftei@amd.com>
Cc: richardcochran@gmail.com, shuah@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 15 Jun 2023 09:34:04 +0100 you wrote:
> Previously, timestamps were printed using "%lld.%u" which is incorrect
> for nanosecond values lower than 100,000,000 as they're fractional
> digits, therefore leading zeros are meaningful.
> 
> This patch changes the format strings to "%lld.%09u" in order to add
> leading zeros to the nanosecond value.
> 
> [...]

Here is the summary with links:
  - selftests/ptp: Fix timestamp printf format for PTP_SYS_OFFSET
    https://git.kernel.org/netdev/net/c/76a4c8b82938

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



