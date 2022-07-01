Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E54C562BFE
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 08:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbiGAGvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 02:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbiGAGvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 02:51:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC4348838;
        Thu, 30 Jun 2022 23:51:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DC90B82E39;
        Fri,  1 Jul 2022 06:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501E3C3411E;
        Fri,  1 Jul 2022 06:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656658264;
        bh=WYAqg0oikTaIjRA7PucH60yRMReGtRCz0Qahgb5/Qa4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OKeIKCM6eKVqr880J2WzA16mhXOToiW9Bk5uMvMmn+jzvE5YgdwF6bwTNcn7Ms7jt
         Py6HgEkvtrlJ4FeI7d/RRbpSKBXOpBXLCQbTs1BH6j7ehJve++hlLKyN7sXNv7qCY0
         lSl7dofydE2xJGfTbmcAtxVkxUSwVzyeMFoGsFcU=
Date:   Fri, 1 Jul 2022 08:51:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Li kunyu <kunyu@nfschina.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v2] net: usb: Fix typo in code
Message-ID: <Yr6ZVZH+b8oAZdHc@kroah.com>
References: <Yr6R/wsl+HlOwOEm@kroah.com>
 <20220701064723.2935-1-kunyu@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701064723.2935-1-kunyu@nfschina.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 02:47:23PM +0800, Li kunyu wrote:
> Remove the repeated ';' from code.
> 
> Signed-off-by: Li kunyu <kunyu@nfschina.com>
> ---
>  drivers/net/usb/catc.c | 2 +-
>  1 file changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/usb/catc.c b/drivers/net/usb/catc.c
> index e7fe9c0f63a9..268c32521691 100644
> --- a/drivers/net/usb/catc.c
> +++ b/drivers/net/usb/catc.c
> @@ -781,7 +781,7 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
>  			intf->altsetting->desc.bInterfaceNumber, 1)) {
>  		dev_err(dev, "Can't set altsetting 1.\n");
>  		ret = -EIO;
> -		goto fail_mem;;
> +		goto fail_mem;
>  	}
>  
>  	netdev = alloc_etherdev(sizeof(struct catc));
> -- 
> 2.18.2
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
