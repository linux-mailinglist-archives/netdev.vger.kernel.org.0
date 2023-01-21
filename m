Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6AC6764EA
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 08:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjAUHW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 02:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjAUHWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 02:22:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB646E40C;
        Fri, 20 Jan 2023 23:22:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC56AB82A2B;
        Sat, 21 Jan 2023 07:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC40C433D2;
        Sat, 21 Jan 2023 07:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674285741;
        bh=Q46aDo5XwLJPjm2uOBtn3vHeb9D259JKNiPEH8WSJ0U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mGqiy+3l5XFHVHcy03XzYZmNJgN2Sqo8dJMeSOH9gSASyqOGFvTuENZmO75QFEO4c
         IBKklzYa4BKgjtrIK3fMmiwiYdv3XVcTQXSfY5ShdhPPqF7+/7DniYzC6jYFyhVeqh
         adjtF3+W/uYJ9nzjXzyUDImIA+1wqMlrySn5tKgY=
Date:   Sat, 21 Jan 2023 08:22:18 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jaewan Kim <jaewan@google.com>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com, adelva@google.com
Subject: Re: [PATCH v4 0/2] mac80211_hwsim: Add PMSR support
Message-ID: <Y8uSqgjXH1WcZKBC@kroah.com>
References: <20230120174934.3528469-1-jaewan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120174934.3528469-1-jaewan@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 05:49:32PM +0000, Jaewan Kim wrote:
> Dear Kernel maintainers,
> 
> I'm proposing series of CLs for adding PMSR support in the mac80211_hwsim.
> 
> PMSR (peer measurement) is generalized measurement between STAs,
> and currently FTM (fine time measurement or flight time measurement)
> is the one and only measurement.
> 
> FTM measures the RTT (round trip time) and FTM can be used to measure
> distances between two STAs. RTT is often referred as 'measuring distance'
> as well.
> 
> 
> Kernel had already defined protocols for PMSR in the
> include/uapi/linux/nl80211.h and relevant parsing/sending code are in the
> net/wireless/pmsr.c, but they are only used in intel's iwlwifi driver.
> 
> This series of CLs are the first attempt to utilize PMSR in the mac80211_hwsim.
> 
> CLs are tested with iw tool on Virtual Android device (a.k.a. Cuttlefish).
> Hope this explains my CLs.
> 
> Many Thanks,
> 
> 
> Jaewan Kim (2):
>   mac80211_hwsim: add PMSR capability support
>   mac80211_hwsim: handle FTM requests with virtio
> 
>  drivers/net/wireless/mac80211_hwsim.c | 827 +++++++++++++++++++++++++-
>  drivers/net/wireless/mac80211_hwsim.h |  56 +-
>  include/net/cfg80211.h                |  20 +
>  net/wireless/nl80211.c                |  28 +-
>  4 files changed, 913 insertions(+), 18 deletions(-)
> 
> -- 
> 2.39.0.246.g2a6d74b583-goog
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

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/process/submitting-patches.rst for what
  needs to be done here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
