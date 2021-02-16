Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F35131C6FF
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 08:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhBPHwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 02:52:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:35192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhBPHv7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 02:51:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3241264DDA;
        Tue, 16 Feb 2021 07:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613461878;
        bh=5QK6asyC9UTS+nh4p/KDBJlmjLE9RWADp20DtO6UjL0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y9XCxbWAzuDwHiWXW6XSkl7ERVY3JVICFiTjpJ9uBnFn+WDLu/TUxSqjAlEHIpOU0
         /vdp3qZ3YBhGGIfPSXiRIf2HQ7K/ZQ44cu2aTGjMwJN/yYpKstp7pNTaZqK7qVIH1X
         aIg8Rn2xzIiJd1DHBkm4j350zCVjlC1+NBxDgexM=
Date:   Tue, 16 Feb 2021 08:51:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Du Cheng <ducheng2@gmail.com>
Cc:     Manish Chopra <manishc@marvell.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] fix coding style in driver/staging/qlge/qlge_main.c
Message-ID: <YCt5cYeS0sZjS2V+@kroah.com>
References: <20210216073526.175212-1-ducheng2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216073526.175212-1-ducheng2@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 03:35:26PM +0800, Du Cheng wrote:
> align * in block comments on each line
> 
> Signed-off-by: Du Cheng <ducheng2@gmail.com>
> ---
>  drivers/staging/qlge/qlge_main.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index 5516be3af898..2682a0e474bd 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -3815,8 +3815,7 @@ static int qlge_adapter_down(struct qlge_adapter *qdev)
>  
>  	qlge_tx_ring_clean(qdev);
>  
> -	/* Call netif_napi_del() from common point.
> -	*/
> +	/* Call netif_napi_del() from common point. */
>  	for (i = 0; i < qdev->rss_ring_count; i++)
>  		netif_napi_del(&qdev->rx_ring[i].napi);
>  
> -- 
> 2.27.0
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- You did not write a descriptive Subject: for the patch, allowing Greg,
  and everyone else, to know what this patch is all about.  Please read
  the section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what a proper Subject: line should
  look like.

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/SubmittingPatches for what needs to be done
  here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
