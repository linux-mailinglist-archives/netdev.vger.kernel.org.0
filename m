Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757BA288612
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 11:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733139AbgJIJjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 05:39:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728014AbgJIJjr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 05:39:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C8A722258;
        Fri,  9 Oct 2020 09:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602236386;
        bh=RiPdu2xnznmwFlrhyCIO21H1HDnSPUFZi24it9/7DmI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RohFRqNR2Geya7oIgV4XtvPDv5p6uR2j2LL3thxSCrw3smEF0o4eBQc9oJXMMf5xU
         VIn3usbKwdxP/I3KkWNh7fVaCgYVRHEY/1e7Da1GxC2dfM4IStAJrYe4yE6XbGaDdz
         tld2JbW6GFmcAuRSWnSjzQuEVdrl27CiE2gpRwZQ=
Date:   Fri, 9 Oct 2020 11:40:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexander Sverdlin <alexander.sverdlin@nokia.com>
Cc:     devel@driverdev.osuosl.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] staging: octeon: Drop on uncorrectable alignment or FCS
 error
Message-ID: <20201009094033.GA486675@kroah.com>
References: <20200108161042.253618-1-alexander.sverdlin@nokia.com>
 <20200110124832.GA1090147@kroah.com>
 <4fc15baf-313b-27fc-b2e6-46552d6a1630@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fc15baf-313b-27fc-b2e6-46552d6a1630@nokia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 09, 2020 at 11:34:47AM +0200, Alexander Sverdlin wrote:
> Hello Greg,
> 
> On 10/01/2020 13:48, Greg Kroah-Hartman wrote:
> > On Wed, Jan 08, 2020 at 05:10:42PM +0100, Alexander X Sverdlin wrote:
> >> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> >>
> >> Currently in case of alignment or FCS error if the packet cannot be
> >> corrected it's still not dropped. Report the error properly and drop the
> >> packet while making the code around a little bit more readable.
> >>
> >> Fixes: 80ff0fd3ab ("Staging: Add octeon-ethernet driver files.")
> >> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> >> ---
> >>  drivers/staging/octeon/ethernet-rx.c | 18 +++++++++---------
> >>  1 file changed, 9 insertions(+), 9 deletions(-)
> > 
> > This driver is now deleted from the tree, sorry.
> 
> Now that the driver is restored, would you please consider this patch again?

Feel free to submit it again if you feel it is still needed.

thanks,

greg k-h
