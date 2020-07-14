Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A6221E7DF
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 08:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgGNGGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 02:06:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgGNGGb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 02:06:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 452AC20890;
        Tue, 14 Jul 2020 06:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594706790;
        bh=ez70MfdjR7K3EBjfRYjJ3zjR0wlAyQw1+DFMslUhBP0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gq0HT9FR0J7BbwZtl32zJtbFIrmMHwMNGPtRV1wIGiSu+VnJVkeyEaEdXm+UhvcvN
         BzI2rUWrqI43jeMQ2+S2G0SbfmCSES/eYvoenGuj7G7WOXgOMPADwNEcecrBYmPTw8
         c5hTA/TxXNcyBI8UKtMzw53QpgYx2+WGJ7Kw3CqY=
Date:   Tue, 14 Jul 2020 08:06:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?Wxcaf=E9?= <wxcafe@wxcafe.net>
Cc:     Miguel =?iso-8859-1?Q?Rodr=EDguez_P=E9rez?= 
        <miguel@det.uvigo.gal>, oliver@neukum.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/4] Simplify usbnet_cdc_update_filter
Message-ID: <20200714060628.GC657428@kroah.com>
References: <20180701081550.GA7048@kroah.com>
 <20180701090553.7776-1-miguel@det.uvigo.gal>
 <20180701090553.7776-2-miguel@det.uvigo.gal>
 <b02575d7937188167ed711a403e6d9fa3f80e60d.camel@wxcafe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b02575d7937188167ed711a403e6d9fa3f80e60d.camel@wxcafe.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 04:43:11PM -0400, Wxcafé wrote:
> Hey,
> 
> I've encountered that same problem a few days ago, found this thread
> and these (unmerged) patches, "ported" them to a more current version
> of the kernel (wasn't much work, let's be honest), and I was wondering
> if it would be possible to get them merged, because this is still a
> problem with cdc_ncm.
> 
> Here's the three "up to date" patches (based on 5.8-rc5), they work
> insofar as I'm running with them, the bug isn't there anymore (I get
> ethernet multicast packets correctly), and there's no obvious bug. I'm
> not a dev though, so I have no idea if these are formatted correctly,
> if the patch separation is correct, or anything like that, I just think
> it would be great if this could be merged into mainline!

You need to submit them in a format they can be applied in, as well as
taking care of the issues that caused Oliver to not agree with them.

thanks,

greg k-h
