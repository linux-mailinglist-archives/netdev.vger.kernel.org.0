Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B6C49E497
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242331AbiA0O3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:29:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57980 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229755AbiA0O3B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 09:29:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tdEgiApI7oRLGEXznkTydqSbjTqfWZLOxD7Ao9uz1aw=; b=IogfjJnx34QYWVPOwnXUQRPY2F
        kWfNrS5OGDRJ3aMuo+aEKPJCDwBXIjahYB1+V9JUzMQY0qiTpu4XdwRPgOQxHt0RldiW7FuO5jITB
        mzIpuirGBkSnASGKta/rF+9JQgjEjHGBaqYU25w1nJancGY6Ya3ofpf0KCPlVjlhXwXs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nD5le-002zzx-LN; Thu, 27 Jan 2022 15:28:54 +0100
Date:   Thu, 27 Jan 2022 15:28:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 4/4] usbnet: add support for label from
 device tree
Message-ID: <YfKsJvvDcKTL3xst@lunn.ch>
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
 <20220127104905.899341-5-o.rempel@pengutronix.de>
 <YfJ6lhZMAEmetdad@kroah.com>
 <20220127112305.GC9150@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127112305.GC9150@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> - Board with USB Ethernet controller with DSA switch. The USB ethernet
>   controller is attached to the CPU port of DSA switch. In this case,
>   DSA switch is the sub-node of the USB device. The CPU port should have
>   stable name for all device related to this product.

All that DSA requires is a phandle pointing to the MAC. It does not
care what the interface name is. It should not be an issue if udev
changes the name to something your product marketing guys say it
should be.

   Andrew
