Return-Path: <netdev+bounces-256-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEAC86F66E1
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 10:11:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0656A280CE9
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 08:11:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 961724C64;
	Thu,  4 May 2023 08:10:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF63ED4
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 08:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDB2C433D2;
	Thu,  4 May 2023 08:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683187854;
	bh=/UpneFGkuiBc6fBT402IWFznM2D8xkqe4Fw28yrUDvI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aW7TlY8VuZv8TontmNanG191obYiP+Rwh3T9tZddAQLiMplPZmqMPHo/raoeKrCvM
	 JNMTvEgofrFgNZoKEB9EAMO383wZj3Xv5bDmZa+vebzS3rZIEg7sUPeDX5p8JE6aVm
	 vRwotNYy8IwjyX/LSRf1H4bst8x1t8hRL1bdEyx4kgEWtirnjPolGle+l+W1sw0XLI
	 xuc6wOKoCvZ7OzJj+H+NVmOfiqYfhHrzP50xJI8Y/O7N6XVby/gXVwkcNBOdLBW5OD
	 SscC1rGa5+frj0ZrVHn3HGGQz0XZqhSRFuEAPxZg+ISbl14FPTq/WecdEcu6eLcsJX
	 gR36AH7K3GBzA==
Date: Thu, 4 May 2023 11:10:49 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Martin Habets <habetsm.xilinx@gmail.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, netdev@vger.kernel.org, ecree.xilinx@gmail.com,
	linux-net-drivers@amd.com
Subject: Re: [PATCH net] sfc: Add back mailing list
Message-ID: <20230504081049.GU525452@unreal>
References: <168318528134.31137.11625787711228662726.stgit@palantir17.mph.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168318528134.31137.11625787711228662726.stgit@palantir17.mph.net>

On Thu, May 04, 2023 at 08:28:01AM +0100, Martin Habets wrote:
> We used to have a mailing list in the MAINTAINERS file, but removed this
> when we became part of Xilinx as it stopped working.
> Now inside AMD we have the list again. Add it back so patches will be seen
> by all sfc developers.

They are invited to join netdev community and read mailing list directly.

> 
> Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
> ---
>  MAINTAINERS |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ebd26b3ca90e..dcab6b41ad8d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18987,6 +18987,7 @@ SFC NETWORK DRIVER
>  M:	Edward Cree <ecree.xilinx@gmail.com>
>  M:	Martin Habets <habetsm.xilinx@gmail.com>
>  L:	netdev@vger.kernel.org
> +L:	linux-net-drivers@amd.com

Is this open list or we will get bounce messages every time we send to it?

Thanks

>  S:	Supported
>  F:	Documentation/networking/devlink/sfc.rst
>  F:	drivers/net/ethernet/sfc/
> 
> 
> 

