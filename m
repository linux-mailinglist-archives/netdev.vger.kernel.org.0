Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A02853A4EC
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 12:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbfFIK7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 06:59:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728029AbfFIK7S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Jun 2019 06:59:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C19FD2083D;
        Sun,  9 Jun 2019 10:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560077958;
        bh=rwSR3o1mv7zWnCRQ7zDWKuYNCzMiZtQnKYlpzI1SHOA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fa586/Nq76fAtEB8nXsQvlJD11gR/Z7mszDYU5HMV9dfRfItXyaUpLfMgfvt4tG3C
         5iZpQxmdpLGyXXZfXYkNwZxEKshPryB2lpBGJldouR7i0KKGUYyIzg2NzgdxbBLYu2
         SH76ke4aksII0NxvnGqEuIlrFrBgcnmL5Oc0ZgrQ=
Date:   Sun, 9 Jun 2019 12:59:09 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Rishiraj Manwatkar <manwatkar@outlook.com>
Cc:     "isdn@linux-pingi.de" <isdn@linux-pingi.de>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] staging: isdn: To make hysdn_proc_entry static.
Message-ID: <20190609105909.GA30671@kroah.com>
References: <VE1PR09MB31685C49AD00EC2206C471E5A4120@VE1PR09MB3168.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VE1PR09MB31685C49AD00EC2206C471E5A4120@VE1PR09MB3168.eurprd09.prod.outlook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 09, 2019 at 12:24:59AM +0000, Rishiraj Manwatkar wrote:
> 	Made hysdn_proc_entry static as suggested by Sparse tool.

Why is this indented?

> 
> Signed-off-by: Rishiraj Manwatkar <manwatkar@outlook.com>
> ---
>  drivers/staging/isdn/hysdn/hysdn_procconf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/isdn/hysdn/hysdn_procconf.c b/drivers/staging/isdn/hysdn/hysdn_procconf.c
> index 73079213ec94..3d12c058a6f1 100644
> --- a/drivers/staging/isdn/hysdn/hysdn_procconf.c
> +++ b/drivers/staging/isdn/hysdn/hysdn_procconf.c
> @@ -349,7 +349,7 @@ static const struct file_operations conf_fops =
>  /*****************************/
>  /* hysdn subdir in /proc/net */
>  /*****************************/
> -struct proc_dir_entry *hysdn_proc_entry = NULL;
> +static struct proc_dir_entry *hysdn_proc_entry = NULL;

I will have to wait until after 5.3-rc1 before taking any
drivers/staging/isdn patches, sorry.

I suggest waiting until then before resending, and even then, the isdn
code is about to be deleted, try working on code that is being accepted.

thanks,

greg k-h
