Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C8A31C6CB
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 08:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhBPH1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 02:27:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:60468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229713AbhBPH1a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 02:27:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E593A64DDA;
        Tue, 16 Feb 2021 07:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613460407;
        bh=mxfZmhyo6JiiViYci1n2jrUW+oCJlmm/a/+n5Vq/PxY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KiD28tAngn9LjDSHvdzUK76XS4jP/vgA04i+j1tr8Q6xZhieGc+7upHCEXUgYGINN
         KY7PJhSbDVLFUCgdHWbUSyFtBvTODioHIqWW0jdzQjpiLm7stFtnb84liGfR1yUWdK
         Hy2Wfl7/Rrd/4bIMPlXEMIXNkvX6rhUzgCyTgXdY=
Date:   Tue, 16 Feb 2021 08:26:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Du Cheng <ducheng2@gmail.com>
Cc:     Manish Chopra <manishc@marvell.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] fix coding style in driver/staging/qlge/qlge_main.c
Message-ID: <YCtzs/wtXqFxUTok@kroah.com>
References: <20210216071849.174077-1-ducheng2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216071849.174077-1-ducheng2@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 03:18:49PM +0800, Du Cheng wrote:
> align * in block comments on each line
> 
> Signed-off-by: Du Cheng <ducheng2@gmail.com>
> ---
>  drivers/staging/qlge/qlge_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index 5516be3af898..bfd7217f3953 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -3816,7 +3816,7 @@ static int qlge_adapter_down(struct qlge_adapter *qdev)
>  	qlge_tx_ring_clean(qdev);
>  
>  	/* Call netif_napi_del() from common point.
> -	*/
> +	 */

Just put it on the previous line please.

Also use scripts/get_maintainer.pl to find the proper lists to send this
to in the future, you forgot the staging mailing list :(

thanks,

greg k-h
