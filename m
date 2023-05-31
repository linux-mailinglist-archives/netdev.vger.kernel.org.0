Return-Path: <netdev+bounces-6939-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B75C3718E25
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 00:10:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FC251C20F7E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 22:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 592E040768;
	Wed, 31 May 2023 22:10:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2174819E7C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 22:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DC8C433D2;
	Wed, 31 May 2023 22:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685571036;
	bh=XsHkCEg9AmeXq1mesBojfBB8VVniBXgX03EI8HB4k/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uh1acxzgOkKruiMcGA9IS2WS1JPU7vf4IgE5zhldHKioPiz9U91U7RYR4xPVqX6EQ
	 x31E/qhoBynOsy32QMftAvRs1QBD3CoUILSbABnHdATvWWnX00KihLxPkVrxD6Dpyj
	 rWMKWNdhwP7VjGIyvnncM0qmUrHBek0oWccv960JLRfgP1TnRuMZIaY2cTMRGSN4+O
	 ZkQHbHHsvrNkL51NO4K9apfT0yy0pcyGIxYG88563GVuBRkD5qHPkp479FBp6D4e02
	 DuNQdzjWqfODsjEEtGTypcBD9hpKiiuxcdZv3r/m1DgTlC+4FD8ptUY6TaqCrdU+dM
	 Oo1T9M/wdPNkQ==
Date: Wed, 31 May 2023 15:10:34 -0700
From: Saeed Mahameed <saeed@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: rafael@kernel.org, linux-pm@vger.kernel.org, thierry.reding@gmail.com,
	Sandipan Patra <spatra@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	"open list:MELLANOX MLX5 core VPI driver" <netdev@vger.kernel.org>,
	"open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] net/mlx5: Update the driver with the recent thermal
 changes
Message-ID: <ZHfF2kXIiONh6iDr@x130>
References: <20230525140135.3589917-1-daniel.lezcano@linaro.org>
 <20230525140135.3589917-2-daniel.lezcano@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230525140135.3589917-2-daniel.lezcano@linaro.org>

On 25 May 16:01, Daniel Lezcano wrote:
>The thermal framework is migrating to the generic trip points. The set
>of changes also implies a self-encapsulation of the thermal zone
>device structure where the internals are no longer directly accessible
>but with accessors.
>
>Use the new API instead, so the next changes can be pushed in the
>thermal framework without this driver failing to compile.
>
>No functional changes intended.
>

I see this patch is part of a large series, do you expect me to re-post to
net-next or you are going to submit via another tree ? 



