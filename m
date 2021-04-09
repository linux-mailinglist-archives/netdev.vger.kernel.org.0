Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A80359E31
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 14:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbhDIMEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 08:04:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231370AbhDIMEf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 08:04:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B019610A4;
        Fri,  9 Apr 2021 12:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617969862;
        bh=uZyNGqVC6Yt6ju9PZIMEGqmzgtRZ1yA7z5VHXQfaHwk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T/w1opDDdhgMXMm67IUaT9bv1ojR+XIqmDNP+0DGWHWZkKJvWD8iXMWCfMusiX6c8
         TDTvqffr/xrfZ2znLYWja6LaxRmGTfzHEA0lQ8AQfWhIIT+d9lG31JML61Y22CZkVI
         DyF2uDzxQLn2oZApN92qxBkVZbiDl0bgk0TDCziE=
Date:   Fri, 9 Apr 2021 13:32:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Koen Vandeputte <koen.vandeputte@citymesh.com>,
        linux-can@vger.kernel.org, wg@grandegger.com,
        netdev@vger.kernel.org, qiangqing.zhang@nxp.com
Subject: Re: flexcan introduced a DIV/0 in kernel
Message-ID: <YHA7X5w8cLuelWll@kroah.com>
References: <5bdfcccb-0b02-e46b-eefe-7df215cc9d02@citymesh.com>
 <27f66de1-42bc-38d9-8a1c-7062eb359958@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27f66de1-42bc-38d9-8a1c-7062eb359958@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 01:21:05PM +0200, Marc Kleine-Budde wrote:
> On 4/9/21 12:18 PM, Koen Vandeputte wrote:
> > Hi All,
> > 
> > I just updated kernel 4.14 within OpenWRT from 4.14.224 to 4.14.229
> > Booting it shows the splat below on each run. [1]
> > 
> > 
> > It seems there are 2 patches regarding flexcan which were introduced in 
> > 4.14.226
> > 
> > --> ce59ffca5c49 ("can: flexcan: enable RX FIFO after FRZ/HALT valid")
> > --> bb7c9039a396 ("can: flexcan: assert FRZ bit in flexcan_chip_freeze()")
> > 
> > Reverting these fixes the splat.
> 
> This patch should fix the problem:
> 
> 47c5e474bc1e can: flexcan: flexcan_chip_freeze(): fix chip freeze for missing
> bitrate
> 
> Greg, can you pick this up for v4.14?

Now queued up, thanks.

greg k-h
