Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC1E136D4D
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 13:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgAJMsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 07:48:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:56674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728074AbgAJMsg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 07:48:36 -0500
Received: from localhost (83-84-126-242.cable.dynamic.v4.ziggo.nl [83.84.126.242])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6AD220721;
        Fri, 10 Jan 2020 12:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578660514;
        bh=PrOwLV4tQ+lI1OTRTBOIvMq4rzUtK4hs298T1zbtacE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SqTugStLNX+pRuf7gCMwoCYvksuMTTptT58RIF20ZMu0BuGuSKdAgAOCm2EpLitWS
         vOKTErvPU5Vix3nOBAjLY2i/QSuzMn9A8/SjgDVkeP91isX2HSNZxtKNab0JneFEDr
         0PKqLX4fOdY06u/Xr50selEkwSjtOc5hITYJORCc=
Date:   Fri, 10 Jan 2020 13:48:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexander X Sverdlin <alexander.sverdlin@nokia.com>
Cc:     devel@driverdev.osuosl.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] staging: octeon: Drop on uncorrectable alignment or FCS
 error
Message-ID: <20200110124832.GA1090147@kroah.com>
References: <20200108161042.253618-1-alexander.sverdlin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108161042.253618-1-alexander.sverdlin@nokia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 05:10:42PM +0100, Alexander X Sverdlin wrote:
> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> 
> Currently in case of alignment or FCS error if the packet cannot be
> corrected it's still not dropped. Report the error properly and drop the
> packet while making the code around a little bit more readable.
> 
> Fixes: 80ff0fd3ab ("Staging: Add octeon-ethernet driver files.")
> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> ---
>  drivers/staging/octeon/ethernet-rx.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)

This driver is now deleted from the tree, sorry.

greg k-h
