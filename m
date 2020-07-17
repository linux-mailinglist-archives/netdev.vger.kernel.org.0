Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91115224175
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 19:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgGQRIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 13:08:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41442 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbgGQRIp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 13:08:45 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jwTql-005dMj-Gy; Fri, 17 Jul 2020 19:08:43 +0200
Date:   Fri, 17 Jul 2020 19:08:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: Assigning MAC addrs to PCI based NIC's
Message-ID: <20200717170843.GB1339445@lunn.ch>
References: <CAJ+vNU30cU36bvgoyKFMzB4z3PAhEPB7OX_ikRQeCZPhSCZztQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ+vNU30cU36bvgoyKFMzB4z3PAhEPB7OX_ikRQeCZPhSCZztQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 08:58:26AM -0700, Tim Harvey wrote:
> Greetings,
> 
> We make embedded boards that often have on-board PCIe based NIC's that
> have MAC addresses stored in an EEPROM (not within NIC's NVRAM). I've
> struggled with a way to have boot firmware assign the mac's via
> device-tree and I find that only some drivers support getting the MAC
> from device-tree anyway.
> 
> What is the appropriate way to assign vendor MAC's to a NIC from boot
> firmware, or even in userspace?

Hi Tim

From user space you can always use

ip link set address XX:XX:XX:XX:XX:XX dev enp42s0

But that assumes the MAC driver actually supports setting its MAC
address. As with getting the MAC address from DT, this is also
optional in the driver. But i guess it is more often implemented.

I don't know of any universal method. So i think you probably do need
to work on each of the MAC drivers you are interested in, and add DT
support.

	Andrew
