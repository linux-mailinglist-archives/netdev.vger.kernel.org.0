Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25E5E35F12
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 16:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbfFEOUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 10:20:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727893AbfFEOUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 10:20:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26DEC20866;
        Wed,  5 Jun 2019 14:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559744437;
        bh=YJFidk1qyJXgXZTyC/dTIMXQADIcivIer6UuGe9JjpM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zbLd49e+BEyXdJ+c7KiopZLS7bK9yg9A2KM+0FiFY41iSSwyu87sNZ/SUaAac9tjR
         NasvIBbrnm5oc6ncTm37edz8CNuB1fOojYHgTQYIm+tv6tarUVzI0KFSSnrC+WOdre
         3o/aoLWgUYuZGTkXJMCbpx4gkH4ZKJQulhgL90sg=
Date:   Wed, 5 Jun 2019 16:20:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Valerio Genovese <valerio.click@gmail.com>
Cc:     isdn@linux-pingi.de, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: isdn: hysdn: fix symbol 'hysdn_proc_entry' was
 not declared.
Message-ID: <20190605142034.GA8803@kroah.com>
References: <20190605135349.6840-1-valerio.click@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605135349.6840-1-valerio.click@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 03:53:49PM +0200, Valerio Genovese wrote:
> This was reported by sparse:
> drivers/staging/isdn/hysdn/hysdn_procconf.c:352:23: warning: symbol 'hysdn_proc_entry' was not declared. Should it be static?
> 
> Signed-off-by: Valerio Genovese <valerio.click@gmail.com>
> ---
>  drivers/staging/isdn/hysdn/hysdn_defs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/isdn/hysdn/hysdn_defs.h b/drivers/staging/isdn/hysdn/hysdn_defs.h
> index cdac46a21692..a651686b1787 100644
> --- a/drivers/staging/isdn/hysdn/hysdn_defs.h
> +++ b/drivers/staging/isdn/hysdn/hysdn_defs.h
> @@ -221,7 +221,7 @@ typedef struct hycapictrl_info hycapictrl_info;
>  /* exported vars */
>  /*****************/
>  extern hysdn_card *card_root;	/* pointer to first card */
> -
> +extern struct proc_dir_entry *hysdn_proc_entry; /* hysdn subdir in /proc/net
>  
>  
>  /*************************/

Shouldn't you also remove it from the place it was devlared as extern?

Also, this is code on its way out of the kernel, not a big deal to leave
it alone for now.

thanks,

greg k-h
