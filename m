Return-Path: <netdev+bounces-141-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92A546F568A
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 12:47:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA2501C20BA8
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:47:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EE11D2F1;
	Wed,  3 May 2023 10:47:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E116AD5F
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 10:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F04C433EF;
	Wed,  3 May 2023 10:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683110839;
	bh=tioAvSYzHANIHhO4CayA08QzY18CDWbsKB7RZNeIoZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jd9wn9ECcSeobXQFrxBU5FRfR/WqS9xgOybu0IOF+h4WjHjOYCNfiHFfnvSNdfh9G
	 0/yX83FmP1W1lz4AIFKGAgkX8441HZaFd1O5Fhii+h9t/2Pw/ETMHxdaB9x+WS/0Q+
	 JVh/Ww9NPtWFbRdoNzB5W4FuCeOVwcDssOv4xHmM3BL6FofaX8n6ciEazcqepA+fCC
	 jS8YBeJGi/4FvlEbsnHAlWXTMIozH32ZWGpF2j2JpZBEQNttryBRL7ujFz6EZlfsbh
	 NPYXmQpyFItLmDvxvq+5zwoDbhMy3L1+Gppr0K17q7/6jf+FX3Zri69p7ciJK5GVEV
	 gzqTHvqnds8LQ==
Date: Wed, 3 May 2023 13:47:15 +0300
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
Subject: Re: [PATCH net 3/4] Documentation: net/mlx5: Add blank line
 separator before numbered lists
Message-ID: <20230503104715.GK525452@unreal>
References: <20230503094248.28931-1-bagasdotme@gmail.com>
 <20230503094248.28931-4-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503094248.28931-4-bagasdotme@gmail.com>

On Wed, May 03, 2023 at 04:42:48PM +0700, Bagas Sanjaya wrote:
> The doc forgets to add separator before numbered lists, which causes the
> lists to be appended to previous paragraph inline instead.
> 
> Add the missing separator.
> 
> Fixes: f2d51e579359b7 ("net/mlx5: Separate mlx5 driver documentation into multiple pages")
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  .../device_drivers/ethernet/mellanox/mlx5/devlink.rst           | 2 ++
>  1 file changed, 2 insertions(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

