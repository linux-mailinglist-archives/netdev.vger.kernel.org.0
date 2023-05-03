Return-Path: <netdev+bounces-142-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CB7E6F568D
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 12:48:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C92F52814CF
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E618BA48;
	Wed,  3 May 2023 10:47:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA011116
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 10:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E774DC433D2;
	Wed,  3 May 2023 10:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683110848;
	bh=xhuxd6ARMk4mr+aQe6ypkrkfvy4IYArr8gIrni8JIT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fGNyOhbjeAGC2KAB3X9MBPsAUUrvI6jDad+G8yRZTGZJa+WchQCZ2pqtRHgjRLgN5
	 OXVTxkmRKCZpis6kd7gg15yB1Z2CssCHNZo8YJ+gQSLlfRJ6vJXXV4dRzuJFyhFBCb
	 ymYVx156Rfpq+w2jgg0/swfMep0Bg7nmzLJD0Hc9yLxoFWdbz+gCE+NbRNufkT2IM0
	 kF5wSmrOS02QT5+tfAtEyyMtiA5gHw8LI+un7YynS1Ma2RXk/94eWkAR4pwmexPmW5
	 LU3qm2VUvMRDRaGfbDDWCKbzkaYOhPgDDjAYV34J/sSgOgtK+kdG4H97b2MqVgibK8
	 5f8z3UR/BpwZA==
Date: Wed, 3 May 2023 13:47:24 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Networking <netdev@vger.kernel.org>,
	Linux Random Direct Memory Access <linux-rdma@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux Networking <linux-kernel@vger.kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [PATCH net 2/4] Documentation: net/mlx5: Use bullet and
 definition lists for vnic counters description
Message-ID: <20230503104724.GL525452@unreal>
References: <20230503094248.28931-1-bagasdotme@gmail.com>
 <20230503094248.28931-3-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503094248.28931-3-bagasdotme@gmail.com>

On Wed, May 03, 2023 at 04:42:47PM +0700, Bagas Sanjaya wrote:
> "vnic reporter" section contains unformatted description for vnic
> counters, which is rendered as one long paragraph instead of list.
> 
> Use bullet and definition lists to match other lists.
> 
> Fixes: b0bc615df488ab ("net/mlx5: Add vnic devlink health reporter to PFs/VFs")
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  .../ethernet/mellanox/mlx5/devlink.rst        | 36 ++++++++++---------
>  1 file changed, 20 insertions(+), 16 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

