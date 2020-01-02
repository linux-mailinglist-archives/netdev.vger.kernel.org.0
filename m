Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47EAA12E593
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 12:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgABLQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 06:16:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:55834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728115AbgABLQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 06:16:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 186F6217F4;
        Thu,  2 Jan 2020 11:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577963815;
        bh=sSSSJ8ifsPR9hBm/oLWc3nWtuHM8c0p+74Uqt6dnvps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GkTkSmBcb38g2LmL8koBMfB4pIbvjbX32IsWFtqt7ldEesewHy2q3VJThO6HC1QM2
         NcxSECCE0telsm8gkd9gT2FopLJJP1LRAHr0jCpplvtGiDcmKXTWV4wJuilZPdrOn7
         vS3PfaoF9ipPZ4BjSEo4srOKQCT54+XWgaQeTCqQ=
Date:   Thu, 2 Jan 2020 12:16:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amrita Patole <longlivelinux@yahoo.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Amrita Patole <amritapatole@gmail.com>
Subject: Re: [PATCH] Fixing coding style. Signed-off-by:
 amritapatole@gmail.com
Message-ID: <20200102111653.GB3961630@kroah.com>
References: <20200102072929.21636-1-longlivelinux.ref@yahoo.com>
 <20200102072929.21636-1-longlivelinux@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102072929.21636-1-longlivelinux@yahoo.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 02, 2020 at 12:59:29PM +0530, Amrita Patole wrote:
> From: Amrita Patole <amritapatole@gmail.com>
> 
> ---
>  drivers/staging/qlge/qlge_mpi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
> index 9e422bbbb6ab..f63db2c79fac 100644
> --- a/drivers/staging/qlge/qlge_mpi.c
> +++ b/drivers/staging/qlge/qlge_mpi.c
> @@ -136,7 +136,8 @@ static int ql_get_mb_sts(struct ql_adapter *qdev, struct mbox_params *mbcp)
>  		    ql_read_mpi_reg(qdev, qdev->mailbox_out + i,
>  				     &mbcp->mbox_out[i]);
>  		if (status) {
> -			netif_err(qdev, drv, qdev->ndev, "Failed mailbox read.\n");
> +			netif_err(qdev, drv, qdev->ndev,
> +                                  "Failed mailbox read. \n");
>  			break;
>  		}
>  	}
> -- 
> 2.20.1

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

- Your patch does not have a Signed-off-by: line.  Please read the
  kernel file, Documentation/SubmittingPatches and resend it after
  adding that line.  Note, the line needs to be in the body of the
  email, before the patch, not at the bottom of the patch or in the
  email signature.

- You did not specify a description of why the patch is needed, or
  possibly, any description at all, in the email body.  Please read the
  section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what is needed in order to
  properly describe the change.

- You did not write a descriptive Subject: for the patch, allowing Greg,
  and everyone else, to know what this patch is all about.  Please read
  the section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what a proper Subject: line should
  look like.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
