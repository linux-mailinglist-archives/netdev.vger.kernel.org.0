Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C7B22B9CD
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 00:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgGWWmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 18:42:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52384 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbgGWWmT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 18:42:19 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jyjus-006anl-JZ; Fri, 24 Jul 2020 00:42:18 +0200
Date:   Fri, 24 Jul 2020 00:42:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andre Edich <andre.edich@microchip.com>
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        steve.glendinning@shawell.net, Parthiban.Veerasooran@microchip.com
Subject: Re: [PATCH net-next v2 2/6] smsc95xx: use usbnet->driver_priv
Message-ID: <20200723224218.GN1553578@lunn.ch>
References: <20200723115507.26194-1-andre.edich@microchip.com>
 <20200723115507.26194-3-andre.edich@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723115507.26194-3-andre.edich@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 01:55:03PM +0200, Andre Edich wrote:
> Using `void *driver_priv` instead of `unsigned long data[]` is more
> straightforward way to recover the `struct smsc95xx_priv *` from the
> `struct net_device *`.
> 
> Signed-off-by: Andre Edich <andre.edich@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
