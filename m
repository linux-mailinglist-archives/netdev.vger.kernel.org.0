Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E7049E841
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244249AbiA0RAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:00:46 -0500
Received: from netrider.rowland.org ([192.131.102.5]:39289 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S244241AbiA0RAq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 12:00:46 -0500
Received: (qmail 178125 invoked by uid 1000); 27 Jan 2022 12:00:44 -0500
Date:   Thu, 27 Jan 2022 12:00:44 -0500
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] usbnet: add devlink support
Message-ID: <YfLPvF6pmcL1UG2f@rowland.harvard.edu>
References: <20220127110742.922752-1-o.rempel@pengutronix.de>
 <YfJ+ceEzvzMM1JsW@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfJ+ceEzvzMM1JsW@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 12:13:53PM +0100, Greg KH wrote:
> On Thu, Jan 27, 2022 at 12:07:42PM +0100, Oleksij Rempel wrote:
> > The weakest link of usbnet devices is the USB cable.
> 
> The weakest link of any USB device is the cable, why is this somehow
> special to usbnet devices?
> 
> > Currently there is
> > no way to automatically detect cable related issues except of analyzing
> > kernel log, which would differ depending on the USB host controller.
> > 
> > The Ethernet packet counter could potentially show evidence of some USB
> > related issues, but can be Ethernet related problem as well.
> > 
> > To provide generic way to detect USB issues or HW issues on different
> > levels we need to make use of devlink.
> 
> Please make this generic to all USB devices, usbnet is not special here
> at all.

Even more basic question: How is the kernel supposed to tell the 
difference between a USB issue and a HW issue?  That is, by what 
criterion do you decide which category a particular issue falls under?

Alan Stern
