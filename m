Return-Path: <netdev+bounces-10018-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4252372BB2A
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:50:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 838791C20A81
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:50:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E89511CB4;
	Mon, 12 Jun 2023 08:50:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159301FB7
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A420DC4339E;
	Mon, 12 Jun 2023 08:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686559840;
	bh=3wEU2eWpI2dfYMagdnkzdlLhdwadAxg23iFRWigAAO8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=kCvrQW4MSxDg78li13w0I6JMFG0vYo318lLmqRFEn+u2Rm10ihdc2rGzHkRwqSyGM
	 VjG6KfjeFNwKpEm/JI69Dwvq3h5XdruyzKYQZIqZC+DvZjVflo3lHpmEbDeSApWBMs
	 m1WJLNQbC4wT6pdH+A5YbdtaaBHjyu1d12HnOrEGqxerAk/zYSa8TeFLbyeksreswX
	 fMw1w2hfi+F4O5jQjrz2z6FoGdCibjTckDdITgOCcrwpVTTMveOG9xNuRKzjkQM2ki
	 +riw/A256Aj4x7U/c8/utQSkX4IiO6EBGfwqAeLACiMr//oMtqoMzYgyOExR7cA505
	 190XV3WHRNqwg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8660DE1CF31;
	Mon, 12 Jun 2023 08:50:40 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: openvswitch: add support for l4 symmetric
 hashing
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168655984053.8602.1349154560216964511.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 08:50:40 +0000
References: <20230609135955.3024931-1-aconole@redhat.com>
In-Reply-To: <20230609135955.3024931-1-aconole@redhat.com>
To: Aaron Conole <aconole@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dev@openvswitch.org,
 pshelar@ovn.org, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, echaudro@redhat.com, dceara@redhat.com, i.maximets@ovn.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri,  9 Jun 2023 09:59:55 -0400 you wrote:
> Since its introduction, the ovs module execute_hash action allowed
> hash algorithms other than the skb->l4_hash to be used.  However,
> additional hash algorithms were not implemented.  This means flows
> requiring different hash distributions weren't able to use the
> kernel datapath.
> 
> Now, introduce support for symmetric hashing algorithm as an
> alternative hash supported by the ovs module using the flow
> dissector.
> 
> [...]

Here is the summary with links:
  - [net-next] net: openvswitch: add support for l4 symmetric hashing
    https://git.kernel.org/netdev/net-next/c/e069ba07e6c7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



