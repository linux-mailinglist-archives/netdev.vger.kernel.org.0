Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C64821AB7B
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 01:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgGIXUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 19:20:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56234 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbgGIXUh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 19:20:37 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jtfqF-004OW7-9c; Fri, 10 Jul 2020 01:20:35 +0200
Date:   Fri, 10 Jul 2020 01:20:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, netdev@vger.kernel.org,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: MDIO Debug Interface
Message-ID: <20200709232035.GE1014141@lunn.ch>
References: <C42DZQLTPHM5.2THDSRK84BI3T@wkz-x280>
 <20200709223936.GC1014141@lunn.ch>
 <20200709225725.xwmyhny4hmiyb5nt@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709225725.xwmyhny4hmiyb5nt@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Fear not, the lack of a mainline UAPI for MDIO access will not prevent
> any vendor from adding a sysfs mdio_read and mdio_write, if they need it
> for their user space SDK :)

They do. But it means you have to use their kernel, or at least their
kernel module. That will put off some people. But if they can claim it
works on any kernel after v5.9, it makes the marketing much easier.

Like i said, it is a trade off.

> Virtualization is a reasonable use case in my opinion and it would
> need something like this, for the guest kernel to have access to its
> PHY.

And i would like a better understanding of this use case. It seems odd
you are putting the driver for a PHY in the VM. Is the MAC driver also
in the VM? As you said, VM context switches are expensive, so it would
seem to make more sense to let the host drive the hardware, which it
can do without all these context switches, and export a much simpler
and efficient API to the VM.

    Andrew
