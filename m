Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C901E2A2B
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 20:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388765AbgEZSfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 14:35:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728113AbgEZSfS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 14:35:18 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E408D207FB;
        Tue, 26 May 2020 18:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590518115;
        bh=56+jc2YBY6x6hHWjn5ToyvjEGYq6fLZWGafNFZADRJQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G4lGutaL6vy8of+yL2FyUXZ13a0yzS7AcXmN+76vej1slcGHjLqAqCMRMA63WRfHI
         WGkF1CILUX0gpR1EJjX+pIjKFVnZ5xghSGngoUxpIwtTUxoPXP5RWiJ4fVoJcPSTeY
         eCmWeZ5lQJ88mVNrrusbK3LJHFviHcs7r1FHHnv4=
Date:   Tue, 26 May 2020 11:35:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
Subject: Re: [net-next RFC v3 0/6] net: marvell: prestera: Add Switchdev
 driver for Prestera family ASIC device 98DX326x (AC3x)
Message-ID: <20200526113512.33246247@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200526171302.28649-1-vadym.kochan@plvision.eu>
References: <20200526171302.28649-1-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 May 2020 20:12:56 +0300 Vadym Kochan wrote:
> Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
> ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> wireless SMB deployment.

This series adds lots of warnings when built with W=3D1, please make sure
every individual patch builds cleanly.

../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:38:24: warning:=
 symbol 'prestera_devlink_alloc' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:47:6: warning: =
symbol 'prestera_devlink_free' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:54:5: warning: =
symbol 'prestera_devlink_register' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:68:6: warning: =
symbol 'prestera_devlink_unregister' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:75:5: warning: =
symbol 'prestera_devlink_port_register' was not declared. Should it be stat=
ic?
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:95:6: warning: =
symbol 'prestera_devlink_port_unregister' was not declared. Should it be st=
atic?
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:100:6: warning:=
 symbol 'prestera_devlink_port_type_set' was not declared. Should it be sta=
tic?
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:105:21: warning=
: symbol 'prestera_devlink_get_port' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:656:5: warning: sy=
mbol 'prestera_sdma_switch_init' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:716:6: warning: sy=
mbol 'prestera_sdma_switch_fini' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:755:13: warning: s=
ymbol 'prestera_sdma_xmit' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:812:5: warning: sy=
mbol 'prestera_rxtx_switch_init' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:825:6: warning: sy=
mbol 'prestera_rxtx_switch_fini' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:831:5: warning: sy=
mbol 'prestera_rxtx_port_init' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:843:13: warning: s=
ymbol 'prestera_rxtx_xmit' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:38:25: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_devlink_alloc=C3=
=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
   38 | struct prestera_switch *prestera_devlink_alloc(void)
      |                         ^~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:47:6: warning: =
no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_devlink_free=C3=A2=
=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
   47 | void prestera_devlink_free(struct prestera_switch *sw)
      |      ^~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:54:5: warning: =
no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_devlink_register=C3=
=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
   54 | int prestera_devlink_register(struct prestera_switch *sw)
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:68:6: warning: =
no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_devlink_unregister=
=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
   68 | void prestera_devlink_unregister(struct prestera_switch *sw)
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:75:5: warning: =
no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_devlink_port_regist=
er=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
   75 | int prestera_devlink_port_register(struct prestera_port *port)
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:95:6: warning: =
no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_devlink_port_unregi=
ster=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
   95 | void prestera_devlink_port_unregister(struct prestera_port *port)
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:100:6: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_devlink_port_type_=
set=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  100 | void prestera_devlink_port_type_set(struct prestera_port *port)
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:105:22: warning=
: no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_devlink_get_port=
=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  105 | struct devlink_port *prestera_devlink_get_port(struct net_device *d=
ev)
      |                      ^~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c: In function =C3=
=A2=E2=82=AC=CB=9Cprestera_sdma_tx_recycle_work_fn=C3=A2=E2=82=AC=E2=84=A2:
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:535:17: warning: v=
ariable =C3=A2=E2=82=AC=CB=9Cdma_dev=C3=A2=E2=82=AC=E2=84=A2 set but not us=
ed [-Wunused-but-set-variable]
  535 |  struct device *dma_dev;
      |                 ^~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c: At top level:
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:656:5: warning: no=
 previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_sdma_switch_init=C3=
=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  656 | int prestera_sdma_switch_init(struct prestera_switch *sw)
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:716:6: warning: no=
 previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_sdma_switch_fini=C3=
=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  716 | void prestera_sdma_switch_fini(struct prestera_switch *sw)
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:755:13: warning: n=
o previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_sdma_xmit=C3=A2=E2=
=82=AC=E2=84=A2 [-Wmissing-prototypes]
  755 | netdev_tx_t prestera_sdma_xmit(struct prestera_sdma *sdma, struct s=
k_buff *skb)
      |             ^~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:812:5: warning: no=
 previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_rxtx_switch_init=C3=
=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  812 | int prestera_rxtx_switch_init(struct prestera_switch *sw)
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:825:6: warning: no=
 previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_rxtx_switch_fini=C3=
=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  825 | void prestera_rxtx_switch_fini(struct prestera_switch *sw)
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:831:5: warning: no=
 previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_rxtx_port_init=C3=A2=
=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  831 | int prestera_rxtx_port_init(struct prestera_port *port)
      |     ^~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:843:13: warning: n=
o previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_rxtx_xmit=C3=A2=E2=
=82=AC=E2=84=A2 [-Wmissing-prototypes]
  843 | netdev_tx_t prestera_rxtx_xmit(struct prestera_port *port, struct s=
k_buff *skb)
      |             ^~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:296:6: warning:=
 symbol 'prestera_ethtool_get_drvinfo' was not declared. Should it be stati=
c?
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:473:5: warning:=
 symbol 'prestera_ethtool_get_link_ksettings' was not declared. Should it b=
e static?
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:598:5: warning:=
 symbol 'prestera_ethtool_set_link_ksettings' was not declared. Should it b=
e static?
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:634:5: warning:=
 symbol 'prestera_ethtool_get_fecparam' was not declared. Should it be stat=
ic?
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:661:5: warning:=
 symbol 'prestera_ethtool_set_fecparam' was not declared. Should it be stat=
ic?
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:696:5: warning:=
 symbol 'prestera_ethtool_get_sset_count' was not declared. Should it be st=
atic?
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:706:6: warning:=
 symbol 'prestera_ethtool_get_strings' was not declared. Should it be stati=
c?
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:715:6: warning:=
 symbol 'prestera_ethtool_get_stats' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:726:5: warning:=
 symbol 'prestera_ethtool_nway_reset' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:296:6: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_ethtool_get_drvinf=
o=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  296 | void prestera_ethtool_get_drvinfo(struct net_device *dev,
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:473:5: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_ethtool_get_link_k=
settings=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  473 | int prestera_ethtool_get_link_ksettings(struct net_device *dev,
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:598:5: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_ethtool_set_link_k=
settings=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  598 | int prestera_ethtool_set_link_ksettings(struct net_device *dev,
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:634:5: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_ethtool_get_fecpar=
am=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  634 | int prestera_ethtool_get_fecparam(struct net_device *dev,
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:661:5: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_ethtool_set_fecpar=
am=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  661 | int prestera_ethtool_set_fecparam(struct net_device *dev,
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:696:5: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_ethtool_get_sset_c=
ount=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  696 | int prestera_ethtool_get_sset_count(struct net_device *dev, int sse=
t)
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:706:6: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_ethtool_get_string=
s=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  706 | void prestera_ethtool_get_strings(struct net_device *dev,
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:715:6: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_ethtool_get_stats=
=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  715 | void prestera_ethtool_get_stats(struct net_device *dev,
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:726:5: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_ethtool_nway_reset=
=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  726 | int prestera_ethtool_nway_reset(struct net_device *dev)
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_pci.c: In function =C3=A2=
=E2=82=AC=CB=9Cprestera_fw_rev_check=C3=A2=E2=82=AC=E2=84=A2:
../drivers/net/ethernet/marvell/prestera/prestera_pci.c:590:15: warning: co=
mparison is always true due to limited range of data type [-Wtype-limits]
  590 |      rev->min >=3D PRESTERA_SUPP_FW_MIN_VER) {
      |               ^~
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:656:5: warning: sy=
mbol 'prestera_sdma_switch_init' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:716:6: warning: sy=
mbol 'prestera_sdma_switch_fini' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:755:13: warning: s=
ymbol 'prestera_sdma_xmit' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:812:5: warning: sy=
mbol 'prestera_rxtx_switch_init' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:825:6: warning: sy=
mbol 'prestera_rxtx_switch_fini' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:831:5: warning: sy=
mbol 'prestera_rxtx_port_init' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:843:13: warning: s=
ymbol 'prestera_rxtx_xmit' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:296:6: warning:=
 symbol 'prestera_ethtool_get_drvinfo' was not declared. Should it be stati=
c?
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:473:5: warning:=
 symbol 'prestera_ethtool_get_link_ksettings' was not declared. Should it b=
e static?
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:598:5: warning:=
 symbol 'prestera_ethtool_set_link_ksettings' was not declared. Should it b=
e static?
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:634:5: warning:=
 symbol 'prestera_ethtool_get_fecparam' was not declared. Should it be stat=
ic?
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:661:5: warning:=
 symbol 'prestera_ethtool_set_fecparam' was not declared. Should it be stat=
ic?
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:696:5: warning:=
 symbol 'prestera_ethtool_get_sset_count' was not declared. Should it be st=
atic?
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:706:6: warning:=
 symbol 'prestera_ethtool_get_strings' was not declared. Should it be stati=
c?
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:715:6: warning:=
 symbol 'prestera_ethtool_get_stats' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:726:5: warning:=
 symbol 'prestera_ethtool_nway_reset' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:38:24: warning:=
 symbol 'prestera_devlink_alloc' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:47:6: warning: =
symbol 'prestera_devlink_free' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:54:5: warning: =
symbol 'prestera_devlink_register' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:68:6: warning: =
symbol 'prestera_devlink_unregister' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:75:5: warning: =
symbol 'prestera_devlink_port_register' was not declared. Should it be stat=
ic?
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:95:6: warning: =
symbol 'prestera_devlink_port_unregister' was not declared. Should it be st=
atic?
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:100:6: warning:=
 symbol 'prestera_devlink_port_type_set' was not declared. Should it be sta=
tic?
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:105:21: warning=
: symbol 'prestera_devlink_get_port' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:214:6: warnin=
g: symbol 'prestera_port_vlan_destroy' was not declared. Should it be stati=
c?
../drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:288:24: warni=
ng: symbol 'prestera_bridge_by_dev' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:537:5: warnin=
g: symbol 'prestera_bridge_port_event' was not declared. Should it be stati=
c?
../drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:1238:5: warni=
ng: symbol 'prestera_switchdev_init' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:1276:6: warni=
ng: symbol 'prestera_switchdev_fini' was not declared. Should it be static?
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:38:25: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_devlink_alloc=C3=
=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
   38 | struct prestera_switch *prestera_devlink_alloc(void)
      |                         ^~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:47:6: warning: =
no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_devlink_free=C3=A2=
=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
   47 | void prestera_devlink_free(struct prestera_switch *sw)
      |      ^~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:54:5: warning: =
no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_devlink_register=C3=
=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
   54 | int prestera_devlink_register(struct prestera_switch *sw)
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:68:6: warning: =
no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_devlink_unregister=
=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
   68 | void prestera_devlink_unregister(struct prestera_switch *sw)
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:75:5: warning: =
no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_devlink_port_regist=
er=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
   75 | int prestera_devlink_port_register(struct prestera_port *port)
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:95:6: warning: =
no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_devlink_port_unregi=
ster=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
   95 | void prestera_devlink_port_unregister(struct prestera_port *port)
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:100:6: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_devlink_port_type_=
set=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  100 | void prestera_devlink_port_type_set(struct prestera_port *port)
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:105:22: warning=
: no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_devlink_get_port=
=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  105 | struct devlink_port *prestera_devlink_get_port(struct net_device *d=
ev)
      |                      ^~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:296:6: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_ethtool_get_drvinf=
o=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  296 | void prestera_ethtool_get_drvinfo(struct net_device *dev,
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:473:5: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_ethtool_get_link_k=
settings=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  473 | int prestera_ethtool_get_link_ksettings(struct net_device *dev,
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:598:5: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_ethtool_set_link_k=
settings=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  598 | int prestera_ethtool_set_link_ksettings(struct net_device *dev,
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:634:5: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_ethtool_get_fecpar=
am=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  634 | int prestera_ethtool_get_fecparam(struct net_device *dev,
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:661:5: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_ethtool_set_fecpar=
am=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  661 | int prestera_ethtool_set_fecparam(struct net_device *dev,
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:696:5: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_ethtool_get_sset_c=
ount=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  696 | int prestera_ethtool_get_sset_count(struct net_device *dev, int sse=
t)
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:706:6: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_ethtool_get_string=
s=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  706 | void prestera_ethtool_get_strings(struct net_device *dev,
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:715:6: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_ethtool_get_stats=
=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  715 | void prestera_ethtool_get_stats(struct net_device *dev,
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:726:5: warning:=
 no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_ethtool_nway_reset=
=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  726 | int prestera_ethtool_nway_reset(struct net_device *dev)
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c: In function =C3=
=A2=E2=82=AC=CB=9Cprestera_sdma_tx_recycle_work_fn=C3=A2=E2=82=AC=E2=84=A2:
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:535:17: warning: v=
ariable =C3=A2=E2=82=AC=CB=9Cdma_dev=C3=A2=E2=82=AC=E2=84=A2 set but not us=
ed [-Wunused-but-set-variable]
  535 |  struct device *dma_dev;
      |                 ^~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c: At top level:
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:656:5: warning: no=
 previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_sdma_switch_init=C3=
=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  656 | int prestera_sdma_switch_init(struct prestera_switch *sw)
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:716:6: warning: no=
 previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_sdma_switch_fini=C3=
=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  716 | void prestera_sdma_switch_fini(struct prestera_switch *sw)
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:755:13: warning: n=
o previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_sdma_xmit=C3=A2=E2=
=82=AC=E2=84=A2 [-Wmissing-prototypes]
  755 | netdev_tx_t prestera_sdma_xmit(struct prestera_sdma *sdma, struct s=
k_buff *skb)
      |             ^~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:812:5: warning: no=
 previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_rxtx_switch_init=C3=
=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  812 | int prestera_rxtx_switch_init(struct prestera_switch *sw)
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:825:6: warning: no=
 previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_rxtx_switch_fini=C3=
=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  825 | void prestera_rxtx_switch_fini(struct prestera_switch *sw)
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:831:5: warning: no=
 previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_rxtx_port_init=C3=A2=
=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  831 | int prestera_rxtx_port_init(struct prestera_port *port)
      |     ^~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:843:13: warning: n=
o previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_rxtx_xmit=C3=A2=E2=
=82=AC=E2=84=A2 [-Wmissing-prototypes]
  843 | netdev_tx_t prestera_rxtx_xmit(struct prestera_port *port, struct s=
k_buff *skb)
      |             ^~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_pci.c: In function =C3=A2=
=E2=82=AC=CB=9Cprestera_fw_rev_check=C3=A2=E2=82=AC=E2=84=A2:
../drivers/net/ethernet/marvell/prestera/prestera_pci.c:590:15: warning: co=
mparison is always true due to limited range of data type [-Wtype-limits]
  590 |      rev->min >=3D PRESTERA_SUPP_FW_MIN_VER) {
      |               ^~
../drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:214:6: warnin=
g: no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_port_vlan_destro=
y=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  214 | void prestera_port_vlan_destroy(struct prestera_port_vlan *port_vla=
n)
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:288:25: warni=
ng: no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_bridge_by_dev=
=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  288 | struct prestera_bridge *prestera_bridge_by_dev(struct prestera_swit=
chdev *swdev,
      |                         ^~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:537:5: warnin=
g: no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_bridge_port_even=
t=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
  537 | int prestera_bridge_port_event(struct net_device *dev, unsigned lon=
g event,
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:1238:5: warni=
ng: no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_switchdev_init=
=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
 1238 | int prestera_switchdev_init(struct prestera_switch *sw)
      |     ^~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:1276:6: warni=
ng: no previous prototype for =C3=A2=E2=82=AC=CB=9Cprestera_switchdev_fini=
=C3=A2=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
 1276 | void prestera_switchdev_fini(struct prestera_switch *sw)
      |      ^~~~~~~~~~~~~~~~~~~~~~~
