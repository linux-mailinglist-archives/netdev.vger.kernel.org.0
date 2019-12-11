Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7DA11A51D
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 08:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbfLKHbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 02:31:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:47666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbfLKHbk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 02:31:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 088F92077B;
        Wed, 11 Dec 2019 07:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576049499;
        bh=hzi59ZxXCtn7N9u9Q1/ZsXgqE+JPAgMDiGZkiykAq3Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AqhM4EM74IqmrdcSyqwzP0zvfddYOBw3VGWlO7KbkNlDcEnsH8Fd4foqvb3+v5FHj
         oi0/VcKwejR8KAsItACMcW/2Dy6QV4sIwLlJwJJJhRz839G+2Tua+hHqhNpJqkFQ1C
         /SWUpgJYJbIKDlpVeCoFvY3VKardOOuIBvifC6rU=
Date:   Wed, 11 Dec 2019 08:31:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Scott Schafer <schaferjscott@gmail.com>
Cc:     devel@driverdev.osuosl.org, GR-Linux-NIC-Dev@marvell.com,
        Manish Chopra <manishc@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: Fix multiple WARNING and CHECK relating
 to formatting
Message-ID: <20191211073136.GB397938@kroah.com>
References: <20191211014759.4749-1-schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211014759.4749-1-schaferjscott@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 07:47:59PM -0600, Scott Schafer wrote:
> CHECK: Please don't use multiple blank lines
> CHECK: Blank lines aren't necessary before a close brace '}'
> CHECK: Blank lines aren't necessary after an open brace '{'
> WARNING: Missing a blank line after declarations
> CHECK: No space is necessary after a cast
> CHECK: braces {} should be used on all arms of this statement
> CHECK: Unbalanced braces around else statement
> WARNING: please, no space before tabs
> CHECK: spaces preferred around that '/' (ctx:VxV)
> CHECK: spaces preferred around that '+' (ctx:VxV)
> CHECK: spaces preferred around that '%' (ctx:VxV)
> CHECK: spaces preferred around that '|' (ctx:VxV)
> CHECK: spaces preferred around that '*' (ctx:VxV)
> WARNING: Unnecessary space before function pointer arguments
> WARNING: please, no spaces at the start of a line
> WARNING: Block comments use a trailing */ on a separate line
> ERROR: trailing whitespace
> 
> In files qlge.h, qlge_dbg.c, qlge_ethtool.c, qlge_main.c, and qlge_mpi.c
> 
> Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
> ---
>  drivers/staging/qlge/qlge.h         |  45 ++++++-------
>  drivers/staging/qlge/qlge_dbg.c     |  41 ++++++-----
>  drivers/staging/qlge/qlge_ethtool.c |  20 ++++--
>  drivers/staging/qlge/qlge_main.c    | 101 ++++++++++++++--------------
>  drivers/staging/qlge/qlge_mpi.c     |  37 +++++-----
>  5 files changed, 125 insertions(+), 119 deletions(-)

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
