Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DED53C1551
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 16:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhGHOnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 10:43:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229738AbhGHOnJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 10:43:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36E2161626;
        Thu,  8 Jul 2021 14:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625755227;
        bh=MAsG3qSXfa86mRK76E2s86ws4T9P2wCUYmiHN8otjks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qvATOC6gyo8yYJJC/n4YlM9JT0Gv5Ts61H3FTKx00SElcUROyVpDAIkKCtwtXcAX/
         jyWGuT6u9PM139Bbe51z69jfJCi2kRM257QjUTUMu4TdfUNvQHr763zVSLZ/bdfA3W
         KNtA5YvaUj447Xg8+Id01Gf7hDdytOsFQMI8M+D8=
Date:   Thu, 8 Jul 2021 16:40:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Carlos Bilbao <bilbao@vt.edu>
Cc:     alexander.deucher@amd.com, davem@davemloft.net,
        mchehab+huawei@kernel.org, kuba@kernel.org,
        James.Bottomley@hansenpartnership.com, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: Follow the indentation coding standard on
 printks
Message-ID: <YOcOWDqlONm69zwo@kroah.com>
References: <2784471.e9J7NaK4W3@iron-maiden>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2784471.e9J7NaK4W3@iron-maiden>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 08, 2021 at 09:10:01AM -0400, Carlos Bilbao wrote:
> Fix indentation of printks that start at the beginning of the line. Change this 
> for the right number of space characters, or tabs if the file uses them. 
> 
> Signed-off-by: Carlos Bilbao <bilbao@vt.edu>
> ---
>  drivers/atm/eni.c                      | 2 +-
>  drivers/atm/iphase.c                   | 2 +-
>  drivers/atm/suni.c                     | 4 ++--
>  drivers/atm/zatm.c                     | 8 ++++----
>  drivers/net/ethernet/dec/tulip/de4x5.c | 2 +-
>  drivers/net/sb1000.c                   | 4 ++--
>  drivers/parisc/iosapic.c               | 4 ++--
>  drivers/parisc/sba_iommu.c             | 2 +-
>  8 files changed, 14 insertions(+), 14 deletions(-)

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

- Your patch did many different things all at once, making it difficult
  to review.  All Linux kernel patches need to only do one thing at a
  time.  If you need to do multiple things (such as clean up all coding
  style issues in a file/driver), do it in a sequence of patches, each
  one doing only one thing.  This will make it easier to review the
  patches to ensure that they are correct, and to help alleviate any
  merge issues that larger patches can cause.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
