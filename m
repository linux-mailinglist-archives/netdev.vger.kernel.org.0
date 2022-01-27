Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1245549DFEA
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239783AbiA0K5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239773AbiA0K5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:57:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8658C06173B;
        Thu, 27 Jan 2022 02:57:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CB50B821EE;
        Thu, 27 Jan 2022 10:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE7DC340E4;
        Thu, 27 Jan 2022 10:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643281055;
        bh=gbW+XTNZXr9hGyQb+2cyWJjlqaEnavG1SF4dDnxcuVI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=btVtwLIntJO6tkL3JKU7gbqQ9LN+0exFu0/1DBbxsFef+RuCqQzQ9mWR954qGAIit
         z60Pb47rocP0pc4n6smGTCdkIh0RvA3UpNKdmB3EemOhUXZ41/sTtBqYh5P7d0q1QU
         +WLYS/eXZ/7Ow0p0ZIr2AmWDU+NuBx4eNtQShQAQ=
Date:   Thu, 27 Jan 2022 11:57:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 4/4] usbnet: add support for label from
 device tree
Message-ID: <YfJ6lhZMAEmetdad@kroah.com>
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
 <20220127104905.899341-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127104905.899341-5-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 11:49:05AM +0100, Oleksij Rempel wrote:
> Similar to the option to set a netdev name in device tree for switch
> ports by using the property "label" in the DSA framework, this patch
> adds this functionality to the usbnet infrastructure.
> 
> This will help to name the interfaces properly throughout supported
> devices. This provides stable interface names which are useful
> especially in embedded use cases.

Stable interface names are for userspace to set, not the kernel.

Why would USB care about this?  If you need something like this, get it
from the USB device itself, not DT, which should have nothing to do with
USB as USB is a dynamic, self-describing, bus.  Unlike DT.

So I do not think this is a good idea.

greg k-h
