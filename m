Return-Path: <netdev+bounces-8938-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C27B87265C1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B5EE1C20B4D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:22:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C603732B;
	Wed,  7 Jun 2023 16:22:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD121370F8
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249DFC433EF;
	Wed,  7 Jun 2023 16:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686154931;
	bh=vNPiho7XHTYNtPtq/iit+9m1GXCFcv8ns7OTAfoEQ/0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ECACco6BWRAB8Du0B4Usut7osCn7uhmFZXtKmaFrK8GJGLBu3r1qdpyH4IujpQBOn
	 1EG0l+EMA1u3T2N1+QJOX3YBEgbFnqv/LEsMv08Rb7nTcyHCTX3BrLXEa2fLhJj8t0
	 TA5Mmq0La8fAdeaF1LSwSQ7RLTeN7aJ449xFebTq/PI6h7sbgy8B9cfxPzCwcDrZK/
	 Bleu+RUo61PnLZW014SSGgb+DQDUhrZC8P/QIRt7QhoHqS6xzJHr3g1cgYRnGL8dij
	 pfNyiT2Ct8HUTsKQD1V3u8W1ASmXhW2r29WVyVftmDOQX2aZfscJXdAO8+RzsV34Aa
	 4E7fM9VL+mgpQ==
Date: Wed, 7 Jun 2023 09:22:10 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Saeed Mahameed <saeed@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
 <edumazet@google.com>, Saeed Mahameed <saeedm@nvidia.com>,
 netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>, Leon Romanovsky
 <leonro@nvidia.com>, linux-rdma@vger.kernel.org, Jiri Pirko
 <jiri@nvidia.com>
Subject: Re: [net-next 13/15] net/mlx5: Skip inline mode check after
 mlx5_eswitch_enable_locked() failure
Message-ID: <20230607092210.62ace50f@kernel.org>
In-Reply-To: <ZICmQcFEJkDn71Xq@nanopsycho>
References: <20230606071219.483255-1-saeed@kernel.org>
	<20230606071219.483255-14-saeed@kernel.org>
	<20230606220117.0696be3e@kernel.org>
	<ZICmQcFEJkDn71Xq@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 7 Jun 2023 17:46:09 +0200 Jiri Pirko wrote:
> >The combination of net-next and Fixes is always odd.
> >Why? 
> >Either it's important enough to be a fix or its not important 
> >and can go to net-next...
> 
> As Jason wrote, this is a fix, but not -net worthy. I believe that
> "Fixes" tag should be there regardless of the target tree,
> it makes things easier to follow.

No it doesn't. Both as a maintainer and a person doing backports for 
a production kernel I'm telling you that it doesn't. Fishing a
gazillion patches with random Fixes tags during the merge window,
2 months after they had been merged is *not* helping anyone.
And as it usually happens fixes people consider "not important enough"
are also usually trivial so very low risk of regression.

Maybe it makes it easier for you to stack patches but that's secondary..
-- 
pw-bot: cr

