Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8BE49E349
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 14:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241662AbiA0NXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 08:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241798AbiA0NXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 08:23:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2A1C06174E;
        Thu, 27 Jan 2022 05:22:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 776CBB82213;
        Thu, 27 Jan 2022 13:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9863FC340E4;
        Thu, 27 Jan 2022 13:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643289772;
        bh=gw18Fbvfp/ZEQuA9OJdXjIR6yRIzDEoPY96pix/ilGQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D/idt8ra099XTl6YPGYstQELWlBsoUXLp9amRf+aqvj1IcC9/fD8ktbfl/zC+nPGk
         oDoSzzufNCZLCwTITvC548tMScQNDXlGs81N7y19jcub9YNquaKkWXtJxmAC+G4zhS
         EfIsahAmL1vV5aIUM/f66fTODwMzOGBQay+z183M=
Date:   Thu, 27 Jan 2022 14:22:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] usbnet: add devlink support
Message-ID: <YfKcqcq4Ii1qu2+8@kroah.com>
References: <20220127110742.922752-1-o.rempel@pengutronix.de>
 <YfJ+ceEzvzMM1JsW@kroah.com>
 <20220127123152.GF9150@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127123152.GF9150@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 01:31:52PM +0100, Oleksij Rempel wrote:
> On Thu, Jan 27, 2022 at 12:13:53PM +0100, Greg KH wrote:
> > On Thu, Jan 27, 2022 at 12:07:42PM +0100, Oleksij Rempel wrote:
> > > The weakest link of usbnet devices is the USB cable.
> > 
> > The weakest link of any USB device is the cable, why is this somehow
> > special to usbnet devices?
> > 
> > > Currently there is
> > > no way to automatically detect cable related issues except of analyzing
> > > kernel log, which would differ depending on the USB host controller.
> > > 
> > > The Ethernet packet counter could potentially show evidence of some USB
> > > related issues, but can be Ethernet related problem as well.
> > > 
> > > To provide generic way to detect USB issues or HW issues on different
> > > levels we need to make use of devlink.
> > 
> > Please make this generic to all USB devices, usbnet is not special here
> > at all.
> 
> Ok. I'll need some help. What is the best place to attach devlink
> registration in the USB subsystem and the places to attach health
> reporters?

You tell us, you are the one that thinks this needs to be reported to
userspace.  What is only being reported in kernel logs that userspace
somehow needs to see?  And what will userspace do with that information?

thanks,

greg k-h
