Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30661D53E2
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgEOPLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:11:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726717AbgEOPJh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 11:09:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 448D1207C3;
        Fri, 15 May 2020 15:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589555376;
        bh=ys1V8HWNqH20yXhWtg1p2L+pPQ1fwqd8rYNvrPx95UM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lS2YsSuumgPFlql65mzaXT7bI02mBOVqmqPUIPQyGjNbMP5CjS5Yhe8iytrsPHNBA
         tLSKzTBJMMCHJ6v2uY+1HJrYDJ2cXMayZvliNSfnz/+NIV5gi36XTpsgnxCH9qfbCy
         cFaTWRXjEkqX+lEvr958G7qHow4nV5GAWGgH7OoI=
Date:   Fri, 15 May 2020 17:09:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 05/19] staging: wfx: fix coherency of hif_scan() prototype
Message-ID: <20200515150934.GA2573363@kroah.com>
References: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
 <20200515083325.378539-6-Jerome.Pouiller@silabs.com>
 <20200515135359.GA2162457@kroah.com>
 <15113296.vvBLmrQuJQ@pc-42>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <15113296.vvBLmrQuJQ@pc-42>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 05:03:40PM +0200, Jérôme Pouiller wrote:
> On Friday 15 May 2020 15:53:59 CEST Greg Kroah-Hartman wrote:
> > On Fri, May 15, 2020 at 10:33:11AM +0200, Jerome Pouiller wrote:
> > > From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > >
> > > The function hif_scan() return the timeout for the completion of the
> > > scan request. It is the only function from hif_tx.c that return another
> > > thing than just an error code. This behavior is not coherent with the
> > > rest of file. Worse, if value returned is positive, the caller can't
> > > make say if it is a timeout or the value returned by the hardware.
> > >
> > > Uniformize API with other HIF functions, only return the error code and
> > > pass timeout with parameters.
> > >
> > > Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > > ---
> > >  drivers/staging/wfx/hif_tx.c | 6 ++++--
> > >  drivers/staging/wfx/hif_tx.h | 2 +-
> > >  drivers/staging/wfx/scan.c   | 6 +++---
> > >  3 files changed, 8 insertions(+), 6 deletions(-)
> > 
> > This patch fails to apply to my branch, so I've stopped here in the
> > patch series.
> 
> Hello Greg,
> 
> Did you applied the patch called "staging: wfx: unlock on error path" from
> Dan?

I have no idea :)

> (I wrote that information in the introduction letter, but maybe I would
> had include the Dan's patch in my PR?)

I think you should have, as my queue is empty now.

thanks,

greg k-h
