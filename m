Return-Path: <netdev+bounces-11186-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 83E37731E92
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 19:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9CDD2813C5
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C882E0D0;
	Thu, 15 Jun 2023 17:00:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FF32E0C0
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 17:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A566C433C0;
	Thu, 15 Jun 2023 17:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686848422;
	bh=o+U5MXh11uepYucZI48qpdFf5GfWBkEs2n/W2UWH/Uk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WN9tfXddBBCsj9x+XyyfUW7KgP4T0UMfd2zvSDQBqpCl5kZYSXoyjbEKELUxxuh+o
	 wrgwcBCz5E5DgTVUtAEegfcpR5t7Lf405AtKR3+Zfw0kpRLNzlbBKRnTobuOihL2BW
	 FpOzrBYwit6LomvSpvwOJNx+/Z21m2elM1Don1qLPapbejlaAx1wFGkulZsEwi65Pz
	 gUmuWAj5J8BOr3Zx9paRHGiWa7I7LN8MNYlMlM8m9PpGoVfJT51dbhUyyyg9VEuYqH
	 Vw7U/CJsJnvVIoIKULGRTA+cNRegz7br0wntdHxUYqj1xOG1f6zNb+wXvOczXp0vtY
	 m72WG8MozxdPA==
Date: Thu, 15 Jun 2023 10:00:21 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: patchwork-bot+netdevbpf@kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
 dsahern@gmail.com, "helpdesk@kernel.org" <helpdesk@kernel.org>
Subject: Re: [PATCH net-next v2 0/2] net: create device lookup API with
 reference tracking
Message-ID: <20230615100021.43d2d041@kernel.org>
In-Reply-To: <168681542074.22382.15571029013760079421.git-patchwork-notify@kernel.org>
References: <20230612214944.1837648-1-kuba@kernel.org>
	<168681542074.22382.15571029013760079421.git-patchwork-notify@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Jun 2023 07:50:20 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
> Here is the summary with links:
>   - [net-next,v2,1/2] net: create device lookup API with reference tracking
>     (no matching commit)

Hi Konstantin!

Any recent changes to the pw-bot in commit matching?
We don't do any editing when applying, AFAIK, and it's 3rd or 4th case
within a week we get a no-match.

Lore
https://lore.kernel.org/all/20230612214944.1837648-2-kuba@kernel.org/

commit
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=70f7457ad6d655e65f1b93cbba2a519e4b11c946

patchwork
https://patchwork.kernel.org/project/netdevbpf/patch/20230612214944.1837648-2-kuba@kernel.org/

