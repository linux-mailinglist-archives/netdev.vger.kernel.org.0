Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D6C17F416
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 10:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgCJJtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 05:49:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbgCJJtW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 05:49:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBF212467D;
        Tue, 10 Mar 2020 09:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583833762;
        bh=x8X/YEDij3sUMNR8UweeVcfkzvy7t7V+waAwpz4gTsk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NBwTpK4869B7VgTGp9H9T3iIMgxKP8GaLoo+23O+CPSj6PChfg7e+cCO9MC3AViTM
         QMyVFknuKY5+CwdZFIr5GTY1GNKVu5XVvuqorsHUIa6QfqYacQdgIMST1zFAYWzjsC
         fxFqLRFbnE0m/Q4IZfPYUwSWFWvZOumiX6TvQUjk=
Date:   Tue, 10 Mar 2020 10:49:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jarrett Knauer <jrtknauer@gmail.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 00/10] qlge.h cleanup - first pass
Message-ID: <20200310094920.GA2516963@kroah.com>
References: <cover.1583647891.git.jrtknauer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1583647891.git.jrtknauer@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 07, 2020 at 11:23:14PM -0700, Jarrett Knauer wrote:
> This patchset cleans up some warnings and checks issued by checkpatch.pl
> for staging: qlge: qlge.h as an effort to eventually bring the qlge TODO
> count to zero.
> 
> There are still many CHECKs and WARNINGs for qlge.h, of which some are
> false-positives or odd instances which I plan on returning to after
> getting some more experience with the driver.
> 
> Jarrett Knauer (10):
>   staging: qlge: removed leading spaces identified by checkpatch.pl
>   staging: qlge: checkpatch.pl CHECK - removed unecessary blank line
>   staging: qlge: checkpatch.pl WARNING - removed spaces before tabs
>   staging: qlge: checkpatch.pl CHECK - added spaces around /
>   staging: qlge: checkpatch.pl WARNING - removed spaces before tabs
>   staging: qlge: checkpatch.pl CHECK - added spaces around %
>   staging: qlge: checkpatch.pl CHECK - removed blank line following
>     brace
>   staging: qlge: checkpatch.pl CHECK - removed blank line after brace
>   staging: qlge: checkpatch.pl WARNING - removed function pointer space
>   staging: qlge: checkpatch.pl WARNING - missing blank line
> 
>  drivers/staging/qlge/qlge.h | 42 ++++++++++++++++++-------------------
>  1 file changed, 20 insertions(+), 22 deletions(-)

I only received 8 of these patches :(

Can you please fix up and resend all of them?

thanks,

greg k-h
