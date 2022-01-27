Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E028E49DFF3
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239807AbiA0K7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiA0K7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:59:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B214C061714;
        Thu, 27 Jan 2022 02:59:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E857861749;
        Thu, 27 Jan 2022 10:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB890C340E4;
        Thu, 27 Jan 2022 10:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643281154;
        bh=pcNRmENdEEkUV6MCKFvEK6F2cJ0wuvvBlqE7Amzj66s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wJ73+kgYOkDCNHfenKejVuiC97OghRnn2BVRlO41HM+TjFwEj+eSFgIzCx95ORo/l
         OmFfXzS/PM4jPS7no/Dl8cvQwFt6+RJqwDe5gUCtiB3oMWajuFeBspcCDjVZVOvaDE
         fgN3bxn3siyZFDHJLfUNozM2cFzrX6uCFIZrweAo=
Date:   Thu, 27 Jan 2022 11:59:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 2/4] dt-bindings: net: add schema for
 Microchip/SMSC LAN95xx USB Ethernet controllers
Message-ID: <YfJ6/xdacR59Jvq+@kroah.com>
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
 <20220127104905.899341-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127104905.899341-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 11:49:03AM +0100, Oleksij Rempel wrote:
> Create initial schema for Microchip/SMSC LAN95xx USB Ethernet controllers and
> import all currently supported USB IDs form drivers/net/usb/smsc95xx.c

That is a loosing game to play.  There is a reason that kernel drivers
only require a device id in 1 place, instead of multiple places like
other operating systems.  Please do not go back and make the same
mistakes others have.

Not to mention that I think overall this is a bad idea anyway.  USB
devices are self-describing, don't add them to DT.

thanks,

greg k-h
