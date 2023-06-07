Return-Path: <netdev+bounces-8691-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55FED725329
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 07:01:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B64191C20BB0
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 05:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFA0EEC1;
	Wed,  7 Jun 2023 05:01:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF96463A
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 05:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F76C433D2;
	Wed,  7 Jun 2023 05:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686114078;
	bh=/nRpo4IO/mdSB+hXTWDtar3XcKvXlt/aPbvEsR8/1Ic=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EQC2A/R+AQG6dCxOT4Bp9nAPwjnrFqlmXrrwvaIsFHolGH4lTYV16vA0wprp/J4vI
	 VVd0OZI0lQNWnyLn9v16y0ZtsXTTSgfjdmJiJn1Ya5Lj7H46A2yMPfdj9ZDfPd4sZZ
	 +B0p2L8fyKc7DSCqW5j2oJp+S3cdeUfm7OPVhClJnJGJDOD6EQzYF+phXO6GRvqA0a
	 OVKG2kJlEilbRhd/XIViw/N7TDGduCmo91a6mPCnN9a5Rvjohr9B4A7BfWsgzK/ONH
	 oVV9U4p3ZBt+Dhrwe0G4wWkkqWCfBItqgIhHutauzeUfaoxpbeNDGhMYucd4pVZXDr
	 gjiTWvSnGP6gQ==
Date: Tue, 6 Jun 2023 22:01:17 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Saeed Mahameed <saeed@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Paolo Abeni
 <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, Saeed Mahameed
 <saeedm@nvidia.com>, netdev@vger.kernel.org, Tariq Toukan
 <tariqt@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 linux-rdma@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [net-next 13/15] net/mlx5: Skip inline mode check after
 mlx5_eswitch_enable_locked() failure
Message-ID: <20230606220117.0696be3e@kernel.org>
In-Reply-To: <20230606071219.483255-14-saeed@kernel.org>
References: <20230606071219.483255-1-saeed@kernel.org>
	<20230606071219.483255-14-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  6 Jun 2023 00:12:17 -0700 Saeed Mahameed wrote:
> Fixes: bffaa916588e ("net/mlx5: E-Switch, Add control for inline mode")
> Fixes: 8c98ee77d911 ("net/mlx5e: E-Switch, Add extack messages to devlink callbacks")

The combination of net-next and Fixes is always odd.
Why? 
Either it's important enough to be a fix or its not important 
and can go to net-next...

