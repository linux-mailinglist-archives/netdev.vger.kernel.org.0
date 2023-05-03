Return-Path: <netdev+bounces-109-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A67566F52F6
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:18:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 424E6281206
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 08:18:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ACF0746A;
	Wed,  3 May 2023 08:18:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23A7EDA
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 08:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B541BC433D2;
	Wed,  3 May 2023 08:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683101879;
	bh=I93VuRN7MMvO6ddsjYz/gykOlYucssQ2dEEPQ3MBwxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hrWagpQX8gRjQvC+Nu06GHYoMnkLW+Y4sfHSBEBvMgvuLaVChjN/xruf6JkAuliwS
	 7XgtuV1YXa1BvWbU0cfpVLJJHftnk5T0rjfQYF4emGW1FVtHdyn5zEQEtXPDAGmOxd
	 PTIkutQeTECUxQw+e6yZkhjDmFsP6OcUdzo+jCEzxheXVR2K+OnZ405oVDUkONhFkf
	 Bp3SkGzJ4BqF+qdzNfm99cZ9+YuLGRPVaWDgc5yDPBpyeZ70G5A79PGSy/lf5xScYN
	 zZ7rt+aK9hut4Sz4on3Xet3rfru0in8TIEFrFVKlWTh0eGw8orwgbkq3Dg0IKwMMzK
	 KE8T6Wc14zlhg==
Date: Wed, 3 May 2023 11:17:54 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
	drivers@pensando.io
Subject: Re: [PATCH net] pds_core: remove CONFIG_DEBUG_FS from makefile
Message-ID: <20230503081754.GG525452@unreal>
References: <20230502202752.13350-1-shannon.nelson@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502202752.13350-1-shannon.nelson@amd.com>

On Tue, May 02, 2023 at 01:27:52PM -0700, Shannon Nelson wrote:
> This cruft from previous drafts should have been removed when
> the code was updated to not use the old style dummy helpers.
> 
> Fixes: 55435ea7729a ("pds_core: initial framework for pds_core PF driver")
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/net/ethernet/amd/pds_core/Makefile | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

