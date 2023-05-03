Return-Path: <netdev+bounces-140-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77F8C6F5686
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 12:47:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35568281536
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:47:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69ABBA48;
	Wed,  3 May 2023 10:47:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68939D307
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 10:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71438C433D2;
	Wed,  3 May 2023 10:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683110833;
	bh=+SW3ix11KnUjyDCfbyUlZlo1W67XDtMkBjbOXSkJePg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EFfC1anuDnn8fx2+XMh4wEDoEGjGYinAgoCeCqiH2lXWR1SLm5s6womuGqMDDo6lF
	 P77M+rly2eYkxXClfkj3OpBM5uqjkhOMhh8ehzDXS6InVE2vFAJJRGP0WKDT2oIvAb
	 ZfxqYFLTRUlQ0/pIneXk3p/gp0wGr/BZQXHH39vDDbQCr1l1wU+Y6wsKn5evx3t+A1
	 zGEpe3eVP8xf83tZ9bsJ7b3r6ipGLlv1Pbki4rol9EUrzd7SyC92Z1IM1KMorCQwVM
	 jJlnKtaZRyENssFRNk3dUcXmI+ylSfXOo+0X5d6upb5yuGS8fyiXBspuZ9L4W/v2+v
	 w02T7NtkUrJtQ==
Date: Wed, 3 May 2023 13:47:08 +0300
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
Subject: Re: [PATCH net 4/4] Documentation: net/mlx5: Wrap notes in
 admonition blocks
Message-ID: <20230503104708.GJ525452@unreal>
References: <20230503094248.28931-1-bagasdotme@gmail.com>
 <20230503094248.28931-5-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503094248.28931-5-bagasdotme@gmail.com>

On Wed, May 03, 2023 at 04:42:49PM +0700, Bagas Sanjaya wrote:
> Wrap note paragraphs in note:: directive as it better fit for the
> purpose of noting devlink commands.
> 
> Fixes: f2d51e579359b7 ("net/mlx5: Separate mlx5 driver documentation into multiple pages")
> Fixes: cf14af140a5ad0 ("net/mlx5e: Add vnic devlink health reporter to representors")
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  .../ethernet/mellanox/mlx5/devlink.rst             | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

