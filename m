Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC1F21C5E6
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 21:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgGKTFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 15:05:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58756 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbgGKTFs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 15:05:48 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1juKoh-004eM7-Un; Sat, 11 Jul 2020 21:05:43 +0200
Date:   Sat, 11 Jul 2020 21:05:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, min.li.xe@renesas.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ptp: add debugfs support for IDT family of
 timing devices
Message-ID: <20200711190543.GT1014141@lunn.ch>
References: <1594395685-25199-1-git-send-email-min.li.xe@renesas.com>
 <20200710135844.58d76d44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200711134601.GD20443@hoboy>
 <20200711163806.GM1014141@lunn.ch>
 <20200711183839.GA26032@hoboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200711183839.GA26032@hoboy>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 11, 2020 at 11:38:39AM -0700, Richard Cochran wrote:
> On Sat, Jul 11, 2020 at 06:38:06PM +0200, Andrew Lunn wrote:
> > But configuration does not belong in debugfs. It would be good to
> > explain what is being configured by these parameters, then we can
> > maybe make a suggestion about the correct API to use.
> 
> Can we at least enumerate the possibilities?
> 
> - driver specific char device
> - private ioctls
> - debugfs

Hi Richard

Since nobody has explained what is actually being configured here, the
list is long, and is very likely to contain all sorts of wrong ways of
doing it:

A new generic parameter added to the PTP API which other PTP clock
providers could use.
A device tree property.
A device tree clock, regulator, ...
An ACPI property?
A sysfs file.
A module parameter
A new POSIX clock?
An LED class device?
A netlink attribute?

  Andrew








