Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0FC1E9267
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 17:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgE3Pyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 11:54:39 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:39267 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729026AbgE3Pyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 11:54:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 76B1D5801D0;
        Sat, 30 May 2020 11:54:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 30 May 2020 11:54:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=jt1dGS
        bVEYpOV6xP0SripkKuJVssfnARK7gl+7OpPPI=; b=YHXb5jCH9U/LSj5fQFwXzh
        Fvvy5m59hiD4ve0H969bgH5FKwDRw4MBY+wvpDrBjBjiSP3QnHLBIhWX8Ma9zpF4
        SiP9976UalYRyumftp32PH5ynLvU3p4rqT+7p2Pe1VG3C75X3Bw7WPJ3ulaWGHMZ
        PThRBksb0RJB0/QXQhvoFmVQMI2AVhLGDQ+w1Ml7fO/SRRbac1i1XtxgIk5F1rU9
        7EkyJYjVcUlCvZ7pEHpkI4S/vcqDX5ldVNqad3+QhjIE3VYL3KxqPk9DPf3qvgaB
        up56p71Fcv1eNrg0HvEzdGdbBwjNaX3JKQWlFNk8COFCXU5aS8DbOgZKsGpZMeDA
        ==
X-ME-Sender: <xms:vIHSXt_FMrUTfcINYC297hYJ6u0_9tkDgmhhOzGjnGNmcIXW1GJJrQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeftddgledvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeetffffleduleejhefhvdfhtdffgfekleehffeuvefgfedugfevhfeffeelhffh
    keenucffohhmrghinhepmhgrihhlqdgrrhgthhhivhgvrdgtohhmnecukfhppeejledrud
    ejiedrvdegrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:vIHSXhu27teKVsO8M2XZa_X2mwlE2SdRzku7AeLIx0wuVAPDU6pedQ>
    <xmx:vIHSXrAjhKoiUMxNEMH-MjZhtxWf1qSqpY9Fbdb5tvWvtKBCNhsHQg>
    <xmx:vIHSXhe-dh2ApjSVe1BgZPhQNZVCDnRIQwwG1DMSsU8zmgSXgMXDxw>
    <xmx:vYHSXjG_pRDobuRxMstclkLf9xD2P0aqktE6rTQGDneZEWTMECEOag>
Received: from localhost (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C84DC3060FE7;
        Sat, 30 May 2020 11:54:35 -0400 (EDT)
Date:   Sat, 30 May 2020 18:54:29 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next 0/6] net: marvell: prestera: Add Switchdev driver for
 Prestera family ASIC device 98DX326x (AC3x)
Message-ID: <20200530155429.GA1639307@splinter>
References: <20200528151245.7592-1-vadym.kochan@plvision.eu>
 <20200530142928.GA1624759@splinter>
 <20200530145231.GB19411@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200530145231.GB19411@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 30, 2020 at 05:52:31PM +0300, Vadym Kochan wrote:
> Hi Ido,
> 
> On Sat, May 30, 2020 at 05:29:28PM +0300, Ido Schimmel wrote:
> > On Thu, May 28, 2020 at 06:12:39PM +0300, Vadym Kochan wrote:
> > > Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
> > > ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> > > wireless SMB deployment.
> > > 
> > > Prestera Switchdev is a firmware based driver that operates via PCI bus.  The
> > > current implementation supports only boards designed for the Marvell Switchdev
> > > solution and requires special firmware.
> > > 
> > > This driver implementation includes only L1, basic L2 support, and RX/TX.
> > > 
> > > The core Prestera switching logic is implemented in prestera_main.c, there is
> > > an intermediate hw layer between core logic and firmware. It is
> > > implemented in prestera_hw.c, the purpose of it is to encapsulate hw
> > > related logic, in future there is a plan to support more devices with
> > > different HW related configurations.
> > > 
> > > The following Switchdev features are supported:
> > > 
> > >     - VLAN-aware bridge offloading
> > >     - VLAN-unaware bridge offloading
> > >     - FDB offloading (learning, ageing)
> > >     - Switchport configuration
> > > 
> > > The firmware image will be uploaded soon to the linux-firmware repository.
> > > 
> > > PATCH:
> > >     1) Fixed W=1 warnings
> > 
> > Hi,
> > 
> > I just applied the patches for review and checkpatch had a lot of
> > complaints. Some are even ERRORs. For example:
> > 
> > WARNING: do not add new typedefs
> > #1064: FILE: drivers/net/ethernet/marvell/prestera/prestera_hw.h:32:
> > +typedef void (*prestera_event_cb_t)
> I may be wrong, as I remember Jiri suggested it and looks like
> it makes sense. I really don't have strong opinion about this.

OK, so I'll let Jiri comment when he is back at work.

> 
> > 
> > WARNING: line over 80 characters
> > #2007: FILE: drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:321:
> > +                       __skb_trim(buf->skb, PRESTERA_SDMA_RX_DESC_PKT_LEN(desc));
> > 
> > WARNING: line over 80 characters
> > #2007: FILE: drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:321:
> > +                       __skb_trim(buf->skb, PRESTERA_SDMA_RX_DESC_PKT_LEN(desc));
> > 
> > ERROR: Macros with complex values should be enclosed in parentheses
> > #196: FILE: drivers/net/ethernet/marvell/prestera/prestera_pci.c:161:
> > +#define PRESTERA_FW_REG_ADDR(fw, reg)  PRESTERA_FW_REG_BASE(fw) + (reg)
> This one makes sense.
> > 
> > WARNING: prefer 'help' over '---help---' for new help texts
> > #52: FILE: drivers/net/ethernet/marvell/prestera/Kconfig:15:
> > +config PRESTERA_PCI
> I will fix it.
> > 
> > ...
> 
> The most are about using ethtool types which are in camel style.
> Regarding > 80 chars is is a required rule ? I saw some discussion
> on LKML that 80+ are acceptable sometimes.

Yea, that's why I didn't include them. Error messages can always exceed
80 characters. Other times I try to follow the rule unless
"the cure is worse than the disease":

https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1818701.html

> 
> > 
> > Also, smatch complaints about:
> > 
> > drivers/net/ethernet/marvell/prestera//prestera_ethtool.c:713
> > prestera_ethtool_get_strings() error: memcpy() '*prestera_cnt_name' too
> > small (32 vs 960)
> > 
> > And coccicheck about:
> > 
> > drivers/net/ethernet/marvell/prestera/prestera_hw.c:681:2-3: Unneeded
> > semicolon
> These looks interesting, I did not use smatch and coccicheck, will look
> on these.
> 
> > 
> > > 
> > >     2) Renamed PCI driver name to be more generic "Prestera DX" because
> > >        there will be more devices supported.
> > > 
> > >     3) Changed firmware image dir path: marvell/ -> mrvl/prestera/
> > >        to be aligned with location in linux-firmware.git (if such
> > >        will be accepted).
> > > 
> > > RFC v3:
> > >     1) Fix prestera prefix in prestera_rxtx.c
> > > 
> > >     2) Protect concurrent access from multiple ports on multiple CPU system
> > >        on tx path by spinlock in prestera_rxtx.c
> > > 
> > >     3) Try to get base mac address from device-tree, otherwise use a random generated one.
> > > 
> > >     4) Move ethtool interface support into separate prestera_ethtool.c file.
> > > 
> > >     5) Add basic devlink support and get rid of physical port naming ops.
> > > 
> > >     6) Add STP support in Switchdev driver.
> > > 
> > >     7) Removed MODULE_AUTHOR
> > > 
> > >     8) Renamed prestera.c -> prestera_main.c, and kernel module to
> > >        prestera.ko
> > > 
> > > RFC v2:
> > >     1) Use "pestera_" prefix in struct's and functions instead of mvsw_pr_
> > > 
> > >     2) Original series split into additional patches for Switchdev ethtool support.
> > > 
> > >     3) Use major and minor firmware version numbers in the firmware image filename.
> > > 
> > >     4) Removed not needed prints.
> > > 
> > >     5) Use iopoll API for waiting on register's value in prestera_pci.c
> > > 
> > >     6) Use standart approach for describing PCI ID matching section instead of using
> > >        custom wrappers in prestera_pci.c
> > > 
> > >     7) Add RX/TX support in prestera_rxtx.c.
> > > 
> > >     8) Rewritten prestera_switchdev.c with following changes:
> > >        - handle netdev events from prestera.c
> > > 
> > >        - use struct prestera_bridge for bridge objects, and get rid of
> > >          struct prestera_bridge_device which may confuse.
> > > 
> > >        - use refcount_t
> > > 
> > >     9) Get rid of macro usage for sending fw requests in prestera_hw.c
> > > 
> > >     10) Add base_mac setting as module parameter. base_mac is required for
> > >         generation default port's mac.
> > > 
> > > Vadym Kochan (6):
> > >   net: marvell: prestera: Add driver for Prestera family ASIC devices
> > >   net: marvell: prestera: Add PCI interface support
> > >   net: marvell: prestera: Add basic devlink support
> > >   net: marvell: prestera: Add ethtool interface support
> > >   net: marvell: prestera: Add Switchdev driver implementation
> > >   dt-bindings: marvell,prestera: Add description for device-tree
> > >     bindings
> > > 
> > >  .../bindings/net/marvell,prestera.txt         |   34 +
> > >  drivers/net/ethernet/marvell/Kconfig          |    1 +
> > >  drivers/net/ethernet/marvell/Makefile         |    1 +
> > >  drivers/net/ethernet/marvell/prestera/Kconfig |   25 +
> > >  .../net/ethernet/marvell/prestera/Makefile    |    7 +
> > >  .../net/ethernet/marvell/prestera/prestera.h  |  208 +++
> > >  .../marvell/prestera/prestera_devlink.c       |  111 ++
> > >  .../marvell/prestera/prestera_devlink.h       |   25 +
> > >  .../ethernet/marvell/prestera/prestera_dsa.c  |  134 ++
> > >  .../ethernet/marvell/prestera/prestera_dsa.h  |   37 +
> > >  .../marvell/prestera/prestera_ethtool.c       |  737 ++++++++++
> > >  .../marvell/prestera/prestera_ethtool.h       |   37 +
> > >  .../ethernet/marvell/prestera/prestera_hw.c   | 1225 ++++++++++++++++
> > >  .../ethernet/marvell/prestera/prestera_hw.h   |  180 +++
> > >  .../ethernet/marvell/prestera/prestera_main.c |  663 +++++++++
> > >  .../ethernet/marvell/prestera/prestera_pci.c  |  825 +++++++++++
> > >  .../ethernet/marvell/prestera/prestera_rxtx.c |  860 +++++++++++
> > >  .../ethernet/marvell/prestera/prestera_rxtx.h |   21 +
> > >  .../marvell/prestera/prestera_switchdev.c     | 1286 +++++++++++++++++
> > >  .../marvell/prestera/prestera_switchdev.h     |   16 +
> > >  20 files changed, 6433 insertions(+)
> > >  create mode 100644 drivers/net/ethernet/marvell/prestera/Kconfig
> > >  create mode 100644 drivers/net/ethernet/marvell/prestera/Makefile
> > >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.h
> > >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.c
> > >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.h
> > >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.c
> > >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.h
> > >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
> > >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
> > >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.c
> > >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.h
> > >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_main.c
> > >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_pci.c
> > >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
> > >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
> > >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> > >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchdev.h
> > > 
> > > -- 
> > > 2.17.1
> > > 
