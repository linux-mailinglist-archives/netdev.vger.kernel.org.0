Return-Path: <netdev+bounces-6699-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A722A71778E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:10:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 624E128139D
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96AF6946E;
	Wed, 31 May 2023 07:10:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29888748C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1FB7C433EF;
	Wed, 31 May 2023 07:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685517018;
	bh=KSMayvjuom8cp9qme1kJ3UxQe5Pu5fLDs9QXhQpNf70=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=QZ/ThUf+ogSB2Lfc036xBRTbBTYIw4TOdLP5yw9TcBHActIE1JtH24CP7Uf1yaYGz
	 6fIA4IK7FDHQ/PqQMweCnOFM8mcDO8aP0UW2CTNS96AkE9tgl3xJS22TfDquhTjz7B
	 gbaIOdWgWLre2jcysWkAo7yV0R4BKFyTAXUZQaX3BNT3jXsEfRZo30dJFjhJcROvhd
	 zZPCMmHvcQQR97Jsond4N2WtkLnsAUrlY4kn8L2El8+udVOYhPHFqX2d4KFa5fCkU8
	 SQWAoj6jde+BaR2kulG1P+tKbup3m3eMiPVRMBZnbTvm08v/QRtlmcfABCuFDkPyMi
	 KLraKGgondf9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A0DA4E52BFB;
	Wed, 31 May 2023 07:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/netlink: fix NETLINK_LIST_MEMBERSHIPS length
 report
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168551701864.26195.8988604899560943264.git-patchwork-notify@kernel.org>
Date: Wed, 31 May 2023 07:10:18 +0000
References: <20230529153335.389815-1-pctammela@mojatatu.com>
In-Reply-To: <20230529153335.389815-1-pctammela@mojatatu.com>
To: Pedro Tammela <pctammela@mojatatu.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, kuniyu@amazon.com, dh.herrmann@gmail.com,
 jhs@mojatatu.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 29 May 2023 12:33:35 -0300 you wrote:
> The current code for the length calculation wrongly truncates the reported
> length of the groups array, causing an under report of the subscribed
> groups. To fix this, use 'BITS_TO_BYTES()' which rounds up the
> division by 8.
> 
> Fixes: b42be38b2778 ("netlink: add API to retrieve all group memberships")
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net/netlink: fix NETLINK_LIST_MEMBERSHIPS length report
    https://git.kernel.org/netdev/net/c/f4e4534850a9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



