Return-Path: <netdev+bounces-257-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10DB76F66EF
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 10:13:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0D75280C8F
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 08:13:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D021B4A31;
	Thu,  4 May 2023 08:12:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEF410EC
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 08:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B469C433EF;
	Thu,  4 May 2023 08:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683187978;
	bh=lw5bGqmQmlqX8tgBw7ja1cDkM+Gc6V5MlhP8g2TZBng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F8OxTNd+lz/QfW0Hy6B095VVDbNcaE/rWJFD5fkO6Zbpl30M/DmZKxyAjm6BWKinr
	 /ooRbnD11pN5PryselhUk+LjMG2tF7NlyzUiOleQReuvmi9aGEKP43WaFiHphfAbV2
	 dJVCAIlif05C2Gjgk9P8gDvGObCCtR3fh5wO0n51j9U6rIZgU+HBEeeEiYPpBxXL59
	 I2aBXuqymUbqoZWYVetYrSrZT4IS0qxSrmL6GXjW1bLOElWk3o2Mz/FZ4wtMil7DIg
	 eu3ZW86fXPiI+tnX25L/gOT9vF0bckzn2t5X+JPeXnituxejk2cV0qXyy5BzQYsP6S
	 5ZlQ/JHCdXXUQ==
Date: Thu, 4 May 2023 11:12:53 +0300
From: Leon Romanovsky <leon@kernel.org>
To: wei.fang@nxp.com
Cc: claudiu.manoil@nxp.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: enetc: check the index of the SFI rather than
 the handle
Message-ID: <20230504081253.GV525452@unreal>
References: <20230504080400.3036266-1-wei.fang@nxp.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504080400.3036266-1-wei.fang@nxp.com>

On Thu, May 04, 2023 at 04:03:59PM +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> We should check whether the current SFI (Stream Filter Instance) table
> is full before creating a new SFI entry. However, the previous logic
> checks the handle by mistake and might lead to unpredictable behavior.
> 
> Fixes: 888ae5a3952b ("net: enetc: add tc flower psfp offload driver")
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc_qos.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

