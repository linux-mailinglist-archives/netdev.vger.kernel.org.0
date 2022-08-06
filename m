Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D8158B3E5
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 06:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238943AbiHFErP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 00:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237545AbiHFErO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 00:47:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEC813F9F;
        Fri,  5 Aug 2022 21:47:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 170F1603F3;
        Sat,  6 Aug 2022 04:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E1DC433D7;
        Sat,  6 Aug 2022 04:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659761231;
        bh=umWU3SWBI08h0u6WT2+UDZdJBDz3n6iZGhmoXS0+tQw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c/oSw+Jl0BRMHNMjI00sTjbn7PwlBBK3BKvBE42RZBeQEVrpUInF53gjNtT8AuHb+
         67XV4+vUepZ6GfZWCT2xesOmzYLhOIB7Um+NilaW0KW1O1ZBGgLi8e39PQPlTio9pK
         f8wVZ6v+043NOzcEmCal5rE/ZFj0eG8TVv8IEn/g=
Date:   Sat, 6 Aug 2022 06:47:09 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jose Alonso <joalonsof@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Ronald Wahl <ronald.wahl@raritan.com>
Subject: Re: [PATCH net] net: usb: ax88179_178a have issues with FLAG_SEND_ZLP
Message-ID: <Yu3yTXS/y2cVzF8S@kroah.com>
References: <b0f0a44a72bdcbca2573aaa5cdb3ed2de233fbdd.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0f0a44a72bdcbca2573aaa5cdb3ed2de233fbdd.camel@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 05, 2022 at 05:02:22PM -0300, Jose Alonso wrote:
>     The usage of FLAG_SEND_ZLP causes problems to other firmware/hardware
>     versions that have no issues.
>     
>     The FLAG_SEND_ZLP is not safe to use in this context.
>     See:
>     https://patchwork.ozlabs.org/project/netdev/patch/1270599787.8900.8.camel@Linuxdev4-laptop/#118378
>     
>     Reported-by: Ronald Wahl <ronald.wahl@raritan.com>
>     Link: https://bugzilla.kernel.org/show_bug.cgi?id=216327
>     Link: https://bugs.archlinux.org/task/75491
>     
>     Fixes: 36a15e1cb134 ("net: usb: ax88179_178a needs FLAG_SEND_ZLP")
>     Signed-off-by: Jose Alonso <joalonsof@gmail.com>

Odd, why the indentaion of the whole changelog?

>     
>     --

That should have been "---", did you hand edit this?  Git should give
you all of this properly for free.

And, as my bot will say:

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

And:


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
